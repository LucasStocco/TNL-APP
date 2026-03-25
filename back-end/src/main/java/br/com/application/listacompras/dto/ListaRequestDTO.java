package br.com.application.listacompras.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class ListaRequestDTO {

    @NotBlank(message = "O nome da lista é obrigatório")
    @Size(max = 100, message = "O nome deve ter no máximo 100 caracteres")
    private String nome;

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
}