#!/bin/bash

set -e

WG_DIR="$HOME/wireguard-poc"
cd "$WG_DIR" || { echo "Directory $WG_DIR not found."; exit 1; }

# Read key values
CLIENT_PRIVATE_KEY=$(<client_private.key)
SERVER_PUBLIC_KEY=$(<server_public.key)

# Ask for server IP
read -rp "Enter your AWS server's public IP: " SERVER_IP

# Create client config
cat > wg0-client.conf <<EOF
[Interface]
PrivateKey = $CLIENT_PRIVATE_KEY
Address = 10.0.0.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
Endpoint = $SERVER_IP:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF

echo "Client config generated: $WG_DIR/wg0-client.conf"

