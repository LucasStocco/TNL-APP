package com.tnl.listacompras.dto.responseDTO.relatorio_item;

public class ItemMaisCompradoDTO {

    private String nomeProduto;
    private Long totalQuantidade;
    private Long frequencia;

    public ItemMaisCompradoDTO(String nomeProduto, Long totalQuantidade, Long frequencia) {
        this.nomeProduto = nomeProduto;
        this.totalQuantidade = totalQuantidade;
        this.frequencia = frequencia;
    }

    public String getNomeProduto() { return nomeProduto; }
    public Long getTotalQuantidade() { return totalQuantidade; }
    public Long getFrequencia() { return frequencia; }
}