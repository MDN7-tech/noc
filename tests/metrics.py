from http.server import BaseHTTPRequestHandler, HTTPServer

METRICS = b'''node_md_disks_required{device="md0"} 2
node_md_disks{device="md0",state="active"} 1
libvirt_domain_info_state{domain="demo-vm"} 6
'''


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "text/plain; version=0.0.4")
        self.end_headers()
        self.wfile.write(METRICS)


HTTPServer(("127.0.0.1", 19100), Handler).serve_forever()
