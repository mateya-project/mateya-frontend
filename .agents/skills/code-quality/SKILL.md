---
name: code-quality
description: Next.js 프로젝트에서 포매터, 린터, pre-commit 훅, staged 파일 검증 정책을 추가하거나 수정할 때 사용하는 지침.
---

# Code Quality Skill

## 기본 원칙

- 포매터와 린터는 역할을 분리한다. Prettier는 코드 스타일 정규화, ESLint는 버그 가능성 및 프레임워크 규칙 검증에 사용한다.
- 프로젝트의 표준 패키지 매니저와 락파일을 따른다. 이 프로젝트는 `npm`과 `package-lock.json`을 기준으로 의존성을 갱신한다.
- pre-commit 훅은 staged 파일에만 적용해 커밋 시간을 예측 가능하게 유지한다.
- 훅을 우회해야 하는 상황은 예외로 취급하고, 우회 대신 실패 원인을 수정하는 것을 기본값으로 둔다.

## 현재 표준

- 포매터: Prettier
- pre-commit 실행기: Husky
- staged 파일 검증: lint-staged
- 로컬 포맷 명령: `npm run format`
- 포맷 검증 명령: `npm run format:check`
- 린트 명령: `npm run lint`

## 변경 절차

1. `package.json`, lockfile, 기존 ESLint/Prettier/Husky 설정을 먼저 확인한다.
2. 의존성 추가는 표준 패키지 매니저로 수행하고 lockfile을 함께 갱신한다.
3. pre-commit 훅에는 전체 프로젝트 빌드처럼 오래 걸리는 작업보다 staged 파일 대상의 빠른 검증을 둔다.
4. 설정 변경 후 `npm run format:check`, `npm run lint`, 필요 시 `npm run build`를 실행한다.
5. 훅 자체를 바꾼 경우 `npx lint-staged --no-stash` 또는 실제 커밋으로 동작을 검증한다.

## 금지 사항

- 린트 실패를 숨기기 위해 ESLint 규칙을 광범위하게 끄지 않는다.
- 포맷 결과와 기능 변경을 불필요하게 섞지 않는다.
- lockfile 없이 `package.json`만 수정하지 않는다.
- pre-commit 훅에서 네트워크 접근, 배포, DB 마이그레이션 같은 외부 상태 변경 작업을 실행하지 않는다.
