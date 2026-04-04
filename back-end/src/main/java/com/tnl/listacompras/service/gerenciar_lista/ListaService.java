package com.tnl.listacompras.service.gerenciar_lista;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.tnl.listacompras.dto.requestDTO.gerenciar_lista.ListaRequestDTO;
import com.tnl.listacompras.dto.responseDTO.gerenciar_lista.ItemResponseDTO;
import com.tnl.listacompras.dto.responseDTO.gerenciar_lista.ListaResponseDTO;
import com.tnl.listacompras.model.gerenciar_lista.Lista;
import com.tnl.listacompras.repository.gerenciar_lista.ListaRepository;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ListaService {

    @Autowired
    private ListaRepository listaRepository;

    @Autowired
    private ItemService itemService;

    // ---------------- CREATE ----------------
    public ListaResponseDTO criar(ListaRequestDTO dto) {
        Lista lista = new Lista();
        lista.setNome(dto.getNome());
        Lista listaSalva = listaRepository.save(lista);
        return toResponseDTO(listaSalva);
    }

    // ---------------- LIST ALL ----------------
    public List<ListaResponseDTO> listarTodos() {
        return listaRepository.findAll()
                .stream()
                .map(this::toResponseDTO)
                .collect(Collectors.toList());
    }

    // ---------------- GET BY ID ----------------
    public ListaResponseDTO buscarPorId(Long id) {
        Lista lista = listaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Lista não encontrada"));
        return toResponseDTO(lista);
    }

    // ---------------- UPDATE ----------------
    public ListaResponseDTO atualizar(Long id, ListaRequestDTO dto) {
        Lista listaAtualizada = listaRepository.findById(id)
                .map(lista -> {
                    lista.setNome(dto.getNome());
                    return listaRepository.save(lista);
                }).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Lista não encontrada"));
        return toResponseDTO(listaAtualizada);
    }

    // ---------------- DELETE ----------------
    public boolean deletar(Long id) {
        return listaRepository.findById(id)
                .map(lista -> {
                    listaRepository.delete(lista);
                    return true;
                }).orElse(false);
    }

    // ---------------- CONVERTER PARA RESPONSE ----------------
    private ListaResponseDTO toResponseDTO(Lista lista) {
        List<ItemResponseDTO> itensDTO = lista.getItens()
                .stream()
                .map(item -> itemService.buscarPorId(lista.getId(), item.getId()))
                .collect(Collectors.toList());

        return new ListaResponseDTO(
                lista.getId(),
                lista.getNome(),
                lista.getDataConclusao(),
                itensDTO
        );
    }
}