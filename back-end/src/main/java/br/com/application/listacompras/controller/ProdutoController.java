package br.com.application.listacompras.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import br.com.application.listacompras.dto.requestDTO.ProdutoRequestDTO;
import br.com.application.listacompras.dto.responseDTO.ProdutoResponseDTO;
import br.com.application.listacompras.model.Produto;
import br.com.application.listacompras.service.ProdutoService;

import java.util.List;

@RestController
@RequestMapping("/produtos")
public class ProdutoController {

    @Autowired
    private ProdutoService produtoService;

    // ---------------- CREATE ----------------
    @PostMapping
    public ResponseEntity<ProdutoResponseDTO> criarProduto(@Valid @RequestBody ProdutoRequestDTO dto) {
        ProdutoResponseDTO novo = produtoService.criar(dto);
        return ResponseEntity.status(201).body(novo);
    }

    // ---------------- LIST ALL ----------------
    @GetMapping
    public ResponseEntity<List<ProdutoResponseDTO>> listarProdutos() {
        List<ProdutoResponseDTO> produtos = produtoService.listarTodos();
        return ResponseEntity.ok(produtos);
    }

    // ---------------- GET BY ID ----------------
    @GetMapping("/{id}")
    public ResponseEntity<ProdutoResponseDTO> buscarProduto(@PathVariable Long id) {
        Produto produto = produtoService.buscarEntidadePorId(id); // retorna Produto direto
        ProdutoResponseDTO dto = produtoService.converterParaDTO(produto);
        return ResponseEntity.ok(dto);
    }

    // ---------------- UPDATE ----------------
    @PutMapping("/{id}")
    public ResponseEntity<ProdutoResponseDTO> atualizarProduto(
            @PathVariable Long id,
            @Valid @RequestBody ProdutoRequestDTO dto) {

        ProdutoResponseDTO atualizado = produtoService.atualizar(id, dto);
        return ResponseEntity.ok(atualizado);
    }

    // ---------------- DELETE ----------------
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletarProduto(@PathVariable Long id) {
        boolean deletado = produtoService.deletar(id);
        return deletado
                ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }
}