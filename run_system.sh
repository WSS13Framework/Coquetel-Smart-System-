#!/bin/bash

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# PIDs dos processos
FRONTEND_PID=""
BACKEND_PID=""
DASHBOARD_PID=""
MONITOR_PID=""

# Função para limpar processos ao sair
cleanup() {
    echo -e "\n${YELLOW}🛑 Encerrando sistema...${NC}"
    
    [[ ! -z "$FRONTEND_PID" ]] && kill $FRONTEND_PID 2>/dev/null
    [[ ! -z "$BACKEND_PID" ]] && kill $BACKEND_PID 2>/dev/null
    [[ ! -z "$DASHBOARD_PID" ]] && kill $DASHBOARD_PID 2>/dev/null
    [[ ! -z "$MONITOR_PID" ]] && kill $MONITOR_PID 2>/dev/null
    
    echo -e "${GREEN}✅ Sistema encerrado com sucesso!${NC}"
    exit 0
}

# Configurar trap para CTRL+C
trap cleanup INT

# Verificar dependências
check_dependencies() {
    echo -e "${CYAN}🔍 Verificando dependências...${NC}"
    
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}❌ Python3 não encontrado!${NC}"
        exit 1
    fi
    
    # Instalar dependências Python se necessário
    pip3 install -q flask flask-cors 2>/dev/null || true
    
    echo -e "${GREEN}✅ Dependências verificadas${NC}\n"
}

# Iniciar Frontend
start_frontend() {
    echo -e "${BLUE}🌐 Iniciando Frontend (porta 8000)...${NC}"
    cd frontend
    python3 -m http.server 8000 > ../logs/frontend.log 2>&1 &
    FRONTEND_PID=$!
    sleep 1
    echo -e "${GREEN}   ✓ Frontend: http://localhost:8000${NC}"
}

# Iniciar Backend API
start_backend() {
    echo -e "${BLUE}⚙️  Iniciando Backend API (porta 8001)...${NC}"
    cd ../backend
    python3 server_api.py > ../logs/backend.log 2>&1 &
    BACKEND_PID=$!
    sleep 1
    echo -e "${GREEN}   ✓ API: http://localhost:8001${NC}"
}

# Iniciar Dashboard
start_dashboard() {
    echo -e "${BLUE}📊 Iniciando Dashboard (porta 8002)...${NC}"
    cd ../dashboard
    python3 -m http.server 8002 > ../logs/dashboard.log 2>&1 &
    DASHBOARD_PID=$!
    sleep 1
    echo -e "${GREEN}   ✓ Dashboard: http://localhost:8002${NC}"
}

# Monitor de Sistema
start_monitor() {
    echo -e "${BLUE}📡 Iniciando Monitor de Sistema...${NC}"
    cd ../scripts
    python3 monitor.py > ../logs/monitor.log 2>&1 &
    MONITOR_PID=$!
    echo -e "${GREEN}   ✓ Monitor ativo${NC}"
}

# Menu principal
show_menu() {
    echo -e "\n${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║       COQUETEL SMART SYSTEM            ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║  URLs dos Serviços:                    ║${NC}"
    echo -e "${CYAN}║                                        ║${NC}"
    echo -e "${CYAN}║  🌐 Cliente:                           ║${NC}"
    echo -e "${CYAN}║     http://localhost:8000              ║${NC}"
    echo -e "${CYAN}║                                        ║${NC}"
    echo -e "${CYAN}║  📊 Dashboard Bar:                     ║${NC}"
    echo -e "${CYAN}║     http://localhost:8002              ║${NC}"
    echo -e "${CYAN}║                                        ║${NC}"
    echo -e "${CYAN}║  ⚙️  API Status:                       ║${NC}"
    echo -e "${CYAN}║     http://localhost:8001/status       ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    echo -e "\n${YELLOW}Pressione CTRL+C para encerrar${NC}\n"
}

# Main
main() {
    clear
    echo -e "${CYAN}🍸 COQUETEL SMART SYSTEM - Inicializando...${NC}\n"
    
    check_dependencies
    
    # Criar diretório de logs se não existir
    mkdir -p logs data
    
    # Limpar logs antigos
    > logs/frontend.log
    > logs/backend.log
    > logs/dashboard.log
    > logs/monitor.log
    
    # Iniciar serviços
    start_frontend
    start_backend
    start_dashboard
    start_monitor
    
    show_menu
    
    # Manter script rodando
    while true; do
        sleep 1
    done
}

# Executar
main
