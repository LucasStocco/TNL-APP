package com.tnl.listacompras.dto.responseDTO.gerenciar_lista;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.tnl.listacompras.model.gerenciar_lista.Item;

public class ItemResponseDTO {

    private Long id;
    private Long idLista;

    private Integer quantidade;
    private Boolean comprado;

    // CONTROLE DE ORIGEM
    private Boolean isGlobalItem;

    // SNAPSHOT PRODUTO
    private String nomeProdutoSnapshot;
    private BigDecimal precoProdutoSnapshot;

    // SNAPSHOT CATEGORIA
    private Long idCategoria;
    private String nomeCategoriaSnapshot;
    private String codigoCategoriaSnapshot;

    // DERIVADOS
    private BigDecimal valorTotal;

    // AUDITORIA
    private LocalDateTime criadoEm;
    private LocalDateTime atualizadoEm;

    // =========================
    // CONSTRUTOR
    // =========================
    public ItemResponseDTO(Item item) {

        this.id = item.getId();
        this.idLista = item.getIdLista();

        this.quantidade = item.getQuantidade();
        this.comprado = item.getComprado();

        this.nomeProdutoSnapshot = item.getNomeProdutoSnapshot();
        this.precoProdutoSnapshot = item.getPrecoProdutoSnapshot();

        this.idCategoria = item.getIdCategoria();
        this.nomeCategoriaSnapshot = item.getNomeCategoriaSnapshot();
        this.codigoCategoriaSnapshot = item.getCodigoCategoriaSnapshot();

        this.criadoEm = item.getCriadoEm();
        this.atualizadoEm = item.getAtualizadoEm();

        this.valorTotal = item.getValorTotal();

        this.isGlobalItem = item.getIdProduto() != null;
    }

    // =========================
    // GETTERS
    // =========================

    public Long getId() {
        return id;
    }

    public Long getIdLista() {
        return idLista;
    }

    public Integer getQuantidade() {
        return quantidade;
    }

    public Boolean getComprado() {
        return comprado;
    }

    public Boolean getIsGlobalItem() {
        return isGlobalItem;
    }

    public String getNomeProdutoSnapshot() {
        return nomeProdutoSnapshot;
    }

    public BigDecimal getPrecoProdutoSnapshot() {
        return precoProdutoSnapshot;
    }

    public Long getIdCategoria() {
        return idCategoria;
    }

    public String getNomeCategoriaSnapshot() {
        return nomeCategoriaSnapshot;
    }

    public String getCodigoCategoriaSnapshot() {
        return codigoCategoriaSnapshot;
    }

    public BigDecimal getValorTotal() {
        return valorTotal;
    }

    public LocalDateTime getCriadoEm() {
        return criadoEm;
    }

    public LocalDateTime getAtualizadoEm() {
        return atualizadoEm;
    }
}