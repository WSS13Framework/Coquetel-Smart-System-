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
