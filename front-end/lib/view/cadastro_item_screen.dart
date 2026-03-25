import 'package:flutter/material.dart';
import '../model/item.dart';
import '../model/produto.dart';
import '../model/categoria.dart';
import '../view_model/categoria_view_model.dart';
import '../my_widgets/categoria_dropdown.dart';

class CriarItemScreen extends StatefulWidget {
  final Item? item;
  final int listaId;

  const CriarItemScreen({super.key, this.item, required this.listaId});

  @override
  State<CriarItemScreen> createState() => _CriarItemScreenState();
}

class _CriarItemScreenState extends State<CriarItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _precoController = TextEditingController();

  final CategoriaViewModel _categoriaVM = CategoriaViewModel();

  Categoria? _categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarCategorias();

    if (widget.item != null) {
      final item = widget.item!;
      _nomeController.text = item.produto.nome;
      _descricaoController.text = item.produto.descricao ?? '';
      _quantidadeController.text = item.quantidade.toString();
      _precoController.text = item.produto.preco.toStringAsFixed(2);
      _categoriaSelecionada = item.produto.categoria;
    }
  }

  Future<void> _carregarCategorias() async {
    await _categoriaVM.carregarCategorias();
    if (mounted) setState(() {});
  }

  Future<void> _salvarItem() async {
    if (!_formKey.currentState!.validate()) return;

    if (_categoriaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma categoria')),
      );
      return;
    }

    final produto = Produto(
      id: widget.item?.produto.id,
      nome: _nomeController.text,
      preco: double.parse(_precoController.text),
      descricao:
          _descricaoController.text.isEmpty ? null : _descricaoController.text,
      categoria: _categoriaSelecionada!,
    );

    final item = Item(
      id: widget.item?.id,
      quantidade: int.parse(_quantidadeController.text),
      comprado: widget.item?.comprado ?? false,
      produto: produto,
    );

    // 🔥 Retorna o item para a tela anterior
    Navigator.pop(context, item);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _quantidadeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Novo Item' : 'Editar Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do produto'),
                validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                decoration:
                    const InputDecoration(labelText: 'Descrição (opcional)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantidadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _precoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Preço'),
                validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),

              // Categoria dropdown
              _categoriaVM.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CategoriaDropdown(
                      viewModel: _categoriaVM,
                      selecionada: _categoriaSelecionada,
                      onChanged: (value) {
                        setState(() => _categoriaSelecionada = value);
                      },
                    ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _salvarItem,
                child: Text(widget.item == null ? 'Adicionar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
