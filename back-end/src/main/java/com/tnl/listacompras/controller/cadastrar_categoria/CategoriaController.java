package com.tnl.listacompras.controller.cadastrar_categoria;

import com.tnl.listacompras.dto.requestDTO.cadastrar_categoria.CategoriaRequestDTO;
import com.tnl.listacompras.dto.requestDTO.cadastrar_categoria.SubcategoriaRequestDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_categoria.CategoriaCompletaResponseDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_categoria.CategoriaResponseDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_categoria.SubcategoriaResponseDTO;
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
    // CATEGORIA
    // =========================

    @PostMapping
    public ResponseEntity<ApiResponse<CategoriaResponseDTO>> criar(
            @Valid @RequestBody CategoriaRequestDTO dto) {

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Categoria criada", service.criar(dto)));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<CategoriaResponseDTO>>> listar() {
        return ResponseEntity.ok(
                ApiResponse.success("Categorias carregadas", service.listar())
        );
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<CategoriaResponseDTO>> buscar(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                ApiResponse.success("Categoria encontrada", service.buscar(id))
        );
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<CategoriaResponseDTO>> atualizar(
            @PathVariable Long id,
            @Valid @RequestBody CategoriaRequestDTO dto) {

        return ResponseEntity.ok(
                ApiResponse.success("Categoria atualizada", service.atualizar(id, dto))
        );
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deletar(@PathVariable Long id) {

        service.deletar(id);

        return ResponseEntity.ok(
                ApiResponse.success("Categoria deletada com sucesso", null)
        );
    }

    // =========================
    // SUBCATEGORIA (CRUD COMPLETO)
    // =========================

    @PostMapping("/{id}/subcategorias")
    public ResponseEntity<ApiResponse<SubcategoriaResponseDTO>> criarSubcategoria(
            @PathVariable Long id,
            @RequestBody SubcategoriaRequestDTO dto) {

        return ResponseEntity.status(HttpStatus.CREATED).body(
                ApiResponse.success(
                        "Subcategoria criada",
                        service.criarSubcategoria(id, dto)
                )
        );
    }

    @GetMapping("/{id}/subcategorias")
    public ResponseEntity<ApiResponse<List<SubcategoriaResponseDTO>>> listarSubcategorias(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Subcategorias da categoria carregadas",
                        service.listarSubcategoriasPorCategoria(id)
                )
        );
    }

    @PutMapping("/{idCategoria}/subcategorias/{idSubcategoria}")
    public ResponseEntity<ApiResponse<SubcategoriaResponseDTO>> atualizarSubcategoria(
            @PathVariable Long idCategoria,
            @PathVariable Long idSubcategoria,
            @RequestBody SubcategoriaRequestDTO dto) {

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Subcategoria atualizada",
                        service.atualizarSubcategoria(idCategoria, idSubcategoria, dto)
                )
        );
    }
    
    @GetMapping("/{id}/completo")
    public ResponseEntity<ApiResponse<CategoriaCompletaResponseDTO>> buscarCompleto(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Categoria completa carregada",
                        service.buscarCategoriaCompleta(id)
                )
        );
    }

    @DeleteMapping("/{idCategoria}/subcategorias/{idSubcategoria}")
    public ResponseEntity<ApiResponse<Void>> deletarSubcategoria(
            @PathVariable Long idCategoria,
            @PathVariable Long idSubcategoria) {

        service.deletarSubcategoria(idCategoria, idSubcategoria);

        return ResponseEntity.ok(
                ApiResponse.success("Subcategoria deletada", null)
        );
    }

    // =========================
    // PRODUTOS DA CATEGORIA
    // =========================

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
}