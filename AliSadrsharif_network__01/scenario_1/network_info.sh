#!/bin/bash

file="network_info.txt"

echo -e "Network Information\n" > $file

echo -e "----- Interfaces -----" >> $file

ip -o link show | awk -F': ' '{print $1": "$2}' >> "$file" 2>/dev/null || echo "there is no existing interfaces" >> "$file"

echo -e "\n----- IP Address -----" >> "$file"
ip -4 addr show | awk '/inet / {print $2}' >> "$file"
ip -6 addr show | awk '/inet6 / {print $2}' >> "$file"

echo -e "\n----- Default Gateway -----" >> "$file"
ip route | awk '/default/ {print $3}' >> "$file"

echo -e "\n----- DNS Servers -----" >> "$file"
grep "nameserver" /etc/resolv.conf | awk '{print $2}' >> "$file"