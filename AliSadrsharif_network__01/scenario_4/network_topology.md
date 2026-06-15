The company's network topology is a **Star topology**. In this setup, all devices are connected to a central **Switch**, which in turn is connected to the main **Router**.

### Network Components:
- **Router (Gateway):** `192.168.1.1`
- **Switch:** Central network connection point
- **Web Server:** `192.168.1.10`
- **DB Server:** `192.168.1.11`
- **Cache Server:** `192.168.1.12`
- **10 User Computers:** From `192.168.1.100` to `192.168.1.110`

In this network, the Router is responsible for connecting the internal network to the internet or other external networks. The Switch manages internal traffic between servers and users.

### If the switch fails, in a star topology this usually happens:

    Communication between internal devices is lost, because all computers and servers are connected through the switch.

    Users can no longer access the servers; for example, the Web Server, DB Server, and Cache Server become unreachable from the internal network.

    Internet access is usually lost too, because the connection between devices and the router goes through the switch.

    As a result, the internal network is almost completely down until the switch is repaired or replaced.

### Star topology:

                Internet
                   |
              [ Router ]
          Gateway: 192.168.1.1
                   |
               [Switch]
       ____________|____________
      |            |            |
[Web Server]   [DB Server]   [Cache]
192.168.1.10 192.168.1.11 192.168.1.12
                   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10
    192.168.1.100   192.168.1.110
