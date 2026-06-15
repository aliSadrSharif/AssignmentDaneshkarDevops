import http.server
import ssl

server_address = ('localhost', 8443)
httpd = http.server.HTTPServer(server_address, http.server.SimpleHTTPRequestHandler)

context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
context.load_cert_chain(certfile='./certs/myapp.crt', keyfile='./certs/myapp.key')

httpd.socket = context.wrap_socket(httpd.socket, server_side=True)

print("Server running on https://localhost:8443")
httpd.serve_forever()
