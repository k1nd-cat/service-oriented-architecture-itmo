#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PAYARA_HOME="${SCRIPT_DIR}/payara/payara6"
ASADMIN="${PAYARA_HOME}/bin/asadmin"

MOVIE_SERVICE_JAR="${SCRIPT_DIR}/movie-service/target/movie-service-1.0.0.jar"
OSCAR_SERVICE_EAR="${SCRIPT_DIR}/oscar-service/oscar-service-ear/target/oscar-service-1.0.0.ear"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Starting deployment script${NC}"
echo -e "${GREEN}========================================${NC}"

echo -e "${YELLOW}Full Payara cleanup with DAS restart...${NC}"

# 1. Убить movie-service
pkill -f "movie-service-1.0.0.jar" || true
sleep 2

# 2. ВРЕМЕННО запустить DAS для очистки
"${ASADMIN}" list-domains | grep "domain1 running" >/dev/null 2>&1
if [ $? -ne 0 ]; then
    # Не запущен – стартуем
    "${ASADMIN}" start-domain domain1 >/dev/null 2>&1 || {
        echo -e "${RED}Failed to start domain1 for cleanup${NC}"
        exit 1
    }
    STARTED_FOR_CLEANUP=true
    sleep 5
else
    # Уже запущен – просто используем
    STARTED_FOR_CLEANUP=false
fi

# 3. Полная очистка (теперь DAS работает!)
echo -e "${BLUE}Cleaning applications and instances...${NC}"

# Удалить ВСЕ refs
REFS=$("${ASADMIN}" list-application-refs | grep -v "COMMAND" | grep -v "N/A" | xargs 2>/dev/null || true)
[ ! -z "$REFS" ] && echo -e "${BLUE}Deleting refs: $REFS${NC}" && for ref in $REFS; do "${ASADMIN}" delete-application-ref "$ref" >/dev/null 2>&1 || true; done

# Удалить ВСЕ приложения
APPS=$("${ASADMIN}" list-applications | grep -v "COMMAND" | grep -v "N/A" | xargs 2>/dev/null || true)
[ ! -z "$APPS" ] && echo -e "${BLUE}Undeploying apps: $APPS${NC}" && for app in $APPS; do "${ASADMIN}" undeploy "$app" --force=true >/dev/null 2>&1 || true; done

# Остановить/удалить instances
INSTANCES=$("${ASADMIN}" list-instances | grep -v "COMMAND" | grep -v "N/A" | xargs 2>/dev/null || true)
[ ! -z "$INSTANCES" ] && echo -e "${BLUE}Stopping instances: $INSTANCES${NC}" && for instance in $INSTANCES; do "${ASADMIN}" stop-local-instance "$instance" >/dev/null 2>&1 || true; done
sleep 2
[ ! -z "$INSTANCES" ] && echo -e "${BLUE}Deleting instances: $INSTANCES${NC}" && for instance in $INSTANCES; do "${ASADMIN}" delete-instance "$instance" >/dev/null 2>&1 || true; done

# Остановить DAS
echo -e "${BLUE}Stopping DAS...${NC}"
"${ASADMIN}" stop-domain domain1 >/dev/null 2>&1 || true
sleep 3

echo -e "${GREEN}Full cleanup completed${NC}"

echo -e "\n${YELLOW}[1/5] Pulling latest changes from git...${NC}"
git pull
if [ $? -ne 0 ]; then
    echo -e "${RED}Git pull failed!${NC}"
    exit 1
fi
echo -e "${GREEN}Git pull completed successfully${NC}"

echo -e "\n${YELLOW}[2/5] Checking Payara status...${NC}"
PAYARA_RUNNING=$("${ASADMIN}" list-domains | grep "domain1 running" | wc -l)

echo -e "\n${YELLOW}[2/5] Checking Payara DAS and instances...${NC}"

# --- Начало инициализации Payara ---

# Проверка DAS (domain1)
PAYARA_RUNNING=$("${ASADMIN}" list-domains | grep "domain1 running" | wc -l)
if [ "$PAYARA_RUNNING" -eq 0 ]; then
    echo -e "${YELLOW}Starting Payara DAS...${NC}"
    "${ASADMIN}" start-domain domain1
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to start Payara DAS!${NC}"
        exit 1
    fi
    echo -e "${GREEN}Payara DAS started${NC}"
    sleep 10  # больше времени для полной инициализации
else
    echo -e "${GREEN}Payara DAS already running${NC}"
fi

# Проверка/создание instance1 (порт 9001)
INSTANCE1_EXISTS=$("${ASADMIN}" list-instances | grep "instance1" | wc -l)
if [ "$INSTANCE1_EXISTS" -eq 0 ]; then
    echo -e "${YELLOW}Creating instance1 (HTTP:9001)...${NC}"
    "${ASADMIN}" create-instance \
        --node localhost-domain1 \
        --systemproperties HTTP_LISTENER_PORT=9001 \
        instance1
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to create instance1!${NC}"
        exit 1
    fi
fi

# Проверка/создание instance2 (порт 9002)
INSTANCE2_EXISTS=$("${ASADMIN}" list-instances | grep "instance2" | wc -l)
if [ "$INSTANCE2_EXISTS" -eq 0 ]; then
    echo -e "${YELLOW}Creating instance2 (HTTP:9002)...${NC}"
    "${ASADMIN}" create-instance \
        --node localhost-domain1 \
        --systemproperties HTTP_LISTENER_PORT=9002 \
        instance2
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to create instance2!${NC}"
        exit 1
    fi
fi

# --- Конец инициализации Payara ---

echo -e "\n${YELLOW}[3/5] Building the projects...${NC}"

echo -e "${BLUE}Building movie-service (Spring Boot)...${NC}"
cd "${SCRIPT_DIR}/movie-service"
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo -e "${RED}Movie-service build failed!${NC}"
    exit 1
fi
echo -e "${GREEN}Movie-service build completed${NC}"

echo -e "${BLUE}Building oscar-service (EAR with EJB)...${NC}"
cd "${SCRIPT_DIR}/oscar-service"
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo -e "${RED}Oscar-service build failed!${NC}"
    exit 1
fi
echo -e "${GREEN}Oscar-service build completed${NC}"

echo -e "${BLUE}Building frontend (webapp)...${NC}"
cd "${SCRIPT_DIR}/webapp"
flutter pub get
if [ $? -ne 0 ]; then
    echo -e "${RED}Flutter pub get failed!${NC}"
    exit 1
fi
echo -e "${GREEN}Flutter dependencies installed${NC}"

dart run build_runner build --delete-conflicting-outputs
if [ $? -ne 0 ]; then
    echo -e "${RED}Build runner failed!${NC}"
    exit 1
fi
echo -e "${GREEN}Build runner completed${NC}"

flutter build web
if [ $? -ne 0 ]; then
    echo -e "${RED}Flutter web build failed!${NC}"
    exit 1
fi
echo -e "${GREEN}Frontend build completed${NC}"

cd "${SCRIPT_DIR}"
echo -e "${GREEN}All builds completed successfully${NC}"

echo -e "\n${YELLOW}[4/5] Stopping old services...${NC}"

MOVIE_PID=$(pgrep -f "movie-service-1.0.0.jar")
if [ ! -z "$MOVIE_PID" ]; then
    echo -e "${BLUE}Stopping movie-service (PID: ${MOVIE_PID})...${NC}"
    kill $MOVIE_PID
    sleep 2
fi

APP_EXISTS=$("${ASADMIN}" list-applications | grep "^oscar-service" | wc -l)
if [ "$APP_EXISTS" -gt 0 ]; then
    echo -e "${BLUE}Undeploying oscar-service...${NC}"
    "${ASADMIN}" undeploy oscar-service
fi

echo -e "\n${YELLOW}[5/5] Starting services...${NC}"

echo -e "${BLUE}Starting movie-service (Spring Boot)...${NC}"
cd "${SCRIPT_DIR}/movie-service"

# Запуск первого инстанса на порту 9003
nohup java -jar "${MOVIE_SERVICE_JAR}" --spring.profiles.active=movie1 > /tmp/movie-service-9003.log 2>&1 &
MOVIE_PID1=$!
echo -e "${GREEN}Movie-service #1 started on port 9003 (PID: ${MOVIE_PID1})${NC}"

# Запуск второго инстанса на порту 9004
nohup java -jar "${MOVIE_SERVICE_JAR}" --spring.profiles.active=movie2 > /tmp/movie-service-9004.log 2>&1 &
MOVIE_PID2=$!
echo -e "${GREEN}Movie-service #2 started on port 9004 (PID: ${MOVIE_PID2})${NC}"

echo -e "${GREEN}All movie-service instances started${NC}"
sleep 5

# --- Деплой Oscar Service ---

echo -e "${BLUE}Deploying oscar-service to domain (DAS)...${NC}"
"${ASADMIN}" deploy --name oscar-service --force=true "${OSCAR_SERVICE_EAR}"
if [ $? -ne 0 ]; then
    echo -e "${RED}Deployment to domain failed!${NC}"
    exit 1
fi
echo -e "${GREEN}oscar-service deployed in domain${NC}"

echo -e "${BLUE}Creating application refs on instances...${NC}"
for instance in instance1 instance2; do
    echo -e "${BLUE}  -> Linking to $instance...${NC}"
    "${ASADMIN}" create-application-ref oscar-service --target "$instance" --force=true
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to create ref on $instance!${NC}"
        exit 1
    fi
done
echo -e "${GREEN}oscar-service is available on instance1 and instance2${NC}"

# --- Конец деплоя Oscar Service ---

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\n${GREEN}Service 1 (Movie Service - Spring Boot):${NC}"
echo -e "  Application URL: ${YELLOW}http://localhost:9000/service1${NC}"
echo -e "  Swagger UI: ${YELLOW}http://localhost:9000/service1/swagger-ui.html${NC}"
echo -e "  API Docs: ${YELLOW}http://localhost:9000/service1/api-docs${NC}"
echo -e "  Public API: ${YELLOW}http://localhost:9000/service1/api/v1/movies${NC}"
echo -e "  Internal API: ${YELLOW}http://localhost:9000/service1/api/v1/internal/oscar/directors/get-loosers${NC}"
echo -e "  Logs: ${YELLOW}tail -f /tmp/movie-service.log${NC}"
echo -e "\n${GREEN}Service 2 (Oscar Service - Payara EAR with EJB):${NC}"
echo -e "  Application URL: ${YELLOW}http://localhost:9001/service2${NC}"
echo -e "  Swagger UI: ${YELLOW}http://localhost:9001/service2/swagger-ui${NC}"
echo -e "  OpenAPI Spec: ${YELLOW}http://localhost:9001/service2/openapi.json${NC}"
echo -e "  API Endpoints:"
echo -e "    - ${YELLOW}POST http://localhost:9001/service2/oscar/directors/get-loosers${NC}"
echo -e "    - ${YELLOW}POST http://localhost:9001/service2/oscar/directors/humiliate-by-genre/{genre}${NC}"
echo -e "  ${BLUE}EJB Configuration:${NC}"
echo -e "    - Stateless EJB with Remote interface"
echo -e "    - Pool: steady-size=5, max=20, resize=2"
echo -e "\n${BLUE}Utility commands:${NC}"
echo -e "  Stop movie-service: ${YELLOW}kill \$(pgrep -f movie-service-1.0.0.jar)${NC}"
echo -e "  View Payara logs: ${YELLOW}tail -f ${PAYARA_HOME}/glassfish/domains/domain1/logs/server.log${NC}"
echo -e "  Stop Payara: ${YELLOW}${ASADMIN} stop-domain domain1${NC}"

