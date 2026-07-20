# Assinaturas Ninja 🥷📱

Aplicativo Flutter moderno para controle financeiro e planejamento de assinaturas recorrentes, com arquitetura desacoplada baseada em Clean Architecture, gerenciamento de estado via Provider, injeção de dependências (Service Locator) e consumo de APIs REST externas brasileiras.

---

## 🚀 Sobre o App

O **Assinaturas Ninja** ajuda os usuários a gerenciar serviços por assinatura, monitorar datas de vencimento com alertas de proximidade, visualizar o impacto financeiro no orçamento mensal/anual e identificar oportunidades reais de investimento. 

O app é projetado sob a premissa **offline-first**: funciona perfeitamente sem conexão de rede, utilizando armazenamento local estruturado e seguro.

---

## 🎨 Funcionalidades

- **Onboarding Personalizado:** Tela inicial opcional para informar o nome e estabelecer uma meta de orçamento mensal limite. O usuário escolhe entre começar com uma base vazia ou carregar dados demonstrativos.
- **Dashboard Financeiro Integrado:**
  - Exibição de gastos ativos com conversão opcional em Dólar (USD).
  - Alerta visual para assinaturas que vencem nos próximos 5 dias.
  - Painel de Simulação de Economia: Calcula o rendimento em 12 meses caso os gastos das assinaturas fossem aplicados no Tesouro Selic.
- **Gerenciamento de Assinaturas (CRUD completo):**
  - Cadastro, visualização de detalhes, edição de dados e exclusão de assinaturas.
  - Pausa/reativação rápida de assinaturas com recálculo instantâneo no orçamento.
  - Busca integrada por nome, ordenação por valor e filtros por status (Todas, Ativas, Pausadas, Canceladas).
- **Relatórios Visuais:**
  - Distribuição percentual de gastos acumulados por categorias.
  - Barra de progresso do orçamento mensal (limite de gastos).
  - Insights de gastos mais caros e vencimentos imediatos.
- **Ajustes e Temas Customizáveis:**
  - Troca da moeda base (BRL/USD).
  - 5 presets de temas escuros refinados (*Ninja Dark*, *Cyberpunk*, *Forest*, *Sunset*, *Midnight*).
  - Possibilidade de configurar cores personalizadas de fundo, cartões e cores primárias/secundárias em tempo de execução.

---

## 🛠️ Tecnologias e Dependências

- **Flutter / Dart SDK:** Framework multiplataforma.
- **Provider:** Gerenciador de estado reativo e injeção do ciclo de vida dos controladores.
- **Hive & Hive Flutter:** Armazenamento local leve chave-valor persistido como JSON.
- **http:** Cliente REST para consumo de serviços externos.
- **intl:** Internacionalização e formatação de moedas (`pt_BR`) e datas.
- **uuid:** Geração de IDs únicos para as assinaturas criadas.

---

## 📐 Estrutura do Projeto e Arquitetura

O código-fonte está estruturado de forma modular orientada a funcionalidades (**Feature-First**):

```txt
lib/
  main.dart             # Inicialização do app, Hive e Providers
  routes.dart           # Roteamento centralizado por rotas nomeadas
  core/                 # Recursos e widgets compartilhados globalmente
    di/                 # Injeção de dependências (ServiceLocator)
    theme/              # Cores, espaçamentos e tipografias globais
    utils/              # Helpers e formatadores genéricos
    widgets/            # Componentes visuais globais (AppCard, status_chip, etc.)
  features/             # Funcionalidades de negócio isoladas
    onboarding/         # Fluxo de boas-vindas e Splash Screen
    dashboard/          # Aba principal com resumos e economia Selic
    subscriptions/      # Lista, CRUD e detalhes de assinaturas + relatórios
    settings/           # Ajustes do perfil, moedas e temas dinâmicos
test/                   # Testes unitários de regras, widgets e integração (espelhando a lib)
docs/                   # Documentação detalhada da arquitetura do projeto
```

### Decisões de Design Principais:
1. **Service Locator:** O contêiner estático `ServiceLocator` gerencia o acoplamento, conectando as interfaces abstratas de persistência às implementações concretas do Hive.
2. **Resiliência e Recuperação:** As rotinas de carregamento de dados possuem tratamento de exceção (`try-catch`) que limpa e autorrecupera a base de dados de forma silenciosa para o estado padrão caso o JSON seja corrompido, evitando quebras na Splash Screen.
3. **APIs REST Integradas:** 
   - **AwesomeAPI** (`https://economia.awesomeapi.com.br/json/last/USD-BRL`) para cotação em tempo real.
   - **Banco Central do Brasil** (SGS Série 432 - Selic anualizada) para a simulação financeira de economia.
   - Ambas possuem timeout estrito de 5 segundos e degradação graciosa (funcionamento offline).

---

## 📖 Documentação Detalhada

A documentação detalhada e centralizada da arquitetura pode ser acessada em:
- 📑 **[arquitetura.md](docs/arquitetura.md):** Manual completo contendo padrões de design MVC/MVP, fluxo de dados reativo, detalhamento das APIs REST e modelo de injeção de dependências.

---

## 🏃 Como Executar

1. Baixe as dependências:
   ```bash
   flutter pub get
   ```
2. Execute a aplicação (garanta que um emulador ou dispositivo esteja conectado):
   ```bash
   flutter run
   ```

---

## 🧪 Validação e Testes

Para garantir a integridade do código antes do deploy, execute os comandos:

```bash
flutter analyze  # Análise estática do Dart
flutter test     # Execução de testes de unidade e widgets
```
