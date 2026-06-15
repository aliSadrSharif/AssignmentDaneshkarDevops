#!/bin/bash
echo -e "----- Network Connectivity Test -----\n" > connectivity_report.txt

echo "Pinging 8.8.8.8:" >> connectivity_report.txt
ping -c 5 8.8.8.8 >> connectivity_report.txt

echo -e "\nPinging google.com:" >> connectivity_report.txt
ping -c 5 google.com >> connectivity_report.txt

echo -e "\nDNS Resolution for github.com:" >> connectivity_report.txt
dig github.com +short >> connectivity_report.txt 2>/dev/null

echo -e "\nTest Completed." >> connectivity_report.txt
