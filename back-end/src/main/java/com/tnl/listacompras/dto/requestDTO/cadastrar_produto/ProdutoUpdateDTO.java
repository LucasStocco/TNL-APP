package com.tnl.listacompras.dto.requestDTO.cadastrar_produto;

import jakarta.validation.constraints.NotNull;

public class ProdutoUpdateDTO {

    @NotNull
    private String nome;

    private String descricao;

    // opcional se você tiver categoria no produto
    private Long categoriaId;

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public Long getCategoriaId() {
        return categoriaId;
    }

    public void setCategoriaId(Long categoriaId) {
        this.categoriaId = categoriaId;
    }
}