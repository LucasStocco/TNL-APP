import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_model/criar_produto/categoria_view_model.dart';
import '../helpers/categoria_helper.dart';
import 'categoria_detalhes_screen.dart'; // Tela de detalhes da categoria

// Tela principal que mostra todas as categorias em um Grid
class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  @override
  void initState() {
    super.initState();

    // Carrega as categorias do ViewModel assim que a tela é aberta
    // Future.microtask garante que seja chamado após o build inicial
    Future.microtask(
      () => Provider.of<CategoriaViewModel>(context, listen: false)
          .carregarCategorias(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriaViewModel>(
      // O Consumer escuta mudanças no ViewModel e reconstrói a tela
      builder: (context, viewModel, child) {
        // Mostra um loading enquanto as categorias estão sendo carregadas
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Caso não existam categorias, exibe uma mensagem
        if (viewModel.categorias.isEmpty) {
          return const Center(child: Text('Nenhuma categoria encontrada'));
        }

        // Padding ao redor do GridView para não encostar nas bordas da tela
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            // Número de itens baseado na lista do ViewModel
            itemCount: viewModel.categorias.length,
            // Define a estrutura do grid
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 cards por linha
              crossAxisSpacing: 12, // espaço horizontal entre cards
              mainAxisSpacing: 12, // espaço vertical entre cards
              childAspectRatio: 1, // proporção largura/altura de cada card
            ),
            // itemBuilder define como cada card será renderizado
            itemBuilder: (context, index) {
              final categoria =
                  viewModel.categorias[index]; // pega a categoria atual
              final icone = CategoriaHelper.iconeParaCategoria(
                categoria.id ?? 0, // se for nulo, usa 0 ou outro id padrão
              );

              return GestureDetector(
                // Ao clicar no card, navega para a tela de detalhes
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoriaDetalhesScreen(
                        nomeCategoria: categoria.nome,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12), // espaço interno do card
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200, // cor de fundo do card
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // cantos arredondados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // sombra leve
                        blurRadius: 5,
                        offset: const Offset(0, 3), // deslocamento da sombra
                      ),
                    ],
                  ),
                  // Conteúdo do card (ícone + nome da categoria)
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        icone,
                        width: 50,
                        height: 50,
                      ), // ícone da categoria
                      const SizedBox(height: 8), // espaço entre ícone e texto
                      Text(
                        categoria.nome,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
