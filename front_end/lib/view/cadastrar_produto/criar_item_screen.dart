import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/cadastrar_produto/item.dart';
import '../../model/cadastrar_categoria/categoria.dart';
import '../../view_model/cadastrar_categoria/categoria_view_model.dart';
import '../../view_model/gerenciar_lista/item_view_model.dart';
import '../../dto/item_manual_dto.dart';
import '../../dto/item_update_dto.dart';

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
  double _preco = 0.0;

  Categoria? _categoriaSelecionada;

  bool get isGlobal => widget.item?.idProduto != null;

  @override
  void initState() {
    super.initState();

    print("===== INIT CriarItemScreen =====");

    if (widget.item != null) {
      print("MODO: EDITAR");
      print("Item ID: ${widget.item!.id}");
      print("ID PRODUTO (global?): ${widget.item!.idProduto}");
      print("Nome atual: ${widget.item!.nomeProdutoSnapshot}");
      print("Quantidade atual: ${widget.item!.quantidade}");
    } else {
      print("MODO: CRIAR");
    }

    Future.microtask(() {
      context.read<CategoriaViewModel>().listar();
    });

    if (widget.item != null) {
      final i = widget.item!;

      _nome = i.nomeProdutoSnapshot;
      _quantidade = i.quantidade;
      _preco = i.precoProdutoSnapshot;
      _descricao = i.descricaoProdutoSnapshot ?? '';

      _categoriaSelecionada = i.idCategoria != null
          ? Categoria(
              id: i.idCategoria,
              nome: i.nomeCategoriaSnapshot,
            )
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriaVM = context.watch<CategoriaViewModel>();
    final itemVM = context.watch<ItemViewModel>();

    final categorias = categoriaVM.categoriasAtivas;

    final categoriaCorrigida =
        categorias.where((c) => c.id == _categoriaSelecionada?.id).isNotEmpty
            ? categorias.firstWhere(
                (c) => c.id == _categoriaSelecionada?.id,
              )
            : null;

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
              if (isGlobal)
                const Text(
                  "Item global: apenas quantidade pode ser editada",
                  style: TextStyle(color: Colors.grey),
                ),
              TextFormField(
                initialValue: _nome,
                enabled: !isGlobal,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
                onSaved: (v) => _nome = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _descricao,
                enabled: !isGlobal,
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
              TextFormField(
                initialValue: _preco.toString(),
                enabled: !isGlobal,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final p = double.tryParse(v ?? '');
                  if (p == null || p < 0) return 'Preço inválido';
                  return null;
                },
                onSaved: (v) => _preco = double.tryParse(v ?? '0') ?? 0.0,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Categoria>(
                value: categoriaCorrigida,
                items: categorias
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.nome),
                        ))
                    .toList(),
                onChanged: isGlobal
                    ? null
                    : (c) => setState(() => _categoriaSelecionada = c),
                decoration: const InputDecoration(labelText: 'Categoria'),
                validator: (c) => c == null ? 'Selecione uma categoria' : null,
              ),
              const SizedBox(height: 32),
              itemVM.isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        print("===== CLICK SALVAR =====");

                        if (!_formKey.currentState!.validate()) {
                          print("Form inválido");
                          return;
                        }

                        _formKey.currentState!.save();

                        print("Dados do form:");
                        print("Nome: $_nome");
                        print("Quantidade: $_quantidade");
                        print("Preço: $_preco");
                        print("Categoria: ${_categoriaSelecionada?.id}");

                        if (_categoriaSelecionada == null ||
                            _categoriaSelecionada?.id == null) {
                          print("Categoria inválida");
                          return;
                        }

                        if (widget.item == null) {
                          print("AÇÃO: CRIAR ITEM");

                          final dto = ItemManualDTO(
                            nomeProdutoSnapshot: _nome,
                            precoProdutoSnapshot: _preco,
                            idCategoria: _categoriaSelecionada!.id!,
                            quantidade: _quantidade,
                          );

                          print("DTO CREATE: ${dto.toJson()}");

                          await itemVM.criarItemManual(
                            widget.listaId,
                            dto,
                          );
                        } else {
                          print("AÇÃO: ATUALIZAR ITEM");
                          print(
                              "ID PRODUTO (global?): ${widget.item!.idProduto}");

                          final dto = ItemUpdateDTO(
                            nomeProdutoSnapshot: isGlobal ? null : _nome,
                            precoProdutoSnapshot: isGlobal ? null : _preco,
                            quantidade: _quantidade,
                            idCategoria:
                                isGlobal ? null : _categoriaSelecionada!.id!,
                          );

                          print("DTO UPDATE: ${dto.toJson()}");

                          await itemVM.atualizarItem(
                            widget.listaId,
                            widget.item!.id!,
                            dto,
                          );
                        }

                        if (itemVM.erro != null) {
                          print("ERRO: ${itemVM.erro}");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(itemVM.erro!)),
                          );
                          return;
                        }

                        print("SUCESSO");
                        Navigator.pop(context);
                      },
                      child: Text(
                        widget.item == null ? 'Adicionar' : 'Salvar',
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
