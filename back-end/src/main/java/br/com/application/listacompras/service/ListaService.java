package br.com.application.listacompras.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import br.com.application.listacompras.dto.requestDTO.ListaRequestDTO;
import br.com.application.listacompras.dto.responseDTO.ItemResponseDTO;
import br.com.application.listacompras.dto.responseDTO.ListaResponseDTO;
import br.com.application.listacompras.model.Lista;
import br.com.application.listacompras.repository.ListaRepository;

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