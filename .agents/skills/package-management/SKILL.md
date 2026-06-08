---
name: package-management
description: Flutter 기반 Android/iOS 앱 프로젝트의 패키지 관리 방법을 안내한다. 새로운 패키지를 추가하거나 제거하는 경우, 또는 의존성 설치와 동기화가 필요한 경우 이 스킬을 사용한다.
---

# 패키지 관리 가이드

이 프로젝트는 Flutter SDK와 `pub` 패키지 매니저를 이용해 앱 의존성을 관리한다. 패키지 정의는 `pubspec.yaml`에서 관리하고, 잠금 파일은 `pubspec.lock`을 사용한다.

## 런타임 및 SDK 관리

- Flutter SDK 버전 호환성은 `pubspec.yaml`의 `environment` 섹션에 정의한다.
- Dart SDK는 Flutter SDK에 포함되어 있으므로 별도로 패키지 매니저를 분리하지 않는다.
- iOS 빌드는 `Xcode`와 `CocoaPods`, Android 빌드는 `Android SDK`와 `Gradle` 설정에 의존한다.

## 패키지 매니저

이 프로젝트는 `flutter pub` 명령어를 사용한다. 패키지 추가, 제거, 설치, 업데이트는 가능한 한 직접 `pubspec.yaml`만 수동 편집하지 말고 `flutter pub` 명령으로 처리한다.

## 패키지 추가

일반 패키지 추가:
```bash
flutter pub add <package_name>
```
예시: `flutter pub add dio`

개발 전용 패키지 추가:
```bash
flutter pub add --dev <package_name>
```
예시: `flutter pub add --dev build_runner`

특정 버전 지정:
```bash
flutter pub add <package_name>:^1.2.3
```

Git 의존성이나 path 의존성은 자동화가 어려운 경우에만 `pubspec.yaml`에 직접 명시한다.

## 패키지 제거

패키지 제거:
```bash
flutter pub remove <package_name>
```
예시: `flutter pub remove dio`

제거 전에는 반드시 코드에서 실제 사용 여부를 확인한다.

## 의존성 설치 및 동기화

프로젝트 의존성 설치:
```bash
flutter pub get
```

의존성 버전 확인:
```bash
flutter pub outdated
```

의존성 업그레이드:
```bash
flutter pub upgrade
```

메이저 버전 포함 가능한 범위까지 올리고 싶을 때:
```bash
flutter pub upgrade --major-versions
```

## 네이티브 플랫폼 반영

- Flutter 패키지 추가 후 iOS는 `Pods` 갱신이 필요할 수 있다.
- 일반적으로 `flutter pub get` 또는 iOS 빌드 시 자동 반영되지만, 문제가 있으면 `ios/`에서 `pod install`을 사용한다.
- Android는 대부분 `flutter pub get` 이후 Gradle 동기화로 반영된다.

필요 시 iOS Pod 재설치:
```bash
cd ios
pod install
```

## 초기 개발 환경 점검

Flutter 개발 환경 점검:
```bash
flutter doctor -v
```

Android 라이선스 승인 필요 시:
```bash
flutter doctor --android-licenses
```

기본 빌드 검증 예시:
```bash
flutter test
flutter build apk --debug
flutter build ios --simulator --debug
```

## 주의사항

- 코드에서 실제로 사용하는 패키지를 제거하지 않도록 주의한다.
- `pubspec.lock`은 앱의 재현 가능한 설치 상태를 보장하므로, 패키지 변경 시 함께 검토한다.
- Flutter 플러그인은 Dart 코드뿐 아니라 iOS/Android 네이티브 의존성까지 추가할 수 있으므로, 추가 후 `flutter doctor`, 테스트, 플랫폼 빌드까지 확인한다.
- 패키지 추가 전에 유지보수 상태, 최근 업데이트, 플랫폼 지원 범위를 확인한다.
- 임시 우회용 패키지보다 공식 문서와 생태계에서 검증된 패키지를 우선한다.
