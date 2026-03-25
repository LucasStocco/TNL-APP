package br.com.application.listacompras.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "itens")
public class Item {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private int quantidade;

    @Column(nullable = false)
    private Boolean comprado = false;

    // --- Relacionamento com Lista ---
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lista_id", nullable = false)
    @JsonIgnore
    private Lista lista;

    // --- Relacionamento com Produto ---
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "produto_id", nullable = false)
    private Produto produto;

    public Item() {}

    // --- Getters e Setters ---
    public Long getId() { return id; }

    public int getQuantidade() { return quantidade; }
    public void setQuantidade(int quantidade) { this.quantidade = quantidade; }

    public Boolean getComprado() { return comprado; }
    public void setComprado(Boolean comprado) { this.comprado = comprado; }

    public Lista getLista() { return lista; }
    public void setLista(Lista lista) { this.lista = lista; }

    public Produto getProduto() { return produto; }
    public void setProduto(Produto produto) { this.produto = produto; }

    // --- Novo método isComprado() ---
    public boolean isComprado() {
        return Boolean.TRUE.equals(this.comprado);
    }
}