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

    // ================= CRIAR =================
    @PostMapping
    public ResponseEntity<ApiResponse<ProdutoResponseDTO>> criar(
            @Valid @RequestBody ProdutoRequestDTO dto
    ) {

        ProdutoResponseDTO produto = produtoService.criar(dto);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ApiResponse.success("Produto criado com sucesso", produto));
    }

    // ================= LISTAR TODOS =================
    @GetMapping
    public ResponseEntity<ApiResponse<List<ProdutoResponseDTO>>> listar() {

        List<ProdutoResponseDTO> lista = produtoService.listarTodos();

        return ResponseEntity.ok(
                ApiResponse.success("Produtos listados com sucesso", lista)
        );
    }

    // ================= BUSCAR POR ID =================
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ProdutoResponseDTO>> buscar(
            @PathVariable Long id
    ) {

        ProdutoResponseDTO produto = produtoService.buscarPorId(id);

        return ResponseEntity.ok(
                ApiResponse.success("Produto encontrado", produto)
        );
    }

    // ================= LISTAR POR CATEGORIA 🔥 =================
    @GetMapping("/categoria/{idCategoria}")
    public ResponseEntity<ApiResponse<List<ProdutoResponseDTO>>> listarPorCategoria(
            @PathVariable Long idCategoria
    ) {

        List<ProdutoResponseDTO> lista =
                produtoService.listarPorCategoria(idCategoria);

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Produtos da categoria carregados",
                        lista
                )
        );
    }

    // ================= ATUALIZAR =================
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<ProdutoResponseDTO>> atualizar(
            @PathVariable Long id,
            @Valid @RequestBody ProdutoRequestDTO dto
    ) {

        ProdutoResponseDTO atualizado =
                produtoService.atualizar(id, dto);

        return ResponseEntity.ok(
                ApiResponse.success("Produto atualizado com sucesso", atualizado)
        );
    }

    // ================= DELETAR =================
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deletar(
            @PathVariable Long id
    ) {

        produtoService.deletar(id);

        return ResponseEntity.ok(
                ApiResponse.success("Produto deletado com sucesso", null)
        );
    }
}