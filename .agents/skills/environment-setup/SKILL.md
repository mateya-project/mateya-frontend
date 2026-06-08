---
name: environment-setup
description: Flutter 기반 Android/iOS 앱 프로젝트의 개발 환경 설정 방법을 안내한다. Flutter 실행, 빌드, SDK 점검, 플랫폼별 개발 환경 확인이 필요한 경우 이 스킬을 사용한다.
---

# 실행 환경 설정 가이드

## Working Directory

- working directory는 프로젝트 루트 디렉토리이다.
- `pubspec.yaml` 파일이 있는 위치에서 Flutter 명령어를 실행한다.
- Android 관련 설정은 `android/`, iOS 관련 설정은 `ios/` 디렉토리에서 관리한다.

## Flutter SDK 및 필수 도구

- Flutter 앱 개발에는 `Flutter SDK`, `Dart SDK`, `Xcode`, `CocoaPods`, `Android SDK`, `Java`가 필요하다.
- Dart SDK는 Flutter SDK에 포함되어 있으므로 별도 설치 대상으로 분리하지 않는다.
- iOS 개발은 macOS와 Xcode가 필요하다.
- Android 개발은 Android SDK와 라이선스 승인이 필요하다.

개발 환경 점검:
```bash
flutter doctor -v
```

Android 라이선스 승인 필요 시:
```bash
flutter doctor --android-licenses
```

## 플랫폼 실행 환경

- Android/iOS 앱 실행과 빌드는 기본적으로 프로젝트 루트에서 `flutter` 명령으로 수행한다.
- 특정 플랫폼 폴더에서 직접 작업하는 경우는 네이티브 설정 수정이나 문제 해결이 필요할 때로 제한한다.

의존성 설치:
```bash
flutter pub get
```

연결된 디바이스/시뮬레이터 확인:
```bash
flutter devices
```

앱 실행:
```bash
flutter run
```

특정 플랫폼 대상으로 실행 예시:
```bash
flutter run -d ios
flutter run -d android
```

## iOS 개발 환경

- iOS 개발 시 Xcode Command Line Tools와 `CocoaPods`가 정상 설치되어 있어야 한다.
- 플러그인 추가 후 iOS 네이티브 의존성 반영이 필요하면 `ios/` 디렉토리에서 `pod install`을 사용한다.
- 시뮬레이터 빌드 검증은 다음 명령을 사용한다.

```bash
flutter build ios --simulator --debug
```

문제가 있을 때 Pod 재설치:
```bash
cd ios
pod install
```

## Android 개발 환경

- Android SDK 경로와 `cmdline-tools`가 정상 설정되어 있어야 한다.
- Android Studio가 설치되어 있으면 SDK, 에뮬레이터, JDK 관리가 수월하다.
- 디버그 빌드 검증은 다음 명령을 사용한다.

```bash
flutter build apk --debug
```

에뮬레이터 목록 확인:
```bash
flutter emulators
```

## 환경변수 및 설정 파일

- 일반적인 Flutter 패키지 의존성은 `pubspec.yaml`에서 관리한다.
- 앱별 환경 분리가 필요하면 `--dart-define` 또는 flavor 전략을 사용한다.
- Django처럼 전역 `settings module`을 강제하는 구조가 아니므로, 환경별 구성 방식은 앱 아키텍처 차원에서 명시적으로 설계해야 한다.

런타임 환경값 전달 예시:
```bash
flutter run --dart-define=API_BASE_URL=https://example.com
```

## 기본 검증 절차

환경 설정 후 최소 검증:
```bash
flutter pub get
flutter doctor -v
flutter test
flutter build apk --debug
flutter build ios --simulator --debug
```

## 주의사항

- Flutter 명령은 가능한 한 프로젝트 루트에서 실행한다.
- iOS/Android 네이티브 설정을 직접 수정한 경우 플랫폼 빌드까지 확인한다.
- 패키지 추가 후에는 Dart 코드만 보지 말고 네이티브 의존성 반영 여부까지 확인한다.
- 로컬 환경 문제를 우회하는 임시 스크립트보다 `flutter doctor` 기준으로 근본 원인을 해결한다.
