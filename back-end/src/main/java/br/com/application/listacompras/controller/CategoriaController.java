package br.com.application.listacompras.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import br.com.application.listacompras.dto.CategoriaRequestDTO;
import br.com.application.listacompras.dto.CategoriaResponseDTO;
import br.com.application.listacompras.service.CategoriaService;
import jakarta.validation.Valid;

import java.util.List;

@RestController
@RequestMapping("/categorias")
public class CategoriaController {

    @Autowired
    private CategoriaService categoriaService;

    @PostMapping
    public ResponseEntity<CategoriaResponseDTO> criarCategoria(
            @Valid @RequestBody CategoriaRequestDTO dto) {

        CategoriaResponseDTO nova = categoriaService.criar(dto);
        return ResponseEntity.status(201).body(nova);
    }

    @GetMapping
    public ResponseEntity<List<CategoriaResponseDTO>> listarCategorias() {
        return ResponseEntity.ok(categoriaService.listarTodos());
    }

    @GetMapping("/{id}")
    public ResponseEntity<CategoriaResponseDTO> buscarCategoria(@PathVariable Long id) {

        CategoriaResponseDTO categoria = categoriaService.buscarPorId(id);

        return categoria != null
                ? ResponseEntity.ok(categoria)
                : ResponseEntity.notFound().build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<CategoriaResponseDTO> atualizarCategoria(
            @PathVariable Long id,
            @Valid @RequestBody CategoriaRequestDTO dto) {

        CategoriaResponseDTO atualizada = categoriaService.atualizar(id, dto);

        return atualizada != null
                ? ResponseEntity.ok(atualizada)
                : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletarCategoria(@PathVariable Long id) {

        boolean deletado = categoriaService.deletar(id);

        return deletado
                ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }
}