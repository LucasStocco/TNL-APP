package com.tnl.listacompras.controller.relatorio_item;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tnl.listacompras.dto.responseDTO.relatorio_item.ItemMaisCompradoDTO;
import com.tnl.listacompras.dto.responseDTO.relatorio_item.ItemPorCategoriaDTO;
import com.tnl.listacompras.dto.responseDTO.relatorio_item.ItemRankingPrecoDTO;
import com.tnl.listacompras.service.relatorio_item.RelatorioItemService;

import response.ApiResponse;

@RestController
@RequestMapping("/relatorios/{listaId}")
public class RelatorioItemController {

    private final RelatorioItemService relatorioItemService;

    public RelatorioItemController(RelatorioItemService relatorioItemService) {
        this.relatorioItemService = relatorioItemService;
    }

    @GetMapping("/mais-comprados")
    public ResponseEntity<ApiResponse<List<ItemMaisCompradoDTO>>> getMaisComprados(@PathVariable Long listaId) {
        return ResponseEntity.ok(
                ApiResponse.success("Itens mais comprados", relatorioItemService.buscarItemMaisComprados(listaId))
        );
    }

    @GetMapping("/por-categoria")
    public ResponseEntity<ApiResponse<List<ItemPorCategoriaDTO>>> getPorCategoria(@PathVariable Long listaId) {
        return ResponseEntity.ok(
                ApiResponse.success("Itens por categoria", relatorioItemService.buscarItemPorCategoria(listaId))
        );
    }

    @GetMapping("/mais-caros")
    public ResponseEntity<ApiResponse<List<ItemRankingPrecoDTO>>> getMaisCaros(@PathVariable Long listaId) {
        return ResponseEntity.ok(
                ApiResponse.success("Itens mais caros", relatorioItemService.buscarItemMaisCaros(listaId))
        );
    }

    @GetMapping("/mais-baratos")
    public ResponseEntity<ApiResponse<List<ItemRankingPrecoDTO>>> getMaisBaratos(@PathVariable Long listaId) {
        return ResponseEntity.ok(
                ApiResponse.success("Itens mais baratos", relatorioItemService.buscarItemMaisBaratos(listaId))
        );
    }
}