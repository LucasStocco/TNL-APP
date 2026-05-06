# 🤝 Contributing — TNL App

Este documento define os padrões obrigatórios para contribuição no projeto **TNL - Lista de Compras**.

> ⚠️ Todas as contribuições devem seguir este guia.

---

## 📚 Sumário

* [🧠 Conceitos Importantes](#-conceitos-importantes)
* [🏷️ Identificação dos ICs](#️-identificação-dos-ics)
* [🔢 Versionamento](#-versionamento-configuração-base)
* [🔄 Controle de Mudanças](#-controle-de-mudanças)
* [🌿 Workflow de Branches](#-workflow-de-branches)
* [🏷️ Nomeação de Branches](#️-nomeação-de-branches)
* [🔗 Integração Issue + Branch](#-integração-issue--branch)
* [📝 Padrão de Commits](#-padrão-de-commits)
* [📋 Responsabilidades](#-responsabilidades)
* [✅ Checklist de Pull Request](#-checklist-de-pull-request)
* [🚨 Regras Gerais](#-regras-gerais)
* [🎯 Objetivo](#-objetivo)
* [💡 Resumo](#-resumo)

---

## 🧠 Conceitos Importantes

### 📦 Item de Configuração (IC)

Qualquer artefato que precisa ser controlado e versionado.

**Exemplos:**

* Código fonte
* Documentos
* Diagramas
* Configurações

➡️ Todo IC deve ser **identificável e rastreável ao longo do tempo**

---

### 🧱 Configuração Base (CB)

Conjunto de itens de configuração que representam um estado estável do sistema em um momento específico.

---

## 🏷️ Identificação dos ICs

Todos os artefatos (exceto código) devem seguir o padrão:

```text
<SIGLA_PROJETO> - <NOME_DO_ARTEFATO>
```

**Exemplos:**

```text
TNL - Visão
TNL - Arquitetura
TNL - Requisitos
```

---

## 🔢 Versionamento (Configuração Base)

Seguimos versionamento semântico:

```text
v-<MAJOR>.<MINOR>.<PATCH>
```

### Onde:

* **MAJOR** → mudanças grandes (breaking change)
* **MINOR** → novas funcionalidades
* **PATCH** → correções e melhorias

**Exemplos:**

```text
v-1.0.0
v-1.2.0
v-2.0.0
```

---

## 🔄 Controle de Mudanças

### 📌 Regra Principal

> Toda mudança no sistema deve começar por uma **Issue no GitHub**

---

## 🌿 Workflow de Branches

### Estrutura do projeto:

```text
main (produção)
  ↑
release
  ↑
develop
  ↑
feature / hotfix
```

### Tipos de branches:

| Tipo    | Uso                       |
| ------- | ------------------------- |
| main    | Produção                  |
| develop | Integração de features    |
| feature | Novas funcionalidades     |
| hotfix  | Correção de bugs críticos |
| release | Preparação para produção  |

---

## 🏷️ Nomeação de Branches

Padrão obrigatório:

```text
<numero-da-issue>-<tipo>-descricao
```

**Exemplos:**

```text
16-feature-home-carousel
25-feature-editar-item
30-hotfix-login-error
```

---

## 🔗 Integração Issue + Branch

### Fluxo obrigatório:

```text
Issue → Branch → Commit → Pull Request → Merge
```

### Exemplo real:

```bash
# criar branch
git checkout -b 16-feature-home-carousel

# commit
git commit -m "feat(home): implement carousel #16"

# PR
Closes #16
```

---

## 📝 Padrão de Commits

Seguimos padrão semântico:

```text
<tipo>(escopo): descrição
```

### Tipos:

* feat → nova funcionalidade
* fix → correção de bug
* refactor → melhoria interna
* docs → documentação
* style → ajustes visuais
* test → testes

### Exemplos:

```bash
feat(home): implement carousel
fix(login): corrige erro de autenticação
docs(readme): adiciona guia de GC
refactor(item): melhora lógica de cálculo
```

---

## 📋 Responsabilidades

* Cada issue deve ter um responsável (**Assignee**)
* Cada branch deve estar vinculada a uma issue
* Todo código deve passar por Pull Request
* Revisão é obrigatória antes do merge

---

## ✅ Checklist de Pull Request

Antes de abrir PR:

* [ ] Issue vinculada
* [ ] Branch nomeada corretamente
* [ ] Código testado
* [ ] Sem erros visuais
* [ ] Seguindo padrão de commit
* [ ] Código revisado

---

## 🚨 Regras Gerais

### ❌ Proibido:

* Commits diretos na `main`
* Criar branch sem issue
* Código sem rastreabilidade

### ✅ Obrigatório:

* Usar padrão de nome
* Linkar commit com issue
* Criar PR para alterações
* Revisar antes de merge

---

## 🎯 Objetivo

Garantir:

* Organização do projeto
* Rastreabilidade de mudanças
* Redução de conflitos
* Qualidade do código
* Escalabilidade do sistema

---

## 💡 Resumo

```text
Tudo começa em uma ISSUE
Tudo vira uma BRANCH
Tudo passa por um PR
Tudo termina em um MERGE
```

---

## 🚀 Fluxo Visual

```text
[ ISSUE ]
     ↓
[ BRANCH ]
     ↓
[ COMMITS ]
     ↓
[ PULL REQUEST ]
     ↓
[ CODE REVIEW ]
     ↓
[ MERGE → DEVELOP → MAIN ]
```

---

> 📌 Seguir este padrão é obrigatório para manter a consistência, organização e qualidade do projeto.
