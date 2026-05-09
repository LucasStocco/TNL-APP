package com.tnl.listacompras.dto.responseDTO.relatorio_item;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.tnl.listacompras.dto.responseDTO.gerenciar_lista.ItemResponseDTO;

import java.util.List;
import java.util.Map;

public class RelatorioItemResponseDTO {

    private Long listaId;

    private List<ItemResponseDTO> todos;
    private List<ItemResponseDTO> comprados;
    private List<ItemResponseDTO> pendentes;

    private int totalItens;
    private int qtdComprados;
    private int qtdPendentes;

    private Double valorTotal;
    private Double valorComprado;
    private Double valorPendente;

    private Double progresso;

    @JsonProperty("totalPorCategoria")
    private Map<String, Double> totalPorCategoria;

    public RelatorioItemResponseDTO(
            Long listaId,
            List<ItemResponseDTO> todos,
            List<ItemResponseDTO> comprados,
            List<ItemResponseDTO> pendentes,
            int totalItens,
            int qtdComprados,
            int qtdPendentes,
            Double valorTotal,
            Double valorComprado,
            Double valorPendente,
            Double progresso,
            Map<String, Double> totalPorCategoria
    ) {
        this.listaId = listaId;
        this.todos = todos;
        this.comprados = comprados;
        this.pendentes = pendentes;
        this.totalItens = totalItens;
        this.qtdComprados = qtdComprados;
        this.qtdPendentes = qtdPendentes;
        this.valorTotal = valorTotal;
        this.valorComprado = valorComprado;
        this.valorPendente = valorPendente;
        this.progresso = progresso;
        this.totalPorCategoria = totalPorCategoria;
    }

    public Long getListaId() { return listaId; }
    public List<ItemResponseDTO> getTodos() { return todos; }
    public List<ItemResponseDTO> getComprados() { return comprados; }
    public List<ItemResponseDTO> getPendentes() { return pendentes; }
    public int getTotalItens() { return totalItens; }
    public int getQtdComprados() { return qtdComprados; }
    public int getQtdPendentes() { return qtdPendentes; }
    public Double getValorTotal() { return valorTotal; }
    public Double getValorComprado() { return valorComprado; }
    public Double getValorPendente() { return valorPendente; }
    public Double getProgresso() { return progresso; }
    public Map<String, Double> getTotalPorCategoria() { return totalPorCategoria; }
}