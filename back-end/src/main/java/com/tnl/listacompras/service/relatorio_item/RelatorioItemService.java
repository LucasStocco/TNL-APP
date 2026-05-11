package com.tnl.listacompras.service.relatorio_item;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.tnl.listacompras.dto.responseDTO.relatorio_item.RelatorioItemMaisBaratoResponseDTO;
import com.tnl.listacompras.dto.responseDTO.relatorio_item.RelatorioItemMaisCaroResponseDTO;
import com.tnl.listacompras.dto.responseDTO.relatorio_item.RelatorioItemMaisCompradosResponseDTO;
import com.tnl.listacompras.dto.responseDTO.relatorio_item.RelatorioItemPorCategoriaResponseDTO;
import com.tnl.listacompras.model.gerenciar_lista.Item;
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

        public List<RelatorioItemPorCategoriaResponseDTO> buscarItensPorCategoria(Long listaId) {
    List<Object[]> resultados = repository.totalPorCategoria(listaId);

    List<RelatorioItemPorCategoriaResponseDTO> response = new ArrayList<>();

    for (Object[] resultado : resultados) {
        RelatorioItemPorCategoriaResponseDTO dto =
                new RelatorioItemPorCategoriaResponseDTO(
                        (String) resultado[0],
                        (Long) resultado[1]
                );

        response.add(dto);
    }

    return response;
}

        public List<RelatorioItemMaisCaroResponseDTO> buscarItensMaisCaros(Long listaId) {

    List<Item> resultados = repository.buscarItensMaisCaros(listaId);

    List<RelatorioItemMaisCaroResponseDTO> response = new ArrayList<>();

    for (Item item : resultados) {
        RelatorioItemMaisCaroResponseDTO dto =
                new RelatorioItemMaisCaroResponseDTO(
                        item.getProduto().getNome(),
                        item.getPreco()
                );

        response.add(dto);
    }

    return response;
}

public List<RelatorioItemMaisBaratoResponseDTO> buscarItensMaisBaratos(Long listaId) {

    List<Item> resultados = repository.buscarItensMaisBaratos(listaId);

    List<RelatorioItemMaisBaratoResponseDTO> response = new ArrayList<>();

    for (Item item : resultados) {
        RelatorioItemMaisBaratoResponseDTO dto =
                new RelatorioItemMaisBaratoResponseDTO(
                        item.getProduto().getNome(),
                        item.getPreco()
                );

        response.add(dto);
    }

    return response;
}

}