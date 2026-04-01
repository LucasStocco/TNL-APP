import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/criar_produto/item.dart';
import '../../model/criar_produto/categoria.dart';
import '../../model/criar_produto/produto.dart';

import '../../view_model/criar_produto/categoria_view_model.dart';
import '../../view_model/criar_produto/produto_view_model.dart';

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

  String _nome = '';
  String _descricao = '';
  int _quantidade = 1;
  Categoria? _categoriaSelecionada;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    // Carrega categorias do backend
    Future.microtask(() {
      context.read<CategoriaViewModel>().carregarCategorias();
    });

    // Se for edição, preenche os campos com o item existente
    if (widget.item != null) {
      final i = widget.item!;
      _nome = i.produto.nome;
      _descricao = i.produto.descricao ?? '';
      _quantidade = i.quantidade;
      _categoriaSelecionada = i.produto.categoria;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriaVM = context.watch<CategoriaViewModel>();
    final produtoVM = context.read<ProdutoViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Criar Item' : 'Editar Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _nome,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
                onSaved: (v) => _nome = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _descricao,
                decoration: const InputDecoration(labelText: 'Descrição'),
                onSaved: (v) => _descricao = v ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _quantidade.toString(),
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final q = int.tryParse(v ?? '');
                  if (q == null || q <= 0) return 'Quantidade inválida';
                  return null;
                },
                onSaved: (v) => _quantidade = int.tryParse(v ?? '1') ?? 1,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Categoria>(
                value: _categoriaSelecionada,
                items: categoriaVM.categorias
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.nome),
                        ))
                    .toList(),
                onChanged: (c) => setState(() => _categoriaSelecionada = c),
                decoration: const InputDecoration(labelText: 'Categoria'),
                validator: (c) => c == null ? 'Selecione uma categoria' : null,
              ),
              const SizedBox(height: 32),
              _isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        _formKey.currentState!.save();
                        setState(() => _isSaving = true);

                        try {
                          // Cria produto se for um novo item
                          Produto produtoCriado = widget.item?.produto ??
                              await produtoVM.criar(
                                Produto(
                                  nome: _nome,
                                  descricao: _descricao,
                                  preco: 0.0,
                                  categoria: _categoriaSelecionada!,
                                ),
                              );

                          // Cria ou atualiza item
                          final item = Item(
                            id: widget.item?.id,
                            quantidade: _quantidade,
                            comprado: widget.item?.comprado ?? false,
                            produto: produtoCriado,
                          );

                          Navigator.pop(context, item);
                        } catch (e) {
                          setState(() => _isSaving = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro: $e')),
                          );
                        }
                      },
                      child: Text(widget.item == null ? 'Adicionar' : 'Salvar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
