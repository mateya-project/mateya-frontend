# Development TODO

- P1: `create`/`details`의 500줄 이상 presentation 파일을 `screen`/`widgets` 단위로 추가 분리
  이유: 이번 리팩토링으로 `home`, `onboarding`, `mypage`, `chat`은 진입 screen과 하위 위젯 책임이 분리됐지만, 나머지 플로우는 여전히 화면 파일 하나에 단계 전환, 섹션 UI, 로컬 입력 상태가 몰려 있어 같은 유지보수 문제가 남아 있음
- P2: `onboarding`/`create` 화면의 개별 로딩 UI를 `MateyaSkeleton` 기반으로 통일
  이유: 이번 작업으로 `home/chat/mypage/details`는 공통 스켈레톤을 쓰게 됐지만, 나머지 플로우는 여전히 화면별 로딩 표현이 달라 UX 일관성이 깨질 수 있음
