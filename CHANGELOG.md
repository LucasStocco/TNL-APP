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

## [v-0.3.1] - em desenvolvimento
### Planejado
- Melhorar UX da seleção de listas (busca e destaque)
- Permitir criar lista direto do BottomSheet
- Melhor feedback de erro na adição de itens