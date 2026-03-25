package br.com.application.listacompras.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import br.com.application.listacompras.dto.ProdutoRequestDTO;
import br.com.application.listacompras.dto.ProdutoResponseDTO;
import br.com.application.listacompras.service.ProdutoService;
import jakarta.validation.Valid;

import java.util.List;

@RestController
@RequestMapping("/produtos")
public class ProdutoController {

    @Autowired
    private ProdutoService produtoService;

    @PostMapping
    public ResponseEntity<ProdutoResponseDTO> criarProduto(
            @Valid @RequestBody ProdutoRequestDTO dto) {

        ProdutoResponseDTO novo = produtoService.criar(dto);
        return ResponseEntity.status(201).body(novo);
    }

    @GetMapping
    public ResponseEntity<List<ProdutoResponseDTO>> listarProdutos() {
        return ResponseEntity.ok(produtoService.listarTodos());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProdutoResponseDTO> buscarProduto(@PathVariable Long id) {

        ProdutoResponseDTO produto = produtoService.buscarPorId(id);

        return produto != null
                ? ResponseEntity.ok(produto)
                : ResponseEntity.notFound().build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProdutoResponseDTO> atualizarProduto(
            @PathVariable Long id,
            @Valid @RequestBody ProdutoRequestDTO dto) {

        ProdutoResponseDTO atualizado = produtoService.atualizar(id, dto);

        return atualizado != null
                ? ResponseEntity.ok(atualizado)
                : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletarProduto(@PathVariable Long id) {

        boolean deletado = produtoService.deletar(id);

        return deletado
                ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }
}