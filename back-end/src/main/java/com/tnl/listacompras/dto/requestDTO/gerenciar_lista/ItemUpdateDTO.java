package com.tnl.listacompras.dto.requestDTO.gerenciar_lista;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public class ItemUpdateDTO {

    @NotNull
    @Min(1)
    private Integer quantidade;

    @NotNull
    @Min(0)
    private Double preco;

    // GETTERS
    public Integer getQuantidade() {
        return quantidade;
    }

    public Double getPreco() {
        return preco;
    }

    // SETTERS
    public void setQuantidade(Integer quantidade) {
        this.quantidade = quantidade;
    }

    public void setPreco(Double preco) {
        this.preco = preco;
    }
}