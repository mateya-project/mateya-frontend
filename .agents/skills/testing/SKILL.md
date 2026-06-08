---
name: testing
description: Next.js 프로젝트에서 테스트 코드를 작성, 수정, 리뷰할 때 사용하는 실무 지침. App Router, Server/Client Component, Route Handler, Server Action, 데이터 패칭, React Testing Library, Playwright, mock 전략, CI 검증 범위를 다룬다.
---

# Next.js Testing Skill

## 기본 원칙

- 테스트는 구현 세부사항보다 사용자에게 보이는 결과와 비즈니스 규칙을 검증한다.
- 테스트 레벨은 비용이 낮은 순서로 선택한다. 순수 로직은 unit, 화면 상호작용은 component, 여러 경계가 얽힌 흐름은 integration, 핵심 사용자 여정은 E2E로 검증한다.
- 프레임워크 내부 동작, CSS 클래스명, hook 호출 순서, private state에 의존하지 않는다.
- 날짜, 시간, 랜덤 값, 네트워크, 브라우저 API처럼 불안정한 요소는 테스트에서 명시적으로 제어한다.
- 새 테스트 도구를 추가하기 전에 `package.json`, 기존 테스트 파일, CI 설정을 확인하고 프로젝트의 표준 스택을 따른다.

## 권장 도구 선택

- Unit/component: Vitest 또는 Jest, React Testing Library, `@testing-library/user-event`
- API/server logic: Vitest 또는 Jest, 필요 시 MSW
- E2E: Playwright
- 정적 검증: TypeScript `tsc --noEmit`, ESLint, 프로젝트의 build 명령

프로젝트가 이미 Jest 또는 Vitest 중 하나를 사용한다면 혼용하지 않는다. 새 도구 도입은 설정, CI, test setup, 예시 테스트까지 함께 정리할 수 있을 때만 진행한다.

## App Router 테스트 기준

- Server Component는 데이터 로딩 결과, 분기 렌더링, 권한 상태, empty/error state를 검증한다.
- Client Component는 입력, 클릭, 키보드 조작, optimistic UI, loading/error 표시, 접근성 상태를 검증한다.
- `next/navigation`의 `useRouter`, `usePathname`, `useSearchParams`는 테스트 setup 또는 테스트 파일에서 명시적으로 mock 처리한다.
- `redirect`, `notFound`, revalidation, cache 관련 동작은 Next.js helper mock이나 통합 테스트로 의도를 명확히 검증한다.
- `next/image`, `next/font`, dynamic import처럼 테스트 환경에서 깨지기 쉬운 기능은 전역 setup에서 일관되게 처리한다.

## Route Handler와 Server Action

- Route Handler는 `Request` 또는 `NextRequest`를 구성해 handler를 직접 호출하고 status, headers, JSON body를 검증한다.
- 인증, 쿠키, 헤더, search params, body validation을 성공/실패 케이스로 나눠 테스트한다.
- Server Action은 핵심 비즈니스 로직을 별도 함수로 분리하고, action은 얇은 orchestration layer로 유지한다.
- DB, 결제, 이메일, 스토리지 같은 외부 의존성은 adapter 또는 repository 경계를 통해 mock/fake로 대체한다.
- mutation 테스트는 성공뿐 아니라 validation error, 권한 오류, 중복 요청, 외부 API 실패를 포함한다.

## React Testing Library 사용법

- query 우선순위는 `getByRole`, `getByLabelText`, `getByText`, `getByTestId` 순서로 둔다.
- `data-testid`는 role, label, text로 안정적으로 찾을 수 없는 요소에만 사용한다.
- 클릭, 입력, 탭 이동은 `fireEvent`보다 `userEvent`를 사용한다.
- 비동기 UI는 `findBy...` 또는 `waitFor`로 기다리고 임의의 `setTimeout` sleep을 넣지 않는다.
- assertion은 단순 존재 여부를 넘어서 disabled 상태, aria 상태, URL 변화, 호출 인자, 저장 결과를 구체적으로 확인한다.

## Mock 전략

- 외부 네트워크는 테스트에서 직접 호출하지 않는다. MSW 또는 명시적 fetch mock으로 계약을 고정한다.
- mock은 실제 API 계약과 가까운 최소 fixture를 사용한다.
- 모든 것을 mock해 통합 문제를 숨기지 않는다. 경계가 중요한 기능은 integration 또는 E2E 테스트를 추가한다.
- 날짜는 fake timers 또는 system time 고정으로 제어한다.
- 랜덤 ID는 생성기를 주입하거나 mock해 재현 가능한 assertion을 만든다.
- 브라우저 전용 API(`ResizeObserver`, `IntersectionObserver`, `matchMedia`, clipboard 등)는 테스트 setup에서 필요한 범위만 polyfill한다.

## 데이터 패칭과 상태 관리

- `fetch` 로직은 success, loading, empty, validation error, authorization error, server error를 분리해 검증한다.
- SWR, React Query, Apollo 같은 client cache는 테스트마다 새 client/cache를 생성한다.
- optimistic update는 즉시 반영, 실패 시 rollback, 성공 시 최종 상태를 각각 검증한다.
- fixture는 거대한 공용 객체보다 케이스별 builder 또는 최소 객체를 선호한다.

## Playwright E2E 기준

- E2E는 로그인, 주요 CRUD, 결제, 온보딩, 권한 분기처럼 제품 핵심 흐름에 집중한다.
- selector는 role, label, text를 우선 사용하고 DOM 구조나 CSS selector 의존을 피한다.
- 인증은 매 테스트마다 UI 로그인을 반복하지 말고 storage state나 테스트 전용 로그인 helper를 사용한다.
- 테스트 데이터는 각 테스트가 독립적으로 만들고 정리한다.
- flaky 테스트는 retry 수 증가로 덮지 말고 trace, screenshot, video, network log로 원인을 확인한다.
- visual regression은 동적 영역을 mask하고, 가치가 큰 화면에 제한적으로 적용한다.

## 테스트 파일 구조

- 기존 프로젝트 규칙이 있으면 우선 따른다.
- 규칙이 없다면 컴포넌트 근처에 `Component.test.tsx`, 순수 로직 근처에 `*.test.ts`, E2E는 `e2e/` 또는 `tests/e2e/`에 둔다.
- 공용 render helper, test provider, fixture, mock server는 `test/` 또는 `tests/` 아래에 모은다.
- 테스트 유틸리티는 제품 코드에서 import하지 않는다.

## CI와 검증 범위

- PR 기본 검증은 lint, typecheck, unit/component test, build를 포함한다.
- E2E는 비용에 따라 smoke suite와 full suite를 분리할 수 있다.
- 테스트 실패 시 먼저 로컬 재현 커맨드, 실패 로그, seed, Playwright trace 또는 screenshot을 확인한다.
- 스냅샷 업데이트는 변경 의도를 설명할 수 있을 때만 허용한다.

## 테스트 추가 절차

1. 변경된 코드의 사용자 영향과 회귀 위험을 확인한다.
2. 가장 낮은 비용으로 신뢰를 주는 테스트 레벨을 선택한다.
3. 기존 테스트 setup, fixture, helper를 재사용한다.
4. 성공 케이스와 실패 또는 경계 케이스를 함께 작성한다.
5. 로컬에서 관련 테스트와 정적 검증을 실행한다.

## 피해야 할 패턴

- 테스트 통과만을 위해 제품 코드에 테스트 전용 분기를 넣는다.
- `act` warning, hydration warning, unhandled promise rejection을 무시한다.
- 큰 DOM snapshot으로 UI 동작 검증을 대체한다.
- 실제 사용자가 접근할 수 없는 selector에 의존한다.
- 테스트 간 전역 상태, cache, localStorage, fake timer를 정리하지 않는다.
- CI에서만 통과하거나 로컬에서만 통과하는 명령을 별도로 만든다.
