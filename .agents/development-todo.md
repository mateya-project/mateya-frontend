# Development TODO

- P1: 책임이 과밀한 `application/data` 파일을 validator/helper/service/repository 단위로 추가 분리
  이유: 500줄 이상 `application/data` 파일은 정리됐지만, `details` repository와 `onboarding/chat` controller는 아직 상태 전이, API 처리, mock 데이터, 검증 책임이 한 파일에 과밀하게 남아 있음
- P2: `onboarding`/`create` 화면의 개별 로딩 UI를 `MateyaSkeleton` 기반으로 통일
  이유: 이번 작업으로 `home/chat/mypage/details`는 공통 스켈레톤을 쓰게 됐지만, 나머지 플로우는 여전히 화면별 로딩 표현이 달라 UX 일관성이 깨질 수 있음
