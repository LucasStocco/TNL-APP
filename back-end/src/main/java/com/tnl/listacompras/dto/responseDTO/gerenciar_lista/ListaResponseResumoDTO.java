package com.tnl.listacompras.dto.responseDTO.gerenciar_lista;

import com.fasterxml.jackson.annotation.JsonProperty;

public class ListaResponseResumoDTO {

    private Long id;
    private String nome;

    private Long totalItens;
    private Long itensComprados;

    public ListaResponseResumoDTO(
            Long id,
            String nome,
            Long totalItens,
            Long itensComprados
    ) {
        this.id = id;
        this.nome = nome;
        this.totalItens = totalItens;
        this.itensComprados = itensComprados;
    }

    @JsonProperty("progresso")
    public double getProgresso() {

        if (totalItens == 0) {
            return 0;
        }

        return ((double) itensComprados / totalItens) * 100;
    }

    public Long getId() {
        return id;
    }

    public String getNome() {
        return nome;
    }

    public Long getTotalItens() {
        return totalItens;
    }

    public Long getItensComprados() {
        return itensComprados;
    }
}