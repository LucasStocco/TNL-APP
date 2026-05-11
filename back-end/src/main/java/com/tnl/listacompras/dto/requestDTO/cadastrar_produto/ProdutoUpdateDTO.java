package com.tnl.listacompras.dto.requestDTO.cadastrar_produto;

import jakarta.validation.constraints.NotBlank;

public class ProdutoUpdateDTO {

    @NotBlank
    private String nome;

    private String descricao;

    public String getNome() {
        return nome;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }
}