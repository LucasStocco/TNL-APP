package com.tnl.listacompras.dto.responseDTO.relatorio_item;

public class ItemRankingPrecoDTO {

    private String nomeProduto;
    private String nomeCategoria;
    private Double preco;

    public ItemRankingPrecoDTO(String nomeProduto, String nomeCategoria, Double preco) {
        this.nomeProduto = nomeProduto;
        this.nomeCategoria = nomeCategoria;
        this.preco = preco;
    }

    public String getNomeProduto() { return nomeProduto; }
    public String getNomeCategoria() { return nomeCategoria; }
    public Double getPreco() { return preco; }
}