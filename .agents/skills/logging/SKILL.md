---
name: logging
description: Next.js 프로젝트에서 Pino 기반 서버 로그, 구조화 로그 필드, 로그 레벨, 민감정보 마스킹, 요청/에러 로깅 정책을 추가하거나 수정할 때 사용하는 실무 지침.
---

# Logging Skill

## 기본 원칙

- 서버 로그는 `src/lib/logger.ts`의 Pino 인스턴스를 사용한다. 브라우저 컴포넌트나 Edge Runtime 코드에서는 이 로거를 import하지 않는다.
- 로그는 사람이 읽는 문장보다 검색 가능한 구조화 필드 중심으로 남긴다.
- 로그는 장애 분석, 보안 감사, 운영 지표 확인에 필요한 이벤트에 제한한다. 렌더링마다 반복되는 노이즈성 로그는 남기지 않는다.
- 비밀번호, 토큰, 쿠키, 인증 헤더, 개인식별정보, 결제 정보는 원문으로 기록하지 않는다.
- 불확실한 도메인 값이나 정책 기준은 추정해서 로그에 넣지 말고 담당자에게 확인한다.

## 현재 표준

- 로거: Pino
- 공통 로거: `src/lib/logger.ts`
- 기본 서비스명: `LOG_SERVICE_NAME` 또는 `frontend`
- 로그 레벨: `LOG_LEVEL` 또는 개발 `debug`, 그 외 `info`
- 시간 형식: ISO timestamp
- 기본 마스킹 필드: `authorization`, `cookie`, `password`, `token`, `secret`, `apiKey`

## 레벨 기준

- `debug`: 로컬 개발 또는 일시적 원인 분석에 필요한 상세 상태. 운영 기본 로그로 남기지 않는다.
- `info`: 정상적인 주요 비즈니스 이벤트, 배치 시작/종료, 외부 연동 성공처럼 운영에서 추적할 가치가 있는 이벤트.
- `warn`: 재시도 가능한 실패, 비정상 입력, 성능 저하, fallback 사용처럼 즉시 장애는 아니지만 확인이 필요한 이벤트.
- `error`: 요청 실패, 외부 API 실패, 저장 실패, 예외처럼 사용자 영향이나 데이터 정합성 문제가 생길 수 있는 이벤트.
- `fatal`: 프로세스 지속이 어렵거나 즉시 복구 조치가 필요한 치명적 상태.

## 필드 규칙

- 공통 필드는 `requestId`, `userId`, `accountId`, `route`, `method`, `statusCode`, `durationMs`, `event`, `errorCode`처럼 일관된 이름을 사용한다.
- `createLogger({ requestId, route })`처럼 child logger로 요청 또는 작업 단위 컨텍스트를 묶는다.
- 에러는 `logger.error({ err, ...context }, "message")` 형태로 기록해 stack과 컨텍스트를 함께 남긴다.
- 로그 메시지는 짧은 영문 동사구 또는 명사구로 통일한다. 상세 설명은 구조화 필드에 둔다.
- 고카디널리티 값은 필요한 경우에만 남긴다. 전체 request body, HTML, 큰 JSON payload는 기록하지 않는다.

## Next.js App Router 기준

- Route Handler와 Server Action에서는 mutation, 외부 연동, 권한 실패, validation 실패, 처리 시간을 우선 기록한다.
- 응답 이후 처리해도 되는 활동 로그는 Next.js `after`를 사용해 요청 응답 시간을 불필요하게 늘리지 않는다.
- Server Component에서 request-time API 값을 `after` 안에서 직접 읽지 않는다. 필요한 값은 렌더링 중 읽어 callback에 전달한다.
- `GET` Route Handler 로그를 추가할 때 캐싱 설정과 정적 생성 여부를 같이 확인한다.
- Client Component에서는 운영 로그 대신 분석 도구나 명시적 telemetry 경계를 사용한다.

## 변경 절차

1. 로그가 필요한 운영 질문을 먼저 정의한다.
2. 기존 로거와 필드명을 확인하고 중복 필드를 만들지 않는다.
3. 민감정보가 포함될 수 있는 값은 로깅 전에 제거하거나 요약한다.
4. 실패 경로에는 원인, 영향 범위, 재시도 가능 여부를 판단할 수 있는 필드를 남긴다.
5. 변경 후 `npm run lint`와 `npm run build`로 import 경계와 타입을 검증한다.

## 금지 사항

- `console.log`를 운영 코드에 남기지 않는다.
- 로그를 위해 사용자 비밀값, raw cookie, raw authorization header, 전체 request body를 기록하지 않는다.
- `logger.error("message", err)`처럼 에러 객체가 구조화되지 않는 형태를 사용하지 않는다.
- 로깅 실패가 사용자 요청 실패로 이어지게 만들지 않는다.
- 임시 디버깅 로그를 장기 운영 로그처럼 남기지 않는다.
