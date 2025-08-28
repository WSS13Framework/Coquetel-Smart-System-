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
