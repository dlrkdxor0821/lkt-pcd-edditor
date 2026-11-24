#!/usr/bin/env python3
"""PCD FPS Editor 서버: 정적 파일 서빙 + POST /save 로 results/ 에 PCD 저장."""
import os
import sys
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse, parse_qs

HERE = os.path.dirname(os.path.abspath(__file__))
RESULTS = os.path.join(HERE, 'results')


def dedup_path(name):
    """results/<name> 이 이미 있으면 '<이름> (2).pcd' 식으로 뒤에 번호를 붙인다."""
    base, ext = os.path.splitext(name)
    path = os.path.join(RESULTS, name)
    n = 2
    while os.path.exists(path):
        path = os.path.join(RESULTS, f'{base} ({n}){ext}')
        n += 1
    return path


class Handler(SimpleHTTPRequestHandler):
    def do_POST(self):
        url = urlparse(self.path)
        if url.path != '/save':
            self.send_error(404)
            return
        name = os.path.basename(parse_qs(url.query).get('name', ['cloud.pcd'])[0])
        if not name.endswith('.pcd'):
            name += '.pcd'
        os.makedirs(RESULTS, exist_ok=True)
        path = dedup_path(name)
        remaining = int(self.headers.get('Content-Length', 0))
        with open(path, 'wb') as f:
            while remaining > 0:
                chunk = self.rfile.read(min(remaining, 1 << 20))
                if not chunk:
                    break
                f.write(chunk)
                remaining -= len(chunk)
        saved = os.path.basename(path).encode('utf-8')
        self.send_response(200)
        self.send_header('Content-Type', 'text/plain; charset=utf-8')
        self.send_header('Content-Length', str(len(saved)))
        self.end_headers()
        self.wfile.write(saved)


if __name__ == '__main__':
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
    os.chdir(HERE)
    ThreadingHTTPServer(('', port), Handler).serve_forever()
