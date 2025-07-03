#!/bin/bash

set -e

WG_DIR="$HOME/wireguard-poc"
mkdir -p "$WG_DIR"
cd "$WG_DIR"

echo "Generating WireGuard keys..."

# Generate server keys
wg genkey | tee server_private.key | wg pubkey > server_public.key

# Generate client keys
wg genkey | tee client_private.key | wg pubkey > client_public.key

# Read keys into variables
SERVER_PRIVATE_KEY=$(<server_private.key)
SERVER_PUBLIC_KEY=$(<server_public.key)
CLIENT_PRIVATE_KEY=$(<client_private.key)
CLIENT_PUBLIC_KEY=$(<client_public.key)

echo "Creating cloud-init.sh..."

#
# ens5 is the default interface in Amazon Linux 2023
#

cat > cloud-init.sh <<EOF
#!/bin/bash
set -e

dnf install -y wireguard-tools iptables

echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sysctl -p

mkdir -p /etc/wireguard
cat > /etc/wireguard/wg0.conf <<CONFIG
[Interface]
Address = 10.0.0.1/24
ListenPort = 51820
PrivateKey = $SERVER_PRIVATE_KEY
PostUp = iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE
PostDown = iptables -t nat -D POSTROUTING -o ens5 -j MASQUERADE

[Peer]
PublicKey = $CLIENT_PUBLIC_KEY
AllowedIPs = 10.0.0.2/32
CONFIG

chmod 600 /etc/wireguard/wg0.conf

systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0
EOF

echo "Done. Files saved in: $WG_DIR"

