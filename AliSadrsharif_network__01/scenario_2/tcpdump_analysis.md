# tcpdump Analysis

This report separates the HTTP/TCP traffic from the DNS traffic so that each capture can be reviewed independently.

## HTTP and TCP Analysis - http_capture.txt

### Primary protocols

The observed traffic in `http_capture.txt` primarily consists of TCP and HTTP packets. The communication is local, between client-side ephemeral ports on `localhost` and the web service on `localhost.http` (port 80).

### TCP three-way handshake

The capture shows a complete TCP handshake before each HTTP request:

1. The client sends a SYN packet, shown by `Flags [S]`.
2. The server replies with SYN-ACK, shown by `Flags [S.]`.
3. The client completes the handshake with an ACK packet, shown by `Flags [.]`.

This confirms that the TCP connection is established successfully before application data is exchanged.

### HTTP data transfer

After the handshake, packets with `Flags [P.]` carry the HTTP payload. The client sends repeated `GET / HTTP/1.1` requests, and the local web server responds with `HTTP/1.1 200 OK`.

The `200 OK` responses show that the HTTP requests were processed successfully and that the web server returned content to the client.

### Connection termination

Each HTTP exchange ends with FIN packets, shown by `Flags [F.]`, followed by ACK packets. This indicates that the TCP sessions were closed normally after the data transfer finished.

### HTTP/TCP conclusion

The `http_capture.txt` file shows multiple successful local HTTP requests. Each request follows the expected sequence: TCP handshake, HTTP GET request, HTTP 200 OK response, and normal TCP connection termination.

## DNS Analysis - dns_capture.txt

### Primary protocol

The observed traffic in `dns_capture.txt` consists of DNS packets. DNS is used here to resolve the domain name `google.com` into an IPv4 address before the client can connect to the destination by IP.

### DNS query packets

The client sends DNS A-record queries from different ephemeral source ports on `localhost` to `_localdnsstub.domain`, which represents the local DNS stub resolver. The query format `A? google.com.` means the client is asking for the IPv4 address of `google.com`.

Example pattern:

`localhost.<ephemeral-port> > _localdnsstub.domain: <transaction-id>+ A? google.com.`

### DNS response packets

The local DNS resolver replies to each query with an A record. The responses contain the resolved IPv4 address `216.239.38.120`.

Example pattern:

`_localdnsstub.domain > localhost.<ephemeral-port>: <transaction-id> 1/0/1 A 216.239.38.120`

### Source and destination pattern

The DNS traffic is between `localhost` and `_localdnsstub.domain`. The client source port changes for each query, while the destination is the local DNS resolver service. This is normal behavior for repeated DNS lookups.

### Repeated DNS lookups

The capture contains repeated query and response pairs for `google.com`. Each query receives a valid response, which means DNS resolution is working correctly. The repeated entries likely come from running the lookup or related test multiple times.

### DNS conclusion

The `dns_capture.txt` file shows successful DNS resolution for `google.com`. The system repeatedly asks the local DNS stub resolver for an A record, and the resolver returns the IPv4 address `216.239.38.120` each time.

## Overall Conclusion

The tcpdump captures show two separate network behaviors:

1. `http_capture.txt` confirms successful local HTTP communication over TCP.
2. `dns_capture.txt` confirms successful DNS name resolution for `google.com`.