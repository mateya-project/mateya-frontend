# MyPage 배지 정책 정리

## 배경
- 마이페이지 배지 정책이 카테고리별 1회 이상 참가 기준으로 단순화됨
- 기존 배지 중 `food lover`, `language sharing`, `craftsman`은 제거 대상

## 발급 기준
- 사용자가 해당 카테고리 활동에 최소 1회 참가하면 배지를 발급한다.

## 카테고리별 배지 매핑
- `TOURIST_ATTRACTION` -> `TOURIST`
- `TRAVEL_COURSE` -> `TOURIST`
- `CULTURE_TRADITION` -> `TRADITIONAL`
- `EVENT_PERFORMANCE_FESTIVAL` -> `FESTIVE`
- `SPORTS` -> `ACTIVE_PERSON`
- `ACTIVITY_LEPORTS` -> `ACTIVE_PERSON`
- `PUBLIC_FACILITY` -> 배지 없음
- `SHOPPING` -> 배지 없음

## 유지/삭제 배지

### 유지
- `TRADITIONAL`
- `ACTIVE_PERSON`
- `FESTIVE`
- `TOURIST`

### 삭제
- `FOOD_LOVER`
- `LANGUAGE_SHARING`
- `CRAFTSMAN`

## 백엔드 요청사항
- 대상 API: `GET /api/v1/users/me/badges`
- 응답에 stable한 `badgeCode`를 포함한다.
- 권장 값: `TRADITIONAL`, `ACTIVE_PERSON`, `FESTIVE`, `TOURIST`
- 삭제 대상 배지는 응답에서 제외한다.
- OpenAPI `UserBadge` 스키마에도 `badgeCode` 필드를 반영한다.

## 프론트 반영 범위
- 마이페이지 배지 카탈로그를 4종으로 축소한다.
- `badgeCode` 기준으로 배지를 식별하고, 이름 기반 추론은 보조 수단으로만 사용한다.
- `SHOPPING`, `PUBLIC_FACILITY`는 어떤 배지 슬롯에도 매핑하지 않는다.
- 목업 데이터와 배지 개수 표시도 새 정책 기준으로 맞춘다.

## 주의사항
- 삭제된 구 배지가 API 응답에 남아 있으면 프론트에서 잘못된 슬롯에 노출될 수 있다.
- 따라서 백엔드에서 삭제 대상 배지를 응답에서 제외하는 것이 안전하다.

## 배지 발급 팝업 알림

### 목표
- 사용자가 배지를 새로 획득한 시점에 인앱 팝업 형태로 즉시 안내한다.

### 권장 처리 방식
- 백엔드가 배지 발급이 발생한 mutation 응답에 `newlyIssuedBadges`를 포함한다.
- 프론트는 해당 응답을 받았을 때 일회성 UI 이벤트로 팝업을 노출한다.
- 팝업 확인 후 마이페이지 배지 목록을 재조회하거나 로컬 상태를 갱신한다.

### 백엔드 요청사항
- 배지 발급이 일어날 수 있는 API 응답에 `newlyIssuedBadges` 필드를 추가한다.
- 각 항목은 최소한 아래 정보를 포함한다.
  - `badgeCode`
  - `badgeName`
  - `badgeImageUrl`
- 예시 대상 API
  - `POST /api/v1/activities/{id}/participants`
  - `POST /api/v1/activities/{id}/participants/{participantUserId}/approve`
- 정책적으로 배지 발급 시점을 확정해야 한다.
  - 참여 신청 시점
  - 호스트 승인 완료 시점
- 현재 정책상 권장안은 `승인 완료 시점` 기준이다.

### 프론트 반영 범위
- 참가 신청/승인 응답 모델에 `newlyIssuedBadges`를 추가한다.
- 컨트롤러에서 새 배지 획득 이벤트를 일회성 상태로 보관한다.
- 화면에서 해당 이벤트를 감지하면 `showDialog` 기반 축하 팝업을 노출한다.
- 팝업 종료 후 배지 데이터 동기화를 수행한다.

### 왜 별도 필드가 필요한가
- 단순히 `GET /api/v1/users/me/badges`만 다시 호출하면 기존 보유 배지와 이번에 새로 발급된 배지를 구분할 수 없다.
- 따라서 "이번 요청으로 새로 발급된 배지"를 명시하는 `newlyIssuedBadges` 같은 필드가 필요하다.

### 알림 방식 선택지
- 1차 권장: 인앱 팝업
- 2차 확장: 푸시 알림

### 현재 기준 판단
- 현재 앱은 `SnackBar` 중심 알림 패턴은 있으나, 배지 축하 연출은 `showDialog` 기반 전용 팝업이 더 적합하다.
- 푸시 알림은 아직 `firebase_messaging` 기반 구현이 없어 별도 작업이 필요하다.
