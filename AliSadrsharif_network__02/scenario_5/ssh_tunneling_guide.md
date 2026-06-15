### Introduction

 SSH Tunneling (port forwarding) is used to securely route network traffic through an encrypted SSH connection between your machine (client) and a remote SSH server.

 There are three common types:
  1. **Local Port Forwarding (-L)**
  2. **Remote Port Forwarding (-R)**
  3. **Dynamic Port Forwarding (-D) — SOCKS proxy**

### Local Port Forwarding (-L)

 *Concept*
  With `-L`, you open a port on **your local machine** and forward incoming connections through SSH to a destination on the **remote server side**.

 *Example command*
  ```bash
  ssh -L 8080:localhost:80 user@server
  ```

 *What this does*
  Your local machine listens on localhost:8080.
  Anything connecting to localhost:8080 is tunneled over SSH.
  The SSH server then forwards it to localhost:80 from the server’s point of view.

 *Real-world use case*
  Securely access an internal web service on the server
  Suppose an internal website runs only on the server at port 80, and you cannot directly expose it to your network.
  With Local Forwarding, you can browse it via http://localhost:8080 safely, without opening new firewall ports.

### Remote Port Forwarding (-R)

 *Concept*
  With -R, you open a port on the remote SSH server and forward incoming connections back to a destination on your local machine.

 *Example command*
  ```bash
  ssh -R 9000:localhost:3000 user@server
  ```

 *What this does*
  The SSH server listens on port 9000.
  Anyone connecting to server:9000 reaches your local service.
  The traffic is forwarded to localhost:3000 on your local machine.

 *Real-world use case*
  Expose a locally running service to the outside world via the SSH server
  You might have a dev web app running on your laptop at localhost:3000, but you’re behind NAT/firewall and cannot port-forward your router.
  Remote Forwarding lets external users reach it through server:9000.

 **Note**
  Remote forwarding may require server-side SSH configuration such as AllowTcpForwarding and possibly GatewayPorts.

### Dynamic Port Forwarding (-D) — SOCKS proxy

 *Concept*
  With -D, SSH creates a dynamic SOCKS proxy on your local machine.
  Unlike -L and -R, the destination is chosen dynamically based on what the client requests.

 *Example command*
  ```bash
  ssh -D 1080 user@server
  ```

 *What this does*
  Your local machine runs a SOCKS proxy on localhost:1080.
  Your browser/tool is configured to use that proxy.
  Requests are forwarded through the SSH tunnel to their final destinations.

 *Real-world use case*
  Route your traffic through a secure tunnel to bypass restrictions
  You may be on a network that blocks certain sites, or you need to access internal resources that are reachable only from the server’s network.
  By using the SOCKS proxy, many tools can transparently send requests through SSH without manually setting up per-destination tunnels.

### Quick Summary

 -L: **local port** → forwarded to destination on the server
 -R: **remote port** → forwarded to destination on the client
 -D: creates a SOCKS proxy for **dynamic routing**