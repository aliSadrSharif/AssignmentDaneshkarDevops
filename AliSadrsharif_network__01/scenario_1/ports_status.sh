#!/bin/sh

{
  echo "----- TCP Ports in LISTEN State -----"
  ss -tln | grep LISTEN
  if [ $? -ne 0 ]; then
     echo "there is no TCP ports listening"
  fi
  

  echo ""
  echo "----- ESTABLISHED TCP Connections -----"
  ss -tuln | grep ESTAB
  if [ $? -ne 0 ]; then
     echo "There is no TCP established connection"
  fi


  echo ""
  echo "----- Processes Listening on port 80 -----"
  ss -tulnp | grep ":80"
  if [ $? -ne 0 ]; then
     echo "There is no process on port 80"
  fi

  echo ""
  echo "----- Processes Listening on port 443 -----"
  ss -tulnp | grep ":443"
  if [ $? -ne 0 ]; then
     echo "There is no process on port 443"
  fi
} > ports_status.txt
