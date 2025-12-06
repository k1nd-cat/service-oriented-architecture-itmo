# ============================================
# PHASE 7: HEALTH CHECK
# ============================================

#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_step()   { echo -e "\n${YELLOW}$1${NC}"; }
log_info()   { echo -e "${BLUE}$1${NC}"; }
log_success(){ echo -e "${GREEN}✅ $1${NC}"; }
log_error()  { echo -e "${RED}❌ $1${NC}"; }

log_step "[6/5] Running health checks..."

log_info "Checking if oscar-service is accessible..."

# Test instance1
log_info "Testing instance1 (port 9001)..."
curl -s -o /dev/null -w "Status: %{http_code}\n" http://localhost:9001/ && \
log_success "instance1 is responding" || \
log_error "instance1 is NOT responding - check logs!"

# Test instance2
log_info "Testing instance2 (port 9002)..."
curl -s -o /dev/null -w "Status: %{http_code}\n" http://localhost:9002/ && \
log_success "instance2 is responding" || \
log_error "instance2 is NOT responding - check logs!"

# Test API endpoints
log_info "Testing API endpoints..."
curl -s -X POST http://localhost:9001/service2/oscar/directors/get-loosers \
    -H "Content-Type: application/json" -d '{}' > /dev/null && \
log_success "API endpoint is responding" || \
log_error "API endpoint returned error"

log_info ""
log_info "For detailed diagnostics, run:"
log_info "  bash check-oscar.sh"
