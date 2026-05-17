import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/gerenciar_lista/item.dart';
import '../../view_model/gerenciar_lista/item_view_model.dart';
import '../../view_model/cadastrar_produto/produto_view_model.dart';
import '../../view_model/cadastrar_categoria/categoria_view_model.dart';
import '../../shared/widgets/buttons/submit_button.dart';

class CriarItemScreen extends StatefulWidget {
  final int listaId;
  final Item? item;

  const CriarItemScreen({
    super.key,
    required this.listaId,
    this.item,
  });

  @override
  State<CriarItemScreen> createState() => _CriarItemScreenState();
}

class _CriarItemScreenState extends State<CriarItemScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers (melhor controle)
  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _quantidadeController = TextEditingController(text: '1');

  int? idCategoria;

  bool get isEditMode => widget.item != null;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CategoriaViewModel>().listar();
    });

    if (widget.item != null) {
      _quantidadeController.text = widget.item!.quantidade.toString();
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final produtoVM = context.read<ProdutoViewModel>();
    final itemVM = context.read<ItemViewModel>();

    final nome = _nomeController.text.trim();
    final preco = double.tryParse(_precoController.text) ?? 0;
    final descricao = _descricaoController.text.trim();
    final quantidade = int.tryParse(_quantidadeController.text) ?? 1;

    if (idCategoria == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione uma categoria")),
      );
      return;
    }

    final produto = await produtoVM.criar(
      nome: nome,
      preco: preco,
      idCategoria: idCategoria!,
      descricao: descricao,
    );

    if (produto == null || produto.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao criar produto")),
      );
      return;
    }

    await itemVM.criar(
      listaId: widget.listaId,
      idProduto: produto.id!,
      quantidade: quantidade,
      preco: produto.preco!,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final itemVM = context.watch<ItemViewModel>();
    final categoriaVM = context.watch<CategoriaViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Editar Item' : 'Adicionar Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ================= NOME =================
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome do produto"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o nome" : null,
              ),

              const SizedBox(height: 16),

              // ================= PREÇO =================
              TextFormField(
                controller: _precoController,
                decoration: const InputDecoration(labelText: "Preço"),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final valor = double.tryParse(v ?? '');
                  if (valor == null || valor <= 0) {
                    return "Preço inválido";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ================= CATEGORIA =================
              DropdownButtonFormField<int>(
                value: idCategoria,
                items: categoriaVM.categorias.map((c) {
                  return DropdownMenuItem(
                    value: c.id,
                    child: Text(c.nome),
                  );
                }).toList(),
                onChanged: (v) => setState(() => idCategoria = v),
                decoration: const InputDecoration(labelText: "Categoria"),
              ),

              const SizedBox(height: 16),

              // ================= DESCRIÇÃO =================
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: "Descrição"),
              ),

              const SizedBox(height: 16),

              // ================= QUANTIDADE =================
              TextFormField(
                controller: _quantidadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Quantidade"),
                validator: (v) {
                  final valor = int.tryParse(v ?? '');
                  if (valor == null || valor <= 0) {
                    return "Quantidade inválida";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // ================= BOTÃO =================
              SubmitButton(
                loading: itemVM.isSaving,
                text: "Adicionar",
                onPressed: _salvar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
