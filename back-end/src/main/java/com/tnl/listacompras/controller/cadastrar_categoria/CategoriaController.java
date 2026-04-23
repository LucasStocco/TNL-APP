package com.tnl.listacompras.controller.cadastrar_categoria;

import com.tnl.listacompras.dto.requestDTO.cadastrar_categoria.CategoriaRequestDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_categoria.CategoriaResponseDTO;
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

    private final CategoriaService categoriaService;

    public CategoriaController(CategoriaService categoriaService) {
        this.categoriaService = categoriaService;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<CategoriaResponseDTO>>> listar() {
        return ResponseEntity.ok(
                ApiResponse.success("Categorias carregadas", categoriaService.listarTodos())
        );
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<CategoriaResponseDTO>> buscar(@PathVariable Long id) {
        return ResponseEntity.ok(
                ApiResponse.success("Categoria encontrada", categoriaService.buscarPorId(id))
        );
    }

    @PostMapping
    public ResponseEntity<ApiResponse<CategoriaResponseDTO>> criar(
            @RequestBody @Valid CategoriaRequestDTO dto) {

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Categoria criada", categoriaService.criar(dto)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<CategoriaResponseDTO>> atualizar(
            @PathVariable Long id,
            @RequestBody @Valid CategoriaRequestDTO dto) {

        return ResponseEntity.ok(
                ApiResponse.success("Categoria atualizada",
                        categoriaService.atualizarCategoria(id, dto))
        );
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deletar(@PathVariable Long id) {

        categoriaService.deletar(id);

        return ResponseEntity.ok(
                ApiResponse.success("Categoria deletada", null)
        );
    }
}