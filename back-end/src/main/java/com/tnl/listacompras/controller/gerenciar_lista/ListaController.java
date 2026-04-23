package com.tnl.listacompras.controller.gerenciar_lista;

import java.util.List;

import com.tnl.listacompras.dto.requestDTO.gerenciar_lista.*;
import com.tnl.listacompras.dto.responseDTO.gerenciar_lista.*;
import com.tnl.listacompras.service.gerenciar_lista.ItemService;
import com.tnl.listacompras.service.gerenciar_lista.ListaService;

import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import response.ApiResponse;

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
    // LISTAS
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

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deletar(@PathVariable Long id) {

        listaService.deletar(id);

        return ResponseEntity.ok(
                ApiResponse.success("Lista deletada com sucesso", null)
        );
    }

    // =========================
    // ITENS
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

    @GetMapping("/{idLista}/itens/categoria/{idCategoria}")
    public ResponseEntity<ApiResponse<List<ItemResponseDTO>>> listarPorCategoria(
            @PathVariable Long idLista,
            @PathVariable Long idCategoria) {

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Itens da categoria carregados",
                        itemService.buscarPorCategoria(idLista, idCategoria)
                )
        );
    }

    // =========================
    // CREATE ITEM MANUAL
    // =========================

    @PostMapping("/{idLista}/itens/manual")
    public ResponseEntity<ApiResponse<ItemResponseDTO>> criarManual(
            @PathVariable Long idLista,
            @Valid @RequestBody ItemManualRequestDTO dto) {

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(
                        "Item criado",
                        itemService.criarManual(idLista, dto)
                ));
    }

    // =========================
    // CREATE ITEM GLOBAL
    // =========================

    @PostMapping("/{idLista}/itens/global")
    public ResponseEntity<ApiResponse<ItemResponseDTO>> criarGlobal(
            @PathVariable Long idLista,
            @Valid @RequestBody ItemGlobalRequestDTO dto) {

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(
                        "Item global criado",
                        itemService.criarGlobal(idLista, dto)
                ));
    }

    // =========================
    // UPDATE ITEM
    // =========================

    @PutMapping("/{idLista}/itens/{idItem}")
    public ResponseEntity<ApiResponse<ItemResponseDTO>> atualizarItem(
            @PathVariable Long idLista,
            @PathVariable Long idItem,
            @Valid @RequestBody ItemUpdateDTO dto) {

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Item atualizado",
                        itemService.atualizar(idLista, idItem, dto)
                )
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

    // =========================
    // COMPRADO
    // =========================

    @PatchMapping("/{idLista}/itens/{idItem}/comprado")
    public ResponseEntity<ApiResponse<Void>> marcarComprado(
            @PathVariable Long idLista,
            @PathVariable Long idItem) {

        itemService.marcarComprado(idLista, idItem);

        return ResponseEntity.ok(
                ApiResponse.success("Status atualizado", null)
        );
    }
    

    // =========================
    // DELETE ITEM
    // =========================

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