package com.tnl.listacompras.controller.relatorio_item;

import com.tnl.listacompras.dto.responseDTO.relatorio_item.ItemMaisCompradoDTO;
import com.tnl.listacompras.dto.responseDTO.relatorio_item.ItemPorCategoriaDTO;
import com.tnl.listacompras.dto.responseDTO.relatorio_item.ItemRankingPrecoDTO;
import com.tnl.listacompras.service.relatorio_item.RelatorioItemService;
import com.tnl.listacompras.session.Session;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import response.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/relatorios")
public class RelatorioItemController {

    private final RelatorioItemService service;

    public RelatorioItemController(RelatorioItemService service) {
        this.service = service;
    }

    @GetMapping("/mais-comprados")
    public ResponseEntity<ApiResponse<List<ItemMaisCompradoDTO>>> getMaisComprados() {
        Long usuarioId = Session.getUsuarioId();
        return ResponseEntity.ok(
                ApiResponse.success("Item mais comprados", service.buscarItemMaisComprados(usuarioId))
        );
    }

    @GetMapping("/por-categoria")
    public ResponseEntity<ApiResponse<List<ItemPorCategoriaDTO>>> getPorCategoria() {
        Long usuarioId = Session.getUsuarioId();
        return ResponseEntity.ok(
                ApiResponse.success("Item por categoria", service.buscarItemPorCategoria(usuarioId))
        );
    }

    @GetMapping("/mais-caros")
    public ResponseEntity<ApiResponse<List<ItemRankingPrecoDTO>>> getMaisCaros() {
        Long usuarioId = Session.getUsuarioId();
        return ResponseEntity.ok(
                ApiResponse.success("Item mais caros", service.buscarItemMaisCaros(usuarioId))
        );
    }

    @GetMapping("/mais-baratos")
    public ResponseEntity<ApiResponse<List<ItemRankingPrecoDTO>>> getMaisBaratos() {
        Long usuarioId = Session.getUsuarioId();
        return ResponseEntity.ok(
                ApiResponse.success("Item mais baratos", service.buscarItemMaisBaratos(usuarioId))
        );
    }
}