#!/bin/bash
# 🍸 COQUETEL SMART SYSTEM - SETUP COMPLETO
# Sistema integrado com Frontend, Backend API e Dashboard

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     🍸 COQUETEL SMART SYSTEM 2.0       ║${NC}"
echo -e "${BLUE}║     Sistema Completo de Eventos        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Criar estrutura de diretórios
echo -e "${YELLOW}📁 Criando estrutura do projeto...${NC}"
mkdir -p ~/Projetos/coquetel-smart-system/{frontend,backend,dashboard,data,logs,scripts}

# Navegar para o diretório do projeto
cd ~/Projetos/coquetel-smart-system

# ═══════════════════════════════════════════════════════════
# 1. CRIAR ARQUIVO PRINCIPAL DE EXECUÇÃO (run_system.sh)
# ═══════════════════════════════════════════════════════════

cat > run_system.sh << 'EOF'
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
EOF

chmod +x run_system.sh

# ═══════════════════════════════════════════════════════════
# 2. FRONTEND - Interface do Cliente (index.html melhorado)
# ═══════════════════════════════════════════════════════════

cat > frontend/index.html << 'EOF'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🍸 Coquetel Smart - Sistema de Pedidos</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 450px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .logo {
            font-size: 3em;
            margin-bottom: 10px;
        }
        
        .title {
            font-size: 1.8em;
            color: #333;
            margin-bottom: 5px;
        }
        
        .event-info {
            background: linear-gradient(135deg, #667eea20, #764ba220);
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 25px;
            text-align: center;
        }
        
        .drinks-grid {
            display: grid;
            gap: 12px;
        }
        
        .drink-card {
            display: flex;
            align-items: center;
            background: white;
            border: 2px solid #f0f0f0;
            border-radius: 12px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .drink-card:hover {
            transform: translateX(5px);
            border-color: #667eea;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.2);
        }
        
        .drink-emoji {
            font-size: 2.5em;
            margin-right: 15px;
        }
        
        .drink-info {
            flex: 1;
        }
        
        .drink-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        
        .drink-desc {
            font-size: 0.85em;
            color: #666;
        }
        
        .status-bar {
            margin-top: 25px;
            padding: 12px;
            background: #4caf50;
            color: white;
            border-radius: 8px;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .status-dot {
            width: 8px;
            height: 8px;
            background: white;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }
        
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            background: white;
            padding: 15px 20px;
            border-radius: 8px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            transform: translateX(400px);
            transition: transform 0.3s ease;
            max-width: 300px;
        }
        
        .notification.show {
            transform: translateX(0);
        }
        
        .notification.success {
            border-left: 4px solid #4caf50;
        }
        
        .notification.error {
            border-left: 4px solid #f44336;
        }
        
        .mesa-input {
            margin-bottom: 20px;
            padding: 15px;
            background: #f5f5f5;
            border-radius: 8px;
        }
        
        .mesa-input label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }
        
        .mesa-input input {
            width: 100%;
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 6px;
            font-size: 1em;
        }
        
        .mesa-input input:focus {
            outline: none;
            border-color: #667eea;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">🍸</div>
            <div class="title">Coquetel Smart</div>
        </div>
        
        <div class="event-info">
            <strong>�� Evento Corporativo WSS+13</strong><br>
            <small>Sistema Inteligente de Pedidos</small>
        </div>
        
        <div class="mesa-input">
            <label for="mesa">Número da Mesa / Nome:</label>
            <input type="text" id="mesa" placeholder="Ex: Mesa 5 ou João Silva" />
        </div>
        
        <div class="drinks-grid" id="drinksGrid"></div>
        
        <div class="status-bar">
            <div class="status-dot"></div>
            <span>Sistema Online - Bar Operacional</span>
        </div>
    </div>
    
    <div class="notification" id="notification"></div>
    
    <script>
        const API_URL = 'http://localhost:8001';
        
        const drinks = [
            { id: 1, name: 'Mojito', emoji: '🍃', desc: 'Refrescante com hortelã' },
            { id: 2, name: 'Caipirinha', emoji: '🍋', desc: 'Cachaça com limão' },
            { id: 3, name: 'Gin Tônica', emoji: '🌿', desc: 'Gin premium especial' },
            { id: 4, name: 'Whisky Sour', emoji: '🥃', desc: 'Bourbon com limão' },
            { id: 5, name: 'Cosmopolitan', emoji: '��', desc: 'Vodka com cranberry' },
            { id: 6, name: 'Água/Refri', emoji: '💧', desc: 'Bebidas sem álcool' }
        ];
        
        function renderDrinks() {
            const grid = document.getElementById('drinksGrid');
            grid.innerHTML = drinks.map(drink => `
                <div class="drink-card" onclick="orderDrink(${drink.id}, '${drink.name}')">
                    <div class="drink-emoji">${drink.emoji}</div>
                    <div class="drink-info">
                        <div class="drink-name">${drink.name}</div>
                        <div class="drink-desc">${drink.desc}</div>
                    </div>
                </div>
            `).join('');
        }
        
        async function orderDrink(id, name) {
            const mesa = document.getElementById('mesa').value.trim();
            
            if (!mesa) {
                showNotification('Por favor, informe a mesa ou nome', 'error');
                document.getElementById('mesa').focus();
                return;
            }
            
            const pedido = {
                drink_id: id,
                drink_name: name,
                mesa: mesa,
                timestamp: new Date().toISOString(),
                evento: 'WSS+13'
            };
            
            try {
                const response = await fetch(`${API_URL}/pedido`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(pedido)
                });
                
                if (response.ok) {
                    showNotification(`✅ ${name} - Pedido enviado!`, 'success');
                } else {
                    throw new Error('Erro no servidor');
                }
            } catch (error) {
                showNotification('❌ Erro ao enviar pedido', 'error');
                console.error(error);
            }
        }
        
        function showNotification(message, type) {
            const notif = document.getElementById('notification');
            notif.className = `notification ${type}`;
            notif.textContent = message;
            notif.classList.add('show');
            
            setTimeout(() => {
                notif.classList.remove('show');
            }, 3000);
        }
        
        // Verificar status da API
        async function checkAPIStatus() {
            try {
                const response = await fetch(`${API_URL}/status`);
                if (!response.ok) throw new Error();
            } catch {
                showNotification('⚠️ Conectando ao servidor...', 'error');
            }
        }
        
        // Inicializar
        renderDrinks();
        checkAPIStatus();
        
        // Verificar status periodicamente
        setInterval(checkAPIStatus, 30000);
    </script>
</body>
</html>
EOF

# ═══════════════════════════════════════════════════════════
# 3. BACKEND API - server_api.py
# ═══════════════════════════════════════════════════════════

cat > backend/server_api.py << 'EOF'
#!/usr/bin/env python3
"""
Backend API - Coquetel Smart System
Gerencia pedidos e fornece dados em tempo real
"""

from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
import json
import os
from datetime import datetime
import threading
import time

app = Flask(__name__)
CORS(app)

# Configurações
DATA_FILE = '../data/pedidos.json'
STATS_FILE = '../data/estatisticas.json'

# Lock para thread safety
data_lock = threading.Lock()

def load_pedidos():
    """Carrega pedidos do arquivo"""
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, 'r') as f:
            return json.load(f)
    return []

def save_pedidos(pedidos):
    """Salva pedidos no arquivo"""
    os.makedirs(os.path.dirname(DATA_FILE), exist_ok=True)
    with data_lock:
        with open(DATA_FILE, 'w') as f:
            json.dump(pedidos, f, indent=2, ensure_ascii=False)

def update_stats():
    """Atualiza estatísticas"""
    pedidos = load_pedidos()
    
    stats = {
        'total_pedidos': len(pedidos),
        'pedidos_hoje': len([p for p in pedidos if p['timestamp'].startswith(datetime.now().strftime('%Y-%m-%d'))]),
        'drinks_populares': {},
        'mesas_ativas': set(),
        'ultima_atualizacao': datetime.now().isoformat()
    }
    
    for pedido in pedidos:
        # Contagem de drinks
        drink = pedido.get('drink_name', 'Desconhecido')
        stats['drinks_populares'][drink] = stats['drinks_populares'].get(drink, 0) + 1
        
        # Mesas ativas
        if pedido.get('status') != 'entregue':
            stats['mesas_ativas'].add(pedido.get('mesa', 'N/A'))
    
    stats['mesas_ativas'] = list(stats['mesas_ativas'])
    
    # Salvar estatísticas
    with open(STATS_FILE, 'w') as f:
        json.dump(stats, f, indent=2, ensure_ascii=False)
    
    return stats

@app.route('/status')
def status():
    """Endpoint de status da API"""
    return jsonify({
        'status': 'online',
        'timestamp': datetime.now().isoformat(),
        'servico': 'Coquetel Smart API'
    })

@app.route('/pedido', methods=['POST'])
def novo_pedido():
    """Recebe novo pedido"""
    try:
        dados = request.json
        
        # Adicionar ID único e status
        pedido = {
            'id': int(time.time() * 1000),  # ID baseado em timestamp
            'drink_id': dados.get('drink_id'),
            'drink_name': dados.get('drink_name'),
            'mesa': dados.get('mesa'),
            'timestamp': dados.get('timestamp', datetime.now().isoformat()),
            'evento': dados.get('evento', 'N/A'),
            'status': 'pendente'  # pendente, preparando, pronto, entregue
        }
        
        # Carregar pedidos existentes
        pedidos = load_pedidos()
        pedidos.append(pedido)
        
        # Salvar
        save_pedidos(pedidos)
        
        # Atualizar estatísticas
        update_stats()
        
        print(f"✅ Novo pedido: {pedido['drink_name']} - Mesa: {pedido['mesa']}")
        
        return jsonify({'success': True, 'pedido_id': pedido['id']}), 201
        
    except Exception as e:
        print(f"❌ Erro: {e}")
        return jsonify({'error': str(e)}), 400

@app.route('/pedidos', methods=['GET'])
def listar_pedidos():
    """Lista todos os pedidos"""
    status_filter = request.args.get('status')
    pedidos = load_pedidos()
    
    if status_filter:
        pedidos = [p for p in pedidos if p.get('status') == status_filter]
    
    # Ordenar por timestamp (mais recentes primeiro)
    pedidos.sort(key=lambda x: x.get('timestamp', ''), reverse=True)
    
    return jsonify(pedidos)

@app.route('/pedido/<int:pedido_id>/status', methods=['PUT'])
def atualizar_status(pedido_id):
    """Atualiza status de um pedido"""
    try:
        novo_status = request.json.get('status')
        
        if novo_status not in ['pendente', 'preparando', 'pronto', 'entregue']:
            return jsonify({'error': 'Status inválido'}), 400
        
        pedidos = load_pedidos()
        
        for pedido in pedidos:
            if pedido['id'] == pedido_id:
                pedido['status'] = novo_status
                pedido['status_updated'] = datetime.now().isoformat()
                save_pedidos(pedidos)
                update_stats()
                return jsonify({'success': True, 'pedido': pedido})
        
        return jsonify({'error': 'Pedido não encontrado'}), 404
        
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@app.route('/estatisticas')
def estatisticas():
    """Retorna estatísticas do sistema"""
    stats = update_stats()
    return jsonify(stats)

@app.route('/reset', methods=['POST'])
def reset_sistema():
    """Reseta o sistema (apenas para desenvolvimento)"""
    if request.json.get('confirm') == 'RESET':
        save_pedidos([])
        update_stats()
        return jsonify({'success': True, 'message': 'Sistema resetado'})
    return jsonify({'error': 'Confirmação incorreta'}), 400

if __name__ == '__main__':
    print("🚀 Coquetel Smart API")
    print("📍 Rodando em http://localhost:8001")
    print("📊 Dashboard em http://localhost:8002")
    print("-" * 40)
    
    # Garantir que diretórios existam
    os.makedirs('../data', exist_ok=True)
    os.makedirs('../logs', exist_ok=True)
    
    # Inicializar estatísticas
    update_stats()
    
    # Rodar servidor
    app.run(host='0.0.0.0', port=8001, debug=False)
EOF

# ═══════════════════════════════════════════════════════════
# 4. DASHBOARD DO BAR - dashboard/index.html
# ═══════════════════════════════════════════════════════════

cat > dashboard/index.html << 'EOF'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📊 Dashboard - Coquetel Smart</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #1a1a2e;
            color: white;
            padding: 20px;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 12px;
            text-align: center;
        }
        
        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            color: #4caf50;
        }
        
        .stat-label {
            color: #aaa;
            margin-top: 5px;
        }
        
        .pedidos-container {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            padding: 20px;
        }
        
        .pedidos-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .filter-buttons {
            display: flex;
            gap: 10px;
        }
        
        .filter-btn {
            padding: 8px 16px;
            background: rgba(255, 255, 255, 0.1);
            border: none;
            border-radius: 6px;
            color: white;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .filter-btn.active {
            background: #667eea;
        }
        
        .pedido-item {
            background: rgba(255, 255, 255, 0.08);
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s;
        }
        
        .pedido-item:hover {
            background: rgba(255, 255, 255, 0.12);
            transform: translateX(5px);
        }
        
        .pedido-info {
            flex: 1;
        }
        
        .pedido-drink {
            font-size: 1.2em;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .pedido-mesa {
            color: #aaa;
            font-size: 0.9em;
        }
        
        .pedido-time {
            color: #888;
            font-size: 0.8em;
        }
        
        .pedido-actions {
            display: flex;
            gap: 10px;
        }
        
        .action-btn {
            padding: 8px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s;
        }
        
        .btn-preparar {
            background: #ff9800;
            color: white;
        }
        
        .btn-pronto {
            background: #4caf50;
            color: white;
        }
        
        .btn-entregue {
            background: #2196f3;
            color: white;
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .status-pendente {
            background: #ff5722;
            color: white;
        }
        
        .status-preparando {
            background: #ff9800;
            color: white;
        }
        
        .status-pronto {
            background: #4caf50;
            color: white;
        }
        
        .status-entregue {
            background: #607d8b;
            color: white;
        }
        
        .auto-refresh {
            color: #4caf50;
            font-size: 0.9em;
        }
        
        #pedidosList:empty::after {
            content: "Nenhum pedido no momento";
            display: block;
            text-align: center;
            padding: 40px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="header">
        <div>
            <h1>📊 Dashboard do Bar</h1>
            <p>Coquetel Smart System - WSS+13</p>
        </div>
        <div class="auto-refresh">
            ⟳ Atualização automática: <span id="countdown">5</span>s
        </div>
    </div>
    
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-number" id="totalPedidos">0</div>
            <div class="stat-label">Total de Pedidos</div>
        </div>
        <div class="stat-card">
            <div class="stat-number" id="pedidosPendentes">0</div>
            <div class="stat-label">Pendentes</div>
        </div>
        <div class="stat-card">
            <div class="stat-number" id="pedidosPreparando">0</div>
            <div class="stat-label">Preparando</div>
        </div>
        <div class="stat-card">
            <div class="stat-number" id="mesasAtivas">0</div>
            <div class="stat-label">Mesas Ativas</div>
        </div>
    </div>
    
    <div class="pedidos-container">
        <div class="pedidos-header">
            <h2>🍸 Pedidos em Tempo Real</h2>
            <div class="filter-buttons">
                <button class="filter-btn active" onclick="filterPedidos('todos')">Todos</button>
                <button class="filter-btn" onclick="filterPedidos('pendente')">Pendentes</button>
                <button class="filter-btn" onclick="filterPedidos('preparando')">Preparando</button>
                <button class="filter-btn" onclick="filterPedidos('pronto')">Prontos</button>
            </div>
        </div>
        <div id="pedidosList"></div>
    </div>
    
    <script>
        const API_URL = 'http://localhost:8001';
        let currentFilter = 'todos';
        let countdownValue = 5;
        
        // Mapeamento de emojis
        const drinkEmojis = {
            'Mojito': '🍃',
            'Caipirinha': '🍋',
            'Gin Tônica': '🌿',
            'Whisky Sour': '🥃',
            'Cosmopolitan': '🍸',
            'Água/Refri': '💧'
        };
        
        async function loadPedidos() {
            try {
                const response = await fetch(`${API_URL}/pedidos`);
                const pedidos = await response.json();
                
                // Filtrar pedidos
                let filteredPedidos = pedidos;
                if (currentFilter !== 'todos') {
                    filteredPedidos = pedidos.filter(p => p.status === currentFilter);
                }
                
                // Atualizar estatísticas
                updateStats(pedidos);
                
                // Renderizar pedidos
                renderPedidos(filteredPedidos);
                
            } catch (error) {
                console.error('Erro ao carregar pedidos:', error);
            }
        }
        
        function updateStats(pedidos) {
            const stats = {
                total: pedidos.length,
                pendente: pedidos.filter(p => p.status === 'pendente').length,
                preparando: pedidos.filter(p => p.status === 'preparando').length,
                mesas: new Set(pedidos.filter(p => p.status !== 'entregue').map(p => p.mesa)).size
            };
            
            document.getElementById('totalPedidos').textContent = stats.total;
            document.getElementById('pedidosPendentes').textContent = stats.pendente;
            document.getElementById('pedidosPreparando').textContent = stats.preparando;
            document.getElementById('mesasAtivas').textContent = stats.mesas;
        }
        
        function renderPedidos(pedidos) {
            const container = document.getElementById('pedidosList');
            
            // Filtrar apenas pedidos não entregues para exibição principal
            const pedidosAtivos = pedidos.filter(p => p.status !== 'entregue').slice(0, 20);
            
            if (pedidosAtivos.length === 0) {
                container.innerHTML = '';
                return;
            }
            
            container.innerHTML = pedidosAtivos.map(pedido => {
                const emoji = drinkEmojis[pedido.drink_name] || '🍹';
                const time = new Date(pedido.timestamp).toLocaleTimeString('pt-BR');
                
                return `
                    <div class="pedido-item">
                        <div class="pedido-info">
                            <div class="pedido-drink">${emoji} ${pedido.drink_name}</div>
                            <div class="pedido-mesa">Mesa/Nome: ${pedido.mesa}</div>
                            <div class="pedido-time">Pedido às ${time}</div>
                        </div>
                        <div class="pedido-actions">
                            <span class="status-badge status-${pedido.status}">${pedido.status}</span>
                            ${getActionButtons(pedido)}
                        </div>
                    </div>
                `;
            }).join('');
        }
        
        function getActionButtons(pedido) {
            switch(pedido.status) {
                case 'pendente':
                    return `<button class="action-btn btn-preparar" onclick="updateStatus(${pedido.id}, 'preparando')">Preparar</button>`;
                case 'preparando':
                    return `<button class="action-btn btn-pronto" onclick="updateStatus(${pedido.id}, 'pronto')">Pronto</button>`;
                case 'pronto':
                    return `<button class="action-btn btn-entregue" onclick="updateStatus(${pedido.id}, 'entregue')">Entregue</button>`;
                default:
                    return '';
            }
        }
        
        async function updateStatus(pedidoId, novoStatus) {
            try {
                const response = await fetch(`${API_URL}/pedido/${pedidoId}/status`, {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ status: novoStatus })
                });
                
                if (response.ok) {
                    // Tocar som de notificação
                    playNotificationSound();
                    // Recarregar pedidos
                    loadPedidos();
                }
            } catch (error) {
                console.error('Erro ao atualizar status:', error);
            }
        }
        
        function filterPedidos(filter) {
            currentFilter = filter;
            
            // Atualizar botões
            document.querySelectorAll('.filter-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            event.target.classList.add('active');
            
            // Recarregar pedidos
            loadPedidos();
        }
        
        function playNotificationSound() {
            // Som de notificação (beep simples)
            const audio = new AudioContext();
            const oscillator = audio.createOscillator();
            const gainNode = audio.createGain();
            
            oscillator.connect(gainNode);
            gainNode.connect(audio.destination);
            
            oscillator.frequency.value = 800;
            oscillator.type = 'sine';
            
            gainNode.gain.setValueAtTime(0.3, audio.currentTime);
            gainNode.gain.exponentialRampToValueAtTime(0.01, audio.currentTime + 0.1);
            
            oscillator.start(audio.currentTime);
            oscillator.stop(audio.currentTime + 0.1);
        }
        
        // Atualização automática
        function startAutoRefresh() {
            setInterval(() => {
                countdownValue--;
                if (countdownValue <= 0) {
                    countdownValue = 5;
                    loadPedidos();
                }
                document.getElementById('countdown').textContent = countdownValue;
            }, 1000);
        }
        
        // Inicializar
        loadPedidos();
        startAutoRefresh();
        
        // Detectar novos pedidos (websocket simulado)
        let lastPedidoCount = 0;
        setInterval(async () => {
            try {
                const response = await fetch(`${API_URL}/estatisticas`);
                const stats = await response.json();
                
                if (stats.total_pedidos > lastPedidoCount && lastPedidoCount > 0) {
                    // Novo pedido detectado!
                    playNotificationSound();
                    console.log('🔔 Novo pedido detectado!');
                }
                lastPedidoCount = stats.total_pedidos;
            } catch (error) {
                // Silencioso
            }
        }, 2000);
    </script>
</body>
</html>
EOF

# ═══════════════════════════════════════════════════════════
# 5. MONITOR DE SISTEMA - scripts/monitor.py
# ═══════════════════════════════════════════════════════════

cat > scripts/monitor.py << 'EOF'
#!/usr/bin/env python3
"""
Monitor de Sistema - Coquetel Smart
Análise em tempo real e insights
"""

import json
import time
import os
from datetime import datetime, timedelta
from collections import Counter

class CocktailMonitor:
    def __init__(self):
        self.data_file = '../data/pedidos.json'
        self.insights_file = '../data/insights.json'
        self.last_check = datetime.now()
        
    def load_pedidos(self):
        """Carrega pedidos do arquivo"""
        if os.path.exists(self.data_file):
            with open(self.data_file, 'r') as f:
                return json.load(f)
        return []
    
    def analyze_patterns(self):
        """Analisa padrões nos pedidos"""
        pedidos = self.load_pedidos()
        
        if not pedidos:
            return None
        
        insights = {
            'timestamp': datetime.now().isoformat(),
            'total_pedidos': len(pedidos),
            'drinks_ranking': {},
            'horarios_pico': {},
            'tempo_medio_preparo': None,
            'mesas_mais_ativas': {},
            'recomendacoes': []
        }
        
        # Análise de drinks mais pedidos
        drinks = [p['drink_name'] for p in pedidos]
        drink_counter = Counter(drinks)
        insights['drinks_ranking'] = dict(drink_counter.most_common(5))
        
        # Análise de horários
        horas = [datetime.fromisoformat(p['timestamp']).hour for p in pedidos]
        hora_counter = Counter(horas)
        insights['horarios_pico'] = dict(hora_counter.most_common(3))
        
        # Mesas mais ativas
        mesas = [p['mesa'] for p in pedidos if p.get('mesa')]
        mesa_counter = Counter(mesas)
        insights['mesas_mais_ativas'] = dict(mesa_counter.most_common(5))
        
        # Gerar recomendações
        if drink_counter:
            mais_pedido = drink_counter.most_common(1)[0][0]
            insights['recomendacoes'].append(
                f"🍸 {mais_pedido} é o mais popular - prepare mais!"
            )
        
        if hora_counter:
            hora_pico = hora_counter.most_common(1)[0][0]
            insights['recomendacoes'].append(
                f"⏰ Horário de pico: {hora_pico}:00 - reforce a equipe!"
            )
        
        # Verificar pedidos pendentes
        pendentes = [p for p in pedidos if p.get('status') == 'pendente']
        if len(pendentes) > 5:
            insights['recomendacoes'].append(
                f"⚠️ {len(pendentes)} pedidos pendentes - acelere o preparo!"
            )
        
        return insights
    
    def save_insights(self, insights):
        """Salva insights em arquivo"""
        with open(self.insights_file, 'w') as f:
            json.dump(insights, f, indent=2, ensure_ascii=False)
    
    def run(self):
        """Loop principal do monitor"""
        print("🔍 Monitor Coquetel Smart iniciado")
        print("=" * 40)
        
        while True:
            try:
                insights = self.analyze_patterns()
                
                if insights:
                    self.save_insights(insights)
                    
                    # Exibir resumo no console
                    print(f"\n📊 Análise - {datetime.now().strftime('%H:%M:%S')}")
                    print(f"   Total de pedidos: {insights['total_pedidos']}")
                    
                    if insights['drinks_ranking']:
                        print("   Top drinks:", list(insights['drinks_ranking'].keys())[:3])
                    
                    if insights['recomendacoes']:
                        print("   Recomendações:")
                        for rec in insights['recomendacoes']:
                            print(f"     {rec}")
                
                time.sleep(30)  # Análise a cada 30 segundos
                
            except KeyboardInterrupt:
                print("\n👋 Monitor encerrado")
                break
            except Exception as e:
                print(f"❌ Erro no monitor: {e}")
                time.sleep(5)

if __name__ == '__main__':
    monitor = CocktailMonitor()
    monitor.run()
EOF

# ═══════════════════════════════════════════════════════════
# 6. SCRIPT DE ANÁLISE - scripts/analyze.py
# ═══════════════════════════════════════════════════════════

cat > scripts/analyze.py << 'EOF'
#!/usr/bin/env python3
"""
Análise de Dados - Coquetel Smart System
Gera relatórios e insights dos pedidos
"""

import json
import os
from datetime import datetime
from collections import Counter
import sys

def load_data():
    """Carrega dados de pedidos"""
    data_file = '../data/pedidos.json'
    if os.path.exists(data_file):
        with open(data_file, 'r') as f:
            return json.load(f)
    return []

def generate_report():
    """Gera relatório completo"""
    pedidos = load_data()
    
    if not pedidos:
        print("❌ Nenhum pedido encontrado")
        return
    
    print("\n" + "="*50)
    print("📊 RELATÓRIO COQUETEL SMART SYSTEM")
    print("="*50)
    
    # Estatísticas Gerais
    print(f"\n📈 ESTATÍSTICAS GERAIS")
    print(f"   Total de pedidos: {len(pedidos)}")
    
    # Status dos pedidos
    status_count = Counter([p.get('status', 'N/A') for p in pedidos])
    print(f"\n📋 STATUS DOS PEDIDOS")
    for status, count in status_count.most_common():
        print(f"   {status}: {count} pedidos")
    
    # Drinks mais populares
    drinks = Counter([p['drink_name'] for p in pedidos])
    print(f"\n🍸 TOP 5 DRINKS MAIS PEDIDOS")
    for i, (drink, count) in enumerate(drinks.most_common(5), 1):
        percent = (count/len(pedidos))*100
        print(f"   {i}. {drink}: {count} pedidos ({percent:.1f}%)")
    
    # Mesas/Clientes mais ativos
    mesas = Counter([p['mesa'] for p in pedidos if p.get('mesa')])
    if mesas:
        print(f"\n🪑 TOP 5 MESAS/CLIENTES MAIS ATIVOS")
        for i, (mesa, count) in enumerate(mesas.most_common(5), 1):
            print(f"   {i}. {mesa}: {count} pedidos")
    
    # Análise temporal
    if pedidos:
        horas = [datetime.fromisoformat(p['timestamp']).hour for p in pedidos]
        hora_counter = Counter(horas)
        hora_pico = hora_counter.most_common(1)[0]
        print(f"\n⏰ ANÁLISE TEMPORAL")
        print(f"   Horário de pico: {hora_pico[0]}:00 ({hora_pico[1]} pedidos)")
        
        # Distribuição por hora
        print(f"\n   Distribuição por hora:")
        for hora in sorted(hora_counter.keys()):
            bar = '█' * int((hora_counter[hora]/max(hora_counter.values()))*20)
            print(f"   {hora:02d}:00 {bar} {hora_counter[hora]}")
    
    # Recomendações
    print(f"\n💡 RECOMENDAÇÕES")
    
    if drinks.most_common(1):
        print(f"   • Aumente o estoque de {drinks.most_common(1)[0][0]}")
    
    if status_count.get('pendente', 0) > 5:
        print(f"   • ⚠️ Muitos pedidos pendentes! Acelere o preparo")
    
    if len(pedidos) > 50:
        print(f"   • ✅ Alto volume de pedidos - considere adicionar mais bartenders")
    
    print("\n" + "="*50)
    print(f"Relatório gerado em: {datetime.now().strftime('%d/%m/%Y %H:%M')}")
    print("="*50 + "\n")

def export_csv():
    """Exporta dados para CSV"""
    pedidos = load_data()
    
    if not pedidos:
        print("❌ Nenhum pedido para exportar")
        return
    
    csv_file = f"../data/export_{datetime.now().strftime('%Y%m%d_%H%M')}.csv"
    
    with open(csv_file, 'w') as f:
        # Header
        f.write("ID,Drink,Mesa,Timestamp,Status,Evento\n")
        
        # Dados
        for p in pedidos:
            f.write(f"{p.get('id','')},{p.get('drink_name','')},{p.get('mesa','')},")
            f.write(f"{p.get('timestamp','')},{p.get('status','')},{p.get('evento','')}\n")
    
    print(f"✅ Dados exportados para: {csv_file}")

if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == 'export':
        export_csv()
    else:
        generate_report()
EOF

# Tornar scripts executáveis
chmod +x scripts/monitor.py
chmod +x scripts/analyze.py

# ═══════════════════════════════════════════════════════════
# 7. README COM INSTRUÇÕES
# ═══════════════════════════════════════════════════════════

cat > README.md << 'EOF'
# 🍸 Coquetel Smart System 2.0

Sistema completo de gestão inteligente para eventos corporativos com pedidos em tempo real.

## 🚀 Início Rápido

```bash
# Iniciar o sistema completo
./run_system.sh
```

## 📱 Acessos

- **Cliente (Pedidos)**: http://localhost:8000
- **Dashboard do Bar**: http://localhost:8002
- **API Status**: http://localhost:8001/status

## 🏗️ Estrutura

```
coquetel-smart-system/
├── frontend/          # Interface do cliente
├── backend/           # API REST
├── dashboard/         # Painel do bar
├── data/             # Dados persistentes
├── logs/             # Logs do sistema
└── scripts/          # Scripts de análise
```

## 📊 Funcionalidades

### Para Clientes
- Interface intuitiva para pedidos
- Confirmação em tempo real
- Identificação por mesa/nome

### Para o Bar
- Dashboard em tempo real
- Gestão de status dos pedidos
- Estatísticas e métricas
- Notificações de novos pedidos

### Para Gestores
- Análise de dados e padrões
- Relatórios detalhados
- Exportação de dados (CSV)
- Insights automáticos

## 🛠️ Comandos Úteis

```bash
# Gerar relatório
python3 scripts/analyze.py

# Exportar dados para CSV
python3 scripts/analyze.py export

# Monitorar sistema (em segundo terminal)
python3 scripts/monitor.py

# Resetar sistema (desenvolvimento)
curl -X POST http://localhost:8001/reset \
  -H "Content-Type: application/json" \
  -d '{"confirm":"RESET"}'
```

## 📈 Métricas Disponíveis

- Total de pedidos
- Drinks mais populares
- Horários de pico
- Mesas mais ativas
- Tempo médio de preparo
- Taxa de conclusão

## 🔧 Tecnologias

- **Frontend**: HTML5, CSS3, JavaScript Vanilla
- **Backend**: Python 3, Flask, Flask-CORS
- **Dados**: JSON (facilmente migrável para PostgreSQL)
- **Deploy**: Pronto para Docker/Cloud

## 📝 Próximas Melhorias

- [ ] WebSocket para atualizações real-time
- [ ] Integração com impressora térmica
- [ ] QR Code para mesas
- [ ] Pagamento integrado
- [ ] App mobile nativo
- [ ] Machine Learning para previsão de demanda

## 🤝 Suporte

Para suporte ou dúvidas sobre o sistema, consulte a documentação ou entre em contato com a equipe de desenvolvimento.

---
**Coquetel Smart System** - Transformando eventos corporativos com tecnologia 🍸
EOF

# ═══════════════════════════════════════════════════════════
# FINALIZAÇÃO
# ═══════════════════════════════════════════════════════════

echo -e "${GREEN}✅ Sistema Coquetel Smart instalado com sucesso!${NC}"
echo ""
echo -e "${YELLOW}📍 Localização: ~/Projetos/coquetel-smart-system${NC}"
echo ""
echo -e "${BLUE}Para iniciar o sistema completo:${NC}"
echo -e "${GREEN}cd ~/Projetos/coquetel-smart-system${NC}"
echo -e "${GREEN}./run_system.sh${NC}"
echo ""
echo -e "${BLUE}Componentes disponíveis:${NC}"
echo -e "  🌐 Cliente: http://localhost:8000"
echo -e "  📊 Dashboard: http://localhost:8002"
echo -e "  ⚙️  API: http://localhost:8001"
echo ""
echo -e "${YELLOW}💡 Dica: Execute './run_system.sh' para iniciar todos os serviços${NC}"
