### Differences Between TCP and UDP

    1) TCP is connection-oriented
    It establishes a connection before sending data.

    2) UDP is connectionless
    It sends data without creating a dedicated connection first.

    3)TCP is more reliable
    It checks whether packets arrive and resends lost packets if needed.

    4)UDP is faster
    It has less overhead and does not wait for acknowledgments.

    5)TCP preserves packet order
    Data is delivered in the same order it was sent.

    6)UDP does not guarantee order
    Packets may arrive in a different order.

    7)TCP has error and flow control
    It uses mechanisms to reduce errors and manage sending speed.

    8)UDP is better for low latency
    It is useful when speed matters more than perfect delivery.

### Which Protocol Is Better for Each Service, and Why?

Video Streaming → UDP

    Because low delay and speed are more important than receiving every single packet.
    If a few frames are lost, the user experience is usually still acceptable.

File Transfer (FTP) → TCP

    Because the file must be transferred completely, accurately, and without errors.
    Losing even a few bytes can corrupt the file.

DNS Query → UDP

    DNS requests are usually short and need a fast response.
    UDP is lighter and faster for this purpose.

Web Browsing (HTTP/HTTPS) → TCP

    Web pages and sensitive data must arrive completely, correctly, and in order.
    HTTPS especially requires reliable transmission.

VoIP Call → UDP

    In voice calls, low delay is more important than delivering every packet.
    If some voice packets are lost, it is better than having a large delay.

Database Query → TCP

    Because database requests and responses must be reliable, complete, and ordered.
    Transmission errors could produce incorrect results.

### Showing Which Protocols Your System Is Using with netstat

To see active TCP and UDP ports on your system, you can run:

netstat -tuln

Meaning of the options:

    -t → show TCP connections
    -u → show UDP connections
    -l → show listening ports
    -n → show addresses and ports numerically

Example explanation of the output:

    If you see ports in LISTEN state, it means services are active on TCP or UDP.
    For example:
        Port 80 or 443 is usually for web traffic and uses TCP
        Port 53 is for DNS and usually uses UDP
        Ports used by audio/streaming apps may be UDP

If you want a more detailed view:

netstat -tunlp

This version also shows the process name using each port.
Short Summary

    TCP: reliable, ordered, but slower
    UDP: fast, lightweight, but no delivery guarantee


(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:36407         0.0.0.0:*               LISTEN      7587/exe            
tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN      -                   
tcp6       0      0 :::22                   :::*                    LISTEN      -                   
tcp6       0      0 :::80                   :::*                    LISTEN      -                   
tcp6       0      0 ::1:631                 :::*                    LISTEN      -                   
udp        0      0 0.0.0.0:5353            0.0.0.0:*                           -                   
udp        0      0 0.0.0.0:50833           0.0.0.0:*                           -                   
udp        0      0 127.0.0.54:53           0.0.0.0:*                           -                   
udp        0      0 127.0.0.53:53           0.0.0.0:*                           -                   
udp6       0      0 fe80::ab0a:dd4c:f25:546 :::*                                -                   
udp6       0      0 fe80::7411:f052:1e2:546 :::*                                -                   
udp6       0      0 :::53827                :::*                                -                   
udp6       0      0 :::5353                 :::*                                -                   
