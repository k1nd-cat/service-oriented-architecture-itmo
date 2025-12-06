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

# ============================================
# CLEANUP PHASE (очистка всего старого)
# ============================================

echo -e "\n${YELLOW}[CLEANUP] Full Payara cleanup...${NC}"

# 1. Kill movie-service processes
pkill -f "movie-service-1.0.0.jar" || true
sleep 2

# 2. Start DAS if not running (needed for cleanup)
"${ASADMIN}" list-domains 2>/dev/null | grep -q "domain1 running"
if [ $? -ne 0 ]; then
    echo -e "${BLUE}Starting DAS for cleanup...${NC}"
    "${ASADMIN}" start-domain domain1 >/dev/null 2>&1 || {
        echo -e "${RED}Failed to start domain1!${NC}"
        exit 1
    }
    sleep 5
fi

# 3. Delete all application references
echo -e "${BLUE}Deleting application references...${NC}"
REFS=$("${ASADMIN}" list-application-refs 2>/dev/null | grep -v "COMMAND" | grep -v "N/A" | xargs || true)
if [ ! -z "$REFS" ]; then
    for ref in $REFS; do
        "${ASADMIN}" delete-application-ref "$ref" >/dev/null 2>&1 || true
    done
fi

# 4. Undeploy all applications
echo -e "${BLUE}Undeploying all applications...${NC}"
APPS=$("${ASADMIN}" list-applications 2>/dev/null | grep -v "COMMAND" | grep -v "N/A" | xargs || true)
if [ ! -z "$APPS" ]; then
    for app in $APPS; do
        "${ASADMIN}" undeploy --force "$app" >/dev/null 2>&1 || true
    done
fi

# 5. Stop and delete instances
echo -e "${BLUE}Removing instances...${NC}"
INSTANCES=$("${ASADMIN}" list-instances 2>/dev/null | grep -v "COMMAND" | grep -v "N/A" | xargs || true)
if [ ! -z "$INSTANCES" ]; then
    for instance in $INSTANCES; do
        "${ASADMIN}" stop-local-instance "$instance" >/dev/null 2>&1 || true
    done
    sleep 2
    for instance in $INSTANCES; do
        "${ASADMIN}" delete-instance "$instance" >/dev/null 2>&1 || true
    done
fi

# 6. Stop DAS
echo -e "${BLUE}Stopping DAS...${NC}"
"${ASADMIN}" stop-domain domain1 >/dev/null 2>&1 || true
sleep 3

echo -e "${GREEN}✅ Cleanup completed${NC}"

# ============================================
# GIT PULL PHASE
# ============================================

echo -e "\n${YELLOW}[1/5] Pulling latest changes from git...${NC}"
git pull
if [ $? -ne 0 ]; then
    echo -e "${RED}Git pull failed!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Git pull completed${NC}"

# ============================================
# PAYARA INITIALIZATION PHASE
# ============================================

echo -e "\n${YELLOW}[2/5] Initializing Payara DAS and instances...${NC}"

# Start DAS
echo -e "${BLUE}Starting Payara DAS...${NC}"
"${ASADMIN}" start-domain domain1
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to start Payara DAS!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Payara DAS started${NC}"
sleep 10

# Create instance1
echo -e "${BLUE}Creating instance1 (HTTP:9001)...${NC}"
"${ASADMIN}" create-instance \
    --node localhost-domain1 \
    --systemproperties HTTP_LISTENER_PORT=9001 \
    instance1 >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to create instance1!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ instance1 created${NC}"

# Create instance2
echo -e "${BLUE}Creating instance2 (HTTP:9002)...${NC}"
"${ASADMIN}" create-instance \
    --node localhost-domain1 \
    --systemproperties HTTP_LISTENER_PORT=9002 \
    instance2 >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to create instance2!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ instance2 created${NC}"

# ============================================
# BUILD PHASE
# ============================================

echo -e "\n${YELLOW}[3/5] Building all projects...${NC}"

# Build movie-service
echo -e "${BLUE}Building movie-service (Spring Boot)...${NC}"
cd "${SCRIPT_DIR}/movie-service"
mvn clean package -DskipTests -q
if [ $? -ne 0 ]; then
    echo -e "${RED}Movie-service build failed!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Movie-service built${NC}"

# Build oscar-service
echo -e "${BLUE}Building oscar-service (EAR)...${NC}"
cd "${SCRIPT_DIR}/oscar-service"
mvn clean package -DskipTests -q
if [ $? -ne 0 ]; then
    echo -e "${RED}Oscar-service build failed!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Oscar-service built${NC}"

# Build frontend
echo -e "${BLUE}Building frontend (Flutter Web)...${NC}"
cd "${SCRIPT_DIR}/webapp"
flutter pub get >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}Flutter pub get failed!${NC}"
    exit 1
fi
dart run build_runner build --delete-conflicting-outputs >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}Build runner failed!${NC}"
    exit 1
fi
flutter build web >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}Flutter web build failed!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Frontend built${NC}"

cd "${SCRIPT_DIR}"
echo -e "${GREEN}✅ All builds completed${NC}"

# ============================================
# START SERVICES PHASE
# ============================================

echo -e "\n${YELLOW}[4/5] Starting services...${NC}"

# Start movie-service instances
echo -e "${BLUE}Starting movie-service instances...${NC}"
cd "${SCRIPT_DIR}/movie-service"

nohup java -jar "${MOVIE_SERVICE_JAR}" --spring.profiles.active=movie1 > /tmp/movie-service-9003.log 2>&1 &
MOVIE_PID1=$!
echo -e "${GREEN}  Movie-service #1 started (PID: ${MOVIE_PID1}, port 9003)${NC}"

nohup java -jar "${MOVIE_SERVICE_JAR}" --spring.profiles.active=movie2 > /tmp/movie-service-9004.log 2>&1 &
MOVIE_PID2=$!
echo -e "${GREEN}  Movie-service #2 started (PID: ${MOVIE_PID2}, port 9004)${NC}"

sleep 5

# ============================================
# DEPLOYMENT PHASE (Oscar Service)
# ============================================

echo -e "\n${YELLOW}[5/5] Deploying Oscar Service...${NC}"

# Deploy to domain (DAS) - once only
echo -e "${BLUE}Deploying oscar-service to domain...${NC}"
"${ASADMIN}" deploy --name oscar-service --force=true "${OSCAR_SERVICE_EAR}"
if [ $? -ne 0 ]; then
    echo -e "${RED}Deployment to domain failed!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ oscar-service deployed to domain${NC}"

# Create application references on instances
echo -e "${BLUE}Creating application references on instances...${NC}"
for instance in instance1 instance2; do
    "${ASADMIN}" create-application-ref oscar-service --target "$instance" --force=true >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to create ref on $instance!${NC}"
        exit 1
    fi
    echo -e "${GREEN}  ✅ oscar-service linked to $instance${NC}"
done

# ============================================
# SUCCESS SUMMARY
# ============================================

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"

echo -e "\n${GREEN}📊 Movie Service (Spring Boot - 2 instances):${NC}"
echo -e "  Instance 1:"
echo -e "    URL: ${YELLOW}http://localhost:9003${NC}"
echo -e "    Swagger: ${YELLOW}http://localhost:9003/swagger-ui.html${NC}"
echo -e "    Logs: ${YELLOW}tail -f /tmp/movie-service-9003.log${NC}"
echo -e "  Instance 2:"
echo -e "    URL: ${YELLOW}http://localhost:9004${NC}"
echo -e "    Swagger: ${YELLOW}http://localhost:9004/swagger-ui.html${NC}"
echo -e "    Logs: ${YELLOW}tail -f /tmp/movie-service-9004.log${NC}"

echo -e "\n${GREEN}📊 Oscar Service (Payara EAR + EJB - 2 instances):${NC}"
echo -e "  Instance 1:"
echo -e "    URL: ${YELLOW}http://localhost:9001/service2${NC}"
echo -e "    Swagger: ${YELLOW}http://localhost:9001/service2/swagger-ui${NC}"
echo -e "  Instance 2:"
echo -e "    URL: ${YELLOW}http://localhost:9002/service2${NC}"
echo -e "    Swagger: ${YELLOW}http://localhost:9002/service2/swagger-ui${NC}"

echo -e "\n${BLUE}🛠️  API Endpoints:${NC}"
echo -e "    POST ${YELLOW}http://localhost:9001/service2/oscar/directors/get-loosers${NC}"
echo -e "    POST ${YELLOW}http://localhost:9001/service2/oscar/directors/humiliate-by-genre/{genre}${NC}"

echo -e "\n${BLUE}📝 Utility Commands:${NC}"
echo -e "  View Payara logs: ${YELLOW}tail -f ${PAYARA_HOME}/glassfish/domains/domain1/logs/server.log${NC}"
echo -e "  Stop Payara: ${YELLOW}${ASADMIN} stop-domain domain1${NC}"
echo -e "  List instances: ${YELLOW}${ASADMIN} list-instances --long${NC}"
echo -e "  Kill movie-service: ${YELLOW}pkill -f movie-service-1.0.0.jar${NC}"

echo -e "\n${GREEN}========================================${NC}"
