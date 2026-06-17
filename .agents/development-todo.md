# Development TODO

- P2: Upgrade `flutter_naver_map` and `package_info_plus` to versions compatible with Flutter Built-in Kotlin migration.
  Reason: `flutter build apk --debug` succeeds, but Flutter warns these plugins still apply the legacy Kotlin Gradle Plugin and future Flutter releases may fail builds.
