# i18n Audit

기준 시점: 2026-06-20

## 지원 언어

- `ko`
- `en`
- `ja`
- `zh-Hans`

현재 프로젝트 내부 근거:

- [lib/shared/preferences/mateya_language_preferences.dart](/Users/emfpdlzj/Desktop/mateya/frontend/lib/shared/preferences/mateya_language_preferences.dart)
- [lib/shared/widgets/mateya_language_dialog.dart](/Users/emfpdlzj/Desktop/mateya/frontend/lib/shared/widgets/mateya_language_dialog.dart)

## 이번 작업으로 연결한 영역

- Flutter 공식 l10n + ARB + `intl` 기반 설정
- 앱 전역 `locale` 상태/저장/복원
- 헤더 Globe 언어 변경과 실제 `MaterialApp.locale` 연결
- 앱 재실행 후 마지막 언어 복원
- 공용 언어 선택 다이얼로그
- 공용 권한 다이얼로그 기본 버튼 라벨
- 온보딩 주요 진입/인증/동네 인증/사업자 인증 UI
- 온보딩 약관 상세 문서
- 온보딩 입력 검증 문구와 위치 조회 실패 문구
- 홈/둘러보기 일부 핵심 UI와 필터/포맷터 기본 라벨
- 홈 즐겨찾기 빈 상태/보조 문구
- 홈 참가자 수 라벨
- 홈 플러스 액션 오버레이의 전통문화 지도 진입 라벨
- 마이페이지 주요 전 경로
  - 설정/기본 정보/동의 내역/차단 사용자/최근 활동
  - 활동 지역 수정 다이얼로그
  - 회원 탈퇴 다이얼로그
  - 배지 축하 다이얼로그 및 배지 라벨
- 공용 신고 시트 (`MateyaReportSheet`)
- 마이페이지 API/mock 데이터 포맷터의 언어/국가/카테고리/가격/참가자 수 라벨
- 온보딩 플로우 페이지의 단계 타이틀/미리보기 힌트
- 회원가입/사업자 인증 만료 토스트
- 채팅 시간 포맷터, 채팅 가이드, 번역 토글, 참여자 수, 작성 힌트
- 홈 둘러보기 필터 시트 전반
  - 섹션 타이틀
  - 일정/비용 placeholder
  - 거리 요약 문구
  - 초기화/적용 버튼
- 생성(Create) 플로우 전반
  - 카테고리/장소/상세/완료 화면
  - 단계 헤더와 완료 상태
  - 날짜/시간 picker 안내 문구
  - 이미지 선택/복구/업로드/검증 에러
  - 장소 검색/추천/삭제/수정 초기화 토스트 및 에러
- 채팅 주요 경로
  - 채팅방 목록/빈 상태/재시도
  - 채팅방 상세 재시도/과거 메시지 로드 안내
  - 사진 첨부 바텀시트/권한 안내/복구/전송 토스트
  - 메시지 전송/읽음 반영/더 불러오기 실패 토스트
  - 기본 채팅방 제목/사진만 있는 메시지 fallback 라벨
- 내 주변 전통문화 지도
  - 지도/검색/현재 위치 fallback 문구
  - 빈 상태/목록 시트/목록 버튼
  - 현재 위치/장소 로드/파싱 에러
- 상세(Details) 전 경로
  - 상세 본문/참여 현황/가격/참여 CTA
  - 후기 정렬/요약/도움돼요/번역 토글
  - 후기 작성 시트/이미지 권한/복구/업로드 실패
  - 참여자 관리/신청 목록/삭제·취소 토스트
  - 공유 복사/신고 진입/상세 로드 에러
- 공용 갤러리 권한 안내/복구 타이틀
- 공용 API/신고 리포지토리 기본 에러 메시지
- 공용 활동 카테고리 fallback 라벨
- 온보딩 인증 재전송/사업자 인증 완료/필수 약관 미동의 토스트
- 홈 추가 결과 로드 실패 문구
- 공용 서버 응답 형식 오류 문구

## 하드코딩 문자열이 남아 있는 주요 화면/영역

2026-06-20 최종 재스캔 기준으로, 실제 런타임 UI/포맷터/리포지토리에서 남아 있는 미적용 화면은 확인되지 않았습니다.

스캔에서 남는 문자열은 아래처럼 번역 대상에서 제외하거나 내부 처리 용도로 판단한 항목입니다.

- `shared/widgets/mateya_language_dialog.dart`
  - 언어 옵션의 native label (`한국어`, `日本語`, `简体中文`) 자체 표기
- `app/app_config.dart`
  - 통신사 고유명칭 (`SKT 알뜰폰` 등)
- `features/onboarding/domain/onboarding_terms.dart`
  - 약관 매칭용 alias 문자열
- `features/onboarding/data/location_repository.dart`
  - 지오코딩 질의를 위한 국가명 suffix (`대한민국`)
- `features/onboarding/application/onboarding_controller_completion.dart`
  - 만료/유효성 오류 탐지용 keyword
- `features/home/data/nearby_culture_map_repository.dart`
  - 샘플 장소명/주소 데이터
- `**/*mock*`, `**/*fixtures*`, `**/*builders*`
  - mock 사용자명, 샘플 본문, 테스트용 데이터

## 검증 메모

- 첫 실행 온보딩부터 locale 반영이 되도록 앱 부트스트랩에서 언어 설정을 먼저 로드하도록 변경했습니다.
- 언어 변경 시 앱 재시작 없이 `MaterialApp.locale`이 즉시 갱신됩니다.
- 마지막 선택 언어 저장/복원은 `SharedPreferences` 기반으로 동작하며, 관련 테스트를 추가했습니다.
- Globe 버튼 경유 언어 변경 직후 앱 루트 텍스트가 즉시 바뀌는지 위젯 테스트로 확인했습니다.
- 현재까지 반영한 i18n 변경은 `flutter analyze` 통과 상태입니다.
- 아래 테스트 묶음은 통과했습니다.
  - `test/features/mypage/mypage_badge_catalog_test.dart`
  - `test/features/mypage/mypage_repository_mock_test.dart`
  - `test/features/mypage/mypage_settings_view_test.dart`
  - `test/features/mypage/mypage_consent_history_view_test.dart`
  - `test/shared/widgets/mateya_language_dialog_test.dart`
  - `test/shared/widgets/mateya_header_test.dart`
  - `test/shared/widgets/mateya_bottom_navigation_test.dart`
- 아래 테스트도 통과했습니다.
  - `test/features/chat/chat_status_widgets_test.dart`
  - `test/features/chat/chat_controller_test.dart`
- 아래 create 테스트도 통과했습니다.
  - `test/features/create/create_overview_steps_test.dart`
  - `test/features/create/create_controller_test.dart`
  - `test/features/create/create_repository_mock_test.dart`
  - `test/features/create/create_repository_api_test.dart`
  - `test/features/create/create_place_widgets_test.dart`
- 아래 온보딩/홈 관련 테스트도 통과했습니다.
  - `test/features/onboarding/onboarding_terms_lookup_test.dart`
  - `test/features/onboarding/onboarding_terms_detail_test.dart`
  - `test/features/onboarding/onboarding_contact_steps_test.dart`
  - `test/features/onboarding/onboarding_controller_test.dart`
  - `test/features/home/home_plus_action_overlay_test.dart`
  - `test/features/home/home_controller_test.dart`
- 아래 상세/locale 관련 테스트도 통과했습니다.
  - `test/features/details/activity_detail_controller_test.dart`
  - `test/features/details/activity_detail_repository_mock_test.dart`
  - `test/features/details/activity_detail_models_test.dart`
  - `test/shared/localization/app_locale_controller_test.dart`
  - `test/shared/widgets/mateya_header_test.dart`
  - `test/shared/widgets/mateya_language_dialog_test.dart`
- 아래 채팅/지도 관련 테스트도 통과했습니다.
  - `test/features/chat/chat_repository_mock_test.dart`
  - `test/features/chat/chat_status_widgets_test.dart`
  - `test/features/chat/chat_controller_test.dart`
  - `test/features/home/nearby_culture_map_controller_test.dart`
  - `test/features/home/nearby_culture_map_repository_test.dart`
  - `test/features/home/nearby_culture_map_widgets_test.dart`
- Flutter 도구 이슈로 `flutter test`를 병렬로 여러 프로세스에서 동시에 실행하면 `macos/Flutter/ephemeral/Packages` 링크 충돌이 날 수 있어, 검증은 단일 프로세스 기준으로 실행했습니다.
