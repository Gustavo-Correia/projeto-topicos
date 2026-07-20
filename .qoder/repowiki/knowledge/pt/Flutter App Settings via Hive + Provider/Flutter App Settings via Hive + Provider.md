---
kind: configuration_system
name: Configurações do App Flutter via Hive + Provider
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

O repositório não possui um sistema de configuração centralizado em tempo de execução (sem .env, diretório config/, carregador de feature-flag ou gerador de config em tempo de build). Em vez disso, as configurações do app voltadas ao usuário são persistidas localmente com Hive e expostas através de um Provider. A única configuração em tempo de compilação/build fica em pubspec.yaml (constraints de SDK, dependências, ícones do Flutter launcher) e nos manifests de plataforma Android/iOS.

### O que é utilizado
- **Hive** (hive + hive_flutter) como armazenamento local chave-valor para configurações do usuário.
- **Provider** (ChangeNotifierProvider) para expor o estado de settings à árvore de widgets.
- Modelos Dart simples com serialização toMap/fromMap — sem biblioteca de schema JSON ou codegen.
- Manifests de plataforma (android/app/src/main/AndroidManifest.xml, ios/Runner/Info.plist) para metadados em nível nativo; sem overrides dinâmicos em tempo de execução.

### Arquivos e pacotes chave
- lib/models/app_settings.dart — modelo imutável de settings (onboardingCompleted, userName, monthlyBudget, themeId, cores customizadas de tema) com copyWith, toMap, fromMap.
- lib/services/settings_storage.dart — interface abstrata SettingsStorage.
- lib/services/settings_storage_service.dart — implementação com Hive usando box settings_box e chave app_settings.
- lib/providers/settings_provider.dart — ChangeNotifier que carrega/salva AppSettings, deriva o AppTheme ativo e expõe updateTheme, completeOnboarding, updateSettings, resetOnboarding.
- lib/utils/app_colors.dart — constantes AppTheme predefinidas mais acessador AppColors.of(context); activeTheme mapeia themeId para um ThemeData.
- lib/main.dart — inicializa boxes Hive, define Intl.defaultLocale = pt_BR, conecta Providers e constrói MaterialApp a partir de SettingsProvider.activeTheme.
- pubspec.yaml — constraints de SDK/ambiente, versões de dependências, seções flutter_launcher_icons e flutter: assets.
- android/app/src/main/AndroidManifest.xml — label do app, permissões, configChanges; android/app/build.gradle.kts contém padrões de assinatura/debug.
- ios/Runner/Info.plist — metadados de bundle iOS.

### Arquitetura e convenções
1. Fonte única de verdade: AppSettings é a forma canônica; toda UI lê através de SettingsProvider.
2. Abstração da camada de persistência: SettingsStorage permite que testes injetem uma implementação fake de storage (ver test/settings_provider_test.dart).
3. Tema como configuração: a preferência do usuário para theming é armazenada como string themeId mais ints opcionais de cores customizadas; SettingsProvider.activeTheme resolve o AppTheme final em tempo de execução.
4. Ordem de inicialização: main() inicializa Hive, abre ambas subscriptions_box e settings_box, então executa o app para que providers possam carregar settings sincronamente no primeiro build.
5. Sem ramificação de ambiente: não há separação de config debug/release/staging; diferenças de comportamento teriam que ser controladas por flags em tempo de execução dentro de AppSettings.

### Regras que desenvolvedores devem seguir
- Adicione novas preferências de usuário estendendo AppSettings (com padrões sensatos), atualizando copyWith/toMap/fromMap e persistindo através de SettingsStorage.saveSettings.
- Nunca leia Hive diretamente fora de SettingsStorageService; passe por SettingsProvider para que a UI permaneça reativa.
- Mantenha valores específicos de plataforma fora do código Dart — coloque-os em AndroidManifest.xml, Info.plist ou pubspec.yaml.
- Não introduza arquivos .env ou package:dotenv; este projeto não os utiliza e não estão conectados ao build.
- Para testabilidade, injete um SettingsStorage mock no SettingsProvider em vez de stubar o estado global do Hive.
