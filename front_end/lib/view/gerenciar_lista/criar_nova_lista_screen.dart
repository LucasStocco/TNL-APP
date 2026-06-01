import 'package:crud_flutter/view/gerenciar_lista/widgets/submit_loading_button.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_resumo_view_model.dart';
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

    final listaVm = context.read<ListaViewModel>();
    final resumoVm = context.read<ListaResumoViewModel>();

    final nome = _nomeController.text;

    await listaVm.criar(nome);

    if (!mounted) return;

    if (listaVm.erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(listaVm.erro!)),
      );
      return;
    }

    // 🔥 ATUALIZA A TELA QUE REALMENTE MOSTRA AS LISTAS
    await resumoVm.carregarResumo();

    Navigator.pop(context, true);
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
