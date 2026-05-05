import 'package:crud_flutter/view/gerenciar_lista/widgets/submit_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/gerenciar_lista/lista.dart';
import '../../view_model/gerenciar_lista/lista_view_model.dart';
import 'widgets/lista_form.dart';

class CriarNovaListaScreen extends StatefulWidget {
  final Lista? lista;

  const CriarNovaListaScreen({super.key, this.lista});

  @override
  State<CriarNovaListaScreen> createState() => _CriarNovaListaScreenState();
}

class _CriarNovaListaScreenState extends State<CriarNovaListaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  bool get isEdit => widget.lista != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      _nomeController.text = widget.lista!.nome;
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<ListaViewModel>();

    final nome = _nomeController.text;

    final result = isEdit
        ? await vm.atualizar(
            Lista(
              id: widget.lista!.id,
              nome: nome,
              concluidoEm: widget.lista!.concluidoEm,
            ),
          )
        : await vm.criar(nome);

    if (vm.erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.erro!)),
      );
      return;
    }

    if (result != null && mounted) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ListaViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Lista' : 'Nova Lista'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListaForm(
              formKey: _formKey,
              controller: _nomeController,
              enabled: !vm.isLoading,
            ),
            const SizedBox(height: 32),
            SubmitLoadingButton(
              loading: vm.isLoading,
              text: isEdit ? 'Atualizar' : 'Criar',
              onPressed: _salvar,
            ),
          ],
        ),
      ),
    );
  }
}
