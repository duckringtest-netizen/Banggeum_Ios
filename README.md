# 방금 (Banggeum) — iOS

> 전화 없이, 부동산 없이, 눈치 없이 방 구하기 — 비대면 월세 플랫폼.

**상태: 더미(mock) 부트스트랩 완료 — `xcodebuild ... BUILD SUCCEEDED`.**
Web/Android와 동일 화면·톤·데이터 모델. 통합 단계에서 MockStore → Supabase 교체.

## 빌드/실행
```bash
xcodegen generate                                  # project.yml → Banggeum.xcodeproj 생성
open Banggeum.xcodeproj                             # Xcode 에서 실행 (⌘R)
# CLI 빌드 검증:
xcodebuild -project Banggeum.xcodeproj -scheme Banggeum \
  -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```
> `Banggeum.xcodeproj` 는 git-ignored (xcodegen 으로 재생성). `project.yml` 이 정본.

## 기술 스택 (기획서 §15)
- SwiftUI (iOS 17+) + XcodeGen. v1 은 순수 mock — **외부 패키지 0** (이미지는 내장 AsyncImage).
- 따뜻한 라이트 톤 고정 (`UIUserInterfaceStyle: Light`). 코랄 `#F1644B` + 모래 `#FAF7F2`.
- 통합 시 `supabase-swift` 추가.

## 구조
```
Banggeum/
  BanggeumApp.swift   (@main + RootTabView 5탭 + Route)
  Theme/Theme.swift   (BG 색 팔레트 + cardStyle)
  Model/Models.swift  (types.ts 미러 + 포맷터)
  Store/MockStore.swift (ObservableObject + 시드)
  View/  Components · Explore · RoomDetail · ReserveSheet · Map · Saved · Reservations · Chat · Login · Host · HostNew
  Assets.xcassets/    (AppIcon · AccentColor 코랄 · LaunchBackground 모래)
```

## MVP 화면 (Web 미러, 9종)
탐색 피드 · 매물 상세(+방문 예약 시트) · 지도 · 찜 · 내 예약 · 채팅 · 인증 · 집주인(예약 승인/거절) · 매물 등록

## 데이터 모델 (정본)
- 스키마: `Web/Banggeum/supabase/migrations/0001_init.sql`
- 통합 가이드: `Web/Banggeum/docs/db-schema.md`
- `Store/MockStore.swift` accessor 를 Supabase 쿼리로 교체 + `Model/Models.swift` 에 `Codable`/`CodingKeys(snake_case)` 추가 → Web/Android 와 1:1.

## Bundle ID
`duckring.banggeum.com`
