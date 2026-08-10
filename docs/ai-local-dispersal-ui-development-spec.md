# MateYa AI 로컬 분산 UI 개발정의서

- 기준일: 2026-08-11
- 대상: Flutter 앱 `frontend/`
- 관련 기획: 루트 `docs/agentic-ai-development-plan.md`
- 기능정의서: Google Sheets `화면별 기능정의` 161~199행

## 1. 목표와 범위

지정과제 2번의 핵심 사용자 흐름을 다음과 같이 구현한다.

```text
AI 홈 또는 AI 채팅 목록
→ 기준 관광지·희망일·이동 반경 입력
→ 날짜 대안 또는 로컬 장소 추천
→ 지도 또는 독립 장소 상세 확인
→ 열린 모임 참여 또는 장소가 입력된 모임 생성
```

AI는 추천과 설명까지만 수행한다. 모임 참여와 생성은 기존 화면에서 사용자가 최종 확인한다.

## 2. 확정된 피그마 화면

| 화면 | node-id | 구현 역할 |
| --- | --- | --- |
| A-2.AI 홈화면 | `2787:3125` | AI 진입 배너와 로컬 추천 목록 |
| Q-2.AI 주변 관광지 보기 | `2794:4540` | 기준 관광지의 집중 안내와 지도 기반 대안 탐색 |
| D-1-2.AI 장소 자세히보기 | `2794:4539` | 모임과 분리된 장소 상세·추천 근거·연결 모임 |
| C-3-2.AI 모임 생성화면 | `2787:2777` | 추천 장소가 미리 입력된 기존 생성 3단계 |
| G-2.AI 채팅방 목록 | `2787:2600` | 사람 채팅과 분리된 고정 AI 진입 카드 |
| H-2.AI 채팅방 | `2788:3724` | 구조화 여행 문맥과 카드형 추천 결과 |

피그마의 시각 기준은 유지하되, 아래 기능 보완이 필요하다.

- Q-2에는 혼잡 문구의 기준이 되는 날짜가 필요하다. AI 대화에서 전달된 날짜가 없으면 예측 문구 대신 날짜 선택 칩을 노출한다.
- D-1-2의 `모임 참여하기`는 연결 모임 수에 따라 동작이 달라진다. 1개면 바로 상세, 여러 개면 선택 목록, 0개면 생성 CTA만 표시한다.
- H-2의 카메라 아이콘은 P1에서 사진 최대 3장 첨부로 구현한다. 사진은 참고자료로 저장하지만 현재 버전은 이미지 내용을 추측하거나 비전 분석하지 않는다.
- 장소 하트 아이콘은 기존 활동 즐겨찾기와 별도 API·저장소를 사용하는 실제 장소 즐겨찾기로 동작한다.

## 3. 현재 코드와 변경 경계

현재 앱에는 `NearbyCultureMapPage`, `CreatePlaceSuggestion`, `ActivityDetailPage`, 사람 채팅용 `ChatRoomType`이 존재한다. 다음 원칙으로 확장한다.

- 독립 장소 상세는 `features/ai` 안에 장소 전용 model/repository/controller/page를 둔다. 기존 활동 상세를 장소 상세로 바꾸는 리팩터링은 하지 않는다.
- AI 기능은 `lib/features/ai/`에 model/data/application/presentation 계층을 둔다.
- `ChatRoomType { group, direct }`에는 AI를 추가하지 않는다. 채팅 목록 상단에 별도 `AiAgentEntryCard`를 조합한다.
- 지도 검색·현재 위치·카테고리 필터는 기존 home 지도 구현을 재사용하고, AI 문맥과 대안 마커만 확장한다.
- 생성 화면은 별도 복제하지 않고 기존 `CreateController`에 선택적인 진입 문맥을 전달한다.

권장 신규 파일 구조는 다음과 같다.

```text
lib/features/ai/
├── model/           # 세션, 문맥, 메시지 part, 추천 카드 모델
├── data/            # Spring 대화 API repository와 SSE transport
├── application/     # 목록·대화·홈 추천 controller
└── presentation/    # AI 카드, 대화 화면, 공통 추천 위젯

lib/features/ai/
└── presentation/ai_place_detail_page.dart
```

## 4. 화면별 구현 명세

### 4.1 A-2 AI 홈

- 배너 CTA는 빈 AI 대화 세션을 생성하고 H-2로 이동한다.
- `AI 로컬 추천`은 홈 전용 highlight API 결과 최대 5개를 표시한다. 화면 진입 때마다 LLM을 호출하지 않는다.
- 추천 카드는 `recommendedPlaceId`, 기준 명소, 한 줄 근거, 이미지, 데이터 기준일을 가진다.
- 카드 선택은 D-1-2로 이동하면서 `recommendationRunId`를 전달한다.
- 홈 추천 실패는 기존 `함께할 수 있는 경험` 목록을 막지 않는다.

### 4.2 Q-2 AI 주변 관광지

- 기준 장소는 기존 지도 검색 결과의 `placeId`로 관리한다.
- 표시 상태는 기준 장소, AI 로컬 대안, 일반 장소를 서로 다른 마커 타입으로 구분한다.
- `visitDate`가 있으면 선택일의 상대 집중 추이와 기준일을 표시한다.
- `visitDate`가 없으면 `날짜를 정하면 방문 집중 추이를 비교할 수 있어요`와 날짜 선택 칩을 표시한다.
- `AI에게 대안 물어보기`는 `placeId`, `visitDate?`, `radiusKm`를 AI 대화 진입 인자로 전달한다.
- `비슷한 로컬 장소 보기`는 추천 결과가 있을 때만 활성화한다.
- 위치 권한이 없으면 사용자 프로필의 활동지역 좌표를 사용하고, 둘 다 없으면 장소 검색은 허용하되 거리 표시는 생략한다.

### 4.3 D-1-2 독립 장소 상세

- 필수 route argument는 `placeId`이고 `recommendationRunId`, `conversationId`는 선택값이다.
- 기본 상세와 AI 추천 근거, 집중 데이터, 연결 모임은 서로 독립적으로 로딩한다.
- 기본 상세 성공 후 보조 영역 일부가 실패해도 화면 전체를 오류로 바꾸지 않는다.
- `sourceDetails`의 영업시간·휴무일·요금·예약 정보는 값이 있을 때만 표시한다.
- AI 추천 근거는 응답의 evidence와 기준일만 표시하고 앱에서 문장을 새로 추론하지 않는다.
- 연결 모임은 정확한 `placeId` 필터와 모집 상태로 조회한다.
- `이 장소로 모임 만들기`는 `CreateEntryContext.aiRecommendation(...)`를 만들고 C-3-2로 이동한다.
- `모임 참여하기`는 모임 1개면 D-1, 여러 개면 bottom sheet, 0개면 숨김 처리한다.

### 4.4 C-3-2 AI 모임 생성

진입 문맥 예시는 다음 필드를 가진다.

```text
source: AI_RECOMMENDATION
conversationId: UUID?
recommendationRunId: UUID?
place: CreatePlaceSuggestion
evidenceIds: List<String>
```

- 장소 정보만 미리 입력한다. 제목·설명·일정·인원·언어 등은 기존 입력과 검증을 그대로 사용한다.
- AI 진입 배너는 `source == AI_RECOMMENDATION`일 때만 표시한다.
- 사용자가 2단계로 돌아가 장소를 바꿀 수 있어야 한다.
- 생성 API 성공 이후에만 `CREATE_COMPLETED` 측정 이벤트를 비동기로 전송한다.
- 측정 실패로 생성 성공을 되돌리지 않는다.

### 4.5 G-2 AI 채팅 목록

- AI 카드는 필터 영역 위에 고정하고 사람 채팅 repository와 독립적으로 로딩한다.
- `새 여행 계획`은 중복 탭을 막은 뒤 새 세션을 만든다.
- `이어서 하기`는 최근 활성 세션을 조회하고, 세션이 없으면 새 세션으로 동작한다.
- 사람 채팅의 안 읽음 수 대신 최근 장소·날짜 또는 `새 여행 계획` 상태를 표시한다.
- AI 세션 API 장애 시에도 기존 사람 채팅 목록과 필터는 정상 동작해야 한다.

### 4.6 H-2 AI 채팅방

- 메시지는 사람 채팅의 WebSocket 모델을 재사용하지 않고 Spring SSE turn으로 전송한다.
- 현재 문맥은 `anchorPlace`, `visitDate`, `radiusKm`, `interests`, `dispersalPreference`로 관리한다.
- 누락된 필수 조건은 한 번에 하나만 질문한다.
- 응답은 sealed part 모델로 렌더링한다: `text`, `dateAlternatives`, `placeRecommendations`, `anchorPlaceChoices`, `quickActions`, `notice`.
- 알 수 없는 part 타입은 무시하고 알려진 part는 계속 표시한다.
- 전송 중 입력 중복과 이중 요청을 막고, `clientMessageId`로 재시도를 멱등 처리한다.
- 사용자 입력은 1~500자, 화면에 우선 표시하는 추천 장소는 최대 3개다.
- SSE의 `accepted`로 접수 상태를, `completed`로 저장된 전체 turn을 반영한다. 연결 전 실패만 동일 `clientMessageId`의 일반 HTTP 요청으로 안전하게 fallback한다.
- 사진은 최대 3장이고, 위치는 사용자가 별도 체크한 경우에만 권한을 요청하고 전송한다.

## 5. API 사용 표

| 화면 | API | 상태 |
| --- | --- | --- |
| A-2 | `GET /api/v1/ai/home/highlights` | 구현 |
| Q-2 | `GET /api/v1/places/map` | 기존 |
| Q-2 | `GET /api/v1/ai-agent/data/places/{placeId}/concentration-forecasts` | 기존 개발 중 |
| D-1-2 | `GET /api/v1/places/{placeId}` | 기존 |
| D-1-2 | `GET /api/v1/activities?placeId=...&statusFilters=RECRUITING` | placeId 필터 신규 |
| G-2/H-2 | `/api/v1/ai/conversations...` | 구현 |
| H-2 | `POST /api/v1/ai/conversations/{id}/messages/stream` | 구현, SSE |
| H-2 | `POST /api/v1/uploads/presign`, `POST /api/v1/uploads/{id}/confirm` | 구현, `AI` 용도 |
| D-1-2 | `POST /api/v1/places/{placeId}/favorite` | 구현 |
| C-3-2 | `POST /api/v1/activities` | 기존 |
| 공통 | `POST /api/v1/ai/recommendation-events` | 구현 |

앱은 AI 서버에 직접 연결하지 않고 Spring 공개 API를 사용한다. Spring이 인증·세션 저장 후 내부 AI 서버를 호출한다.

## 6. 로딩·오류·빈 상태

- 홈 AI 영역, AI 채팅 카드, 장소의 추천 근거는 다른 기존 기능과 별도 로딩 경계를 가진다.
- 추천 데이터가 없으면 `현재 조건에 맞는 대안을 찾지 못했어요`와 반경·날짜 변경 action을 제공한다.
- LLM 장애로 `fallbackUsed=true`이면 추천 카드는 유지하고 템플릿 설명 사용 안내를 표시한다.
- 집중 데이터가 없으면 혼잡을 단정하지 않고 장소 대안만 표시한다.
- 세션 401은 기존 인증 만료 흐름으로 연결하고, 409는 최신 세션 상태 재조회 후 사용자 입력을 복원한다.

## 7. 다국어·접근성

- 모든 신규 문자열은 기존 localization 계층에 추가한다.
- `ko`, `en`, `ja`, `zh`의 정적 UI는 ARB를 사용한다. AI 동적 응답과 장소명은 요청 언어가 처음 필요할 때 Spring에서 번역·저장한 값을 사용한다.
- 지도 마커, 추천 배지, 아이콘 버튼에 의미가 드러나는 semantic label을 제공한다.
- 색상만으로 기준 장소와 대안 장소를 구분하지 않고 아이콘 형태 또는 라벨을 함께 사용한다.
- 상대 집중 지표는 숫자뿐 아니라 설명 문구로 제공한다.

## 8. 측정 이벤트

허용 이벤트는 `AI_ENTRY_OPENED`, `RECOMMENDATION_EXPOSED`, `DATE_ALTERNATIVE_SELECTED`, `PLACE_SELECTED`, `PLACE_DETAIL_OPENED`, `JOIN_FLOW_OPENED`, `JOIN_COMPLETED`, `CREATE_FLOW_OPENED`, `CREATE_COMPLETED`로 제한한다.

- `recommendationRunId`, `conversationId`, `placeId`, `activityId` 중 필요한 식별자만 전송한다.
- 대화 전문, 정확한 현재 위치, 자유입력 관심사는 분석 이벤트에 넣지 않는다.

## 9. 구현 순서와 완료 기준

### P0

1. 공통 모델과 Spring repository
2. G-2 세션 진입과 H-2 텍스트 대화
3. D-1-2 독립 장소 상세와 placeId 기반 모임 조회
4. H-2 추천 카드에서 D-1-2·D-1·C-3-2 이동
5. Q-2 날짜/장소 문맥과 AI 대안 표시
6. A-2 배너와 홈 highlight
7. 측정 이벤트와 폴백·빈 상태

### P1 구현 완료

- 장소 즐겨찾기와 낙관적 UI
- AI 사진 최대 3장 입력
- 사용자 명시 동의 기반 사진 위치 공유
- 접수·완료·오류 SSE와 연결 전 HTTP fallback
- 자유입력 장소 검색과 동명 장소 선택 카드
- 신규 카피 4개 언어와 작은 화면·200% 텍스트 접근성 회귀 테스트

AI 생성 제목·설명 초안은 현재 P1의 분산 추천 핵심 범위에서 제외하고 후속 작성 도우미 단계로 둔다.

### 완료 기준

- 피그마 6개 화면의 정상·로딩·빈 결과·오류 상태 widget test
- `AI 질문 → 로컬 장소 상세 → 기존 모임 참여` 통합 흐름 통과
- `AI 질문 → 장소 prefill → 모임 생성 완료` 통합 흐름 통과
- `flutter analyze`와 관련 테스트 통과
- AI 기능 장애 시 기존 홈·지도·사람 채팅·모임 생성이 정상 동작
