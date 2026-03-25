package br.com.application.listacompras.dto;

import jakarta.validation.constraints.NotNull;

public class ItemRequestDTO {

    @NotNull(message = "O produto é obrigatório")
    private ProdutoRequestDTO produto;

    @NotNull(message = "A quantidade é obrigatória")
    private Integer quantidade;

    private Boolean comprado = false; // padrão falso

    // Getters e Setters
    public ProdutoRequestDTO getProduto() { return produto; }
    public void setProduto(ProdutoRequestDTO produto) { this.produto = produto; }

    public Integer getQuantidade() { return quantidade; }
    public void setQuantidade(Integer quantidade) { this.quantidade = quantidade; }

    public Boolean getComprado() { return comprado; }
    public void setComprado(Boolean comprado) { this.comprado = comprado; }
}

/*
 * Recebe dados do cliente para criar ou atualizar itens.
 */