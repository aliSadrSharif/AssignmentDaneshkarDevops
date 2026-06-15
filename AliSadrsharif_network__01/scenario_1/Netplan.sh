#!/bin/bash

#find interface
INTERFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -vE "lo|docker|veth|virbr|br-|wl" | head -n 1)

#check for valid interface
if [ -z "$INTERFACE" ]; then
    echo "There is no valid interface"
    exit 1
fi

echo -e "Selected interface: $INTERFACE\n"
echo -e "Need access for appling changes\n."

#creating netplan yaml file
NETPLAN_FILE="/etc/netplan/01-netcfg.yaml"

#Servers commenly use ethernet as network connection
sudo tee $NETPLAN_FILE > /dev/null <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    ${INTERFACE}:
      dhcp4: no
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 1.1.1.1
EOF

sudo netplan apply

echo -e "Changes are as follows:\n"
cat $NETPLAN_FILE