# Development TODO

- P2: Upgrade `flutter_naver_map` and `package_info_plus` to versions compatible with Flutter Built-in Kotlin migration.
  Reason: `flutter build apk --debug` succeeds, but Flutter warns these plugins still apply the legacy Kotlin Gradle Plugin and future Flutter releases may fail builds.
- P1: Add a post-signup activity-region update flow and connect it to `PATCH /api/v1/users/me/activity-region`.
  Reason: Initial signup stores neighborhood data, but there is no frontend path to re-auth or change the saved activity region after account creation.
- P1: Wire the existing create/edit controller scaffolding into an actual activity edit entry flow.
  Reason: `CreateController` already supports `isEditMode`, `editingId`, and delete behavior, but current navigation always opens create in new-item mode.
- P2: Reduce reliance on local-only join/favorite toggles in activity detail until server state is available.
  Reason: The current detail screen initializes `isFavorite` and `isJoined` as local defaults and mutates join state without a server round-trip, which can misrepresent the actual participant/favorite state.
