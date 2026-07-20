---
kind: build_system
name: Build e Gerenciamento de Artefatos do Monorepo Flutter
category: build_system
scope:
    - '**'
source_files:
    - pubspec.yaml
    - analysis_options.yaml
    - android/build.gradle.kts
    - android/app/build.gradle.kts
    - android/local.properties
    - ios/Flutter/Generated.xcconfig
---

Este repositório é um projeto Flutter único (não um monorepo multi-app) que reúne fonte Dart, shells de plataforma Android/iOS, testes e documentação sob um build guiado por um único pubspec.yaml. Não há Makefiles customizados, scripts shell, Dockerfiles ou pipelines de CI commitados no repositório; o sistema de build depende inteiramente do toolchain padrão do Flutter mais as ferramentas de build nativas de cada plataforma.

Sistema/abordagem utilizada:
- Dart/Flutter SDK para resolução de dependências, análise, testes (flutter test) e builds multiplataforma (flutter run, flutter build apk|aab|ios|ipa).
- Android Gradle Plugin com Kotlin DSL via dev.flutter.flutter-gradle-plugin.
- Xcode/CocoaPods para iOS, guiado por arquivos .xcconfig gerados pelo flutter create.
- Linting através de analysis_options.yaml incluindo package:flutter_lints/flutter.yaml.
- Geração de ícones via flutter_launcher_icons configurado em pubspec.yaml.

Arquivos e pacotes chave:
- pubspec.yaml: nome do pacote, versão (1.0.0+1), constraint de SDK (>=3.11.0 <4.0.0), dependências, dev dependencies, config do gerador de ícones e declarações de assets Flutter.
- analysis_options.yaml: regras de linter derivadas do Flutter lints com overrides específicos do projeto.
- android/build.gradle.kts: script Gradle raiz centralizando repositórios, redirecionando todos os outputs de build para build/ compartilhado, e registrando task clean.
- android/app/build.gradle.kts: aplica com.android.application e dev.flutter.flutter-gradle-plugin, define compile/target Java/Kotlin 17, obtém compileSdk/minSdk/targetSdk/versionCode/versionName do Flutter, e aponta flutter { source = "../.." } de volta à raiz Dart.
- android/local.properties: caminhos locais do desenvolvedor para sdk.dir e flutter.sdk, mais flutter.buildMode, flutter.versionName, flutter.versionCode.
- ios/Flutter/Generated.xcconfig: config Xcode gerada apontando para FLUTTER_ROOT, FLUTTER_APPLICATION_PATH, arquivo target, diretório de build e nome/número de build.
- ios/Runner.xcodeproj e ios/Runner/: projeto Xcode, entry points Swift, storyboards, assets e Info.plist consumidos pelo xcodebuild.

Arquitetura e convenções:
- Fonte única de verdade para versionamento: pubspec.yaml declara version: 1.0.0+1; Android lê através de flutter.versionCode/flutter.versionName, e iOS espelha em Generated.xcconfig (FLUTTER_BUILD_NAME=1.0.0, FLUTTER_BUILD_NUMBER=1). O local.properties local atualmente fixa esses valores por desenvolvedor.
- Árvore de output de build compartilhada: o diretório build/ raiz agrega artefatos de ambos subprojetos Android e do engine Flutter, mantendo binários gerados fora do controle de versão (.gitignore exclui /android/app/release).
- Sem assinatura configurada para release ainda: android/app/build.gradle.kts deixa release.signingConfig apontando para debug, com comentário TODO indicando que configuração real de keystore está pendente.
- Assets são referenciados diretamente por path em flutter_launcher_icons mas não estão listados sob flutter.assets: em pubspec.yaml; isso funciona para geração de ícones mas pode causar falhas de carregamento em runtime se código tentar carregar a imagem como asset empacotado.

Regras que desenvolvedores devem seguir:
- Mantenha pubspec.yaml como local canônico para versão do app e atualizações de dependências; não edite android/local.properties ou ios/Flutter/Generated.xcconfig manualmente — são regenerados pelo Flutter.
- Ao adicionar imagens/fontes, declare-os sob flutter.assets: em pubspec.yaml para que sejam incluídos no bundle do app (o atual app_icon_master.png é consumido apenas pelo gerador de ícones).
- Para releases Android, substitua o stub de assinatura debug em android/app/build.gradle.kts por um bloco signingConfigs apropriado referenciando uma keystore antes de buildar flutter build apk --release ou flutter build appbundle --release.
- Mudanças de lint devem passar em flutter analyze; o projeto aplica prefer_const_constructors, prefer_const_literals_to_create_immutables e avoid_print.
- Testes ficam em test/ e são executados via flutter test; não há harness de teste separado ou etapa de CI commitada no repositório.
