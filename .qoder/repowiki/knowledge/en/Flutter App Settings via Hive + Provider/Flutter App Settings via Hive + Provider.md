---
kind: configuration_system
name: Flutter App Settings via Hive + Provider
category: configuration_system
scope:
    - '**'
source_files:
    - lib/models/app_settings.dart
    - lib/services/settings_storage.dart
    - lib/services/settings_storage_service.dart
    - lib/providers/settings_provider.dart
    - lib/utils/app_colors.dart
    - lib/main.dart
    - pubspec.yaml
    - android/app/src/main/AndroidManifest.xml
    - android/app/build.gradle.kts
    - ios/Runner/Info.plist
---

The repository has no centralized runtime configuration system (no .env, config/ directory, feature-flag loader, or build-time config generator). Instead, user-facing app settings are persisted locally with Hive and surfaced through a Provider. The only compile-time / build-time configuration lives in pubspec.yaml (SDK constraints, dependencies, Flutter launcher icons) and the Android/iOS platform manifests.

### What is used
- **Hive** (hive + hive_flutter) as the local key-value store for user settings.
- **Provider** (ChangeNotifierProvider) to expose settings state to the widget tree.
- Plain Dart models with toMap/fromMap serialization — no JSON schema library or codegen.
- Platform manifests (android/app/src/main/AndroidManifest.xml, ios/Runner/Info.plist) for native-level metadata; no dynamic runtime overrides.

### Key files and packages
- lib/models/app_settings.dart — immutable settings model (onboardingCompleted, userName, monthlyBudget, themeId, custom theme colors) with copyWith, toMap, fromMap.
- lib/services/settings_storage.dart — abstract SettingsStorage interface.
- lib/services/settings_storage_service.dart — Hive-backed implementation using box settings_box and key app_settings.
- lib/providers/settings_provider.dart — ChangeNotifier that loads/saves AppSettings, derives the active AppTheme, and exposes updateTheme, completeOnboarding, updateSettings, resetOnboarding.
- lib/utils/app_colors.dart — predefined AppTheme constants plus AppColors.of(context) accessor; activeTheme maps themeId to a ThemeData.
- lib/main.dart — bootstraps Hive boxes, sets Intl.defaultLocale = pt_BR, wires Providers, and builds MaterialApp from SettingsProvider.activeTheme.
- pubspec.yaml — SDK/environment constraints, dependency versions, flutter_launcher_icons and flutter: asset sections.
- android/app/src/main/AndroidManifest.xml — app label, permissions, configChanges; android/app/build.gradle.kts contains signing/debug defaults.
- ios/Runner/Info.plist — iOS bundle metadata.

### Architecture and conventions
1. Single source of truth: AppSettings is the canonical shape; every UI reads it through SettingsProvider.
2. Persistence layer abstraction: SettingsStorage lets tests inject a fake storage implementation (see test/settings_provider_test.dart).
3. Theme-as-config: User preference for theming is stored as a string themeId plus optional custom color ints; SettingsProvider.activeTheme resolves the final AppTheme at runtime.
4. Initialization order: main() initializes Hive, opens both subscriptions_box and settings_box, then runs the app so providers can load settings synchronously on first build.
5. No environment branching: There is no debug/release/staging config split; behavior differences would have to be gated by runtime flags inside AppSettings.

### Rules developers should follow
- Add new user preferences by extending AppSettings (with sensible defaults), updating copyWith/toMap/fromMap, and persisting through SettingsStorage.saveSettings.
- Never read Hive directly outside SettingsStorageService; go through SettingsProvider so the UI stays reactive.
- Keep platform-specific values out of Dart code — put them in AndroidManifest.xml, Info.plist, or pubspec.yaml.
- Do not introduce .env files or package:dotenv; this project does not use them and they are not wired into the build.
- For testability, inject a mock SettingsStorage into SettingsProvider instead of stubbing global Hive state.