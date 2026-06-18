# Development TODO

- P2: Replace hardcoded activity category constants with `/api/v1/activity-categories`.
  Reason: The backend category metadata endpoint can now return public-data-compatible top-level codes and detail codes, but the frontend still hardcodes `kExploreCategories`, `CreateFormOptions.categories`, and local category label maps. Keep the UI-only `all` option on the client.

- P2: Resolve the remaining Flutter Built-in Kotlin migration warning for `flutter_naver_map` and `package_info_plus`.
  Reason: As of `2026-06-18`, `flutter_naver_map 1.4.4` and transitive `package_info_plus 10.1.0` are already the latest versions on pub.dev, but `flutter build apk --debug` still warns that both plugins apply the legacy Kotlin Gradle Plugin. This now looks blocked on an upstream plugin release or a reviewed fork/override.
