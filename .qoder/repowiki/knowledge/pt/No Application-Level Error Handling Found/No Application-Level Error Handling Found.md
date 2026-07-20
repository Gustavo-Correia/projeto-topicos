---
kind: error_handling
name: Nenhum Tratamento de Erro em Nível de Aplicação Encontrado
category: error_handling
scope:
    - '**'
---

Após buscar no repositório, nenhum arquivo fonte Dart foi encontrado no diretório `lib/` apesar de estar listado como módulo de nível superior. O único tratamento de erro presente está em código de plataforma auto-gerado (`GeneratedPluginRegistrant.java` e `GeneratedPluginRegistrant.m`) que usa try/catch básico ao redor do registro de plugins — isso é boilerplate do tooling Flutter, não lógica de aplicação. Não há classes de exceção customizadas, erros sentinela, tipos de erro, middleware ou padrões estruturados de propagação de erro em nenhum lugar do codebase. Isso significa que ou os arquivos fonte Dart estão ausentes deste snapshot de branch, ou o projeto ainda não implementou nenhum tratamento de erro em nível de aplicação além do comportamento padrão do Flutter.
