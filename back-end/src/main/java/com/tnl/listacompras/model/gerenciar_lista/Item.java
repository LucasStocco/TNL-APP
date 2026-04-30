package com.tnl.listacompras.model.gerenciar_lista;

import com.tnl.listacompras.model.cadastrar_produto.Produto;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "itens")
public class Item {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Evita null no banco
    @Column(nullable = false)
    private Integer quantidade = 1;

    @Column(nullable = false)
    private Boolean comprado = false;

    @Column(nullable = false)
    private Boolean deletado = false;
    
    // Não pode ser null
    @Column(nullable = false)
    private Double preco;
    
   
    // Total automatico
    public Double getTotal() {
        if (preco == null || quantidade == null) return 0.0;
        return preco * quantidade;
    }

    // 📋 muitos itens → 1 lista
    @ManyToOne
    @JoinColumn(name = "lista_id", nullable = false)
    private Lista lista;

    // 🧾 muitos itens → 1 produto
    @ManyToOne
    @JoinColumn(name = "produto_id", nullable = false)
    private Produto produto;

    private LocalDateTime criadoEm;
    private LocalDateTime atualizadoEm;

    @PrePersist
    public void prePersist() {
        LocalDateTime agora = LocalDateTime.now();
        this.criadoEm = agora;
        this.atualizadoEm = agora;
    }

    @PreUpdate
    public void preUpdate() {
        this.atualizadoEm = LocalDateTime.now();
    }

    // ================= GETTERS / SETTERS =================

    public Long getId() {
        return id;
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

    public Double getPreco() {
        return preco;
    }

    public void setPreco(Double preco) {
        this.preco = preco;
    }

    public Lista getLista() {
        return lista;
    }

    public void setLista(Lista lista) {
        this.lista = lista;
    }

    public Produto getProduto() {
        return produto;
    }

    public void setProduto(Produto produto) {
        this.produto = produto;
    }

    public LocalDateTime getCriadoEm() {
        return criadoEm;
    }

    public LocalDateTime getAtualizadoEm() {
        return atualizadoEm;
    }
}