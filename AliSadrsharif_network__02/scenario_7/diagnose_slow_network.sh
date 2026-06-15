#!/bin/bash
OUT="network_performance_diagnosis.txt"
DNS_DOMAIN="daneshkar.net"
: > "$OUT"
echo "----- Network Performance Diagnosis -----" >> "$OUT"
echo "DNS domain: $DNS_DOMAIN" >> "$OUT"
# 1) Latency test
echo "----- Latency test -----" | tee -a "$OUT"
ping -c 10 $DNS_DOMAIN | grep avg | tee -a "$OUT" || echo "Latency test failed" | tee -a "$OUT"
echo "" | tee -a "$OUT"
# 2) Packet loss
echo "----- Packet loss (from ping) -----" | tee -a "$OUT"
ping -c 10 $DNS_DOMAIN | tee -a "$OUT"
echo "" | tee -a "$OUT"
# 3) DNS resolution time
echo "----- DNS resolution time -----" | tee -a "$OUT"
time dig "$DNS_DOMAIN" | tee -a "$OUT"
echo "" | tee -a "$OUT"
# 4) MTU size check
echo "----- MTU size check -----" | tee -a "$OUT"
ip link show | grep mtu | tee -a "$OUT"
ping -M do -s 1472 $DNS_DOMAIN | tee -a "$OUT"
# 5) Identify probable bottleneck 
echo "----- Probable bottleneck -----" | tee -a "$OUT"
echo "Based on results:" >> "$OUT"
echo "- High avg latency => likely RTT/routing/ISP issue" | tee -a "$OUT"
echo "- High packet loss => likely congestion or unstable path" | tee -a "$OUT"
echo "- MTU/fragmentation symptoms => likely Path MTU / MTU problem" | tee -a "$OUT"
