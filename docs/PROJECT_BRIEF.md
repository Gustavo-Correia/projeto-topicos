# Briefing do Projeto — Assinaturas Ninja 📋

Este documento descreve os objetivos, o escopo, as restrições e as regras de negócio acordadas para o desenvolvimento do aplicativo **Assinaturas Ninja**. Ele serve como guia conceitual para alinhar o que o sistema se propõe a fazer e, mais importante, o que ele **não** deve fazer.

---

## 🎯 Objetivos do Projeto

O **Assinaturas Ninja** é um projeto de caráter acadêmico que visa entregar um gerenciador de assinaturas recorrentes com as seguintes premissas:
1. **Funcional e Apresentável**: O sistema deve possuir uma interface bonita, coesa e moderna (modo escuro em primeiro lugar), facilitando demonstrações e apresentações.
2. **Código Limpo e Explicável**: A arquitetura do código deve ser didática, demonstrando boas práticas de separação de conceitos no Flutter (camadas de modelo, regras de negócio e visual).
3. **Persistência Local Simplificada**: Armazenamento offline que preserve o estado do aplicativo mesmo após o reinício, sem introduzir complexidade de servidores.

---

## 🛑 Limites e Restrições do Escopo

Para garantir a simplicidade e a viabilidade do projeto acadêmico, foram estabelecidas as seguintes restrições:

- **100% Offline**: O aplicativo não possui integração com nenhum serviço em nuvem. Não há backend, autenticação via Firebase, APIs de rede ou sincronização de banco de dados externo.
- **Sem Integração Financeira Real**: Não são realizadas integrações bancárias (Open Finance), varredura de SMS/e-mails, geração de boletos ou cobranças via Pix/Cartão de Crédito. Todo o controle é preenchido manualmente pelo usuário.
- **Notificações Simples/Locais**: Caso haja lembretes de vencimento, estes devem ser meramente visuais dentro do app (alertas de tela), sem agendamento complexo de push notifications nativas via servidores externos.
- **Dados Iniciais Limpos**: O aplicativo deve iniciar completamente vazio no primeiro uso (sem dados demonstrativos automáticos), exigindo uma ação explícita do usuário para carregar exemplos.

---

## 💼 Regras de Negócio Fundamentais

Todas as funcionalidades do aplicativo obedecem estritamente às regras de cálculo e validação descritas abaixo:

### 1. Cálculos de Dashboard e Totais
- **Apenas assinaturas com status `Ativa` (`active`)** entram nos cálculos de:
  - Total mensal gasto.
  - Total anual gasto (calculado como `Total Mensal * 12`).
  - Identificação da assinatura "Mais Cara".
  - Mapeamento das categorias com maior consumo financeiro.
- Assinaturas com status `Pausada` (`paused`) ou `Cancelada` (`canceled`) são preservadas no banco de dados, mas **são excluídas de todos os somatórios ativos**.

### 2. Prazos e Vencimentos
- **Cobrança Vencendo Hoje**: Recebe destaque visual forte (ex: borda vermelha no card e exibição em banner de aviso no topo da tela) se o dia atual do calendário corresponder ao dia de vencimento cadastrado.
- **Cobrança Próxima**: Considera-se "Vencimento próximo" se a próxima cobrança estiver agendada para ocorrer em **até 5 dias** a partir da data atual.
- **Meses Curtos (Tratamento de Dia 31)**: Se uma assinatura estiver configurada para o dia 29, 30 ou 31, e o mês atual não contiver esse dia (ex: fevereiro), a data de vencimento correspondente é clampada para o último dia válido daquele mês (ex: 28 ou 29 de fevereiro).

### 3. Validações de Formulário (CRUD)
- **Valor da Assinatura**: Deve ser obrigatoriamente **maior que zero**. Valores negativos ou zerados devem ser rejeitados pelo formulário de cadastro/edição.
- **Dia de Vencimento**: Deve ser um número inteiro no intervalo **entre 1 e 31**.
- **Nome do Serviço**: Campo obrigatório que deve conter um texto identificador válido.

### 4. Gestão de Dados e Demonstração
- **Carga de Dados Demo**: A inclusão de dados fictícios para fins de testes/apresentação só ocorre após o usuário selecionar explicitamente essa opção (na tela de Onboarding ou no menu de Configurações).
- **Reset de Dados**: O aplicativo deve fornecer uma opção nas configurações para limpar completamente a base de dados (onboarding e assinaturas), retornando o app ao seu estado de instalação original.
