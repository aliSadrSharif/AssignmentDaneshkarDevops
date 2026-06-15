#!/bin/bash

# Local interface
INTERFACE="192.168.1.0/24"

# Check if UFW exists
if command -v ufw >/dev/null 2>&1; then
    echo "----- Configuring firewall with UFW -----"

    sudo ufw --force reset
    sudo ufw default deny incoming
    sudo ufw default allow outgoing

    # Allow SSH only from local network
    sudo ufw allow from "$INTERFACE" to any port 22 proto tcp

    # Allow HTTP and HTTPS from anywhere
    sudo ufw allow 80/tcp
    sudo ufw allow 443/tcp

    # Enable UFW
    sudo ufw --force enable

    # Save active rules
    sudo ufw status numbered > firewall_rules.txt

else
    echo "----- Configuring firewall with iptables -----"

    # Flush existing rules
    sudo iptables -F
    sudo iptables -X
    sudo iptables -Z

    # Default policies
    sudo iptables -P INPUT DROP
    sudo iptables -P FORWARD DROP
    sudo iptables -P OUTPUT ACCEPT

    # Allow localhost and established connections
    sudo iptables -A INPUT -i lo -j ACCEPT
    sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

    # Allow SSH only from local network
    sudo iptables -A INPUT -p tcp -s "$INTERFACE" --dport 22 -j ACCEPT

    # Allow HTTP and HTTPS from anywhere
    sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

    # Save active rules
    sudo iptables -L -n > firewall_rules.txt
fi

echo "Firewall configured successfully."
echo "Rules saved to firewall_rules.txt"
