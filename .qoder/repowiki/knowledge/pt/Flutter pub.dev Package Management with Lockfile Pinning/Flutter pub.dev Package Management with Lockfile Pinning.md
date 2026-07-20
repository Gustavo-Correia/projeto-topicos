---
kind: dependency_management
name: Gerenciamento de Pacotes Flutter pub.dev com Lockfile
category: dependency_management
scope:
    - '**'
source_files:
    - pubspec.yaml
    - pubspec.lock
---

Este monorepo Flutter usa o sistema padrão de gerenciamento de dependências Dart/Flutter centrado em `pubspec.yaml` e um arquivo `pubspec.lock` commitado. Todos os pacotes de terceiros são resolvidos do registro público `https://pub.dev` — sem registros privados, vendoring ou overrides de path local configurados.

**Sistema utilizado**
- **Gerenciador de pacotes**: `pub` (Dart SDK) / `flutter pub` (Flutter SDK).
- **Manifesto**: `pubspec.yaml` na raiz do repositório declara dependências diretas e dev-dependencies.
- **Lockfile**: `pubspec.lock` é commitado no controle de versão, fixando toda dependência transitiva a uma versão exata mais checksum sha256 para builds reproduzíveis.
- **Registro**: Apenas `pub.dev` público; sem `pubspec_overrides.yaml`, `PUB_HOSTED_URL` ou blocos `dependency_overrides` customizados em `pubspec.yaml`.
- **Constraints de SDK**: `environment.sdk: '>=3.11.0 <4.0.0'` restringe o Dart SDK; o lockfile adicionalmente fixa `flutter >=3.38.4`.

**Arquivos chave**
- `pubspec.yaml` — fonte única de verdade para dependências declaradas (`provider`, `hive`, `hive_flutter`, `intl`, `uuid`, `http`, `cupertino_icons`) e ferramentas de dev (`flutter_lints`, `flutter_launcher_icons`).
- `pubspec.lock` — snapshot imutável do grafo completo de dependências (diretas + transitivas), incluindo plugins de plataforma como `path_provider_*` e `jni`/`jni_flutter` puxados transitivamente pelo Hive.
- `android/build.gradle.kts`, `android/settings.gradle.kts`, `ios/Runner.xcodeproj/project.pbxproj` — shells de plataforma dependem do engine Flutter mas não declaram seus próprios manifestos de pacotes; integração de plugins nativos é tratada pelos registrants gerados pelo Flutter.

**Arquitetura e convenções**
- Manifesto de raiz única: todo código Dart vive em `lib/` e depende de um único `pubspec.yaml` compartilhado; não há arquivos `pubspec.yaml` de sub-pacotes, então é efetivamente um projeto plano em vez de um workspace pub multi-pacote.
- Estilo de versionamento: dependências diretas usam ranges caret (`^x.y.z`) permitindo atualizações compatíveis de minor/patch enquanto ainda são fixadas pelo lockfile; constraint de SDK usa range limitado (`>=3.11.0 <4.0.0`).
- Separação dev vs runtime: pacotes de teste e ferramentas de build (`flutter_test`, `flutter_lints`, `flutter_launcher_icons`) são colocados em `dev_dependencies` e nunca incluídos em builds de produção.
- Sem vendoring ou estratégia de cache offline aplicada em nível de repositório; desenvolvedores dependem do cache global pub e do lockfile commitado para determinismo.

**Regras que desenvolvedores devem seguir**
1. Sempre execute `flutter pub get` após puxar mudanças para que o cache local corresponda ao `pubspec.lock` commitado.
2. Ao adicionar uma nova dependência, declare-a em `pubspec.yaml` e commit o `pubspec.lock` atualizado — não edite o lockfile manualmente.
3. Prefira ranges de versão caret (`^`) em `pubspec.yaml` para permitir bumps seguros de patch/minor; dependa de CI para capturar upgrades breaking via `flutter pub upgrade --major-versions`.
4. Mantenha `publish_to: 'none'` pois é uma aplicação, não uma biblioteca destinada a publicação no pub.dev.
5. Não introduza `dependency_overrides` ou `pubspec_overrides.yaml` sem acordo da equipe; eles contornam o lockfile e quebram reprodutibilidade.
