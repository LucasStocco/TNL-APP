package br.com.application.listacompras.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import br.com.application.listacompras.dto.ItemResponseDTO;
import br.com.application.listacompras.dto.ListaRequestDTO;
import br.com.application.listacompras.dto.ListaResponseDTO;
import br.com.application.listacompras.model.Lista;
import br.com.application.listacompras.repository.ListaRepository;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ListaService {

    @Autowired
    private ListaRepository listaRepository;

    @Autowired
    private ItemService itemService;

    // LISTAR TODAS
    public List<ListaResponseDTO> listarTodas() {
        return listaRepository.findAll()
                .stream()
                .map(this::toResponseDTO)
                .collect(Collectors.toList());
    }

    // BUSCAR POR ID
    public Optional<ListaResponseDTO> buscarPorId(Long id) {
        return listaRepository.findById(id)
                .map(this::toResponseDTO);
    }

    // CRIAR
    public ListaResponseDTO criar(ListaRequestDTO dto) {
        Lista lista = new Lista();
        lista.setNome(dto.getNome());

        Lista salva = listaRepository.save(lista);
        return toResponseDTO(salva);
    }

    // ATUALIZAR
    public ListaResponseDTO atualizar(Long id, ListaRequestDTO dto) {
        return listaRepository.findById(id)
                .map(lista -> {
                    lista.setNome(dto.getNome());
                    Lista atualizada = listaRepository.save(lista);
                    return toResponseDTO(atualizada);
                }).orElse(null);
    }

    // DELETAR
    public boolean deletar(Long id) {
        return listaRepository.findById(id)
                .map(lista -> {
                    listaRepository.delete(lista);
                    return true;
                }).orElse(false);
    }

    // CONVERTER PARA RESPONSE
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