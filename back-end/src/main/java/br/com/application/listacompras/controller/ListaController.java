package br.com.application.listacompras.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import br.com.application.listacompras.dto.ListaRequestDTO;
import br.com.application.listacompras.dto.ListaResponseDTO;
import br.com.application.listacompras.service.ListaService;

import java.util.List;

@RestController
@RequestMapping("/listas")
public class ListaController {

    @Autowired
    private ListaService listaService;

    @PostMapping
    public ResponseEntity<ListaResponseDTO> criarLista(@RequestBody ListaRequestDTO dto) {
        return ResponseEntity.status(201).body(listaService.criar(dto));
    }

    @GetMapping
    public ResponseEntity<List<ListaResponseDTO>> listarTodas() {
        return ResponseEntity.ok(listaService.listarTodos());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ListaResponseDTO> buscarLista(@PathVariable Long id) {
        return ResponseEntity.ok(listaService.buscarPorId(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ListaResponseDTO> atualizarLista(@PathVariable Long id, @RequestBody ListaRequestDTO dto) {
        return ResponseEntity.ok(listaService.atualizar(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletarLista(@PathVariable Long id) {
        boolean deletado = listaService.deletar(id);
        return deletado ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }
}