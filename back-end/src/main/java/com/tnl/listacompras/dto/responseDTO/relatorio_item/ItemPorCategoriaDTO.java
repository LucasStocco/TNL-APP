package com.tnl.listacompras.dto.responseDTO.relatorio_item;

public class ItemPorCategoriaDTO {

    private String nomeCategoria;
    private Long totalItens;
    private Long totalQuantidade;
    private Double totalGasto;

    public ItemPorCategoriaDTO(String nomeCategoria, Long totalItens, Long totalQuantidade, Double totalGasto) {
        this.nomeCategoria = nomeCategoria;
        this.totalItens = totalItens;
        this.totalQuantidade = totalQuantidade;
        this.totalGasto = totalGasto;
    }

    public String getNomeCategoria() { return nomeCategoria; }
    public Long getTotalItens() { return totalItens; }
    public Long getTotalQuantidade() { return totalQuantidade; }
    public Double getTotalGasto() { return totalGasto; }
}