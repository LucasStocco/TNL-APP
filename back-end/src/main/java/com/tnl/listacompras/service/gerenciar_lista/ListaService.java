package com.tnl.listacompras.service.gerenciar_lista;

import org.springframework.stereotype.Service;

import com.tnl.listacompras.dto.requestDTO.gerenciar_lista.ListaRequestDTO;
import com.tnl.listacompras.dto.responseDTO.gerenciar_lista.ListaResponseDTO;
import com.tnl.listacompras.model.gerenciar_lista.Lista;
import com.tnl.listacompras.repository.gerenciar_lista.ListaRepository;
import com.tnl.listacompras.session.Session;

import exception.business.BusinessException;
import exception.business.NotFoundException;

import java.util.List;

@Service
public class ListaService {

    private final ListaRepository listaRepository;

    public ListaService(ListaRepository listaRepository) {
        this.listaRepository = listaRepository;
    }

    // =========================
    // SESSION
    // =========================
    private Long usuarioAtual() {
        return Session.getUsuarioId();
    }

    // =========================
    // HELPER
    // =========================
    private Lista buscarOuFalhar(Long id, Long idUsuario) {
        return listaRepository
                .findByIdAndIdUsuarioAndDeletadoFalse(id, idUsuario)
                .orElseThrow(() -> new NotFoundException("Lista não encontrada"));
    }

    // =========================
    // LISTAR
    // =========================
    public List<ListaResponseDTO> listar() {
        Long idUsuario = usuarioAtual();

        return listaRepository.findAllVisible(idUsuario)
                .stream()
                .map(this::toDTO)
                .toList();
    }

    // =========================
    // BUSCAR
    // =========================
    public ListaResponseDTO buscarPorId(Long id) {
        Long idUsuario = usuarioAtual();

        Lista lista = buscarOuFalhar(id, idUsuario);

        return toDTO(lista);
    }

    // =========================
    // CRIAR
    // =========================
    public ListaResponseDTO criar(ListaRequestDTO dto) {
        Long idUsuario = usuarioAtual();

        if (listaRepository.existsVisibleByName(dto.getNome(), idUsuario)) {
            throw new BusinessException("Lista já existe");
        }

        Lista lista = new Lista();
        lista.setNome(dto.getNome());
        lista.setIdUsuario(idUsuario);

        Lista saved = listaRepository.save(lista);

        return toDTO(saved);
    }

    // =========================
    // ✏️ ATUALIZAR (PUT - CORRIGIDO)
    // =========================
    public ListaResponseDTO atualizar(Long id, ListaRequestDTO dto) {

        Long idUsuario = usuarioAtual();

        Lista lista = buscarOuFalhar(id, idUsuario);

        // LOG importante pro debug Flutter
        System.out.println("✏️ ATUALIZANDO LISTA ID=" + id + " NOVO NOME=" + dto.getNome());

        lista.setNome(dto.getNome());

        Lista saved = listaRepository.save(lista);

        System.out.println("✔ LISTA ATUALIZADA: " + saved.getId() + " | " + saved.getNome());

        return toDTO(saved);
    }

    // =========================
    // CONCLUIR
    // =========================
    public ListaResponseDTO concluir(Long id) {
        Long idUsuario = usuarioAtual();

        Lista lista = buscarOuFalhar(id, idUsuario);

        if (lista.isConcluida()) {
            throw new BusinessException("Lista já está concluída");
        }

        lista.concluir();

        return toDTO(listaRepository.save(lista));
    }

    // =========================
    // REABRIR
    // =========================
    public ListaResponseDTO reabrir(Long id) {
        Long idUsuario = usuarioAtual();

        Lista lista = buscarOuFalhar(id, idUsuario);

        if (!lista.isConcluida()) {
            throw new BusinessException("Lista já está ativa");
        }

        lista.reabrir();

        return toDTO(listaRepository.save(lista));
    }

    // =========================
    // DELETAR
    // =========================
    public void deletar(Long id) {
        Long idUsuario = usuarioAtual();

        Lista lista = buscarOuFalhar(id, idUsuario);

        lista.deletar();

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
}