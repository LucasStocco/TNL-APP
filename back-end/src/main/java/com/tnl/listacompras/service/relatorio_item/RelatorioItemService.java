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

    private final RelatorioItemRepository relatorioItemRepository;

    public RelatorioItemService(RelatorioItemRepository relatorioItemRepository) {
        this.relatorioItemRepository = relatorioItemRepository;
    }

    public List<ItemMaisCompradoDTO> buscarItemMaisComprados(Long listaId) {
        List<Object[]> resultados = relatorioItemRepository.buscarItensMaisComprados(listaId);
        List<ItemMaisCompradoDTO> response = new ArrayList<>();
        for (Object[] resultado : resultados) {
            response.add(new ItemMaisCompradoDTO(
                    (String) resultado[0],
                    (Long) resultado[1],
                    (Long) resultado[2]
            ));
        }
        return response;
    }

    public List<ItemPorCategoriaDTO> buscarItemPorCategoria(Long listaId) {
        List<Object[]> resultados = relatorioItemRepository.buscarItensPorCategoria(listaId);
        List<ItemPorCategoriaDTO> response = new ArrayList<>();
        for (Object[] resultado : resultados) {
            response.add(new ItemPorCategoriaDTO(
                    (String) resultado[0],
                    (Long) resultado[1],
                    (Long) resultado[2],
                    (Double) resultado[3]
            ));
        }
        return response;
    }

    public List<ItemRankingPrecoDTO> buscarItemMaisCaros(Long listaId) {
        List<Object[]> resultados = relatorioItemRepository.buscarItensMaisCaros(listaId);
        List<ItemRankingPrecoDTO> response = new ArrayList<>();
        for (Object[] resultado : resultados) {
            response.add(new ItemRankingPrecoDTO(
                    (String) resultado[0],
                    (String) resultado[1],
                    (Double) resultado[2]
            ));
        }
        return response;
    }

    public List<ItemRankingPrecoDTO> buscarItemMaisBaratos(Long listaId) {
        List<Object[]> resultados = relatorioItemRepository.buscarItensMaisBaratos(listaId);
        List<ItemRankingPrecoDTO> response = new ArrayList<>();
        for (Object[] resultado : resultados) {
            response.add(new ItemRankingPrecoDTO(
                    (String) resultado[0],
                    (String) resultado[1],
                    (Double) resultado[2]
            ));
        }
        return response;
    }
}