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

# ============================================
# ФУНКЦИИ ЛОГИРОВАНИЯ И ОБРАБОТКИ ОШИБОК
# ============================================

log_section() {
    echo -e "\n${GREEN}========================================${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${GREEN}========================================${NC}"
}

log_step() {
    echo -e "\n${YELLOW}$1${NC}"
}

log_info() {
    echo -e "${BLUE}$1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

exit_with_error() {
    log_error "$1"
    exit 1
}

# ============================================
# ОСНОВНАЯ ЛОГИКА СКРИПТА
# ============================================

log_section "Starting deployment script"

# ============================================
# PHASE 1: CLEANUP
# ============================================

log_step "[CLEANUP] Full cleanup of all services..."

# Kill ALL Java processes related to our services
log_info "Stopping all service processes..."
pkill -f "movie-service-1.0.0.jar" || true
pkill -f "payara" || true
pkill -9 -f "GlassFish" || true
sleep 2

# Stop all Payara instances (if running)
log_info "Stopping Payara instances..."
"${ASADMIN}" stop-local-instance instance1 >/dev/null 2>&1 || true
"${ASADMIN}" stop-local-instance instance2 >/dev/null 2>&1 || true
sleep 2

# Stop DAS (Domain Administration Server)
log_info "Stopping DAS..."
"${ASADMIN}" stop-domain domain1 >/dev/null 2>&1 || true
sleep 3

# Kill any remaining processes on ports
log_info "Freeing ports..."
for port in 4848 9001 9002 9003 9004 8181; do
    lsof -ti:$port 2>/dev/null | xargs kill -9 2>/dev/null || true
done
sleep 2

# Remove old domain completely
log_info "Removing old domain..."
rm -rf "${PAYARA_HOME}/glassfish/domains/domain1"
rm -rf "${PAYARA_HOME}/glassfish/nodes/localhost-domain1"

# Recreate fresh domain
log_info "Creating fresh domain..."
"${ASADMIN}" create-domain --adminport 4848 --nopassword domain1
if [ $? -ne 0 ]; then
    exit_with_error "Failed to create domain1"
fi

log_success "Cleanup completed"

# ============================================
# PHASE 2: GIT PULL (OPTIONAL)
# ============================================

log_step "[1/5] Skipping git pull (manual deployment)..."
cd "${SCRIPT_DIR}"
# git pull можно раскомментировать при необходимости
log_success "Git check completed"

# ============================================
# PHASE 3: PAYARA INITIALIZATION
# ============================================

log_step "[2/5] Initializing Payara DAS and instances..."

# Start DAS
log_info "Starting Payara DAS..."
"${ASADMIN}" start-domain domain1
if [ $? -ne 0 ]; then
    exit_with_error "Failed to start Payara DAS"
fi
log_success "Payara DAS started"
sleep 10

# Create instance1
log_info "Creating instance1 (HTTP:9001)..."
"${ASADMIN}" create-instance \
    --node localhost-domain1 \
    --systemproperties HTTP_LISTENER_PORT=9001 \
    instance1 >/dev/null 2>&1
if [ $? -ne 0 ]; then
    exit_with_error "Failed to create instance1"
fi
log_success "instance1 created"

# Жёстко прописываем HTTP-порт 9001 для конфигурации instance1-config
log_info "Forcing HTTP port 9001 for instance1..."
"${ASADMIN}" set "configs.config.instance1-config.network-config.network-listeners.network-listener.http-listener-1.port=9001"
if [ $? -ne 0 ]; then
    exit_with_error "Failed to set HTTP port for instance1"
fi

# Create instance2
log_info "Creating instance2 (HTTP:9002)..."
"${ASADMIN}" create-instance \
    --node localhost-domain1 \
    --systemproperties HTTP_LISTENER_PORT=9002 \
    instance2 >/dev/null 2>&1
if [ $? -ne 0 ]; then
    exit_with_error "Failed to create instance2"
fi
log_success "instance2 created"

# Жёстко прописываем HTTP-порт 9002 для конфигурации instance2-config
log_info "Forcing HTTP port 9002 for instance2..."
"${ASADMIN}" set "configs.config.instance2-config.network-config.network-listeners.network-listener.http-listener-1.port=9002"
if [ $? -ne 0 ]; then
    exit_with_error "Failed to set HTTP port for instance2"
fi

# ============================================
# PHASE 4: BUILD PROJECTS
# ============================================

log_step "[3/5] Building all projects..."

# Build movie-service
log_info "Building movie-service (Spring Boot)..."
cd "${SCRIPT_DIR}/movie-service"
mvn clean package -DskipTests -q
if [ $? -ne 0 ]; then
    exit_with_error "Movie-service build failed"
fi
log_success "Movie-service built"

# Build oscar-service
log_info "Building oscar-service (EAR)..."
cd "${SCRIPT_DIR}/oscar-service"
mvn clean package -DskipTests -q
if [ $? -ne 0 ]; then
    exit_with_error "Oscar-service build failed"
fi
log_success "Oscar-service built"

# Build frontend
log_info "Building frontend (Flutter Web)..."
cd "${SCRIPT_DIR}/webapp"
flutter pub get >/dev/null 2>&1
if [ $? -ne 0 ]; then
    exit_with_error "Flutter pub get failed"
fi
dart run build_runner build --delete-conflicting-outputs >/dev/null 2>&1
if [ $? -ne 0 ]; then
    exit_with_error "Build runner failed"
fi
flutter build web >/dev/null 2>&1
if [ $? -ne 0 ]; then
    exit_with_error "Flutter web build failed"
fi
log_success "Frontend built"

cd "${SCRIPT_DIR}"
log_success "All builds completed"

# ============================================
# PHASE 5: START SERVICES (SPRING BOOT)
# ============================================

log_step "[4/5] Starting services..."

log_info "Starting movie-service instances..."
cd "${SCRIPT_DIR}/movie-service"

nohup java -jar "${MOVIE_SERVICE_JAR}" --spring.profiles.active=movie1 > /tmp/movie-service-9003.log 2>&1 &
MOVIE_PID1=$!
log_success "Movie-service #1 started (PID: ${MOVIE_PID1}, port 9003)"

nohup java -jar "${MOVIE_SERVICE_JAR}" --spring.profiles.active=movie2 > /tmp/movie-service-9004.log 2>&1 &
MOVIE_PID2=$!
log_success "Movie-service #2 started (PID: ${MOVIE_PID2}, port 9004)"

sleep 5

# ============================================
# PHASE 6: DEPLOYMENT (OSCAR SERVICE) - ИСПРАВЛЕННАЯ
# ============================================

log_step "[5/5] Deploying Oscar Service..."

# ВАЖНО: Сначала развертываем на DAS
log_info "Deploying oscar-service to DAS..."

# Используем deploy вместо redeploy (т.к. это первое развертывание)
"${ASADMIN}" deploy --name oscar-service "${OSCAR_SERVICE_EAR}" >/dev/null 2>&1
if [ $? -ne 0 ]; then
    # Если deploy не сработал, пробуем redeploy (может быть старая версия)
    log_info "Deploy failed, trying redeploy..."
    "${ASADMIN}" redeploy --name oscar-service --force=true "${OSCAR_SERVICE_EAR}" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        exit_with_error "Failed to deploy oscar-service to DAS"
    fi
fi
log_success "oscar-service deployed to DAS"

# Даем время на полное развертывание
sleep 5

# ВАЖНО: Запускаем экземпляры ПОСЛЕ успешного развертывания на DAS
kill_process_on_port() {
    local port=$1
    local pids=$(lsof -ti:$port 2>/dev/null)
    if [ -n "$pids" ]; then
        log_info "Port $port is in use (PID: $pids), killing..."
        kill -9 $pids 2>/dev/null || true
        sleep 1
    fi
}

check_port_available() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        return 1  # Port is in use
    else
        return 0  # Port is available
    fi
}

log_info "Starting instances..."

log_info "Checking and freeing ports 9001/9002..."
kill_process_on_port 9001
kill_process_on_port 9002
sleep 2

for instance in instance1 instance2; do
    log_info "  Starting $instance..."
    "${ASADMIN}" start-local-instance "$instance" > /tmp/instance-$instance.log 2>&1
    if [ $? -ne 0 ]; then
        log_error "Failed to start $instance"
        log_info "Last 20 lines of instance log:"
        tail -20 "${PAYARA_HOME}/glassfish/nodes/localhost-domain1/${instance}/logs/server.log" 2>/dev/null || \
        tail -20 /tmp/instance-$instance.log
        exit_with_error "Failed to start $instance"
    fi
    log_success "$instance started"
    sleep 5
done

# Даем время на запуск и синхронизацию
sleep 8

# ВАЖНО: Создаем ссылки на приложение на работающих экземплярах
log_info "Creating application references on instances..."
for instance in instance1 instance2; do
    log_info "  Creating reference on $instance..."
    
    # Ключ здесь: используем --target вместо create-application-ref
    # create-application-ref создает ссылку на уже развернутое приложение
    "${ASADMIN}" create-application-ref --target="$instance" oscar-service >/dev/null 2>&1
    
    if [ $? -ne 0 ]; then
        # Если не сработала первая команда, пробуем с дополнительными параметрами
        log_info "  Retry with force flag..."
        "${ASADMIN}" create-application-ref --target="$instance" --force=true oscar-service >/dev/null 2>&1
        
        if [ $? -ne 0 ]; then
            exit_with_error "Failed to create application reference on $instance"
        fi
    fi
    
    log_success "oscar-service linked to $instance"
done

sleep 3

# ============================================
# SUMMARY
# ============================================

log_section "🎉 Deployment completed successfully!"

echo -e "\n${GREEN}📊 Movie Service (Spring Boot - 2 instances):${NC}"
echo -e "  Instance 1:"
echo -e "    URL: ${YELLOW}http://localhost:9003${NC}"
echo -e "    Swagger: ${YELLOW}http://localhost:9003/service1/swagger-ui.html${NC}"
echo -e "    Logs: ${YELLOW}tail -f /tmp/movie-service-9003.log${NC}"
echo -e "  Instance 2:"
echo -e "    URL: ${YELLOW}http://localhost:9004${NC}"
echo -e "    Swagger: ${YELLOW}http://localhost:9004/service1/swagger-ui.html${NC}"
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
echo -e "  Check instance status: ${YELLOW}${ASADMIN} list-instances${NC}"

echo -e "\n${GREEN}========================================${NC}"
