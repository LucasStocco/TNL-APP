package com.tnl.listacompras.dto.responseDTO.gerenciar_lista;

import java.time.LocalDateTime;

public class ListaResponseDTO {

    private final Long id;
    private final String nome;

    private final LocalDateTime criadoEm;
    private final LocalDateTime atualizadoEm;
    private final LocalDateTime concluidoEm;

    private final boolean concluida;

    public ListaResponseDTO(Long id, String nome,
                            LocalDateTime criadoEm,
                            LocalDateTime atualizadoEm,
                            LocalDateTime concluidoEm) {

        this.id = id;
        this.nome = nome;
        this.criadoEm = criadoEm;
        this.atualizadoEm = atualizadoEm;
        this.concluidoEm = concluidoEm;
        this.concluida = concluidoEm != null;
    }

    public Long getId() { return id; }
    public String getNome() { return nome; }

    public LocalDateTime getCriadoEm() { return criadoEm; }
    public LocalDateTime getAtualizadoEm() { return atualizadoEm; }
    public LocalDateTime getConcluidoEm() { return concluidoEm; }

    public boolean isConcluida() { return concluida; }
}