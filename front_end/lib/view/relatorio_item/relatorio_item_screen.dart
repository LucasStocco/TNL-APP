import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_flutter/model/gerenciar_lista/lista.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_resumo_view_model.dart';
import 'package:crud_flutter/view_model/relatorio_item/relatorio_item_view_model.dart';

class RelatorioItemScreen extends StatefulWidget {
  const RelatorioItemScreen({super.key});

  @override
  State<RelatorioItemScreen> createState() => _RelatorioItemScreenState();
}

class _RelatorioItemScreenState extends State<RelatorioItemScreen> {
  Lista? _listaSelecionada;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListaResumoViewModel>().listar();
    });
  }

  void _selecionarLista(Lista lista) {
    setState(() => _listaSelecionada = lista);
    context.read<RelatorioItemViewModel>().carregar(lista.id!);
  }

  @override
  Widget build(BuildContext context) {
    final listaVm = context.watch<ListaResumoViewModel>();
    final relatorioVm = context.watch<RelatorioItemViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Relatório de Itens',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Column(
        children: [

          // =========================
          // SELETOR DE LISTA
          // =========================
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: listaVm.isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.red))
                : listaVm.listasCrud.isEmpty
                    ? const Text('Nenhuma lista encontrada')
                    : DropdownButtonFormField<Lista>(
                        value: _listaSelecionada,
                        hint: const Text('Selecione uma lista'),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        items: listaVm.listasCrud.map((lista) {
                          return DropdownMenuItem(
                            value: lista,
                            child: Text(lista.nome),
                          );
                        }).toList(),
                        onChanged: (lista) {
                          if (lista != null) _selecionarLista(lista);
                        },
                      ),
          ),

          // =========================
          // CONTEÚDO
          // =========================
          Expanded(
            child: _listaSelecionada == null
                ? const Center(child: Text('Selecione uma lista para ver o relatório'))
                : relatorioVm.isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.red))
                    : relatorioVm.erro != null
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                                const SizedBox(height: 12),
                                Text(relatorioVm.erro!),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => relatorioVm.carregar(_listaSelecionada!.id!),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: const Text('Tentar novamente', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            color: Colors.red,
                            onRefresh: () => relatorioVm.carregar(_listaSelecionada!.id!),
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  _buildSecao(
                                    titulo: 'Mais comprados',
                                    icone: Icons.trending_up,
                                    cor: Colors.orange,
                                    itens: relatorioVm.maisComprados.isEmpty
                                        ? [_vazio()]
                                        : relatorioVm.maisComprados.asMap().entries.map((e) =>
                                            _buildCard(
                                              posicao: e.key + 1,
                                              linha1: e.value.nomeProduto,
                                              linha2: '${e.value.totalQuantidade}x em ${e.value.frequencia} lista(s)',
                                              valor: null,
                                              cor: Colors.orange,
                                            )).toList(),
                                  ),

                                  _buildSecao(
                                    titulo: 'Gasto por categoria',
                                    icone: Icons.category,
                                    cor: Colors.blue,
                                    itens: relatorioVm.porCategoria.isEmpty
                                        ? [_vazio()]
                                        : relatorioVm.porCategoria.map((e) =>
                                            _buildCard(
                                              posicao: null,
                                              linha1: e.nomeCategoria,
                                              linha2: '${e.totalItens} produto(s) · ${e.totalQuantidade} unid.',
                                              valor: 'R\$ ${e.totalGasto.toStringAsFixed(2)}',
                                              cor: Colors.blue,
                                            )).toList(),
                                  ),

                                  _buildSecao(
                                    titulo: 'Mais caros',
                                    icone: Icons.arrow_upward,
                                    cor: Colors.red,
                                    itens: relatorioVm.maisCaros.isEmpty
                                        ? [_vazio()]
                                        : relatorioVm.maisCaros.asMap().entries.map((e) =>
                                            _buildCard(
                                              posicao: e.key + 1,
                                              linha1: e.value.nomeProduto,
                                              linha2: e.value.nomeCategoria,
                                              valor: 'R\$ ${e.value.preco.toStringAsFixed(2)}',
                                              cor: Colors.red,
                                            )).toList(),
                                  ),

                                  _buildSecao(
                                    titulo: 'Mais baratos',
                                    icone: Icons.arrow_downward,
                                    cor: Colors.green,
                                    itens: relatorioVm.maisBaratos.isEmpty
                                        ? [_vazio()]
                                        : relatorioVm.maisBaratos.asMap().entries.map((e) =>
                                            _buildCard(
                                              posicao: e.key + 1,
                                              linha1: e.value.nomeProduto,
                                              linha2: e.value.nomeCategoria,
                                              valor: 'R\$ ${e.value.preco.toStringAsFixed(2)}',
                                              cor: Colors.green,
                                            )).toList(),
                                  ),

                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecao({
    required String titulo,
    required IconData icone,
    required Color cor,
    required List<Widget> itens,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icone, color: cor, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              titulo,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...itens,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCard({
    required int? posicao,
    required String linha1,
    required String linha2,
    required String? valor,
    required Color cor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          if (posicao != null) ...[
            Container(
              width: 28, height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: cor.withOpacity(0.12), shape: BoxShape.circle),
              child: Text('$posicao', style: TextStyle(fontWeight: FontWeight.bold, color: cor, fontSize: 12)),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(linha1, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), overflow: TextOverflow.ellipsis),
                Text(linha2, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          if (valor != null)
            Text(valor, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: cor)),
        ],
      ),
    );
  }

  Widget _vazio() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(child: Text('Nenhum dado encontrado', style: TextStyle(color: Colors.grey[400], fontSize: 14))),
    );
  }
}