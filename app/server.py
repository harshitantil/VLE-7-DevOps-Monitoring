from http.server import BaseHTTPRequestHandler, HTTPServer
from datetime import datetime, timezone
import json
import os
import socket

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        payload = {
            "app": "vle7-demo",
            "status": "ok",
            "hostname": socket.gethostname(),
            "time_utc": datetime.now(timezone.utc).isoformat(),
            "path": self.path,
        }
        body = json.dumps(payload, indent=2).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        print("%s - %s" % (self.address_string(), fmt % args), flush=True)

if __name__ == "__main__":
    HTTPServer(("0.0.0.0", int(os.getenv("PORT", "8080"))), Handler).serve_forever()
