package com.tnl.listacompras.model.gerenciar_lista;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "itens")
public class Item {

    // =========================
    // ID
    // =========================
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // =========================
    // RELAÇÕES
    // =========================
    @Column(name = "lista_id", nullable = false)
    private Long idLista;

    @Column(name = "produto_id")
    private Long idProduto;

    @Column(name = "categoria_id", nullable = false)
    private Long idCategoria;

    // =========================
    // DADOS
    // =========================
    @Column(nullable = false)
    private Integer quantidade = 1;

    @Column(nullable = false)
    private Boolean comprado = false;

    @Column(nullable = false)
    private Boolean deletado = false;

    // =========================
    // SNAPSHOT
    // =========================
    @Column(name = "nome_produto_snapshot", nullable = false)
    private String nomeProdutoSnapshot;

    @Column(name = "preco_produto_snapshot", nullable = false)
    private BigDecimal precoProdutoSnapshot;

    @Column(name = "nome_categoria_snapshot", nullable = false)
    private String nomeCategoriaSnapshot;

    @Column(name = "codigo_categoria_snapshot", nullable = false)
    private String codigoCategoriaSnapshot;

    // =========================
    // TEMPO
    // =========================
    @Column(name = "criado_em", nullable = false, updatable = false)
    private LocalDateTime criadoEm;

    @Column(name = "atualizado_em", nullable = false)
    private LocalDateTime atualizadoEm;

    // =========================
    // LIFECYCLE
    // =========================
    @PrePersist
    protected void onCreate() {
        this.criadoEm = LocalDateTime.now();
        this.atualizadoEm = LocalDateTime.now();

        this.comprado = this.comprado != null ? this.comprado : false;
        this.deletado = this.deletado != null ? this.deletado : false;
        this.quantidade = this.quantidade != null ? this.quantidade : 1;

        // 🔥 GARANTE CONSISTÊNCIA COM nullable = false
        if (this.precoProdutoSnapshot == null) {
            this.precoProdutoSnapshot = BigDecimal.ZERO;
        }

        if (this.nomeProdutoSnapshot == null) {
            this.nomeProdutoSnapshot = "";
        }

        if (this.nomeCategoriaSnapshot == null) {
            this.nomeCategoriaSnapshot = "";
        }

        if (this.codigoCategoriaSnapshot == null) {
            this.codigoCategoriaSnapshot = "";
        }
    }

    @PreUpdate
    protected void onUpdate() {
        this.atualizadoEm = LocalDateTime.now();
    }

    // =========================
    // REGRA DE NEGÓCIO (SAFE)
    // =========================
    public BigDecimal getValorTotal() {
        if (precoProdutoSnapshot == null || quantidade == null) {
            return BigDecimal.ZERO;
        }

        return precoProdutoSnapshot.multiply(BigDecimal.valueOf(quantidade));
    }

    // =========================
    // GETTERS E SETTERS
    // =========================

    public Long getId() {
        return id;
    }

    public Long getIdLista() {
        return idLista;
    }

    public void setIdLista(Long idLista) {
        this.idLista = idLista;
    }

    public Long getIdProduto() {
        return idProduto;
    }

    public void setIdProduto(Long idProduto) {
        this.idProduto = idProduto;
    }

    public Long getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(Long idCategoria) {
        this.idCategoria = idCategoria;
    }

    public Integer getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(Integer quantidade) {
        this.quantidade = quantidade;
    }

    public Boolean getComprado() {
        return comprado;
    }

    public void setComprado(Boolean comprado) {
        this.comprado = comprado;
    }

    public Boolean getDeletado() {
        return deletado;
    }

    public void setDeletado(Boolean deletado) {
        this.deletado = deletado;
    }

    public String getNomeProdutoSnapshot() {
        return nomeProdutoSnapshot;
    }

    public void setNomeProdutoSnapshot(String nomeProdutoSnapshot) {
        this.nomeProdutoSnapshot = nomeProdutoSnapshot;
    }

    public BigDecimal getPrecoProdutoSnapshot() {
        return precoProdutoSnapshot;
    }

    public void setPrecoProdutoSnapshot(BigDecimal precoProdutoSnapshot) {
        this.precoProdutoSnapshot = precoProdutoSnapshot;
    }

    public String getNomeCategoriaSnapshot() {
        return nomeCategoriaSnapshot;
    }

    public void setNomeCategoriaSnapshot(String nomeCategoriaSnapshot) {
        this.nomeCategoriaSnapshot = nomeCategoriaSnapshot;
    }

    public String getCodigoCategoriaSnapshot() {
        return codigoCategoriaSnapshot;
    }

    public void setCodigoCategoriaSnapshot(String codigoCategoriaSnapshot) {
        this.codigoCategoriaSnapshot = codigoCategoriaSnapshot;
    }

    public LocalDateTime getCriadoEm() {
        return criadoEm;
    }

    public void setCriadoEm(LocalDateTime criadoEm) {
        this.criadoEm = criadoEm;
    }

    public LocalDateTime getAtualizadoEm() {
        return atualizadoEm;
    }

    public void setAtualizadoEm(LocalDateTime atualizadoEm) {
        this.atualizadoEm = atualizadoEm;
    }
}