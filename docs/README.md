# Assinaturas Ninja 🥷📱

O **Assinaturas Ninja** é um aplicativo móvel de gestão financeira desenvolvido em Flutter, focado no controle offline de assinaturas recorrentes (como streaming, softwares, serviços e mensalidades).

O projeto foi concebido como um aplicativo acadêmico funcional, de código limpo e fácil de apresentar, mantendo a simplicidade operacional, mas entregando uma experiência visual premium no modo escuro.

---

## 🚀 Stack Tecnológica

O projeto foi construído utilizando as seguintes tecnologias e pacotes fundamentais do ecossistema Flutter:

- **Framework**: [Flutter](https://flutter.dev) (SDK `^3.11.0` ou superior) / [Dart](https://dart.dev)
- **Gerenciamento de Estado**: [Provider](https://pub.dev/packages/provider) (`ChangeNotifier`) para controle de estado reativo.
- **Persistência Local**: [Hive](https://pub.dev/packages/hive) para banco NoSQL de chave-valor local extremamente rápido.
- **Formatação**: [intl](https://pub.dev/packages/intl) para formatação de moedas (R$) e tratamento de localidade.
- **Identificadores**: [uuid](https://pub.dev/packages/uuid) para geração de chaves únicas universais (UUID v4) das assinaturas.

---

## 📂 Estrutura de Pastas

A arquitetura do código-fonte está estruturada de forma lógica e modular sob o diretório `lib/`:

```txt
lib/
├── main.dart                          # Ponto de entrada do app (configuração de Hive, Providers e MaterialApp)
├── models/                            # Classes de domínio e modelos de dados imutáveis
│   ├── subscription.dart              # Representação da assinatura e regras de vencimento
│   └── app_settings.dart              # Configurações do app (onboarding, tema, orçamento)
├── providers/                         # Lógica de negócio e gerenciamento de estado (ChangeNotifiers)
│   ├── subscription_provider.dart     # Regras de CRUD, dashboard, relatórios e filtros de assinaturas
│   └── settings_provider.dart         # Controle de temas, onboarding e perfil de usuário
├── services/                          # Camada de infraestrutura e persistência de dados
│   ├── subscription_storage.dart      # Interface abstrata para armazenamento de assinaturas
│   ├── subscription_storage_service.dart # Implementação concreta via Hive Box
│   ├── settings_storage.dart          # Interface abstrata para armazenamento de configurações
│   └── settings_storage_service.dart  # Implementação concreta via Hive Box
├── utils/                             # Utilitários e helpers de design do sistema
│   ├── app_colors.dart                # Definição e cálculo dinâmico do sistema de temas
│   └── formatters.dart                # Formatação de valores monetários e rótulos de data
├── widgets/                           # Componentes visuais reutilizáveis e isolados
│   ├── brand_mark.dart                # Logotipo Ninja renderizado dinamicamente com CustomPainter
│   ├── category_icon.dart             # Ícone e cor representativa para cada categoria
│   ├── empty_state.dart               # Tela informativa exibida para listas vazias
│   ├── status_chip.dart               # Badge indicador de status da assinatura (Ativa/Pausada/Cancelada)
│   ├── subscription_card.dart         # Card de visualização rápida da assinatura na lista
│   └── summary_card.dart              # Card genérico do dashboard para exibição de métricas
└── screens/                           # Telas completas que compõem o fluxo do aplicativo
    ├── splash_screen.dart             # Tela de carregamento assíncrono inicial
    ├── onboarding_screen.dart         # Introdução, setup de perfil e carga opcional de dados demo
    ├── home_screen.dart               # Shell principal contendo navegação em abas (IndexedStack)
    ├── subscriptions_screen.dart      # Listagem de assinaturas com busca, filtros e ordenação
    ├── subscription_form_screen.dart  # Formulário para criação e edição de assinaturas (CRUD)
    ├── subscription_detail_screen.dart# Detalhamento de assinaturas com ações rápidas de status/exclusão
    ├── reports_screen.dart            # Relatório financeiro, insights e consumo de orçamento
    └── settings_screen.dart           # Painel de ajustes de perfil, reset de dados e troca de temas
```

---

## 🛠️ Como Executar o Projeto

Para executar, testar ou gerar builds do projeto localmente, certifique-se de que o Flutter SDK está configurado em sua máquina e execute os seguintes comandos no terminal:

### 1. Obter dependências do projeto
```bash
flutter pub get
```

### 2. Executar análise estática do código (Linter)
```bash
flutter analyze
```

### 3. Executar a suíte de testes unitários e de widgets
```bash
flutter test
```

### 4. Executar o projeto em modo desenvolvimento (Debug)
```bash
flutter run
```

### 5. Compilar o APK de depuração (Android Debug Build)
```bash
flutter build apk --debug
```
