package br.com.application.listacompras.dto;

import java.time.LocalDateTime;
import java.util.List;

public class ListaResponseDTO {

    private Long id;
    private String nome;
    private LocalDateTime dataConclusao;
    private List<ItemResponseDTO> itens;

    public ListaResponseDTO() {}

    public ListaResponseDTO(Long id, String nome, LocalDateTime dataConclusao, List<ItemResponseDTO> itens) {
        this.id = id;
        this.nome = nome;
        this.dataConclusao = dataConclusao;
        this.itens = itens;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public LocalDateTime getDataConclusao() { return dataConclusao; }
    public void setDataConclusao(LocalDateTime dataConclusao) { this.dataConclusao = dataConclusao; }

    public List<ItemResponseDTO> getItens() { return itens; }
    public void setItens(List<ItemResponseDTO> itens) { this.itens = itens; }
}