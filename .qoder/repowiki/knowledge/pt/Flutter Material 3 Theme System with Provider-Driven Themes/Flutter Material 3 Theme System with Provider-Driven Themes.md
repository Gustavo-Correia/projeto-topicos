---
kind: frontend_style
name: Sistema de Temas Flutter Material 3 com Temas Guiados por Provider
category: frontend_style
scope:
    - '**'
source_files:
    - lib/utils/app_colors.dart
    - lib/providers/settings_provider.dart
    - lib/models/app_settings.dart
    - lib/main.dart
---

O app usa um sistema de estilização Flutter construído sobre Material 3, centrado em uma abstração de tema customizada que é resolvida em tempo de execução via estado Provider.

**Abordagem central**
- `AppTheme` (em `lib/utils/app_colors.dart`) é a fonte única de verdade para todos os tokens visuais: background, card, green/cyan/purple/yellow/red/muted/textPrimary/border. Expõe `toThemeData()` que constrói um `ThemeData` de `MaterialApp` com `useMaterial3: true`, brilho escuro, e padrões consistentes para `appBarTheme`, `cardTheme`, `inputDecorationTheme` e `elevatedButtonTheme`.
- `AppColors.of(context)` é o acessador no lado do widget; lê o `AppTheme` ativo do `SettingsProvider`, então telas nunca fazem hard-code de cores ou estilos de texto — chamam `final theme = AppColors.of(context);` e então usam `theme.green`, `theme.card`, etc.
- `SettingsProvider.activeTheme` resolve o tema atual por `themeId`. Se `themeId == 'custom'`, constrói um `AppTheme` a partir de ints de cores persistidos e deriva `backgroundSoft`/`cardLight` clareando as cores base via HSL. Caso contrário, busca um dos temas predefinidos em `AppColors.themes`.
- `main.dart` envolve o app em `MultiProvider` e alimenta `SettingsProvider` em um `Consumer` que passa `settings.activeTheme.toThemeData()` para `MaterialApp.theme`, fazendo mudanças de tema propagarem por toda a árvore.

**Temas predefinidos**
O repositório inclui cinco temas nomeados como constantes: `ninjaDark` (padrão), `cyberpunk`, `forest`, `sunset`, `midnight`. Cada um define sua própria paleta mantendo a mesma superfície de tokens.

**Persistência e modelo de settings**
`AppSettings` (em `lib/models/app_settings.dart`) armazena `themeId` mais ints opcionais `customPrimaryColor`/`customSecondaryColor`/`customBackgroundColor`/`customCardColor`, com `copyWith`/`toMap`/`fromMap` para serialização Hive. `SettingsStorageService` persiste esses valores para que o tema escolhido sobreviva a reinícios.

**Convenções observadas nas telas**
- Telas importam `../utils/app_colors.dart` e obtêm o tema via `AppColors.of(context)`, frequentemente cacheando em variável local (`final theme = AppColors.of(context);`) antes de construir subárvores grandes.
- Estilo de texto ainda é frequentemente escrito inline com `TextStyle(fontSize: ..., fontWeight: FontWeight.w900)` em vez de através de `Theme.textTheme`, mas uso de cores passa exclusivamente por `theme.<token>`.
- O `themeId` padrão é `'ninja_dark'`; troca de temas acontece através de `SettingsProvider.updateTheme(themeId, {primary, secondary, background, card})`.

**O que NÃO é utilizado**
Sem bibliotecas externas de CSS-in-Dart (ex: flutter_styled_widget, theming baseado em rxdart), sem SCSS/Sass, sem abordagem utilitária estilo Tailwind, e sem arquivos JSON de design-token separados — tudo vive em Dart.
