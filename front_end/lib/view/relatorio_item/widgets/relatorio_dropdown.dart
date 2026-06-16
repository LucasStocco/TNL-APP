import 'package:flutter/material.dart';
import 'package:crud_flutter/model/gerenciar_lista/lista.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_view_model.dart';

class RelatorioDropdown extends StatelessWidget {
  final ListaViewModel listaVm;
  final Lista? listaSelecionada;
  final ValueChanged<Lista?> onChanged;

  const RelatorioDropdown({
    super.key,
    required this.listaVm,
    required this.listaSelecionada,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2))
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
                            strokeWidth: 2, color: Colors.red)),
                    SizedBox(width: 10),
                    Text('Carregando listas...'),
                  ],
                ),
              )
            : DropdownButton<Lista>(
                isExpanded: true,
                hint: const Text('Selecione uma lista'),
                value: listaSelecionada,
                items: listaVm.listas
                    .map((lista) => DropdownMenuItem<Lista>(
                          value: lista,
                          child:
                              Text(lista.nome, overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: onChanged,
              ),
      ),
    );
  }
}