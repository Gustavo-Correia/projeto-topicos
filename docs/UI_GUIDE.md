# Guia de Interface (UI) e Experiência (UX) — Assinaturas Ninja 🎨✨

Este guia documenta os princípios visuais, a identidade da marca, os sistemas de cores, temas e os componentes personalizados construídos para o aplicativo **Assinaturas Ninja**.

---

## 1. Identidade e Filosofia Visual

O aplicativo utiliza uma identidade **Dark-First** (priorizando o modo escuro) inspirada na temática do sigilo e agilidade associada aos "Ninjas". A escolha do design escuro traz os seguintes benefícios:
- **Estética Premium**: Contrastes elevados com elementos coloridos vibrantes.
- **Redução do Cansaço Visual**: Confortável para consulta e edição rápida de dados financeiros.
- **Conexão com a Marca**: O logotipo do aplicativo é desenhado programaticamente por meio de um `CustomPainter` representando a máscara de um guerreiro Ninja.

---

## 2. Sistema de Cores e Temas

O aplicativo implementa um sistema de temas inovador e dinâmico, baseado na classe abstrata [AppTheme](file:///c:/Users/202200007717/Desktop/ASSINATURAS%20NINJA/lib/utils/app_colors.dart) que mapeia 14 slots de cores estruturais.

### 2.1 Paletas Pré-definidas

Existem **5 opções de temas** pré-configurados que transformam radicalmente a paleta do aplicativo:

| Tema | ID | Fundo Principal | Cor de Destaque | Conceito |
|---|---|---|---|---|
| **Ninja Dark** | `ninjaDark` | `#0D0E12` | `#39FF14` (Neon Green) | Padrão sigiloso, alta tecnologia e contraste. |
| **Cyberpunk** | `cyberpunk` | `#0B001A` | `#FF007F` (Neon Pink) | Cores neon brilhantes inspiradas em luzes de neon urbanas. |
| **Eco Floresta** | `forest` | `#0B130E` | `#2ECC71` (Emerald Green) | Paleta suave de tons orgânicos e cores terrestres. |
| **Pôr do Sol** | `sunset` | `#1A0F0F` | `#E67E22` (Sunset Orange) | Tons quentes remetendo à transição do entardecer. |
| **Midnight Blue**| `midnight` | `#080F1A` | `#00D2FF` (Cyan) | Tons azulados escuros simulando a profundidade da noite. |

### 2.2 Temas Customizados e Derivação HSL
Além dos temas embutidos, o usuário pode montar um **Tema Personalizado**. Ele escolhe quatro cores primordiais usando swatches circulares na tela de ajustes:
1. Cor de Fundo (`background`)
2. Cor do Card (`card`)
3. Cor Primária (`primary`)
4. Cor Secundária (`secondary`)

A partir dessas escolhas, o sistema calcula dinamicamente as **cores de apoio** (como `backgroundSoft`, `cardLight` e `border`) usando o modelo **HSL (Hue, Saturation, Lightness)**. Por exemplo, a cor de borda é gerada clareando a cor do card em 5%, garantindo consistência visual e harmonia cromática em qualquer combinação selecionada.

---

## 3. Componentes Visuais Reutilizáveis (UI Components)

A coerência visual do app é mantida através de componentes que encapsulam elementos gráficos recorrentes:

### 3.1 [BrandMark](file:///c:/Users/202200007717/Desktop/ASSINATURAS%20NINJA/lib/widgets/brand_mark.dart) — Logotipo Programático
O logotipo da marca é gerado inteiramente por meio de um `CustomPainter` chamado `NinjaMaskPainter`. Ele desenha vetorialmente as curvas e os recortes da máscara ninja e seus olhos brilhantes com gradiente, eliminando a dependência de arquivos PNG ou SVG.

### 3.2 [CategoryIcon](file:///c:/Users/202200007717/Desktop/ASSINATURAS%20NINJA/lib/widgets/category_icon.dart) — Mapeamento Semântico
Associa cada categoria de assinatura a um ícone da biblioteca do Flutter e a uma cor de destaque correspondente.
- **Normalização Textual**: Para evitar erros causados por acentos ou caixas diferentes (ex: "Saúde", "saude", "SAÚDE"), a classe normaliza a string removendo acentuações e convertendo tudo para letras minúsculas antes de decidir qual ícone renderizar.

### 3.3 [SubscriptionCard](file:///c:/Users/202200007717/Desktop/ASSINATURAS%20NINJA/lib/widgets/subscription_card.dart) — Card da Assinatura
Utilizado para listar os serviços ativos ou inativos nas listagens e pesquisas.
- **Vencimento Crítico**: Se o vencimento ocorrer no dia atual (`isDueToday`), o card exibe uma **borda vermelha forte de destaque**, alertando o usuário sobre o débito iminente.
- **Menu Rápido**: Incorpora um menu do tipo popup que permite pausar, reativar ou excluir a assinatura diretamente da lista, sem a necessidade de abrir a tela de detalhes.

### 3.4 [SummaryCard](file:///c:/Users/202200007717/Desktop/ASSINATURAS%20NINJA/lib/widgets/summary_card.dart) — Métrica Consolidada
Painel utilizado no topo da dashboard principal para evidenciar indicadores chave de performance (KPIs), como a contagem de assinaturas ativas, o valor da fatura de maior preço e a contagem de pagamentos agendados para a próxima semana.
