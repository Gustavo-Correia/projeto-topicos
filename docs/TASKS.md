# Diagnóstico Técnico e Oportunidades de Evolução — Assinaturas Ninja 📋🛠️

Este documento descreve o status atual das funcionalidades desenvolvidas no aplicativo **Assinaturas Ninja**, bem como um diagnóstico técnico que detalha melhorias que podem ser aplicadas para aprimorar o desempenho, a segurança de dados e a robustez do software.

---

## 1. Status das Funcionalidades Desenvolvidas

| Funcionalidade | Descrição | Status Atual | Observações |
|---|---|---|---|
| **Onboarding** | Fluxo inicial de boas-vindas com cadastro de nome e orçamento mensal. | ✅ Concluído | Permite pular ou iniciar com dados de teste. |
| **Dashboard** | Resumo financeiro mensal e alerta de vencimentos urgentes. | ✅ Concluído | Atualizado em tempo real pelas mudanças de status. |
| **Lista de Assinaturas** | Listagem geral com barra de pesquisa, filtros e ordenações. | ✅ Concluído | Inclui ordenação por preço, nome, data e relevância. |
| **CRUD de Assinaturas** | Criação, detalhamento, edição e exclusão de assinaturas. | ✅ Concluído | Validações básicas de campos ativas na tela de formulário. |
| **Relatórios e Insights** | Divisão de despesas por categoria e insights automáticos de economia. | ✅ Concluído | Integração visual com barra de progresso do orçamento mensal. |
| **Temas Reativos** | 5 paletas pré-definidas e editor de paleta customizada. | ✅ Concluído | Integração com Hive Box para manter a escolha ativa. |
| **Persistência Offline** | Armazenamento local completo para salvar o estado das assinaturas. | ✅ Concluído | Baseado em caixas do banco NoSQL local Hive. |

---

## 2. Oportunidades de Evolução e Refatorações

Durante a auditoria arquitetural, foram localizados pontos de melhoria que podem ser implementados em sprints futuras, separados por nível de impacto e complexidade:

### 🟡 Baixo Impacto / Fácil Resolução

1. **Declaração de Assets Ausente no `pubspec.yaml`**
   - **Descrição**: O arquivo `assets/branding/app_icon_master.png` existe fisicamente, mas a tag `assets:` no arquivo `pubspec.yaml` não o declara. 
   - **Solução**: Adicionar a chave de listagem no bloco `flutter:` do arquivo `pubspec.yaml` para evitar possíveis erros de empacotamento em runtime caso o ícone seja carregado programaticamente.

2. **Acoplamento de Fallback Estático em `AppColors`**
   - **Descrição**: As constantes estáticas de cores de fallback presentes no final do arquivo `app_colors.dart` duplicam o tema padrão `ninjaDark`.
   - **Solução**: Centralizar o fallback apontando diretamente para o objeto `AppTheme.ninjaDark` pré-existente, eliminando a redundância do código.

3. **Fragilidade na Normalização Ortográfica de `CategoryIcon`**
   - **Descrição**: A remoção manual de acentos (`replaceAll('ú', 'u')`, etc.) é suscetível a erros com novas acentuações.
   - **Solução**: Usar mapeamento de chaves estáticas imutáveis no Model de dados ou adotar um dicionário unificado que associe enums de categoria aos ícones desejados.

---

### 🟠 Médio Impacto / Complexidade Moderada

4. **Tratamento de Exceções na Desserialização do Storage**
    - **Descrição**: O processo de leitura de JSON no `SubscriptionStorageService` e `SettingsStorageService` não possui blocos `try-catch`. Caso o arquivo do Hive seja corrompido, o app quebrará no carregamento inicial da Splash.
   - **Solução**: Implementar capturas de exceção e rotinas de autorrecuperação (como recriar o JSON vazio se a string original for inválida).

5. **Fragilidade no Parser de Preço no Formulário**
   - **Descrição**: A substituição manual de vírgulas e pontos para formatação (`replaceAll('.', '').replaceAll(',', '.')`) falha com entradas contendo múltiplos pontos de milhar.
   - **Solução**: Integrar um formatador monetário nativo ou máscara de input direto no `TextFormField` impedindo digitação de caracteres inválidos.

6. **Desacoplamento de Componentes na `SettingsScreen`**
   - **Descrição**: A tela de ajustes possui 566 linhas de código, contendo diversos subwidgets privados relacionados à paleta de temas customizados.
   - **Solução**: Extrair os componentes `_ThemePreviewCard`, `_CustomColorCircle` e `_ColorPickerRow` para arquivos independentes no diretório `widgets/`.

---

### 🔴 Alto Impacto / Planejamento Estratégico

7. **Limitação de Performance do SharedPreferences para Listas Volumosas [RESOLVIDO]**
   - **Descrição**: A persistência original reescrevia a lista JSON em disco via SharedPreferences a cada alteração, degradando a performance.
   - **Solução**: O aplicativo foi migrado com sucesso para o banco NoSQL local **Hive** (boxes indexados em memória), eliminando as restrições de performance e de bloqueio de I/O síncrono do SharedPreferences.

8. **Ausência de Funcionalidade de Backup (Exportação/Importação)**
   - **Descrição**: Por ser 100% offline, se o usuário trocar de aparelho ou desinstalar o app, todos os dados cadastrados serão perdidos sem possibilidade de recuperação.
   - **Solução**: Criar uma opção no menu de configurações para exportar a base de dados para um arquivo JSON local compartilhável e importá-lo posteriormente.

9. **Lacunas na Cobertura de Testes Visuais e Integrados**
   - **Descrição**: A suíte de testes de UI do app cobre apenas widgets fundamentais isolados (`EmptyState`, `StatusChip`). Não há testes de integração cobrindo fluxos de ponta a ponta (como criar uma assinatura e ver o dashboard recalcular o total).
   - **Solução**: Escrever testes integrados utilizando `integration_test` ou aplicar Golden Tests para garantir a integridade do design em alterações futuras de código.
