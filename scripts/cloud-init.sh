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
PrivateKey = IPmG33XO6ft5mpAmwMo7BaqHJQKbCHNIztpnrnpNhVw=
PostUp = iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = VfRckhoRkml6xmis4cmGGBKnQgy2cuaPy97ZdShJ0GA=
AllowedIPs = 10.0.0.2/32
CONFIG

chmod 600 /etc/wireguard/wg0.conf

systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0
