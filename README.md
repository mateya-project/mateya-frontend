# Mateya Frontend

Flutter 기반 Mateya 앱 프론트엔드입니다.

## 요구 사항

- Flutter SDK 설치
- Dart SDK
- Xcode
- Android Studio

권장 확인:

```bash
flutter doctor
```

`flutter doctor`에서 iOS 또는 Android 관련 이슈가 남아 있으면 먼저 해결한 뒤 실행하는 편이 낫습니다.

## 로컬 실행

프로젝트 루트에서 아래 순서로 실행합니다.

### 1. 패키지 설치

```bash
flutter pub get
```

### 2. 연결된 디바이스 확인

```bash
flutter devices
```

에뮬레이터나 시뮬레이터가 없다면 먼저 실행합니다.

- iOS Simulator: Xcode 또는 Simulator 앱 실행
- Android Emulator: Android Studio Device Manager에서 실행

### 3. 앱 실행

```bash
flutter run
```

특정 디바이스를 지정하려면:

```bash
flutter run -d <device-id>
```

예시:

```bash
flutter run -d ios
flutter run -d android
```

## 현재 구현 화면 진입

현재 앱은 별도 라우트 URL을 두지 않았고, 아래 화면이 첫 진입점입니다.

- 진입 화면: `OnboardingFlowPage`
- 설정 위치: `lib/app/app.dart`
- 시작 방식: `MaterialApp.home`

즉, 앱 실행 후 바로 아래 온보딩 플로우가 열립니다.

- `J. 시작화면`
- `K-0. 개인정보 동의`
- `K-1. 인적사항 입력`
- `K-2. 전화번호 입력 / 인증번호 입력`
- `M-1. 동네 인증 자동`
- `M-2. 동네 인증 수동`
- `M-3. 가입완료`
- `N-0. 사업자 개인정보 동의`
- `N. 사업자 인증`

웹으로 확인하는 경우에는 `flutter run -d chrome` 실행 후 출력되는 로컬 주소(`http://localhost:<port>`)로 접속하면 위 온보딩 시작화면이 바로 열립니다.

## 자주 쓰는 명령어

코드 포맷:

```bash
dart format lib
```

정적 분석:

```bash
flutter analyze
```

테스트 실행:

```bash
flutter test
```


```bash
flutter run -d 521FF68C-98F0-4EE5-B3AA-917C014AFD11
```