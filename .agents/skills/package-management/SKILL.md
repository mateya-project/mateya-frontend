# Package Management Skill

Next.js 프로젝트에서 버전 관리, 패키지 매니저, 의존성 변경을 다룰 때 적용한다. 목표는 로컬 개발, CI, 배포 환경이 같은 Node.js 런타임과 같은 의존성 그래프로 재현되게 만드는 것이다.

## Next.js 버전 관리

- Next.js는 `package.json`에 정확한 버전으로 고정한다. 운영 프로젝트에서는 `next: "15.3.2"`처럼 명시하고, `^15.3.2`, `~15.3.2`, `latest`는 기본값으로 사용하지 않는다.
- Next.js, React, React DOM, TypeScript, ESLint, `eslint-config-next`는 하나의 호환성 묶음으로 관리한다. Next.js만 단독으로 올리지 않는다.
- 업그레이드는 패치, 마이너, 메이저를 분리한다. 특히 메이저 업그레이드는 별도 브랜치에서 진행하고 공식 릴리즈 노트와 마이그레이션 가이드를 확인한다.
- App Router, Server Actions, Middleware, Image Optimization, Turbopack, 캐시 동작은 버전 변화의 영향을 크게 받는다. 해당 기능을 사용하는 프로젝트는 업그레이드 시 관련 경로의 회귀 테스트나 수동 검증 기록을 남긴다.
- `next.config.*`, `middleware.*`, `instrumentation.*`, 커스텀 서버, Vercel 설정은 Next.js 버전 변화와 함께 검토한다.
- 보안 패치는 빠르게 반영하되, 락파일만 수정하고 끝내지 않는다. 실제 설치 버전, 빌드 결과, 핵심 페이지 렌더링 결과까지 확인한다.

## 패키지 매니저 선택

- 프로젝트마다 패키지 매니저는 하나만 사용한다. `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `bun.lockb`가 동시에 존재하면 먼저 표준 매니저를 결정한다.
- 표준 패키지 매니저는 `package.json`의 `packageManager` 필드에 명시한다. 예: `"packageManager": "pnpm@9.15.4"`.
- 패키지 매니저 선택은 프로젝트 재현성, 모노레포 지원, CI 속도, 배포 환경 호환성, 팀 운영 비용을 기준으로 결정한다.
- Corepack을 사용할 수 있는 환경에서는 Corepack으로 패키지 매니저 버전을 고정한다. 개인 전역 설치 버전에 의존하지 않는다.
- 패키지 매니저 변경은 일반 의존성 변경과 분리한다. 매니저 전환 작업에는 락파일 재생성, CI 설치 명령, 배포 설정, README 또는 온보딩 문서 변경을 함께 포함한다.

## 락파일과 설치 명령

- 락파일은 의존성 그래프의 계약으로 취급한다. 충돌을 해결할 때 임의 삭제 후 재생성하지 않고, 표준 패키지 매니저로만 갱신한다.
- CI에서는 락파일을 강제하는 설치 명령을 사용한다. npm은 `npm ci`, pnpm은 `pnpm install --frozen-lockfile`, Yarn Berry는 `yarn install --immutable`을 사용한다.
- 로컬 개발과 CI가 다른 설치 명령을 사용하지 않게 한다. 로컬에서만 통과하는 의존성 상태는 허용하지 않는다.
- Node.js 버전은 `.nvmrc`, `.node-version`, `package.json`의 `engines.node`, CI 설정 중 프로젝트가 채택한 방식에 맞춰 일관되게 고정한다.
- Node.js 버전 변경은 Next.js 및 네이티브 의존성 빌드 결과에 영향을 줄 수 있으므로 별도 변경으로 취급한다.

## 의존성 변경 절차

1. 현재 표준 패키지 매니저, Node.js 버전, 락파일 종류를 확인한다.
2. Next.js와 호환되는 React, TypeScript, ESLint 관련 버전을 함께 확인한다.
3. 의존성 변경 후 락파일이 표준 패키지 매니저로만 갱신되었는지 확인한다.
4. 프로젝트에 정의된 `lint`, `typecheck`, `test`, `build` 명령을 실행한다.
5. 라우팅, API Route, Middleware, 인증, 이미지, 캐시처럼 프로젝트 핵심 경로를 수동 또는 자동으로 검증한다.
6. 업그레이드 PR이나 커밋 메시지에는 변경한 버전, 변경 이유, 검증 결과를 남긴다.

## 금지 사항

- 원인 확인 없이 `--legacy-peer-deps`, `--force`, `resolutions`, `overrides`를 추가하지 않는다.
- 여러 패키지 매니저의 락파일을 함께 커밋하지 않는다.
- Next.js 오류를 숨기기 위해 `ignoreBuildErrors`, `ignoreDuringBuilds` 같은 설정을 추가하지 않는다.
- `latest`, canary, beta, rc 버전을 명확한 사유와 롤백 계획 없이 운영 프로젝트에 도입하지 않는다.
- CI 실패를 피하기 위해 설치 명령, Node.js 버전, 락파일 검증을 느슨하게 만들지 않는다.

## 판단 기준

- 버전 고정은 재현성을 위한 기본값이다. 자동 업데이트는 Renovate, Dependabot 같은 도구로 PR 단위 검증이 가능할 때만 사용한다.
- 빠른 임시 통과보다 원인, 영향 범위, 되돌릴 수 있는 변경 단위를 명확히 하는 쪽을 선택한다.
- 불확실한 호환성 정보가 있으면 추정하지 않고 공식 문서, 릴리즈 노트, 실제 빌드 결과로 확인한다.
