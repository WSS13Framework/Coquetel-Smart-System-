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
