#!/usr/bin/env bash

# final script is refactored by AI

set -euo pipefail
OUT="log_analysis_report.txt"
: > "$OUT"
echo "----- Log Analysis Report -----" >> "$OUT"
echo "Generated at: $(date)" >> "$OUT"
echo >> "$OUT"
# 1) Find network-related log files in /var/log
echo "[1] Searching network-related logs in /var/log ..." | tee -a "$OUT"
NETWORK_LOG_FILES=()
# Common candidates on Debian/Ubuntu (extend if needed)
for f in /var/log/syslog /var/log/kern.log /var/log/auth.log /var/log/daemon.log \
         /var/log/secure /var/log/messages /var/log/ufw.log; do
  if [[ -f "$f" ]]; then
    if grep -qiE "sshd|connection|connected|disconnected|failed password|invalid user|port|tcp|udp|brute|ssh" "$f" 2>/dev/null; then
      NETWORK_LOG_FILES+=("$f")
    fi
  fi
done
if [[ ${#NETWORK_LOG_FILES[@]} -eq 0 ]]; then
  echo "No log files found under /var/log for analysis." | tee -a "$OUT"
  exit 1
fi
echo "Network-related log candidates:" >> "$OUT"
printf " - %s\n" "${NETWORK_LOG_FILES[@]}" >> "$OUT"
echo >> "$OUT"
# Helper: extract recent events
extract_recent() {
  local files=("$@")
  local PATTERN='sshd|ssh|connection|connected|disconnected|failed password|invalid user|port|tcp|udp|brute|authentication failure|kernel:.*(tcp|udp)'
  grep -EHi "$PATTERN" "${files[@]}" 2>/dev/null | tail -n 10
}
# 2) Extract the last 10 network-related events
echo "[2] Extracting last 10 network-related events ..." | tee -a "$OUT"
echo "Last 10 events:" >> "$OUT"
extract_recent "${NETWORK_LOG_FILES[@]}" >> "$OUT" || true
echo >> "$OUT"
# 3) Extract IP addresses and count them
echo "[3] Extracting and counting IP addresses from logs ..." | tee -a "$OUT"
echo "Top IPs (by occurrence):" >> "$OUT"
grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' "${NETWORK_LOG_FILES[@]}" 2>/dev/null \
  | sort \
  | uniq -c \
  | sort -nr \
  | head -n 50 >> "$OUT" || true
echo >> "$OUT"
# 4) Identify suspicious patterns (e.g., multiple failed attempts)
echo "[4] Identifying suspicious patterns (e.g., multiple failed attempts) ..." | tee -a "$OUT"
SUSPICIOUS_PATTERNS='Failed password|Invalid user|authentication failure|POSSIBLE BREAK-IN|multiple failed|Failed to authenticate|brute force'
{
  echo "Suspicious lines (summary):"
  grep -EHi "$SUSPICIOUS_PATTERNS" "${NETWORK_LOG_FILES[@]}" 2>/dev/null | tail -n 50
} >> "$OUT" || true
echo >> "$OUT"
echo "Suspicious IPs with multiple failed attempts (simple heuristic):" >> "$OUT"
# Heuristic: look only at auth logs for failed attempts per IP
AUTH_CANDIDATES=()
for f in /var/log/auth.log /var/log/secure; do
  [[ -f "$f" ]] && AUTH_CANDIDATES+=("$f")
done
if [[ ${#AUTH_CANDIDATES[@]} -gt 0 ]]; then
  THRESHOLD=5   # change if needed
  grep -EHi 'Failed password|Invalid user|authentication failure|Failed to authenticate' "${AUTH_CANDIDATES[@]}" 2>/dev/null \
    | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' \
    | sort \
    | uniq -c \
    | awk -v t="$THRESHOLD" '$1>=t {print}' \
    | sort -nr \
    | head -n 30 >> "$OUT" || true
else
  echo "No auth.log/secure found for failed-attempt heuristic." >> "$OUT"
fi
echo >> "$OUT"
