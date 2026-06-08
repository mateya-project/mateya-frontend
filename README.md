# Frontend

Next.js 16 기반 프론트엔드 프로젝트입니다.

## 로컬 실행 방법

### 1. 사전 요구사항

- Node.js `20.9.0` 이상
- npm `11.6.2` 권장

현재 프로젝트는 `package-lock.json`과 `packageManager` 설정을 기준으로 npm을 사용합니다.

```bash
node -v
npm -v
```

### 2. 의존성 설치

```bash
npm ci
```

`package-lock.json`을 기준으로 동일한 버전의 의존성을 설치합니다. 의존성을 새로 추가하거나 갱신해야 하는 경우에만 `npm install`을 사용합니다.

### 3. 개발 서버 실행

```bash
npm run dev
```

브라우저에서 [http://localhost:3000](http://localhost:3000)으로 접속합니다.

Next.js 16에서는 `next dev`가 기본적으로 Turbopack을 사용합니다. 포트를 변경해야 하면 다음처럼 실행합니다.

```bash
npm run dev -- -p 4000
```

### 4. 로컬 빌드 확인

```bash
npm run build
```

프로덕션 빌드가 정상적으로 생성되는지 확인합니다.

### 5. 프로덕션 모드 실행

`npm run start`는 빌드 결과물을 실행하므로 먼저 `npm run build`가 필요합니다.

```bash
npm run build
npm run start
```

기본 접속 주소는 [http://localhost:3000](http://localhost:3000)입니다.

## 자주 쓰는 명령어

```bash
npm run dev           # 개발 서버 실행
npm run build         # 프로덕션 빌드
npm run start         # 빌드 결과물 실행
npm run lint          # ESLint 검사
npm run format:check  # Prettier 포맷 검사
npm run format        # Prettier 포맷 적용
```
