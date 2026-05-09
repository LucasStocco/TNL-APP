package com.tnl.listacompras.service.relatorio_item;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.tnl.listacompras.dto.responseDTO.gerenciar_lista.ItemResponseDTO;
import com.tnl.listacompras.dto.responseDTO.relatorio_item.RelatorioItemResponseDTO;
import com.tnl.listacompras.model.gerenciar_lista.Lista;
import com.tnl.listacompras.repository.gerenciar_lista.ListaRepository;
import com.tnl.listacompras.repository.relatorio_item.RelatorioItemRepository;
import com.tnl.listacompras.session.Session;

import exception.business.NotFoundException;

@Service
public class RelatorioItemService {

    private final RelatorioItemRepository relatorioItemRepository;
    private final ListaRepository listaRepository;

    public RelatorioItemService(RelatorioItemRepository relatorioItemRepository,
                                ListaRepository listaRepository) {
        this.relatorioItemRepository = relatorioItemRepository;
        this.listaRepository = listaRepository;
    }

    // =========================
    // HELPER SEGURANÇA
    // =========================
    private Lista validarLista(Long listaId) {
        Long userId = Session.getUsuarioId();

        return listaRepository.findById(listaId)
                .filter(l -> l.getUsuario().getId().equals(userId))
                .filter(l -> !Boolean.TRUE.equals(l.getDeletado()))
                .orElseThrow(() -> new NotFoundException("Lista não encontrada"));
    }

    // =========================
    // RELATÓRIO COMPLETO
    // =========================
    public RelatorioItemResponseDTO gerarRelatorio(Long listaId) {

        validarLista(listaId);

        List<ItemResponseDTO> todosItens = relatorioItemRepository
                .findByListaIdAndDeletadoFalse(listaId)
                .stream()
                .map(ItemResponseDTO::new)
                .toList();

        List<ItemResponseDTO> itensComprados = relatorioItemRepository
                .findByListaIdAndCompradoTrueAndDeletadoFalse(listaId)
                .stream()
                .map(ItemResponseDTO::new)
                .toList();

        List<ItemResponseDTO> itensPendentes = relatorioItemRepository
                .findByListaIdAndCompradoFalseAndDeletadoFalse(listaId)
                .stream()
                .map(ItemResponseDTO::new)
                .toList();

        double valorTotal    = relatorioItemRepository.somarTotalLista(listaId);
        double valorComprado = relatorioItemRepository.somarTotalComprado(listaId);
        double valorPendente = relatorioItemRepository.somarTotalPendente(listaId);

        int totalItens   = relatorioItemRepository.contarItensAtivos(listaId);
        int qtdComprados = relatorioItemRepository.contarItensComprados(listaId);
        int qtdPendentes = relatorioItemRepository.contarItensPendentes(listaId);

        double progresso = totalItens == 0 ? 0.0
                : ((double) qtdComprados / totalItens) * 100;

        Map<String, Double> totalPorCategoria = relatorioItemRepository
                .totalPorCategoria(listaId)
                .stream()
                .collect(Collectors.toMap(
                        row -> (String) row[0],
                        row -> (Double) row[1]
                ));

        return new RelatorioItemResponseDTO(
                listaId,
                todosItens,
                itensComprados,
                itensPendentes,
                totalItens,
                qtdComprados,
                qtdPendentes,
                valorTotal,
                valorComprado,
                valorPendente,
                progresso,
                totalPorCategoria
        );
    }

    // =========================
    // LISTAR POR STATUS
    // =========================
    public List<ItemResponseDTO> listarComprados(Long listaId) {
        validarLista(listaId);
        return relatorioItemRepository
                .findByListaIdAndCompradoTrueAndDeletadoFalse(listaId)
                .stream()
                .map(ItemResponseDTO::new)
                .toList();
    }

    public List<ItemResponseDTO> listarPendentes(Long listaId) {
        validarLista(listaId);
        return relatorioItemRepository
                .findByListaIdAndCompradoFalseAndDeletadoFalse(listaId)
                .stream()
                .map(ItemResponseDTO::new)
                .toList();
    }

    public List<ItemResponseDTO> listarPorCategoria(Long listaId, Long categoriaId) {
        validarLista(listaId);
        return relatorioItemRepository
                .findByListaIdAndCategoriaId(listaId, categoriaId)
                .stream()
                .map(ItemResponseDTO::new)
                .toList();
    }

    // =========================
    // MÉTRICAS ISOLADAS
    // =========================
    public double valorTotal(Long listaId) {
        validarLista(listaId);
        return relatorioItemRepository.somarTotalLista(listaId);
    }

    public Map<String, Double> valorPorCategoria(Long listaId) {
        validarLista(listaId);
        return relatorioItemRepository
                .totalPorCategoria(listaId)
                .stream()
                .collect(Collectors.toMap(
                        row -> (String) row[0],
                        row -> (Double) row[1]
                ));
    }
}