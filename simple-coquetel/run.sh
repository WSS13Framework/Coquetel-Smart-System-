#!/bin/bash

echo "🍎 Iniciando Sistema Coquetel - Estilo Steve Jobs"
echo "================================================"

# Instala dependências se necessário
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 não encontrado. Instale primeiro."
    exit 1
fi

# Instala qrcode se necessário
pip3 install qrcode[pil] 2>/dev/null || echo "📦 QRCode já instalado"

# Gera QR Code
cd qr && python3 generate.py http://localhost:8000 && cd ..

# Inicia servidor
cd web && python3 server.py
