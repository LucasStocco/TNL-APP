package br.com.application.listacompras.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import br.com.application.listacompras.dto.ItemRequestDTO;
import br.com.application.listacompras.dto.ItemResponseDTO;
import br.com.application.listacompras.service.ItemService;

import java.util.List;

@RestController
@RequestMapping("/listas/{listaId}/itens")
public class ItemController {

    @Autowired
    private ItemService itemService;

    @PostMapping
    public ResponseEntity<ItemResponseDTO> criarItem(
            @PathVariable Long listaId,
            @RequestBody ItemRequestDTO itemDTO
    ) {
        return ResponseEntity.status(201).body(itemService.criar(listaId, itemDTO));
    }

    @GetMapping
    public ResponseEntity<List<ItemResponseDTO>> listarItens(@PathVariable Long listaId) {
        return ResponseEntity.ok(itemService.listarPorLista(listaId));
    }

    @GetMapping("/{itemId}")
    public ResponseEntity<ItemResponseDTO> buscarItem(
            @PathVariable Long listaId,
            @PathVariable Long itemId
    ) {
        return ResponseEntity.ok(itemService.buscarPorId(listaId, itemId));
    }

    @PutMapping("/{itemId}")
    public ResponseEntity<ItemResponseDTO> atualizarItem(
            @PathVariable Long listaId,
            @PathVariable Long itemId,
            @RequestBody ItemRequestDTO itemDTO
    ) {
        return ResponseEntity.ok(itemService.atualizar(listaId, itemId, itemDTO));
    }

    @DeleteMapping("/{itemId}")
    public ResponseEntity<Void> deletarItem(
            @PathVariable Long listaId,
            @PathVariable Long itemId
    ) {
        boolean deletado = itemService.deletar(listaId, itemId);
        return deletado ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }
}