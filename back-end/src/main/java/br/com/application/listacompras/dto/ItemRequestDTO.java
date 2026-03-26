package br.com.application.listacompras.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Min;

public class ItemRequestDTO {

    private Long produtoId;

    @NotNull(message = "quantidade é obrigatória")
    @Min(value = 1, message = "quantidade deve ser no mínimo 1")
    private Integer quantidade;

    private Boolean comprado = false;

    public Long getProdutoId() { return produtoId; }
    public void setProdutoId(Long produtoId) { this.produtoId = produtoId; }

    public Integer getQuantidade() { return quantidade; }
    public void setQuantidade(Integer quantidade) { this.quantidade = quantidade; }

    public Boolean getComprado() { return comprado; }
    public void setComprado(Boolean comprado) { this.comprado = comprado; }
}