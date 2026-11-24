# lkt-pcd-edditor

브라우저에서 PCD 포인트클라우드를 FPS 시점으로 돌아다니며 점을 지우고 저장하는 편집기.

- `index.html` — three.js 기반 PCD FPS Editor (ascii PCD, `FIELDS x y z intensity` 지원)
- `serve.sh` — 런처 (input/ 스캔, three.js 최초 1회 자동 다운로드 → `vendor/`)
- `serve.py` — 정적 서빙 + 저장(POST /save → `results/`) 서버

## 실행 방법

1. 편집할 `.pcd` 파일을 `input/` 폴더에 넣는다.
2. 실행:

```bash
./serve.sh [-n 이름] [포트]   # 기본 포트 8000
./serve.sh -n asd             # input/asd.pcd 를 연다
```

- `-n 이름` 을 주면 `input/<이름>.pcd` 를 연다 (`.pcd` 붙여도 됨, 없으면 input/ 목록 보여주고 종료).
- `-n` 생략 시 `input/` 에서 가장 최근에 수정된 파일을 연다.
- 실행하면 브라우저가 자동으로 열림 (xdg-open).
- 요구사항: `python3`, 최초 실행 시 three.js 다운로드를 위한 `curl` 또는 `wget` (이후 오프라인 동작)

## 저장

- `P` 를 누르면 `results/` 폴더에 **원본과 같은 이름**으로 저장된다. 원본(`input/`)은 건드리지 않음.
- 같은 이름이 이미 있으면 `이름 (2).pcd`, `이름 (3).pcd` 식으로 번호가 붙는다.

## 조작법

| 키 | 동작 |
|---|---|
| 마우스 | 구(brush) 이동 |
| 좌클릭 드래그 | 회전 (yaw+pitch) |
| 우클릭 드래그 | 좌우 회전 (yaw) |
| `W A S D` | 이동 (`E` 위 / `C` 아래 / `Shift` 가속) |
| `← → ↑ ↓` | 제자리 회전 |
| `Space` 홀드 | 구 안의 점 지우기 |
| 휠 | brush 크기 |
| `;` `'` | brush 거리 |
| `-` `=` | 점 크기 |
| `Ctrl+Z` / `Z` | 되돌리기 |
| `P` | 저장 (`results/`) |
| `G` | brush 토글 |
| 좌상단 XYZ 축 클릭 | 해당 방향 뷰 |
