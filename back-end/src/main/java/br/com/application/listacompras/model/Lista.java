package br.com.application.listacompras.model;

import java.util.ArrayList;
import java.util.List;
import java.time.LocalDateTime;
import jakarta.persistence.*;

@Entity
public class Lista {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;

    @Column(name = "data_conclusao")
    private LocalDateTime dataConclusao;

    @OneToMany(mappedBy = "lista", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Item> itens = new ArrayList<>();

    public Lista() {}

    public Lista(String nome) {
        this.nome = nome;
    }

    public void adicionarItem(Item item) {
        item.setLista(this);
        this.itens.add(item);
    }

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public LocalDateTime getDataConclusao() { return dataConclusao; }
    public void setDataConclusao(LocalDateTime dataConclusao) { this.dataConclusao = dataConclusao; }

    public List<Item> getItens() { return itens; }
    public void setItens(List<Item> itens) { this.itens = itens; }

    // Método para verificar se a lista foi concluída
    public void verificarConclusao() {
        boolean todosConcluidos = itens.stream()
                                       .allMatch(Item::isComprado); // Item precisa ter boolean isComprado()
        if (todosConcluidos && !itens.isEmpty()) {
            this.dataConclusao = LocalDateTime.now();
        } else {
            this.dataConclusao = null; // opcional
        }
    }
}