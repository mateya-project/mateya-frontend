# Development TODO

- P2: Resolve the remaining Flutter Built-in Kotlin migration warning for `flutter_naver_map` and `package_info_plus`.
  Reason: Re-verified on `2026-06-18` with `flutter build apk --debug`. The app project already uses Kotlin DSL and the warning is emitted because each plugin still has its own `android/build.gradle` with `apply plugin: 'kotlin-android'`. The local `android.builtInKotlin=false` flag is only a Flutter template/migration marker, so removing or toggling it is not a real fix.

- P3: If this warning must be eliminated before upstream releases, review a path/git override strategy for `flutter_naver_map` and `package_info_plus`.
  Reason: The only frontend-side fix left is to vendor or override the plugins with a reviewed Built-in Kotlin migration. That changes dependency sources and should be agreed with the team before proceeding.
