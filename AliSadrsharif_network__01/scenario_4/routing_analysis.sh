#!/bin/bash

# DNS 8.8.8.8 doesn't work so i used daneshkar.net instead
{
  echo "----- Routing Table -----"
  ip route show
  echo -e "\n----- Trace to daneshkar -----"
  traceroute daneshkar.net
  echo -e "\n----- Router Definition -----"
  echo "A router is a network device that forwards data packets between different networks. It examines the destination IP address and chooses the best path for delivery. Routers can also connect multiple networks and manage traffic between them."
} > routing_analysis.txt
