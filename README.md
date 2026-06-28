# Mateya Frontend

Mateya는 외국인과 로컬 사용자가 한국의 문화, 여행, 액티비티를 함께 경험할 수 있도록 연결하는 Flutter 기반 소셜 액티비티 앱입니다. 이 저장소는 온보딩, 장소 탐색, 활동 생성·참여, 다국어 채팅, 마이페이지까지 실제 사용자 앱 경험을 담당합니다.

## 서비스 주소

- https://apps.apple.com/kr/app/mateya/id6782392321

## 서비스 개요

- 공공데이터와 위치 기반 탐색으로 한국 문화 장소를 찾을 수 있습니다.
- 게스트와 호스트가 각각의 온보딩 흐름으로 가입할 수 있습니다.
- 사용자는 모임·클래스를 만들거나 참여를 신청할 수 있습니다.
- 채팅에서 번역과 원문 보기를 함께 제공해 다국어 소통을 보조합니다.
- 앱 전반에서 `ko`, `en`, `ja`, `zh-Hans` 로케일을 지원합니다.

## 앱 화면

온보딩, 탐색, 예약, 호스트/마이페이지 흐름 기준으로 주요 화면을 정리했습니다.

### 온보딩

<table align="center">
  <tr>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/start_screen.png" width="220" alt="Mateya start screen" /><br /><sub>앱 첫 진입 화면에서 서비스 성격과 시작 동선을 안내합니다.</sub></td>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/register_verification%20phone.png" width="220" alt="Mateya phone verification screen" /><br /><sub>전화번호 인증으로 가입 절차를 완료하는 단계입니다.</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/register_location%20info.png" width="220" alt="Mateya location registration screen" /><br /><sub>동네와 활동 지역 정보를 설정해 추천 정확도를 높입니다.</sub></td>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/language-change.png" width="220" alt="Mateya language change screen" /><br /><sub>지원 언어를 즉시 바꿔 다국어 UI를 사용할 수 있습니다.</sub></td>
  </tr>
</table>

### 탐색과 지도

<table align="center">
  <tr>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/search%20filter%20screen.png" width="220" alt="Mateya search filter screen" /><br /><sub>카테고리와 조건으로 원하는 문화 활동을 빠르게 찾습니다.</sub></td>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/near_traditional_info.png" width="220" alt="Mateya nearby culture map" /><br /><sub>주변 전통·문화 장소를 지도 기반으로 탐색할 수 있습니다.</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/near_traditional_info_list.png" width="220" alt="Mateya nearby culture list screen" /><br /><sub>지도와 함께 장소 목록을 비교하며 탐색할 수 있습니다.</sub></td>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/multilingual-screen.png" width="220" alt="Mateya multilingual chat screen" /><br /><sub>번역과 원문 보기를 통해 여러 언어 사용자와 소통합니다.</sub></td>
  </tr>
</table>

### 예약과 참여

<table align="center">
  <tr>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/reservation-home.png" width="220" alt="Mateya reservation home" /><br /><sub>예약과 참여 흐름의 진입 화면에서 전체 상태를 확인합니다.</sub></td>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/make%20reservation%20-%20step%201.png" width="220" alt="Mateya make reservation step 1" /><br /><sub>활동 예약 생성의 첫 단계에서 기본 정보를 입력합니다.</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/make%20reservation%20-%20step%202.png" width="220" alt="Mateya make reservation step 2" /><br /><sub>일정, 언어, 인원 같은 참여 조건을 구체화합니다.</sub></td>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/make%20reservation%20-%20step%203.png" width="220" alt="Mateya make reservation step 3" /><br /><sub>입력 내용을 확인하고 예약 생성을 마무리합니다.</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/reservation-list.png" width="220" alt="Mateya reservation list" /><br /><sub>내가 신청하거나 운영 중인 예약 목록을 한 번에 확인합니다.</sub></td>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/reservation%20-%20detail.png" width="220" alt="Mateya reservation detail" /><br /><sub>예약 상세에서 일정, 소개, 참여 상태를 확인합니다.</sub></td>
  </tr>
</table>

### 호스트와 마이페이지

<table align="center">
  <tr>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/host%20verification%20screen.png" width="220" alt="Mateya host verification screen" /><br /><sub>호스트 등록과 검증 절차를 통해 운영 권한을 신청합니다.</sub></td>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/host%20mypage.png" width="220" alt="Mateya host mypage" /><br /><sub>호스트 전용 마이페이지에서 운영 기능을 관리합니다.</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="https://raw.githubusercontent.com/mateya-project/.github/main/images/app/user%20mypage.png" width="220" alt="Mateya user mypage" /><br /><sub>일반 사용자 마이페이지에서 활동 이력과 설정을 관리합니다.</sub></td>
    <td align="center"></td>
  </tr>
</table>

## 기술 스택

| 영역 | 사용 기술 |
| --- | --- |
| App | Flutter, Dart |
| 지도 | `flutter_naver_map`, `geolocator`, `geocoding` |
| 인증/저장 | `flutter_secure_storage`, `shared_preferences` |
| 실시간 | `stomp_dart_client` |
| 관측성 | Firebase Crashlytics |
| UI | `google_fonts`, `flutter_svg` |
| 다국어 | `flutter_localizations`, `intl` |


## 핵심 기능

### 1. 온보딩과 회원 진입

- 게스트/호스트 시작 분기
- 약관 동의, 이름·사업자 정보 입력
- 전화번호 인증 기반 가입 완료
- 동네 설정과 초기 프로필 구성
- 세션 유무에 따라 홈 또는 온보딩 플로우 자동 분기

관련 코드:

- `lib/main.dart`
- `lib/app/app.dart`
- `lib/features/onboarding/`

### 2. 장소 탐색과 주변 문화 지도

- 공공데이터 기반 장소/행사/전통 정보 탐색
- 현재 위치 주변 문화 장소 목록·지도 통합 화면
- 카테고리 필터와 장소 상세 정보 제공
- 네이버 지도 SDK 기반 지도 렌더링

관련 코드:

- `lib/features/home/`
- `lib/shared/maps/`
- `lib/shared/activity_categories/`

### 3. 활동 생성과 참여 흐름

- 장소를 기반으로 모임 또는 클래스 생성
- 일정, 소개, 언어, 인원 등 세부 조건 입력
- 참여 신청, 예약 목록, 상세 확인 흐름 제공
- 호스트 승인/운영 시나리오 대응

관련 코드:

- `lib/features/create/`
- `lib/features/details/`

### 4. 다국어 채팅과 사용자 안전

- REST + WebSocket 기반 채팅
- 번역 결과와 원문 보기 토글 제공
- 신고 시트, 차단 사용자 관리, 마이페이지 설정 연동
- 선택한 언어를 로컬 저장소와 서버 프로필에 함께 동기화

관련 코드:

- `lib/features/chat/`
- `lib/features/mypage/`
- `lib/shared/localization/`
- `lib/shared/report/`

## 앱 구조

```text
lib/
  app/          앱 부팅, 라우팅, 초기 플로우 분기
  features/     onboarding, home, create, details, chat, mypage
  shared/       auth, localization, maps, network, widgets, theme
  l10n/         다국어 리소스와 생성 코드
test/
  app/          앱 초기화와 플로우 분기 테스트
  features/     기능별 위젯/컨트롤러/저장소 테스트
  shared/       공통 모듈 테스트
```

현재 테스트는 온보딩, 홈, 생성, 상세, 채팅, 마이페이지, 로케일/세션/네트워크 공통 모듈까지 분리되어 있습니다.

## 실행 방법

사전 확인:

```bash
flutter doctor
```

의존성 설치와 실행:

```bash
flutter pub get
flutter run
```

플랫폼 지정 실행:

```bash
flutter run -d ios
flutter run -d android
flutter run -d chrome
```

품질 확인:

```bash
dart format lib test
flutter analyze
flutter test
```

## 함께 보는 저장소

- Backend: [mateya-project/backend](https://github.com/mateya-project/backend)
- Organization Profile: [mateya-project/.github](https://github.com/mateya-project/.github)
