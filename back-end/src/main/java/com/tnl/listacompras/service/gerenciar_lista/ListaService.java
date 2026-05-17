package com.tnl.listacompras.service.gerenciar_lista;
import com.tnl.listacompras.dto.responseDTO.gerenciar_lista.ListaResponseResumoDTO;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;

import com.tnl.listacompras.dto.requestDTO.gerenciar_lista.ListaRequestDTO;
import com.tnl.listacompras.dto.responseDTO.gerenciar_lista.ListaResponseDTO;
import com.tnl.listacompras.model.auto_cadastro.Usuario;
import com.tnl.listacompras.model.gerenciar_lista.Lista;
import com.tnl.listacompras.repository.gerenciar_lista.ListaRepository;
import com.tnl.listacompras.session.Session;
import com.tnl.listacompras.repository.gerenciar_lista.ItemRepository;
import exception.business.BusinessException;
import exception.business.NotFoundException;

@Service
public class ListaService {

    private final ListaRepository listaRepository;
    private final ItemRepository itemRepository;
    

    public ListaService(ListaRepository listaRepository, ItemRepository itemRepository) {
        this.listaRepository = listaRepository;
        this.itemRepository = itemRepository;
    }
    
    // =========================
    // SESSION
    // =========================
    private Long usuarioAtual() {
        return Session.getUsuarioId();
    }

    // =========================
    // HELPER SEGURANÇA
    // =========================
    private Lista buscarOuFalhar(Long id) {
        Long userId = usuarioAtual();

        return listaRepository.findById(id)
                .filter(l -> l.getUsuario().getId().equals(userId))
                .filter(l -> !Boolean.TRUE.equals(l.getDeletado()))
                .orElseThrow(() -> new NotFoundException("Lista não encontrada"));
    }

    // =========================
    // LISTAR
    // =========================
    public List<ListaResponseDTO> listar() {
        Long userId = usuarioAtual();

        return listaRepository.findAll()
                .stream()
                .filter(l -> l.getUsuario().getId().equals(userId))
                .filter(l -> !Boolean.TRUE.equals(l.getDeletado()))
                .map(this::toDTO)
                .toList();
    }

    // =========================
    // BUSCAR
    // =========================
    public ListaResponseDTO buscarPorId(Long id) {
        return toDTO(buscarOuFalhar(id));
    }

    // =========================
    // CRIAR
    // =========================
    public ListaResponseDTO criar(ListaRequestDTO dto) {

        Long userId = usuarioAtual();

        boolean existe = listaRepository.findAll()
                .stream()
                .anyMatch(l ->
                        l.getUsuario().getId().equals(userId) &&
                        l.getNome().equalsIgnoreCase(dto.getNome()) &&
                        !Boolean.TRUE.equals(l.getDeletado())
                );

        if (existe) {
            throw new BusinessException("Já existe uma lista com esse nome");
        }

        Lista lista = new Lista();
        lista.setNome(dto.getNome());

        Usuario usuario = new Usuario();
        usuario.setId(userId);

        lista.setUsuario(usuario);

        return toDTO(listaRepository.save(lista));
    }

    // =========================
    // ATUALIZAR
    // =========================
    public ListaResponseDTO atualizar(Long id, ListaRequestDTO dto) {

        Lista lista = buscarOuFalhar(id);

        lista.setNome(dto.getNome());

        return toDTO(listaRepository.save(lista));
    }

    // =========================
    // CONCLUIR
    // =========================
    public ListaResponseDTO concluir(Long id) {

        Lista lista = buscarOuFalhar(id);

        if (lista.getConcluidoEm() != null) {
            throw new BusinessException("Lista já concluída");
        }

        lista.setConcluidoEm(LocalDateTime.now());

        return toDTO(listaRepository.save(lista));
    }

    // =========================
    // REABRIR
    // =========================
    public ListaResponseDTO reabrir(Long id) {

        Lista lista = buscarOuFalhar(id);

        if (lista.getConcluidoEm() == null) {
            throw new BusinessException("Lista já está ativa");
        }

        lista.setConcluidoEm(null);

        return toDTO(listaRepository.save(lista));
    }

    // =========================
    // DELETE LÓGICO
    // =========================
    public void deletar(Long id) {

        Lista lista = buscarOuFalhar(id);

        lista.setDeletado(true);

        listaRepository.save(lista);
    }

    // =========================
    // MAPPER
    // =========================
    private ListaResponseDTO toDTO(Lista lista) {
        return new ListaResponseDTO(
                lista.getId(),
                lista.getNome(),
                lista.getCriadoEm(),
                lista.getAtualizadoEm(),
                lista.getConcluidoEm()
        );
    }
    // ================================
    // resumo de todas as listas do usuário, sem trazer tudo da lista (só dados essenciais).
    // =================================
    public List<ListaResponseResumoDTO> listarResumo() {

        Long userId = usuarioAtual();

        return listaRepository
                .findByUsuarioIdAndDeletadoFalse(userId)
                .stream()
                .map(lista -> {

                    int totalItens = itemRepository.contarItensAtivos(lista.getId());
                    int itensComprados = itemRepository.contarItensComprados(lista.getId());

                    return new ListaResponseResumoDTO(
                            lista.getId(),
                            lista.getNome(),
                            totalItens,
                            itensComprados
                    );
                })
                .toList();
    }

}