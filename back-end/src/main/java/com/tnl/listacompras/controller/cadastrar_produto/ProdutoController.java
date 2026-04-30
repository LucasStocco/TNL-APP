package com.tnl.listacompras.controller.cadastrar_produto;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.tnl.listacompras.dto.requestDTO.cadastrar_produto.ProdutoRequestDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_produto.ProdutoResponseDTO;
import com.tnl.listacompras.service.cadastrar_produto.ProdutoService;

import jakarta.validation.Valid;
import response.ApiResponse;

@RestController
@RequestMapping("/produtos")
public class ProdutoController {

    private final ProdutoService produtoService;

    public ProdutoController(ProdutoService produtoService) {
        this.produtoService = produtoService;
    }

    @PostMapping
    public ResponseEntity<ApiResponse<ProdutoResponseDTO>> criar(
            @Valid @RequestBody ProdutoRequestDTO dto) {

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Produto criado", produtoService.criar(dto)));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<ProdutoResponseDTO>>> listar() {
        return ResponseEntity.ok(
                ApiResponse.success("Produtos carregados", produtoService.listar())
        );
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ProdutoResponseDTO>> buscar(@PathVariable Long id) {
        return ResponseEntity.ok(
                ApiResponse.success("Produto encontrado", produtoService.buscar(id))
        );
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<ProdutoResponseDTO>> atualizar(
            @PathVariable Long id,
            @Valid @RequestBody ProdutoRequestDTO dto) {

        return ResponseEntity.ok(
                ApiResponse.success("Produto atualizado", produtoService.atualizar(id, dto))
        );
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deletar(@PathVariable Long id) {

        produtoService.deletar(id);

        return ResponseEntity.ok(
                ApiResponse.success("Produto deletado", null)
        );
    }
}