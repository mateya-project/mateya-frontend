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
