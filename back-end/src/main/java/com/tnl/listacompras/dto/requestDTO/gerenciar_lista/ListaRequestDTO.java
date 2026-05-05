package com.tnl.listacompras.dto.requestDTO.gerenciar_lista;

import jakarta.validation.constraints.NotBlank;

public class ListaRequestDTO {

    @NotBlank
    private String nome;

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
}