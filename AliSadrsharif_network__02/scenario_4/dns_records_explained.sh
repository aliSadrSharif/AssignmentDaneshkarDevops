#!/bin/bash
SITE="google.com"
RECORD_TYPES=("A" "AAAA" "MX" "TXT" "NS")
for type in "${RECORD_TYPES[@]}"; do
  echo -e "----- Query $type record for $SITE -----\n"
  dig "$SITE" "$type"
done > dns_records_explained.txt
