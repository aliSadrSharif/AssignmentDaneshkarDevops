#!/usr/bin/env bash

# Refreshes every 10 seconds
# Requires: ip, ss, lsof/netstat (optional), dig (optional), tail
REFRESH_SECONDS=10
# Optional: DNS server detection (Linux)
get_dns_servers() {
  # Try systemd-resolved first
  if [ -f /etc/resolv.conf ]; then
    awk '/^nameserver / {print $2}' /etc/resolv.conf 2>/dev/null
  fi
}
# Optional: Open ports detection (top listening ports)
get_open_ports() {
  # ss is widely available; show listening TCP/UDP ports
  echo "TCP Listening:"
  ss -lntu 2>/dev/null | awk 'NR==1{print} NR>1{print}'
  echo
  echo "UDP Listening:"
  ss -lnu 2>/dev/null | awk 'NR==1{print} NR>1{print}'
}
# Latest 5 log entries
get_latest_logs() {
  # Prefer syslog/messages
  if [ -f /var/log/syslog ]; then
    tail -n 5 /var/log/syslog 2>/dev/null
  elif [ -f /var/log/messages ]; then
    tail -n 5 /var/log/messages 2>/dev/null
  else
    echo "No common system log file found (/var/log/syslog or /var/log/messages)."
  fi
}
    while true; do
  clear
  echo "------ Network Dashboard -----"
echo
  echo -e "\e[32m[1] Network interfaces (ip -br addr)\e[0m"
  ip -br addr 2>/dev/null || echo "ip command not available"
echo
  echo -e "\e[32m[2] Active connections (ss -ntu)\e[0m"
  # Count all TCP/UDP established + listening lines depending on ss output; simplest: number of lines excluding header
  # If ss output has a header, filter it out.
  conn_count="$(ss -ntu 2>/dev/null | wc -l)"
  echo -e "Connections count: $conn_count"
echo
  echo -e "\e[32m[3] Open ports (Listening) using ss\e[0m"
  get_open_ports
echo
  echo -e "\e[32m[4] DNS servers\e[0m"
  dns="$(get_dns_servers | tr '\n' ' ')"
  if [ -z "$dns" ]; then
    echo "DNS servers: not found"
  else
    echo "DNS servers: $dns"
  fi
echo
  echo -e "\e[32m[5] Latest 5 log entries\e[0m"
  get_latest_logs
echo
  echo -e "\e[31m(Refreshing every ${REFRESH_SECONDS}s, Ctrl+C to exit)\e[0m"
sleep "$REFRESH_SECONDS"
done
