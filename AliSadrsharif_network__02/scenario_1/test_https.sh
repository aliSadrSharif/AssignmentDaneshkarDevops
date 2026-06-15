#!/usr/bin/env bash

{
  echo -e "----- HTTPS Test Report -----\n"

  echo -e "curl verbose HTTPS request\n"
  curl -vI https://google.com 2>&1 | grep -E "SSL|TLS|expire"

  echo -e "\ninsecure request to expired certificate site\n"
  curl --insecure -v https://google.com 2>&1

  echo -e "\ncertificate chain\n"
  openssl s_client -connect google.com:443 -showcerts

  echo -e "\ncertificate expiration dates\n"
  echo | openssl s_client -connect google.com:443 2>/dev/null | \
    openssl x509 -noout -dates
  echo

} > "https_test_report.txt"
