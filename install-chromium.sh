#!/bin/bash

echo "=== Setup Chromium di VPS Ubuntu ==="

# Input username & password
read -p "Masukkan nama pengguna: " username
read -s -p "Masukkan kata sandi: " password
echo

# Update sistem
apt update && apt upgrade -y

# Install paket dasar
apt install -y xfce4 xfce4-goodies tightvncserver curl wget git ufw docker.io

# Setup UFW (buka port VNC & Chromium web)
ufw allow 3010/tcp
ufw allow 5901/tcp
ufw --force enable

# Setup Docker
systemctl start docker
systemctl enable docker

# Pull image Chromium dari Kasm
docker pull kasmweb/chromium:1.13.0

# Jalankan container
docker run -d \
  -p 3010:6901 \
  -e VNC_PW="$password" \
  -e KASM_USER="$username" \
  --name chromium-web \
  kasmweb/chromium:1.13.0

# Tampilkan informasi akses
IP=$(curl -s ifconfig.me)
echo "========================================"
echo "Akses Chromium di browser Anda di: http://$IP:3010/"
echo "Nama pengguna: $username"
echo "Kata sandi: $password"
echo "========================================"
