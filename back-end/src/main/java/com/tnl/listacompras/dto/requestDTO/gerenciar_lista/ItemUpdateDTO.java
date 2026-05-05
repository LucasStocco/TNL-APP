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

    public Integer getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(Integer quantidade) {
        this.quantidade = quantidade;
    }

    public Double getPreco() {
        return preco;
    }

    public void setPreco(Double preco) {
        this.preco = preco;
    }
}