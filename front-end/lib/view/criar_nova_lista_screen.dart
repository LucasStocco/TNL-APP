import 'package:flutter/material.dart';
import '../model/lista.dart';
import '../view_model/lista_view_model.dart';
import 'package:provider/provider.dart';

class CriarNovaListaScreen extends StatefulWidget {
  final Lista? lista; // parâmetro opcional para edição

  const CriarNovaListaScreen({super.key, this.lista});

  @override
  State<CriarNovaListaScreen> createState() => _CriarNovaListaScreenState();
}

class _CriarNovaListaScreenState extends State<CriarNovaListaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.lista != null) {
      _nomeController.text = widget.lista!.nome;
    }
  }

  Future<void> _salvarLista() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final viewModel = context.read<ListaViewModel>();

      Lista lista = Lista(
        id: widget.lista?.id,
        nome: _nomeController.text,
        dataConclusao: widget.lista?.dataConclusao,
      );

      Lista? listaRetornada;

      if (widget.lista == null) {
        listaRetornada = await viewModel.criar(lista.nome);
      } else {
        listaRetornada = await viewModel.atualizar(lista);
      }

      if (listaRetornada != null && mounted) {
        Navigator.pop(context, listaRetornada);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar lista: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lista == null ? 'Nova Lista' : 'Editar Lista'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome da Lista'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _salvarLista,
                      child: Text(widget.lista == null ? 'Criar' : 'Atualizar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
