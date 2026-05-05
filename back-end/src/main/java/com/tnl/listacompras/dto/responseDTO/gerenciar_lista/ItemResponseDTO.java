package com.tnl.listacompras.dto.responseDTO.gerenciar_lista;

import java.time.LocalDateTime;

import com.tnl.listacompras.model.gerenciar_lista.Item;

public class ItemResponseDTO {

    private Long id;
    private Integer quantidade;
    private Boolean comprado;

    private Long produtoId;
    private String nomeProduto;

    private Long categoriaId;
    private String nomeCategoria;

    private Double preco; // 🔥 NOVO

    private LocalDateTime criadoEm;
    private LocalDateTime atualizadoEm;

    // =========================
    // CONSTRUTOR
    // =========================
    public ItemResponseDTO(Item item) {

        this.id = item.getId();
        this.quantidade = item.getQuantidade();
        this.comprado = item.getComprado();

        this.produtoId = item.getProduto().getId();
        this.nomeProduto = item.getProduto().getNome();

        if (item.getProduto().getCategoria() != null) {
            this.categoriaId = item.getProduto().getCategoria().getId();
            this.nomeCategoria = item.getProduto().getCategoria().getNome();
        }

        this.preco = item.getPreco(); // 🔥 IMPORTANTE

        this.criadoEm = item.getCriadoEm();
        this.atualizadoEm = item.getAtualizadoEm();
    }

    // =========================
    // GETTERS (ESSENCIAL)
    // =========================

    public Long getId() { return id; }

    public Integer getQuantidade() { return quantidade; }

    public Boolean getComprado() { return comprado; }

    public Long getProdutoId() { return produtoId; }

    public String getNomeProduto() { return nomeProduto; }

    public Long getCategoriaId() { return categoriaId; }

    public String getNomeCategoria() { return nomeCategoria; }

    public Double getPreco() { return preco; }

    public LocalDateTime getCriadoEm() { return criadoEm; }

    public LocalDateTime getAtualizadoEm() { return atualizadoEm; }
}