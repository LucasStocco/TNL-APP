package com.tnl.listacompras.dto.responseDTO.gerenciar_lista;

// Ele só muda como você entrega os dados para o Flutter
import com.fasterxml.jackson.annotation.JsonProperty;

public class ListaResponseResumoDTO {

    private Long id;
    private String nome;

    private int totalItens;
    private int itensComprados;

    public ListaResponseResumoDTO(Long id, String nome, int totalItens, int itensComprados) {
        this.id = id;
        this.nome = nome;
        this.totalItens = totalItens;
        this.itensComprados = itensComprados;
    }

    @JsonProperty("progresso")
    public double getProgresso() {
        if (totalItens == 0) return 0;
        return ((double) itensComprados / totalItens) * 100;
    }

    public Long getId() {
        return id;
    }

    public String getNome() {
        return nome;
    }

    public int getTotalItens() {
        return totalItens;
    }

    public int getItensComprados() {
        return itensComprados;
    }
}