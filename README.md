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
