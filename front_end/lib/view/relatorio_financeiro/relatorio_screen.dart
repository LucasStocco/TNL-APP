import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/relatorio_financeiro/financeiro_view_model.dart';
import 'widgets/relatorio_card.dart';

class RelatorioScreen extends StatefulWidget {
  const RelatorioScreen({super.key});

  @override
  State<RelatorioScreen> createState() =>
      _RelatorioScreenState();
}
class _RelatorioScreenState
    extends State<RelatorioScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {

      Provider.of<FinanceiroViewModel>(
        context,
        listen: false,
      ).carregarTotalGeral();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<FinanceiroViewModel>(

      builder: (
        context,
        viewModel,
        child,
      ) {

       
        if (viewModel.loading) {

          return const Scaffold(
            body: Center(
              child:
                  CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(

          backgroundColor:
              Colors.grey[100],

          body: SafeArea(

            child: Padding(
              padding:
                  const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                 
                  const Text(
                    'Relatórios',

                    style: TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                 
                  const Text(
                    '📊 Financeiro',

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  
                  Row(
                    children: [

                  
                      Expanded(
                        child:
                            RelatorioCard(

                          titulo:
                              'Total Geral',

                          valor:
                              'R\$ ${viewModel.totalGeral?.total ?? 0}',
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

              
                      Expanded(
                        child:
                            RelatorioCard(

                          titulo: 'Média',

                          valor:
                              'R\$ 0',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 16,
                  ),
  
                  RelatorioCard(
                    titulo: 'Categorias',
                    valor: '3', )],)),),);
      },
    );
  }
}