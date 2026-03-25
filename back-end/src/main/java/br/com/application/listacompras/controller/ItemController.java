package br.com.application.listacompras.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import br.com.application.listacompras.dto.ItemRequestDTO;
import br.com.application.listacompras.dto.ItemResponseDTO;
import br.com.application.listacompras.service.ItemService;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/listas/{listaId}/itens")
public class ItemController {

    @Autowired
    private ItemService itemService;

    // ---------------- CREATE ----------------
    @PostMapping
    public ResponseEntity<ItemResponseDTO> criarItem(
            @PathVariable Long listaId,
            @Valid @RequestBody ItemRequestDTO itemDTO
    ) {
        ItemResponseDTO novoItem = itemService.criar(listaId, itemDTO);
        return ResponseEntity.status(201).body(novoItem);
    }

    // ---------------- READ ALL ----------------
    @GetMapping
    public ResponseEntity<List<ItemResponseDTO>> listarItens(
            @PathVariable Long listaId
    ) {
        List<ItemResponseDTO> itens = itemService.listarPorLista(listaId);
        return ResponseEntity.ok(itens);
    }

    // ---------------- READ ONE ----------------
    @GetMapping("/{id}")
    public ResponseEntity<ItemResponseDTO> buscarPorId(
            @PathVariable Long listaId,
            @PathVariable Long id
    ) {
        ItemResponseDTO item = itemService.buscarPorId(listaId, id);

        return item != null
                ? ResponseEntity.ok(item)
                : ResponseEntity.notFound().build();
    }

    // ---------------- UPDATE ----------------
    @PutMapping("/{id}")
    public ResponseEntity<ItemResponseDTO> atualizarItem(
            @PathVariable Long listaId,
            @PathVariable Long id,
            @Valid @RequestBody ItemRequestDTO itemDTO
    ) {
        ItemResponseDTO atualizado = itemService.atualizar(listaId, id, itemDTO);

        return atualizado != null
                ? ResponseEntity.ok(atualizado)
                : ResponseEntity.notFound().build();
    }

    // ---------------- DELETE ----------------
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletarItem(
            @PathVariable Long listaId,
            @PathVariable Long id
    ) {
        boolean deletado = itemService.deletar(listaId, id);

        return deletado
                ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }
}