package com.tnl.listacompras.controller.gerenciar_lista;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.tnl.listacompras.dto.requestDTO.gerenciar_lista.ItemRequestDTO;
import com.tnl.listacompras.dto.requestDTO.gerenciar_lista.ListaRequestDTO;
import com.tnl.listacompras.dto.responseDTO.gerenciar_lista.ItemResponseDTO;
import com.tnl.listacompras.dto.responseDTO.gerenciar_lista.ListaResponseDTO;
import com.tnl.listacompras.service.gerenciar_lista.ItemService;
import com.tnl.listacompras.service.gerenciar_lista.ListaService;

import java.util.List;

@RestController
@RequestMapping("/listas")
public class ListaController {

    @Autowired
    private ListaService listaService;

    @Autowired
    private ItemService itemService;

    // ------------------- LISTA -------------------
    @PostMapping
    public ResponseEntity<ListaResponseDTO> criarLista(@RequestBody ListaRequestDTO dto) {
        return ResponseEntity.status(201).body(listaService.criar(dto));
    }

    @GetMapping
    public ResponseEntity<List<ListaResponseDTO>> listarTodas() {
        return ResponseEntity.ok(listaService.listarTodos());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ListaResponseDTO> buscarLista(@PathVariable Long id) {
        return ResponseEntity.ok(listaService.buscarPorId(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ListaResponseDTO> atualizarLista(@PathVariable Long id, @RequestBody ListaRequestDTO dto) {
        return ResponseEntity.ok(listaService.atualizar(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletarLista(@PathVariable Long id) {
        boolean deletado = listaService.deletar(id);
        return deletado ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }

    // ------------------- ITENS (pertencem à lista) -------------------
    @PostMapping("/{listaId}/itens")
    public ResponseEntity<ItemResponseDTO> criarItem(
            @PathVariable Long listaId,
            @RequestBody ItemRequestDTO itemDTO
    ) {
        return ResponseEntity.status(201).body(itemService.criar(listaId, itemDTO));
    }

    @GetMapping("/{listaId}/itens")
    public ResponseEntity<List<ItemResponseDTO>> listarItens(@PathVariable Long listaId) {
        return ResponseEntity.ok(itemService.listarPorLista(listaId));
    }

    @GetMapping("/{listaId}/itens/{itemId}")
    public ResponseEntity<ItemResponseDTO> buscarItem(
            @PathVariable Long listaId,
            @PathVariable Long itemId
    ) {
        return ResponseEntity.ok(itemService.buscarPorId(listaId, itemId));
    }

    @PutMapping("/{listaId}/itens/{itemId}")
    public ResponseEntity<ItemResponseDTO> atualizarItem(
            @PathVariable Long listaId,
            @PathVariable Long itemId,
            @RequestBody ItemRequestDTO itemDTO
    ) {
        return ResponseEntity.ok(itemService.atualizar(listaId, itemId, itemDTO));
    }

    @DeleteMapping("/{listaId}/itens/{itemId}")
    public ResponseEntity<Void> deletarItem(
            @PathVariable Long listaId,
            @PathVariable Long itemId
    ) {
        boolean deletado = itemService.deletar(listaId, itemId);
        return deletado ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }
}