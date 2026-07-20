# Assinaturas Ninja

Aplicativo Flutter para controle financeiro de assinaturas recorrentes, com arquitetura em camadas, injeção de dependências e consumo de API REST externa.

## Sobre o App

O **Assinaturas Ninja** ajuda o usuário a cadastrar serviços recorrentes, acompanhar vencimentos, visualizar gastos ativos e identificar oportunidades de economia.

O primeiro acesso apresenta uma configuração inicial simples: o usuário pode começar com a lista vazia ou carregar dados de demonstração voluntariamente.

## Funcionalidades

- Boas-vindas com nome e meta mensal opcionais.
- Dashboard financeiro com próximas cobranças e taxa de câmbio USD→BRL (via API).
- Cadastro, edição, exclusão e detalhes de assinaturas.
- Busca, filtros, ordenação e alteração rápida de status.
- Relatórios por categoria e insights financeiros.
- Ajustes e gerenciamento local dos dados.
- Persistência offline com Hive.
- Tema escuro com 5 temas predefinidos + tema customizado.
- Navegação por rotas nomeadas e tabs.
- Identidade visual própria para Android.

## Tecnologias

- Flutter / Dart
- Provider (gerenciamento de estado)
- Hive (persistência local)
- http (consumo de API REST — AwesomeAPI)
- intl (formatação pt_BR)
- uuid (identificadores únicos)

## Arquitetura

O projeto segue arquitetura em camadas com injeção de dependências:

```txt
telas → providers → services → models/utils
```

- **ServiceLocator** (`lib/services/service_locator.dart`): conecta interfaces abstratas às implementações concretas.
- **Rotas nomeadas** (`lib/routes.dart`): `onGenerateRoute` centraliza toda a navegação.
- **API REST** (`lib/services/currency_api_service.dart`): busca cotação USD→BRL com fallback gracioso offline.

## Como Rodar

```bash
flutter pub get
flutter run
```

## Validação

```bash
flutter analyze
flutter test
flutter build apk --debug
```

O APK debug é gerado em:

```txt
build/app/outputs/flutter-apk/app-debug.apk
```

## Estrutura

```txt
lib/
  main.dart
  routes.dart
  models/
  providers/
  screens/
  services/
  utils/
  widgets/
test/
docs/
```

## Documentação

O índice completo está em [docs/README.md](docs/README.md).

Knowledge cards do projeto disponíveis em inglês e português em `.qoder/repowiki/knowledge/`.

## Regras Centrais

- Apenas assinaturas ativas entram nos totais e relatórios financeiros.
- Vencimentos nos próximos 5 dias recebem destaque.
- O valor deve ser maior que zero e o dia de vencimento deve ficar entre 1 e 31.
- Dados demonstrativos nunca são inseridos automaticamente.
- O app funciona 100% offline; a chamada à API é opcional e degrada silenciosamente.
