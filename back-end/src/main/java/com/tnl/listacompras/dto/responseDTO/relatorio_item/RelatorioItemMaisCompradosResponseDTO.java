package com.tnl.listacompras.dto.responseDTO.relatorio_item;

public class RelatorioItemMaisCompradosResponseDTO{
    private String nomeProduto;
    private Long quantidade;

    public RelatorioItemMaisCompradosResponseDTO(String nomeProduto, Long quantidade) {
    this.nomeProduto = nomeProduto;
    this.quantidade = quantidade;
    }

    public String getNomeProduto() {
    return nomeProduto;
    }

    public Long getQuantidade() {
    return quantidade;
    }

    
}