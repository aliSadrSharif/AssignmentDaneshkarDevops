
## Scenario
A user reports: **SSH connection to the server times out**.

## 1) Possible causes of timeout

1. **Firewall blocking**
   - Local firewall, network firewall, or server firewall may block port 22.

2. **Wrong IP or port**
   - The SSH client may be connecting to the wrong address or a non-standard SSH port.

3. **Network routing issue**
   - Packets may not reach the server because of routing problems, VPN issues, or gateway misconfiguration.

4. **Server down**
   - The target machine may be powered off, unreachable, or its SSH service may not be running.

5. **DNS resolution failure**
   - Hostname may not resolve correctly to the expected IP.

## 2) Diagnostic commands for each cause

### 1. Firewall blocking
Commands:
```bash
sudo ufw status
sudo firewall-cmd --list-all
sudo iptables -L -n
sudo nft list ruleset
nc -zv -w 5 server 22
```
What to look for:

    Port 22 denied or filtered
    Connection attempt hangs or times out

### 2. Wrong IP or port
Commands:
```bash
ssh -v user@server
ssh -p 2222 user@server
dig server
nslookup server
```
What to look for:

    Incorrect resolved IP
    SSH service listening on a different port
    Misconfigured SSH client command

### 3. Network routing issue
Commands:
```bash
ping -c 4 server
traceroute server
tracepath server
ip route
```
What to look for:

    Packet loss
    Missing route
    Stops at a specific hop

### 4. Server down
Commands:
```bash
ping server
nmap -Pn -p 22 server
ssh user@server
```
What to look for:

    No ping response
    Port 22 closed or filtered
    No SSH banner / no connection

### 5. DNS resolution failure
Commands:
```bash
dig server
nslookup server
getent hosts server
cat /etc/resolv.conf
```
What to look for:

    No DNS answer
    Wrong IP returned
    Broken resolver configuration

## 3) Suggested solutions

### 1. Firewall blocking

    Open port 22 on the server firewall
    Allow SSH traffic in network security groups
    Ensure upstream firewall permits TCP/22

Example:
```bash
sudo ufw allow 22/tcp
sudo firewall-cmd --add-service=ssh --permanent
sudo firewall-cmd --reload
```

### 2. Wrong IP or port

    Verify the correct server IP
    Confirm the SSH port
    Update ~/.ssh/config if needed

Example:
```bash
ssh -p 22 user@192.168.1.10
```

### 3. Network routing issue

    Fix routing tables
    Check VPN/gateway setup
    Verify network interface status

Example:
```bash
ip route add default via 192.168.1.1
```

### 4. Server down

    Power on the server
    Restart the SSH service
    Check machine health

Example:
```bash
sudo systemctl restart ssh
sudo systemctl status ssh
```

### 5. DNS resolution failure

    Fix DNS server configuration
    Use the correct hostname
    Temporarily connect via IP

Example:
```bash
ssh user@192.168.1.10
```

## 4) Script to simulate the timeout problem

Below is a simple Bash script that simulates an SSH timeout by trying to connect to a port that does not respond, or by using an unreachable host.

```bash
#!/bin/bash

TARGET_HOST="192.0.2.1"   # TEST-NET-1, non-routable reserved IP
TARGET_PORT=22
TIMEOUT=5

echo "Testing SSH connectivity to $TARGET_HOST:$TARGET_PORT ..."
timeout $TIMEOUT ssh -o ConnectTimeout=$TIMEOUT user@$TARGET_HOST

if [ $? -eq 124 ]; then
echo "Simulated timeout occurred."
else
echo "Connection attempt completed (unexpected for timeout test)."
fi
```

Quick testing commands:

```bash
timeout 5 ssh user@server
telnet server 22
nc -zv -w 5 server 22
```
