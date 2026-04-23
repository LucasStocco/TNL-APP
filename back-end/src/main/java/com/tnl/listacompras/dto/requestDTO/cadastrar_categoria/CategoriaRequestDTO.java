package com.tnl.listacompras.dto.requestDTO.cadastrar_categoria;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class CategoriaRequestDTO {

    @NotBlank
    @Size(max = 100)
    private String nome;

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }
}