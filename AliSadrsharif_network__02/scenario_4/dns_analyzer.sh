#!/usr/bin/env bash
OUT="dns_analysis_report.txt"
: > "$OUT"
DOMAINS=("daneshkar.net" "google.com" "varzesh3.com")
echo -e "----- DNS Analysis Report -----\n" >> "$OUT"
for domain in "${DOMAINS[@]}"; do
  ttl=$(dig "$domain" +noall +answer | awk 'NR==1{print $2}')
  ttl=${ttl:-N/A}
ips=$(dig +short "$domain" | tr '\n' ' ')
  ips=${ips:-N/A}
  t=$( (time dig "$domain" > /dev/null) 2>&1 | awk '/real/ {print $2}' )
  t=${t%s}
  t_ms=$(awk -v s="$t" 'BEGIN{printf "%.3f", s*1000}')
{
    echo "Domain: $domain"
    echo "TTL: $ttl"
    echo "IP Addresses: $ips"
    echo "Response Time (ms): $t_ms"
    echo "----------------------------------------"
  } >> "$OUT"
done
