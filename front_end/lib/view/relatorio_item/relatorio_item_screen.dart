import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_flutter/model/gerenciar_lista/lista.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_view_model.dart';
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
      // Busca as listas disponíveis para o dropdown
      context.read<ListaViewModel>().listar();
    });
  }

  void _onListaSelecionada(Lista? lista) {
    if (lista == null) return;
    setState(() => _listaSelecionada = lista);
    context.read<RelatorioItemViewModel>().carregar(lista.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ListaViewModel, RelatorioItemViewModel>(
      builder: (context, listaVm, relatorioVm, _) {
        return RefreshIndicator(
          color: Colors.red,
          onRefresh: () async {
            if (_listaSelecionada != null) {
              await relatorioVm.carregar(_listaSelecionada!.id!);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // =========================
                // DROPDOWN DE LISTAS
                // =========================
                _buildDropdown(listaVm),
                const SizedBox(height: 24),

                // =========================
                // SEM LISTA SELECIONADA
                // =========================
                if (_listaSelecionada == null)
                  _buildPlaceholder()

                // =========================
                // LOADING
                // =========================
                else if (relatorioVm.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: CircularProgressIndicator(color: Colors.red),
                    ),
                  )

                // =========================
                // ERRO
                // =========================
                else if (relatorioVm.erro != null)
                  _buildErro(relatorioVm)

                // =========================
                // CONTEÚDO
                // =========================
                else ...[
                  _buildSecao(
                    titulo: 'Mais comprados',
                    icone: Icons.trending_up,
                    cor: Colors.orange,
                    itens: relatorioVm.maisComprados.isEmpty
                        ? [_vazio()]
                        : relatorioVm.maisComprados.asMap().entries.map((e) {
                            final item = e.value;
                            final pos = e.key + 1;
                            return _buildCard(
                              posicao: pos,
                              linha1: item.nomeProduto,
                              linha2: '${item.totalQuantidade}x em ${item.frequencia} lista(s)',
                              valor: null,
                              cor: Colors.orange,
                            );
                          }).toList(),
                  ),
                  _buildSecao(
                    titulo: 'Gasto por categoria',
                    icone: Icons.category,
                    cor: Colors.blue,
                    itens: relatorioVm.porCategoria.isEmpty
                        ? [_vazio()]
                        : relatorioVm.porCategoria.map((item) {
                            return _buildCard(
                              posicao: null,
                              linha1: item.nomeCategoria,
                              linha2: '${item.totalItens} produto(s) · ${item.totalQuantidade} unid.',
                              valor: 'R\$ ${item.totalGasto.toStringAsFixed(2)}',
                              cor: Colors.blue,
                            );
                          }).toList(),
                  ),
                  _buildSecao(
                    titulo: 'Mais caros',
                    icone: Icons.arrow_upward,
                    cor: Colors.red,
                    itens: relatorioVm.maisCaros.isEmpty
                        ? [_vazio()]
                        : relatorioVm.maisCaros.asMap().entries.map((e) {
                            final item = e.value;
                            final pos = e.key + 1;
                            return _buildCard(
                              posicao: pos,
                              linha1: item.nomeProduto,
                              linha2: item.nomeCategoria,
                              valor: 'R\$ ${item.preco.toStringAsFixed(2)}',
                              cor: Colors.red,
                            );
                          }).toList(),
                  ),
                  _buildSecao(
                    titulo: 'Mais baratos',
                    icone: Icons.arrow_downward,
                    cor: Colors.green,
                    itens: relatorioVm.maisBaratos.isEmpty
                        ? [_vazio()]
                        : relatorioVm.maisBaratos.asMap().entries.map((e) {
                            final item = e.value;
                            final pos = e.key + 1;
                            return _buildCard(
                              posicao: pos,
                              linha1: item.nomeProduto,
                              linha2: item.nomeCategoria,
                              valor: 'R\$ ${item.preco.toStringAsFixed(2)}',
                              cor: Colors.green,
                            );
                          }).toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================
  // DROPDOWN
  // =========================
  Widget _buildDropdown(ListaViewModel listaVm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: listaVm.isLoading
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.red),
                    ),
                    SizedBox(width: 10),
                    Text('Carregando listas...'),
                  ],
                ),
              )
            : DropdownButton<Lista>(
                isExpanded: true,
                hint: const Text('Selecione uma lista'),
                value: _listaSelecionada,
                items: listaVm.listas.map((lista) {
                  return DropdownMenuItem<Lista>(
                    value: lista,
                    child: Text(
                      lista.nome,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: _onListaSelecionada,
              ),
      ),
    );
  }

  // =========================
  // PLACEHOLDER (sem lista)
  // =========================
  Widget _buildPlaceholder() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.bar_chart, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Selecione uma lista para ver o relatório',
              style: TextStyle(color: Colors.grey[400], fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // ERRO
  // =========================
  Widget _buildErro(RelatorioItemViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(vm.erro!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => vm.carregar(_listaSelecionada!.id!),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Tentar novamente',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // SEÇÃO
  // =========================
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...itens,
        const SizedBox(height: 24),
      ],
    );
  }

  // =========================
  // CARD
  // =========================
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (posicao != null) ...[
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: cor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$posicao',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: cor,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  linha1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  linha2,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          if (valor != null)
            Text(
              valor,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: cor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _vazio() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          'Nenhum dado encontrado',
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
      ),
    );
  }
}