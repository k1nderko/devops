#!/bin/bash

set -e

# Функція для перевірки встановлення команди
check_installed() {
    command -v "$1" >/dev/null 2>&1
}

echo "=== Встановлення Docker ==="
if check_installed docker; then
    echo "Docker вже встановлений"
else
    echo "Встановлюємо Docker..."
    sudo apt update
    sudo apt install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) \
      signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker "$USER"
    echo "Docker встановлено"
fi

echo "=== Встановлення Docker Compose ==="
if check_installed docker-compose; then
    echo "Docker Compose вже встановлений"
else
    echo "Встановлюємо Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose встановлено"
fi

echo "=== Встановлення Python 3.9+ ==="
if check_installed python3; then
    PYTHON_VERSION=$(python3 -V | awk '{print $2}')
    if [[ "$PYTHON_VERSION" > "3.8" ]]; then
        echo "Python $PYTHON_VERSION вже встановлений"
    else
        echo "Python версія замала, оновлення..."
        sudo apt update
        sudo apt install -y python3 python3-pip
    fi
else
    echo "Встановлюємо Python..."
    sudo apt update
    sudo apt install -y python3 python3-pip
fi

echo "=== Встановлення Django ==="
if python3 -m django --version >/dev/null 2>&1; then
    echo "Django вже встановлений"
else
    echo "Встановлюємо Django..."
    python3 -m pip install --upgrade pip
    pip3 install Django
    echo "Django встановлено"
fi

echo "✅ Усі інструменти встановлено або вже були встановлені"
