# CHANGELOG

Todas as mudanças importantes deste projeto serão documentadas neste arquivo.

O formato segue versionamento semântico:
- **v-<MAJOR>.<MINOR>.<PATCH>**
  - MAJOR: mudanças incompatíveis
  - MINOR: novas funcionalidades
  - PATCH: correções e melhorias

---

## [v-0.1.0] - 2026-04-26
### Adicionado
- Estrutura inicial do projeto Flutter
- Arquitetura MVVM base
- Integração com Provider
- Modelos iniciais de Categoria, Produto e Lista

---

## [v-0.2.0] - 2026-05-02
### Adicionado
- Listagem de categorias com ícones dinâmicos
- Tela de produtos por categoria
- Navegação entre categorias e produtos
- ViewModel de categorias com carregamento de produtos
- Integração com API de categorias e produtos

### Melhorado
- Mapeamento de ícones de categoria (CategoriaIconMapper)
- Normalização de códigos de categoria

---

## [v-0.3.0] - 2026-05-02
### Adicionado
- Sistema de listas de compras (criar e listar listas)
- BottomSheet de seleção de lista para adicionar produtos
- Fluxo completo: produto → seleção de lista → item criado na lista
- Integração com ItemService (POST /listas/{id}/itens)

### Melhorado
- Feedback visual com SnackBar ao adicionar produto
- Carregamento automático de listas via ListaViewModel
- Consumer para atualização reativa da UI

### Corrigido
- Erro de null safety em `listaId` e `produtoId`
- Payload incompleto ao criar item (preço e quantidade obrigatórios)
- Problema de lista vazia ao abrir seleção (ViewModel não carregado)
- Erro de parsing no ApiResponse quando retorno era null

---

## [v-0.3.1] - em [Unreleased]
### Planejado
- Melhorar UX da seleção de listas (busca e destaque)
- Permitir criar lista direto do BottomSheet
- Melhor feedback de erro na adição de itens

## [v-0.4.0] - 2026-05-02

### Adicionado

* Endpoint `GET /listas/resumo` para retorno de dados agregados
* DTO `ListaResponseResumoDTO` no backend
* Modelo `ListaResumo` no Flutter
* `ListaResumoService` para consumo do endpoint de resumo
* `ListaResumoViewModel` para gerenciamento de estado
* Barra de progresso na tela **Minhas Listas**
* Exibição de porcentagem de conclusão e quantidade de itens

### Melhorado

* Tela **MinhasListasScreen** agora utiliza dados resumidos (sem carregar itens)
* Cálculo de progresso movido do frontend para o backend
* Atualização automática da tela ao retornar da `ListaScreen`
* Contagem de itens otimizada usando queries no banco

### Corrigido

* Progresso incorreto causado por itens deletados
* Listas exibindo 0% mesmo com itens comprados
* Falta de sincronização entre telas após alterações nos itens

### Técnico

* Melhor separação de responsabilidades (DTO específico)
* Redução de carga no frontend
* Base preparada para escalabilidade
