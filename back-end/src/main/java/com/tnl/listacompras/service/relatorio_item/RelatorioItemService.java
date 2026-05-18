package com.tnl.listacompras.service.relatorio_item;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.tnl.listacompras.dto.responseDTO.relatorio_item.ItemMaisCompradoDTO;
import com.tnl.listacompras.dto.responseDTO.relatorio_item.ItemPorCategoriaDTO;
import com.tnl.listacompras.dto.responseDTO.relatorio_item.ItemRankingPrecoDTO;
import com.tnl.listacompras.repository.relatorio_item.RelatorioItemRepository;

@Service
public class RelatorioItemService {

    private final RelatorioItemRepository repository;

    public RelatorioItemService(RelatorioItemRepository repository) {
        this.repository = repository;
    }

    public List<ItemMaisCompradoDTO> buscarItemMaisComprados(Long usuarioId) {
        List<Object[]> resultados = repository.buscarItensMaisComprados(usuarioId);

        List<ItemMaisCompradoDTO> response = new ArrayList<>();

        for (Object[] resultado : resultados) {
            ItemMaisCompradoDTO dto = new ItemMaisCompradoDTO(
                    (String) resultado[0],
                    (Long) resultado[1],
                    (Long) resultado[2]
            );
            response.add(dto);
        }

        return response;
    }

    public List<ItemPorCategoriaDTO> buscarItemPorCategoria(Long usuarioId) {
        List<Object[]> resultados = repository.buscarItensPorCategoria(usuarioId);

        List<ItemPorCategoriaDTO> response = new ArrayList<>();

        for (Object[] resultado : resultados) {
            ItemPorCategoriaDTO dto = new ItemPorCategoriaDTO(
                    (String) resultado[0],
                    (Long) resultado[1],
                    (Long) resultado[2],
                    (Double) resultado[3]
            );
            response.add(dto);
        }

        return response;
    }

    public List<ItemRankingPrecoDTO> buscarItemMaisCaros(Long usuarioId) {
        List<Object[]> resultados = repository.buscarItensMaisCaros(usuarioId);

        List<ItemRankingPrecoDTO> response = new ArrayList<>();

        for (Object[] resultado : resultados) {
            ItemRankingPrecoDTO dto = new ItemRankingPrecoDTO(
                    (String) resultado[0],
                    (String) resultado[1],
                    (Double) resultado[2]
            );
            response.add(dto);
        }

        return response;
    }

    public List<ItemRankingPrecoDTO> buscarItemMaisBaratos(Long usuarioId) {
        List<Object[]> resultados = repository.buscarItensMaisBaratos(usuarioId);

        List<ItemRankingPrecoDTO> response = new ArrayList<>();

        for (Object[] resultado : resultados) {
            ItemRankingPrecoDTO dto = new ItemRankingPrecoDTO(
                    (String) resultado[0],
                    (String) resultado[1],
                    (Double) resultado[2]
            );
            response.add(dto);
        }

        return response;
    }
}