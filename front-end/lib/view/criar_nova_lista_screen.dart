import 'package:flutter/material.dart';
import '../model/lista.dart';
import '../service/lista_service.dart';

class CriarNovaListaScreen extends StatefulWidget {
  final Lista? lista; // parâmetro opcional para edição

  const CriarNovaListaScreen({super.key, this.lista});

  @override
  State<CriarNovaListaScreen> createState() => _CriarNovaListaScreenState();
}

class _CriarNovaListaScreenState extends State<CriarNovaListaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  final ListaService _service = ListaService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Se for edição, preenche o campo
    if (widget.lista != null) {
      _nomeController.text = widget.lista!.nome;
    }
  }

  Future<void> _salvarLista() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final lista = Lista(
        id: widget.lista?.id, // mantém o id se for edição
        nome: _nomeController.text,
        dataConclusao:
            widget.lista?.dataConclusao, // mantém a data original ou null
      );

      Lista listaRetornada;

      if (widget.lista == null) {
        // criando nova lista
        listaRetornada = await _service.create(lista);
      } else {
        // atualizando lista existente
        listaRetornada = await _service.update(lista);
      }

      // Retorna para a tela anterior
      if (mounted) {
        Navigator.pop(context, listaRetornada);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar lista: $e')),
        );
      }
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
