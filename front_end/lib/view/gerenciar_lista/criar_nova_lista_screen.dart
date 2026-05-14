import 'package:crud_flutter/view/gerenciar_lista/widgets/submit_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// A View não conhece a entidade Lista como objeto de domínio, ela só recebe dados já “traduzidos” pelo ViewModel.
import '../../view_model/gerenciar_lista/lista_view_model.dart';
import 'widgets/lista_form.dart';

class CriarNovaListaScreen extends StatefulWidget {
  final int? listaId; // opcional para edição
  final String? nomeInicial;

  const CriarNovaListaScreen({
    super.key,
    this.listaId,
    this.nomeInicial,
  });

  bool get isEdit => listaId != null;

  @override
  State<CriarNovaListaScreen> createState() => _CriarNovaListaScreenState();
}

class _CriarNovaListaScreenState extends State<CriarNovaListaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.nomeInicial != null) {
      _nomeController.text = widget.nomeInicial!;
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<ListaViewModel>();
    final nome = _nomeController.text;

    await vm.salvarLista(widget.listaId, nome);

    if (vm.erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.erro!)),
      );
      return;
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // relação com ListaViewModel
    final vm = context.watch<ListaViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Editar Lista' : 'Nova Lista'),
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
              text: widget.isEdit ? 'Atualizar' : 'Criar',
              onPressed: _salvar,
            ),
          ],
        ),
      ),
    );
  }
}
