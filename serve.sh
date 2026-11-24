#!/usr/bin/env bash
# PCD FPS Editor 런처.
# 사용법: input/ 폴더에 .pcd 를 넣고 ./serve.sh [포트]  (기본 포트 = 8000)
#   여러 개면 가장 최근에 수정된 파일을 연다. 저장은 results/ 에 떨어진다.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
PORT="${1:-8000}"

mkdir -p "$HERE/input" "$HERE/results"

# input/ 에서 대상 PCD 선택 (여러 개면 최신 수정 파일)
PCD="$(ls -1t "$HERE/input"/*.pcd 2>/dev/null | head -1 || true)"
[ -n "$PCD" ] || { echo "[ERROR] input/ 에 .pcd 가 없음 — 편집할 PCD 를 $HERE/input/ 에 넣고 다시 실행"; exit 1; }
COUNT="$(ls -1 "$HERE/input"/*.pcd | wc -l)"
[ "$COUNT" -gt 1 ] && echo "[*] input/ 에 PCD ${COUNT}개 — 최신 파일 사용: $(basename "$PCD")"

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
echo "  (저장(P)은 results/${BASE}.pcd 로 떨어짐 — 이름 중복 시 '(2)' 붙음)"
echo
command -v xdg-open >/dev/null && (sleep 1; xdg-open "$URL" >/dev/null 2>&1 &) || true
exec python3 "$HERE/serve.py" "$PORT"
