package com.tnl.listacompras.controller.gerenciar_lista;

import com.tnl.listacompras.dto.requestDTO.gerenciar_lista.*;
import com.tnl.listacompras.dto.responseDTO.gerenciar_lista.*;
import com.tnl.listacompras.model.gerenciar_lista.Item;
import com.tnl.listacompras.service.gerenciar_lista.ItemService;
import com.tnl.listacompras.service.gerenciar_lista.ListaService;

import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import response.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/listas")
public class ListaController {

    private final ListaService listaService;
    private final ItemService itemService;

    public ListaController(ListaService listaService, ItemService itemService) {
        this.listaService = listaService;
        this.itemService = itemService;
    }

    // =========================
    // LISTA (CRUD)
    // =========================

    @PostMapping
    public ResponseEntity<ApiResponse<ListaResponseDTO>> criar(
            @Valid @RequestBody ListaRequestDTO dto) {

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Lista criada", listaService.criar(dto)));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<ListaResponseDTO>>> listar() {
        return ResponseEntity.ok(
                ApiResponse.success("Listas carregadas", listaService.listar())
        );
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ListaResponseDTO>> buscar(@PathVariable Long id) {
        return ResponseEntity.ok(
                ApiResponse.success("Lista encontrada", listaService.buscarPorId(id))
        );
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<ListaResponseDTO>> atualizar(
            @PathVariable Long id,
            @Valid @RequestBody ListaRequestDTO dto) {

        return ResponseEntity.ok(
                ApiResponse.success("Lista atualizada", listaService.atualizar(id, dto))
        );
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deletar(@PathVariable Long id) {

        listaService.deletar(id);

        return ResponseEntity.ok(
                ApiResponse.success("Lista deletada com sucesso", null)
        );
    }

    // =========================
    // ITENS (dentro da lista)
    // =========================

    @GetMapping("/{idLista}/itens")
    public ResponseEntity<ApiResponse<List<ItemResponseDTO>>> listarItens(
            @PathVariable Long idLista) {

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Itens carregados",
                        itemService.listarPorLista(idLista)
                )
        );
    }

    @PostMapping("/{idLista}/itens")
    public ResponseEntity<ApiResponse<ItemResponseDTO>> criarItem(
            @PathVariable Long idLista,
            @Valid @RequestBody ItemRequestDTO dto) {

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(
                        "Item criado",
                        itemService.criar(idLista, dto)
                ));
    }

    @PutMapping("/{idLista}/itens/{idItem}")
    public ResponseEntity<ApiResponse<ItemResponseDTO>> atualizarItem(
            @PathVariable Long idLista,
            @PathVariable Long idItem,
            @Valid @RequestBody ItemUpdateDTO dto) {

        ItemResponseDTO itemAtualizado =
                itemService.atualizar(idLista, idItem, dto);

        return ResponseEntity.ok(
                ApiResponse.success("Item atualizado", itemAtualizado)
        );
    }
    
    @PatchMapping("/{idLista}/itens/{idItem}/comprado")
    public ResponseEntity<ApiResponse<Void>> marcarComprado(
            @PathVariable Long idLista,
            @PathVariable Long idItem) {

        itemService.marcarComprado(idLista, idItem);

        return ResponseEntity.ok(
                ApiResponse.success("Item marcado como comprado", null)
        );
    }

    @PatchMapping("/{idLista}/itens/{idItem}/desmarcar")
    public ResponseEntity<ApiResponse<Void>> desmarcarComprado(
            @PathVariable Long idLista,
            @PathVariable Long idItem) {

        itemService.desmarcarComprado(idLista, idItem);

        return ResponseEntity.ok(
                ApiResponse.success("Item desmarcado", null)
        );
    }

    @DeleteMapping("/{idLista}/itens/{idItem}")
    public ResponseEntity<ApiResponse<Void>> deletarItem(
            @PathVariable Long idLista,
            @PathVariable Long idItem) {

        itemService.deletar(idLista, idItem);

        return ResponseEntity.ok(
                ApiResponse.success("Item deletado", null)
        );
    }
}