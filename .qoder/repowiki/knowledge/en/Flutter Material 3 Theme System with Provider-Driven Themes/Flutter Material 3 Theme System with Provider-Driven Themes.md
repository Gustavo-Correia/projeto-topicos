---
kind: frontend_style
name: Flutter Material 3 Theme System with Provider-Driven Themes
category: frontend_style
scope:
    - '**'
source_files:
    - lib/utils/app_colors.dart
    - lib/providers/settings_provider.dart
    - lib/models/app_settings.dart
    - lib/main.dart
---

The app uses a Flutter-based styling system built on top of Material 3, centered around a custom theme abstraction that is resolved at runtime via Provider state.

**Core approach**
- `AppTheme` (in `lib/utils/app_colors.dart`) is the single source of truth for all visual tokens: background, card, green/cyan/purple/yellow/red/muted/textPrimary/border. It exposes `toThemeData()` which builds a `MaterialApp` `ThemeData` with `useMaterial3: true`, dark brightness, and consistent defaults for `appBarTheme`, `cardTheme`, `inputDecorationTheme`, and `elevatedButtonTheme`.
- `AppColors.of(context)` is the widget-side accessor; it reads the active `AppTheme` from `SettingsProvider`, so screens never hard-code colors or text styles — they call `final theme = AppColors.of(context);` and then use `theme.green`, `theme.card`, etc.
- `SettingsProvider.activeTheme` resolves the current theme by `themeId`. If `themeId == 'custom'`, it constructs an `AppTheme` from persisted color ints and derives `backgroundSoft`/`cardLight` by lightening the base colors via HSL. Otherwise it looks up one of the predefined themes in `AppColors.themes`.
- `main.dart` wraps the app in `MultiProvider` and feeds `SettingsProvider` into a `Consumer` that passes `settings.activeTheme.toThemeData()` to `MaterialApp.theme`, making theme changes propagate across the entire tree.

**Predefined themes**
The repo ships five named themes as constants: `ninjaDark` (default), `cyberpunk`, `forest`, `sunset`, `midnight`. Each defines its own palette while keeping the same token surface area.

**Persistence & settings model**
`AppSettings` (in `lib/models/app_settings.dart`) stores `themeId` plus optional `customPrimaryColor`/`customSecondaryColor`/`customBackgroundColor`/`customCardColor` ints, with `copyWith`/`toMap`/`fromMap` for Hive serialization. `SettingsStorageService` persists these values so the chosen theme survives restarts.

**Conventions observed in screens**
- Screens import `../utils/app_colors.dart` and obtain the theme via `AppColors.of(context)`, often caching it in a local variable (`final theme = AppColors.of(context);`) before building large subtrees.
- Text style is still frequently written inline with `TextStyle(fontSize: ..., fontWeight: FontWeight.w900)` rather than through `Theme.textTheme`, but color usage goes exclusively through `theme.<token>`.
- The default `themeId` is `'ninja_dark'`; switching themes happens through `SettingsProvider.updateTheme(themeId, {primary, secondary, background, card})`.

**What is NOT used**
No external CSS-in-Dart libraries (e.g., flutter_styled_widget, rxdart-based theming), no SCSS/Sass, no Tailwind-style utility approach, and no separate design-token JSON files — everything lives in Dart.