#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Starting deployment script${NC}"
echo -e "${GREEN}========================================${NC}"

# 1. Git pull
echo -e "\n${YELLOW}[1/4] Pulling latest changes from git...${NC}"
git pull
if [ $? -ne 0 ]; then
    echo -e "${RED}Git pull failed!${NC}"
    exit 1
fi
echo -e "${GREEN}Git pull completed successfully${NC}"

# 2. Убиваем запущенные JAR процессы movie-service
echo -e "\n${YELLOW}[2/4] Checking for running movie-service processes...${NC}"
PIDS=$(ps aux | grep '[m]ovie-service.*\.jar' | awk '{print $2}')

if [ -z "$PIDS" ]; then
    echo -e "${GREEN}No running movie-service processes found${NC}"
else
    echo -e "${YELLOW}Found running processes: $PIDS${NC}"
    echo "$PIDS" | xargs kill -9
    echo -e "${GREEN}Killed all movie-service processes${NC}"
    sleep 2
fi

# 3. Пересобираем проект
echo -e "\n${YELLOW}[3/4] Building the project...${NC}"
cd movie-service
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo -e "${RED}Build failed!${NC}"
    exit 1
fi
cd ..
echo -e "${GREEN}Build completed successfully${NC}"

# 4. Запускаем проект
echo -e "\n${YELLOW}[4/4] Starting movie-service...${NC}"
nohup java -jar movie-service/target/movie-service-1.0.0.jar > movie-service.log 2>&1 &
NEW_PID=$!
echo -e "${GREEN}movie-service started with PID: $NEW_PID${NC}"
echo -e "${GREEN}Logs are being written to: movie-service.log${NC}"

# Ждем немного и проверяем, что процесс запустился
sleep 3
if ps -p $NEW_PID > /dev/null; then
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Deployment completed successfully!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo -e "To view logs: ${YELLOW}tail -f movie-service.log${NC}"
    echo -e "To stop service: ${YELLOW}kill $NEW_PID${NC}"
else
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}Service failed to start!${NC}"
    echo -e "${RED}Check movie-service.log for details${NC}"
    echo -e "${RED}========================================${NC}"
    exit 1
fi

