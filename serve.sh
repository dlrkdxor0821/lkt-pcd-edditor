#!/usr/bin/env bash
# PCD FPS Editor 런처.
# 사용법: ./serve.sh [PCD경로] [포트]
#   기본 PCD = ~/maps/seo-002.pcd, 기본 포트 = 8000
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
PCD="${1:-$HOME/leekt/seo-map/seo-002.pcd}"
PORT="${2:-8000}"

[ -f "$PCD" ] || { echo "[ERROR] PCD 없음: $PCD"; exit 1; }

# three.js 로컬 vendoring (최초 1회만 다운로드, 이후 오프라인 동작)
mkdir -p "$HERE/vendor"
THREE="$HERE/vendor/three.module.js"
if [ ! -s "$THREE" ]; then
  echo "[*] three.js 다운로드 중…"
  URL="https://cdn.jsdelivr.net/npm/three@0.160.0/build/three.module.js"
  if command -v curl >/dev/null; then curl -fsSL "$URL" -o "$THREE";
  elif command -v wget >/dev/null; then wget -qO "$THREE" "$URL";
  else echo "[ERROR] curl/wget 없음 — 수동으로 $URL 를 $THREE 에 저장"; exit 1; fi
  echo "[*] 저장: $THREE ($(du -h "$THREE" | cut -f1))"
fi

# 대상 PCD 를 서빙 디렉토리로 심볼릭 링크
ln -sf "$PCD" "$HERE/cloud.pcd"
BASE="$(basename "$PCD")"; BASE="${BASE%.pcd}"

URL="http://localhost:$PORT/?file=cloud.pcd&name=$BASE"
echo
echo "  대상 PCD : $PCD"
echo "  열기     : $URL"
echo "  (저장은 브라우저 다운로드 폴더에 ${BASE}-edit.pcd 로 떨어짐)"
echo
command -v xdg-open >/dev/null && (sleep 1; xdg-open "$URL" >/dev/null 2>&1 &) || true
cd "$HERE"
exec python3 -m http.server "$PORT"
