#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Получаем директорию, где находится скрипт
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Путь к Payara (относительно корня проекта)
PAYARA_HOME="${SCRIPT_DIR}/payara/payara6"
ASADMIN="${PAYARA_HOME}/bin/asadmin"

# Конфигурация приложений
declare -A APPS
APPS["service1"]="${SCRIPT_DIR}/movie-service/target/movie-service-1.0.0.war"
APPS["service2"]="${SCRIPT_DIR}/oscar-service/target/oscar-service-1.0.0.war"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Starting deployment script for Payara${NC}"
echo -e "${GREEN}========================================${NC}"

# 1. Git pull
echo -e "\n${YELLOW}[1/6] Pulling latest changes from git...${NC}"
git pull
if [ $? -ne 0 ]; then
    echo -e "${RED}Git pull failed!${NC}"
    exit 1
fi
echo -e "${GREEN}Git pull completed successfully${NC}"

# 2. Проверяем, запущен ли Payara
echo -e "\n${YELLOW}[2/6] Checking Payara status...${NC}"
PAYARA_RUNNING=$("${ASADMIN}" list-domains | grep "domain1 running" | wc -l)

if [ "$PAYARA_RUNNING" -eq 0 ]; then
    echo -e "${YELLOW}Payara is not running. Starting Payara...${NC}"
    "${ASADMIN}" start-domain domain1
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to start Payara!${NC}"
        exit 1
    fi
    echo -e "${GREEN}Payara started successfully${NC}"
    sleep 5
else
    echo -e "${GREEN}Payara is already running${NC}"
fi

# 3. Пересобираем проекты
echo -e "\n${YELLOW}[3/6] Building the projects...${NC}"

echo -e "${BLUE}Building movie-service...${NC}"
cd "${SCRIPT_DIR}/movie-service"
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo -e "${RED}Movie-service build failed!${NC}"
    exit 1
fi
echo -e "${GREEN}Movie-service build completed${NC}"

echo -e "${BLUE}Building oscar-service...${NC}"
cd "${SCRIPT_DIR}/oscar-service"
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo -e "${RED}Oscar-service build failed!${NC}"
    exit 1
fi
echo -e "${GREEN}Oscar-service build completed${NC}"

cd "${SCRIPT_DIR}"
echo -e "${GREEN}All builds completed successfully${NC}"

# 4. Проверяем существующие приложения и удаляем их
echo -e "\n${YELLOW}[4/6] Checking for existing applications...${NC}"

for APP_NAME in "${!APPS[@]}"; do
    APP_EXISTS=$("${ASADMIN}" list-applications | grep "^${APP_NAME}" | wc -l)
    
    if [ "$APP_EXISTS" -gt 0 ]; then
        echo -e "${BLUE}Found existing ${APP_NAME}. Undeploying...${NC}"
        "${ASADMIN}" undeploy "${APP_NAME}"
        if [ $? -ne 0 ]; then
            echo -e "${RED}Failed to undeploy ${APP_NAME}!${NC}"
            exit 1
        fi
        echo -e "${GREEN}${APP_NAME} undeployed successfully${NC}"
    else
        echo -e "${GREEN}No existing ${APP_NAME} found${NC}"
    fi
done

# 5. Деплоим новые версии
echo -e "\n${YELLOW}[5/6] Deploying applications to Payara...${NC}"

for APP_NAME in "${!APPS[@]}"; do
    WAR_FILE="${APPS[$APP_NAME]}"
    echo -e "${BLUE}Deploying ${APP_NAME}...${NC}"
    "${ASADMIN}" deploy --name "${APP_NAME}" --contextroot "${APP_NAME}" "${WAR_FILE}"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Deployment of ${APP_NAME} failed!${NC}"
        exit 1
    fi
    echo -e "${GREEN}${APP_NAME} deployed successfully${NC}"
done

# 6. Вывод информации о deployed приложениях
echo -e "\n${YELLOW}[6/6] Verifying deployments...${NC}"
"${ASADMIN}" list-applications

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\n${GREEN}Service 1 (Movie Service):${NC}"
echo -e "  Application URL: ${YELLOW}http://localhost:9001/service1${NC}"
echo -e "  Swagger UI: ${YELLOW}http://localhost:9001/service1/swagger-ui.html${NC}"
echo -e "  API Docs: ${YELLOW}http://localhost:9001/service1/api-docs${NC}"
echo -e "  Public API: ${YELLOW}http://localhost:9001/service1/api/v1/movies${NC}"
echo -e "  Internal API: ${YELLOW}http://localhost:9001/service1/api/v1/oscar/directors/get-loosers${NC}"
echo -e "\n${GREEN}Service 2 (Oscar Service):${NC}"
echo -e "  Application URL: ${YELLOW}http://localhost:9001/service2${NC}"
echo -e "  Swagger UI: ${YELLOW}http://localhost:9001/service2/swagger-ui${NC}"
echo -e "  OpenAPI Spec: ${YELLOW}http://localhost:9001/service2/openapi.json${NC}"
echo -e "  API Endpoints:"
echo -e "    - ${YELLOW}POST http://localhost:9001/service2/oscar/directors/get-loosers${NC}"
echo -e "    - ${YELLOW}POST http://localhost:9001/service2/oscar/directors/humiliate-by-genre/{genre}${NC}"
echo -e "\n${BLUE}Utility commands:${NC}"
echo -e "  View Payara logs: ${YELLOW}tail -f ${PAYARA_HOME}/glassfish/domains/domain1/logs/server.log${NC}"
echo -e "  Stop Payara: ${YELLOW}${ASADMIN} stop-domain domain1${NC}"
echo -e "  Restart Payara: ${YELLOW}${ASADMIN} restart-domain domain1${NC}"

