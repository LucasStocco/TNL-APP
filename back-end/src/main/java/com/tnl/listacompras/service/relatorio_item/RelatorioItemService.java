package com.tnl.listacompras.service.relatorio_item;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.tnl.listacompras.dto.responseDTO.relatorio_item.RelatorioItemMaisCompradosResponseDTO;
import com.tnl.listacompras.repository.relatorio_item.RelatorioItemRepository;

@Service
public class RelatorioItemService{
        private final RelatorioItemRepository repository;

        public RelatorioItemService(RelatorioItemRepository repository) {
        this.repository = repository;
    }

    public List<RelatorioItemMaisCompradosResponseDTO> buscarItensMaisComprados() {
    List<Object[]> resultados = repository.buscarItensMaisComprados();

    List<RelatorioItemMaisCompradosResponseDTO> response = new ArrayList<>();

    for (Object[] resultado : resultados) {
        RelatorioItemMaisCompradosResponseDTO dto =
                new RelatorioItemMaisCompradosResponseDTO(
                        (String) resultado[0],
                        (Long) resultado[1]
                );

        response.add(dto);
    }

    return response;
}
}