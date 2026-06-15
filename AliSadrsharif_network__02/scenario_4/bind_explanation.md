# BIND Local DNS Zone Explanation

## Goal
This scenario adds a simple local DNS zone for `example.local` using BIND. The zone allows a local DNS server to answer queries for names such as `example.local`, `www.example.local`, and `mail.example.local`.

## `named.conf.local`
The `named.conf.local` file defines the local DNS zone:

```conf
zone "example.local" {
    type master;
    file "/etc/bind/db.example.local";
    allow-query { any; };
};
```

Explanation:
 - `zone "example.local"` tells BIND that this server is responsible for the `example.local` domain.
 - `type master` means this server stores the main writable copy of the zone.
 - `file "/etc/bind/db.example.local"` points BIND to the zone database file.
 - `allow-query { any; }` allows clients to query this zone.

## `db.example.local`
The `db.example.local` file contains the DNS records for the zone.

Important records:
 - `SOA` defines the start of authority for the zone and includes the primary name server, admin email, and timing values.
 - `NS` defines the authoritative name server for the domain.
 - `A` records map hostnames to IPv4 addresses.
 - `MX` defines the mail server for the domain.

Example records used in this scenario:
 - `example.local` points to `192.168.1.10`
 - `ns1.example.local` points to `192.168.1.10`
 - `www.example.local` points to `192.168.1.20`
 - `mail.example.local` points to `192.168.1.30`
 - Email for `example.local` is handled by `mail.example.local`

## How to apply the configuration
Copy the files to BIND's configuration directory:

```bash
sudo cp named.conf.local /etc/bind/named.conf.local
sudo cp db.example.local /etc/bind/db.example.local
```

Check the configuration and zone file:

```bash
sudo named-checkconf
sudo named-checkzone example.local /etc/bind/db.example.local
```

Restart BIND:

```bash
sudo systemctl restart bind9
```

Test DNS resolution:

```bash
dig @localhost example.local
dig @localhost www.example.local
dig @localhost MX example.local
```
