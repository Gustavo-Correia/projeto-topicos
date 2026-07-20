---
kind: dependency_management
name: Flutter pub.dev Package Management with Lockfile Pinning
category: dependency_management
scope:
    - '**'
source_files:
    - pubspec.yaml
    - pubspec.lock
---

This Flutter monorepo uses the standard Dart/Flutter dependency management system centered on `pubspec.yaml` and a committed `pubspec.lock` file. All third-party packages are resolved from the public `https://pub.dev` registry — no private registries, vendoring, or local path overrides are configured.

**System used**
- **Package manager**: `pub` (Dart SDK) / `flutter pub` (Flutter SDK).
- **Manifest**: `pubspec.yaml` at the repository root declares direct dependencies and dev-dependencies.
- **Lockfile**: `pubspec.lock` is committed to version control, pinning every transitive dependency to an exact version plus sha256 checksum for reproducible builds.
- **Registry**: Public `pub.dev` only; no `pubspec_overrides.yaml`, `PUB_HOSTED_URL`, or custom `pubspec.yaml` `dependency_overrides` blocks are present.
- **SDK constraints**: `environment.sdk: '>=3.11.0 <4.0.0'` constrains the Dart SDK; the lockfile further pins `flutter >=3.38.4`.

**Key files**
- `pubspec.yaml` — single source of truth for declared dependencies (`provider`, `hive`, `hive_flutter`, `intl`, `uuid`, `http`, `cupertino_icons`) and dev tools (`flutter_lints`, `flutter_launcher_icons`).
- `pubspec.lock` — immutable snapshot of the full dependency graph (direct + transitive), including platform plugins such as `path_provider_*` and `jni`/`jni_flutter` pulled in transitively by Hive.
- `android/build.gradle.kts`, `android/settings.gradle.kts`, `ios/Runner.xcodeproj/project.pbxproj` — platform shells depend on the Flutter engine but do not declare their own package manifests; native plugin integration is handled through Flutter's generated registrants.

**Architecture & conventions**
- Single-root manifest: all Dart code lives under `lib/` and depends on one shared `pubspec.yaml`; there are no sub-package `pubspec.yaml` files, so this is effectively a flat project rather than a multi-package pub workspace.
- Versioning style: direct dependencies use caret ranges (`^x.y.z`) allowing compatible minor/patch updates while still being pinned by the lockfile; SDK constraint uses a bounded range (`>=3.11.0 <4.0.0`).
- Dev vs runtime split: testing and build-tooling packages (`flutter_test`, `flutter_lints`, `flutter_launcher_icons`) are placed under `dev_dependencies` and never shipped into production builds.
- No vendoring or offline cache strategy is enforced at repo level; developers rely on the global pub cache and the committed lockfile for determinism.

**Rules developers should follow**
1. Always run `flutter pub get` after pulling changes so the local cache matches the committed `pubspec.lock`.
2. When adding a new dependency, declare it in `pubspec.yaml` and commit the updated `pubspec.lock` — do not edit the lockfile by hand.
3. Prefer caret (`^`) version ranges in `pubspec.yaml` to allow safe patch/minor bumps; rely on CI to catch breaking upgrades via `flutter pub upgrade --major-versions`.
4. Keep `publish_to: 'none'` since this is an application, not a library meant for publishing to pub.dev.
5. Do not introduce `dependency_overrides` or `pubspec_overrides.yaml` without team agreement; they bypass the lockfile and break reproducibility.