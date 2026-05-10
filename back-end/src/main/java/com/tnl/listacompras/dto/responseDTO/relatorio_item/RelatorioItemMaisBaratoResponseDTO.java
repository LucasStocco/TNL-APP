package com.tnl.listacompras.dto.responseDTO.relatorio_item;

public class RelatorioItemMaisBaratoResponseDTO {

    private String nomeProduto;
    private Double preco;

    public RelatorioItemMaisBaratoResponseDTO(String nomeProduto, Double preco) {
        this.nomeProduto = nomeProduto;
        this.preco = preco;
    }

    public String getNomeProduto() {
        return nomeProduto;
    }

    public Double getPreco() {
        return preco;
    }
}