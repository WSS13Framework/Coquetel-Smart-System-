#!/bin/bash

echo "🎪 Configurando Sistema para Evento Corporativo..."

cat > simple-coquetel/index.html << 'EOF_HTML'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🍸 Coquetel Smart - Evento Corporativo</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #0a0a0a 0%, #1a1a1a 100%);
            color: #ffffff;
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 400px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.1);
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
            font-weight: 300;
            margin-bottom: 5px;
        }
        
        .subtitle {
            color: #888;
            font-size: 0.9em;
        }
        
        .drinks-grid {
            display: grid;
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .drink-card {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 15px;
            padding: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .drink-card:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.12);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }
        
        .drink-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
            transition: left 0.5s;
        }
        
        .drink-card:hover::before {
            left: 100%;
        }
        
        .drink-emoji {
            font-size: 2.5em;
            margin-bottom: 10px;
            display: block;
        }
        
        .drink-name {
            font-size: 1.2em;
            font-weight: 500;
            margin-bottom: 5px;
        }
        
        .drink-desc {
            color: #aaa;
            font-size: 0.85em;
            line-height: 1.4;
        }
        
        .status {
            text-align: center;
            padding: 15px;
            background: rgba(0, 255, 0, 0.1);
            border-radius: 10px;
            border: 1px solid rgba(0, 255, 0, 0.3);
            margin-top: 20px;
            display: none;
        }
        
        .popup {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) scale(0);
            background: rgba(0, 0, 0, 0.9);
            backdrop-filter: blur(20px);
            color: white;
            padding: 30px;
            border-radius: 20px;
            border: 2px solid #00ff00;
            text-align: center;
            z-index: 1000;
            transition: transform 0.3s ease;
        }
        
        .popup.show {
            transform: translate(-50%, -50%) scale(1);
        }
        
        .popup-emoji {
            font-size: 3em;
            margin-bottom: 15px;
        }
        
        .event-info {
            text-align: center;
            margin-bottom: 25px;
            padding: 15px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
        }
        
        .event-name {
            font-size: 1.1em;
            color: #00ff88;
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">🍸</div>
            <div class="title">Coquetel Smart</div>
            <div class="subtitle">Sistema Inteligente para Eventos</div>
        </div>
        
        <div class="event-info">
            <div class="event-name">🎪 Evento Corporativo WSS+13</div>
            <div style="color: #888; font-size: 0.8em;">Lançamento de Produto</div>
        </div>
        
        <div class="drinks-grid">
            <div class="drink-card" onclick="orderDrink('Mojito Clássico', '🍃')">
                <span class="drink-emoji">🍃</span>
                <div class="drink-name">Mojito Clássico</div>
                <div class="drink-desc">Refrescante com hortelã e limão</div>
            </div>
            
            <div class="drink-card" onclick="orderDrink('Caipirinha Premium', '🍋')">
                <span class="drink-emoji">🍋</span>
                <div class="drink-name">Caipirinha Premium</div>
                <div class="drink-desc">Cachaça artesanal com limão siciliano</div>
            </div>
            
            <div class="drink-card" onclick="orderDrink('Gin Tônica Especial', '🌿')">
                <span class="drink-emoji">🌿</span>
                <div class="drink-name">Gin Tônica Especial</div>
                <div class="drink-desc">Gin premium com especiarias</div>
            </div>
            
            <div class="drink-card" onclick="orderDrink('Whisky Sour', '🥃')">
                <span class="drink-emoji">🥃</span>
                <div class="drink-name">Whisky Sour</div>
                <div class="drink-desc">Clássico americano com limão</div>
            </div>
            
            <div class="drink-card" onclick="orderDrink('Cosmopolitan', '🍸')">
                <span class="drink-emoji">🍸</span>
                <div class="drink-name">Cosmopolitan</div>
                <div class="drink-desc">Elegante com cranberry</div>
            </div>
            
            <div class="drink-card" onclick="orderDrink('Água Premium', '💧')">
                <span class="drink-emoji">💧</span>
                <div class="drink-name">Água Premium</div>
                <div class="drink-desc">Água mineral com gás ou sem gás</div>
            </div>
        </div>
        
        <div class="status" id="status">
            ✅ Sistema Online - Pronto para pedidos
        </div>
    </div>
    
    <div class="popup" id="popup">
        <div class="popup-emoji">✅</div>
        <div id="popup-message"></div>
    </div>
    
    <script>
        // Mostrar status online
        document.getElementById('status').style.display = 'block';
        
        function orderDrink(name, emoji) {
            // Simular envio do pedido
            console.log(`Pedido: ${name}`);
            
            // Mostrar popup de confirmação
            showPopup(`${emoji} ${name}\n\nPedido enviado com sucesso!\nSeu drink será preparado em instantes.`);
            
            // Aqui conectaria com o backend real
            // fetch('/api/order', { method: 'POST', body: JSON.stringify({drink: name}) })
        }
        
        function showPopup(message) {
            const popup = document.getElementById('popup');
            const messageEl = document.getElementById('popup-message');
            
            messageEl.textContent = message;
            popup.classList.add('show');
            
            setTimeout(() => {
                popup.classList.remove('show');
            }, 3000);
        }
        
        // Simular conexão em tempo real
        setInterval(() => {
            console.log('Sistema online - aguardando pedidos...');
        }, 5000);
    </script>
</body>
</html>
EOF_HTML

echo "🎪 Sistema Corporativo configurado!"
echo "✅ SEM preços, SEM WhatsApp"
echo "🔄 Recarregue para ver o novo design"
