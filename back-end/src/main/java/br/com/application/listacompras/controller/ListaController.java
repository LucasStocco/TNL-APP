package br.com.application.listacompras.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import br.com.application.listacompras.dto.ListaRequestDTO;
import br.com.application.listacompras.dto.ListaResponseDTO;
import br.com.application.listacompras.service.ListaService;
import jakarta.validation.Valid;

import java.util.List;

@RestController
@RequestMapping("/listas")
public class ListaController {

    @Autowired
    private ListaService listaService;

    // CRIAR LISTA
    @PostMapping
    public ResponseEntity<ListaResponseDTO> criarLista(
            @Valid @RequestBody ListaRequestDTO dto) {

        ListaResponseDTO nova = listaService.criar(dto);
        return ResponseEntity.ok(nova);
    }

    // LISTAR TODAS
    @GetMapping
    public ResponseEntity<List<ListaResponseDTO>> listarListas() {
        return ResponseEntity.ok(listaService.listarTodas());
    }

    // BUSCAR POR ID
    @GetMapping("/{id}")
    public ResponseEntity<ListaResponseDTO> buscarLista(@PathVariable Long id) {

        return listaService.buscarPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // ATUALIZAR
    @PutMapping("/{id}")
    public ResponseEntity<ListaResponseDTO> atualizarLista(
            @PathVariable Long id,
            @Valid @RequestBody ListaRequestDTO dto) {

        ListaResponseDTO atualizada = listaService.atualizar(id, dto);

        return atualizada != null
                ? ResponseEntity.ok(atualizada)
                : ResponseEntity.notFound().build();
    }

    // DELETAR
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletarLista(@PathVariable Long id) {

        boolean deletado = listaService.deletar(id);

        return deletado
                ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }
}