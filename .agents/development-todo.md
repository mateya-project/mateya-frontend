# Development TODO

- P2: Upgrade `flutter_naver_map` and `package_info_plus` to versions compatible with Flutter Built-in Kotlin migration.
  Reason: `flutter build apk --debug` succeeds, but Flutter warns these plugins still apply the legacy Kotlin Gradle Plugin and future Flutter releases may fail builds.
- P1: Connect the new report sheet UI to a backend report API and image upload flow.
  Reason: `2026-06-17` Swagger has no report endpoint yet, so the current report flow is frontend-only and does not persist submissions.
