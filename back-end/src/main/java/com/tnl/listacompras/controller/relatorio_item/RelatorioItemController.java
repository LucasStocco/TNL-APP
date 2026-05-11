package com.tnl.listacompras.controller.relatorio_item;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tnl.listacompras.dto.responseDTO.relatorio_item.RelatorioItemMaisCaroResponseDTO;
import com.tnl.listacompras.dto.responseDTO.relatorio_item.RelatorioItemMaisBaratoResponseDTO;
import com.tnl.listacompras.dto.responseDTO.relatorio_item.RelatorioItemMaisCompradosResponseDTO;
import com.tnl.listacompras.dto.responseDTO.relatorio_item.RelatorioItemPorCategoriaResponseDTO;
import com.tnl.listacompras.service.relatorio_item.RelatorioItemService;

@RestController
@RequestMapping("relatorios/itens")
public class RelatorioItemController {
    
    private final RelatorioItemService service;

    public RelatorioItemController(RelatorioItemService service){
        this.service = service;
    }

    @GetMapping("/mais-comprados")
    public List<RelatorioItemMaisCompradosResponseDTO> buscarItensMaisComprados(){
        return service.buscarItensMaisComprados();
    }

    @GetMapping("/categorias/{listaId}")
    public List<RelatorioItemPorCategoriaResponseDTO> buscarItemPorCategoria(
        @PathVariable Long listaId
    ){
        return service.buscarItensPorCategoria(listaId);
    }

    @GetMapping("/mais-caros/{listaId}")
    public List<RelatorioItemMaisCaroResponseDTO> buscarItemMaisCaro(
        @PathVariable Long listaId
    ){
        return service.buscarItensMaisCaros(listaId);
    }

    @GetMapping("/mais-baratos/{listaId}")
    public List<RelatorioItemMaisBaratoResponseDTO> buscarItemMaisBarato(
        @PathVariable Long listaId
    ){
        return service.buscarItensMaisBaratos(listaId);
    }
}
