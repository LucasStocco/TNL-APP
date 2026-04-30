package com.tnl.listacompras.controller.cadastrar_categoria;

import com.tnl.listacompras.dto.requestDTO.cadastrar_categoria.CategoriaRequestDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_categoria.CategoriaResponseDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_produto.ProdutoResponseDTO;
import com.tnl.listacompras.service.cadastrar_categoria.CategoriaService;

import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import response.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/categorias")
public class CategoriaController {

    private final CategoriaService service;

    public CategoriaController(CategoriaService service) {
        this.service = service;
    }

    // =========================
    // CREATE
    // =========================
    @PostMapping
    public ResponseEntity<ApiResponse<CategoriaResponseDTO>> criar(
            @Valid @RequestBody CategoriaRequestDTO dto) {

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Categoria criada", service.criar(dto)));
    }
    // Listar produtos de uma categoria
    @GetMapping("/{id}/produtos")
    public ResponseEntity<ApiResponse<List<ProdutoResponseDTO>>> listarProdutosPorCategoria(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Produtos da categoria carregados",
                        service.listarProdutosPorCategoria(id)
                )
        );
    }

    // =========================
    // READ ALL
    // =========================
    @GetMapping
    public ResponseEntity<ApiResponse<List<CategoriaResponseDTO>>> listar() {

        return ResponseEntity.ok(
                ApiResponse.success("Categorias carregadas", service.listar())
        );
    }

    // =========================
    // READ BY ID
    // =========================
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<CategoriaResponseDTO>> buscar(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                ApiResponse.success("Categoria encontrada", service.buscar(id))
        );
    }

    // =========================
    // UPDATE
    // =========================
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<CategoriaResponseDTO>> atualizar(
            @PathVariable Long id,
            @Valid @RequestBody CategoriaRequestDTO dto) {

        return ResponseEntity.ok(
                ApiResponse.success("Categoria atualizada", service.atualizar(id, dto))
        );
    }

    // =========================
    // DELETE (soft)
    // =========================
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deletar(@PathVariable Long id) {

        service.deletar(id);

        return ResponseEntity.ok(
                ApiResponse.success("Categoria deletada com sucesso", null)
        );
    }
}