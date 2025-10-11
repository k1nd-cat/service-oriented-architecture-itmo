#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Получаем директорию, где находится скрипт
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Путь к Payara (относительно корня проекта)
PAYARA_HOME="${SCRIPT_DIR}/payara/payara6"
ASADMIN="${PAYARA_HOME}/bin/asadmin"

# Имя приложения
APP_NAME="service1"
WAR_FILE="${SCRIPT_DIR}/movie-service/target/movie-service-1.0.0.war"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Starting deployment script for Payara${NC}"
echo -e "${GREEN}========================================${NC}"

# 1. Git pull
echo -e "\n${YELLOW}[1/5] Pulling latest changes from git...${NC}"
git pull
if [ $? -ne 0 ]; then
    echo -e "${RED}Git pull failed!${NC}"
    exit 1
fi
echo -e "${GREEN}Git pull completed successfully${NC}"

# 2. Проверяем, запущен ли Payara
echo -e "\n${YELLOW}[2/5] Checking Payara status...${NC}"
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

# 3. Пересобираем проект
echo -e "\n${YELLOW}[3/5] Building the project...${NC}"
cd "${SCRIPT_DIR}/movie-service"
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo -e "${RED}Build failed!${NC}"
    exit 1
fi
cd "${SCRIPT_DIR}"
echo -e "${GREEN}Build completed successfully${NC}"

# 4. Проверяем, существует ли приложение, и если да - удаляем его
echo -e "\n${YELLOW}[4/5] Checking for existing application...${NC}"
APP_EXISTS=$("${ASADMIN}" list-applications | grep "^${APP_NAME}" | wc -l)

if [ "$APP_EXISTS" -gt 0 ]; then
    echo -e "${YELLOW}Found existing application. Undeploying...${NC}"
    "${ASADMIN}" undeploy "${APP_NAME}"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to undeploy existing application!${NC}"
        exit 1
    fi
    echo -e "${GREEN}Existing application undeployed successfully${NC}"
else
    echo -e "${GREEN}No existing application found${NC}"
fi

# 5. Деплоим новую версию
echo -e "\n${YELLOW}[5/5] Deploying application to Payara...${NC}"
"${ASADMIN}" deploy --name "${APP_NAME}" --contextroot "${APP_NAME}" "${WAR_FILE}"
if [ $? -ne 0 ]; then
    echo -e "${RED}Deployment failed!${NC}"
    exit 1
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Application URL: ${YELLOW}http://localhost:9001/${APP_NAME}${NC}"
echo -e "${GREEN}Swagger UI: ${YELLOW}http://localhost:9001/${APP_NAME}/swagger-ui.html${NC}"
echo -e "${GREEN}API Docs: ${YELLOW}http://localhost:9001/${APP_NAME}/api-docs${NC}"
echo -e "${GREEN}Internal API: ${YELLOW}http://localhost:9001/${APP_NAME}/api/v1/internal/movies${NC}"
echo -e "\nTo view Payara logs: ${YELLOW}tail -f ${PAYARA_HOME}/glassfish/domains/domain1/logs/server.log${NC}"
echo -e "To stop Payara: ${YELLOW}${ASADMIN} stop-domain domain1${NC}"
echo -e "To restart Payara: ${YELLOW}${ASADMIN} restart-domain domain1${NC}"

