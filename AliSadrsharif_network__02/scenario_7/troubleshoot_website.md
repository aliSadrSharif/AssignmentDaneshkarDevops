## Scenario
A user reports: **"The user cannot access example.com"** (slow access or no access).
---
## 1) Debugging steps (Step-by-step)
1. **Check physical connection / basic network link**
2. **Check IP configuration**
3. **Check DNS resolution**
4. **Check routing to the destination**
5. **Check firewall / security controls**
6. **Check the application / web server health**

## 2) Commands to run (for each step)
### Step 1: Check physical connection / basic network link
```bash
ip link
ip a
ip route
ping -c 4 <GATEWAY_IP>
```
### Step 2: Check IP configuration
```bash
ip a
cat /etc/resolv.conf
ip route
```
If you use DHCP and need to renew:

```bash
sudo dhclient -r && sudo dhclient
```

### Step 3: Check DNS resolution
Get the resolved IP(s):

```bash
dig example.com +short
```
Alternative DNS check:
```bash
nslookup example.com
```
Check current DNS servers configured on the client:
```bash
cat /etc/resolv.conf
```

### Step 4: Check routing
First, use the IP you got from DNS resolution:

```bash
ip route get <EXAMPLE_COM_IP>
```
Test basic reachability:
```bash
ping -c 4 <EXAMPLE_COM_IP>
```
Trace the path:
```bash
traceroute <EXAMPLE_COM_IP>
# or:
mtr -rwzbc 100 <EXAMPLE_COM_IP>
```

### Step 5: Check firewall / security controls
On the client (examples):

```bash
sudo ufw status verbose
sudo iptables -S
sudo nft list ruleset
```
Test web ports:
```bash
nc -vz example.com 80
nc -vz example.com 443
```
Test HTTP/HTTPS responses:
```bash
curl -v http://example.com
curl -v https://example.com
```

### Step 6: Check application / web server health (server-side)
On the server (if you manage the origin/hosting): Check web server service status:

```bash
sudo systemctl status nginx
# or:
sudo systemctl status apache2
```
Local web tests:
```bash
curl -I http://localhost
curl -I https://localhost
```
Check logs:
```bash
sudo tail -n 200 /var/log/nginx/error.log
sudo tail -n 200 /var/log/nginx/access.log
# Apache:
sudo tail -n 200 /var/log/apache2/error.log
sudo tail -n 200 /var/log/apache2/access.log
```
If HTTPS uses certbot:
```bash
sudo certbot certificates
```
Also validate web server config:
```bash
sudo nginx -t
```

## 3) Possible root causes (list)
1. Physical/network connectivity issue (cable/Wi‑Fi problems, wrong network)
2. Incorrect or missing IP configuration (no IP, wrong gateway, DHCP issues)
3. DNS resolution problem (DNS server unreachable, wrong records, misconfigured resolver)
4. Routing issue (no route, broken gateway, intermediary routing problems)
5. Firewall / ACL / security policy blocking access (ports 80/443 blocked, IP blocked)
6. Web server or application downtime / misconfiguration
7. HTTPS/TLS certificate issue (expired certificate, wrong TLS config)
8. CDN/WAF/rate limiting/blocking (origin errors, bot protection, rate limit)

## 4) Solutions for each cause (Solution per root cause)

1) Physical/network connectivity issue
Reconnect/replace the network cable or rejoin Wi‑Fi.
Test using another network (e.g., mobile hotspot) to confirm it’s network-specific.
Ensure the link is up and IP is properly assigned.

2) Incorrect or missing IP configuration
Verify IP and default route:
```bash
ip a
ip route
```
Renew DHCP:
```bash
sudo dhclient -r && sudo dhclient
```
Fix gateway/DNS configuration to match the network requirements.

3) DNS resolution problem
Verify correct DNS records:
```bash
dig example.com +short
```
Change DNS resolvers for testing (e.g., use a known public resolver).
If records are wrong, update A/AAAA/CNAME records in the DNS provider
Clear DNS cache (depending on OS; example is system-specific).

4) Routing issue
Check the route to the destination:
```bash
ip route get <EXAMPLE_COM_IP>
```
Use traceroute/mtr output to identify where the path breaks.
Coordinate with the network team / ISP if intermediary hops are failing.

5) Firewall / ACL / security policy blocking access
Allow inbound/outbound traffic for ports 80 and 443 as required.
Review firewall rules:
```bash
sudo ufw status verbose
sudo nft list ruleset
```
If behind an enterprise firewall or proxy, ensure the destination domain is permitted.
If using CDN/WAF, verify no IP/geo rules are blocking the user.

6) Web server or application downtime / misconfiguration
Check service status and restart if appropriate:
```bash
sudo systemctl restart nginx
```
Validate configuration:
```bash
sudo nginx -t
```
Inspect error logs and fix the underlying configuration/runtime issue.
If the app depends on other services (DB, backend), check their health too.

7) HTTPS/TLS certificate issue
Check certificate validity:
```bash
sudo certbot certificates
```
Fix TLS settings and reissue/renew certificates as needed.
Confirm with:
```bash
curl -vk https://example.com
```

8) CDN/WAF/rate limiting/blocking
Check CDN/WAF logs for blocks, rate limits, or origin failures.
Review rules for bot protection, country/ASN restrictions, and request limits.
Confirm origin connectivity from the CDN to the server.
Make controlled rule adjustments (with approval) and retest.