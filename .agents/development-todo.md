# Development TODO

- P2: Resolve the remaining Flutter Built-in Kotlin migration warning for `flutter_naver_map` and `package_info_plus`.
  Reason: As of `2026-06-18`, `flutter_naver_map 1.4.4` and transitive `package_info_plus 10.1.0` are already the latest versions on pub.dev, but `flutter build apk --debug` still warns that both plugins apply the legacy Kotlin Gradle Plugin. This now looks blocked on an upstream plugin release or a reviewed fork/override.
