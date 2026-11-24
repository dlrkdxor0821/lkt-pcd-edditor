# lkt-pcd-edditor

브라우저에서 PCD 포인트클라우드를 FPS 시점으로 돌아다니며 점을 지우고 저장하는 편집기.

- `index.html` — three.js 기반 PCD FPS Editor (ascii PCD, `FIELDS x y z intensity` 지원)
- `serve.sh` — 로컬 서버 런처 (three.js 최초 1회 자동 다운로드 → `vendor/`)

## 실행 방법

```bash
./serve.sh [PCD경로] [포트]
```

- 기본 PCD: `~/leekt/seo-map/seo-002.pcd`, 기본 포트: `8000`
- 예시: `./serve.sh ~/maps/seo-001.pcd 8000`
- 실행하면 `http://localhost:8000/?file=cloud.pcd&name=<이름>` 이 자동으로 열림 (xdg-open)
- 요구사항: `python3`, 최초 실행 시 three.js 다운로드를 위한 `curl` 또는 `wget` (이후 오프라인 동작)
- 저장(`P`)은 원본을 건드리지 않고 `<이름>-edit.pcd` 로 새 파일 저장 (File System Access API 지원 브라우저는 폴더/이름 직접 선택, 미지원 시 다운로드 폴더)

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
| `P` | 저장 (이름 지정) |
| `G` | brush 토글 |
| 좌상단 XYZ 축 클릭 | 해당 방향 뷰 |
