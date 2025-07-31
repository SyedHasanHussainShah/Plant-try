#!/usr/bin/env python3
"""
PlantDoctor - Simple HTTP Server
A lightweight server to serve the PlantDoctor web application.
"""

import http.server
import socketserver
import os
import ssl
import argparse
from pathlib import Path

class PlantDoctorHandler(http.server.SimpleHTTPRequestHandler):
    """Custom handler for PlantDoctor with proper MIME types and CORS."""
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=os.getcwd(), **kwargs)
    
    def end_headers(self):
        # Add CORS headers for development
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        super().end_headers()
    
    def do_OPTIONS(self):
        """Handle preflight CORS requests."""
        self.send_response(200)
        self.end_headers()
    
    def guess_type(self, path):
        """Override MIME type guessing for better file handling."""
        # Custom MIME types for better browser handling
        if path.endswith('.js'):
            return 'application/javascript'
        elif path.endswith('.css'):
            return 'text/css'
        elif path.endswith('.html'):
            return 'text/html'
        elif path.endswith('.json'):
            return 'application/json'
        elif path.endswith('.svg'):
            return 'image/svg+xml'
        return super().guess_type(path)

def create_ssl_context():
    """Create SSL context for HTTPS (self-signed certificate for development)."""
    try:
        import ssl
        context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
        
        # Generate self-signed certificate if it doesn't exist
        cert_file = 'plantdoctor.crt'
        key_file = 'plantdoctor.key'
        
        if not (os.path.exists(cert_file) and os.path.exists(key_file)):
            print("Generating self-signed certificate for HTTPS...")
            os.system(f'openssl req -x509 -newkey rsa:4096 -keyout {key_file} -out {cert_file} -days 365 -nodes -subj "/C=US/ST=State/L=City/O=PlantDoctor/CN=localhost"')
        
        context.load_cert_chain(cert_file, key_file)
        return context
    except Exception as e:
        print(f"SSL setup failed: {e}")
        print("Continuing without HTTPS...")
        return None

def main():
    parser = argparse.ArgumentParser(description='PlantDoctor HTTP Server')
    parser.add_argument('--port', type=int, default=8000, help='Port to serve on (default: 8000)')
    parser.add_argument('--https', action='store_true', help='Enable HTTPS (required for camera access)')
    parser.add_argument('--host', default='localhost', help='Host to bind to (default: localhost)')
    
    args = parser.parse_args()
    
    # Check if required files exist
    required_files = ['index.html', 'styles.css', 'script.js']
    missing_files = [f for f in required_files if not os.path.exists(f)]
    
    if missing_files:
        print(f"Error: Missing required files: {missing_files}")
        print("Please ensure all PlantDoctor files are in the current directory.")
        return
    
    # Create server
    handler = PlantDoctorHandler
    
    if args.https:
        # HTTPS server
        context = create_ssl_context()
        if context:
            with socketserver.TCPServer((args.host, args.port), handler) as httpd:
                httpd.socket = context.wrap_socket(httpd.socket, server_side=True)
                print(f"🌱 PlantDoctor server running on https://{args.host}:{args.port}")
                print("📸 Camera access will work with HTTPS!")
                print("Press Ctrl+C to stop the server")
                httpd.serve_forever()
        else:
            print("Failed to create HTTPS server. Falling back to HTTP...")
            args.https = False
    
    if not args.https:
        # HTTP server
        with socketserver.TCPServer((args.host, args.port), handler) as httpd:
            print(f"🌱 PlantDoctor server running on http://{args.host}:{args.port}")
            print("⚠️  Note: Camera access requires HTTPS")
            print("   Use --https flag for full functionality")
            print("Press Ctrl+C to stop the server")
            httpd.serve_forever()

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("\n👋 PlantDoctor server stopped. Goodbye!")
    except Exception as e:
        print(f"❌ Server error: {e}")