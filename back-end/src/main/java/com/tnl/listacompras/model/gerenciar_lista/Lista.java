package com.tnl.listacompras.model.gerenciar_lista;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

import com.tnl.listacompras.model.auto_cadastro.Usuario;

@Entity
@Table(name = "listas")
public class Lista {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;

    // 👤 FK usuario_id
    // 👤 muitas listas → 1 usuário
    @ManyToOne
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    // 📦 1 lista → muitos itens
    @OneToMany(mappedBy = "lista", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Item> itens;

    private LocalDateTime criadoEm;
    private LocalDateTime atualizadoEm;
    private LocalDateTime concluidoEm;
    private Boolean deletado = false;

    @PrePersist
    public void prePersist() {
        LocalDateTime agora = LocalDateTime.now();
        this.criadoEm = agora;
        this.atualizadoEm = agora;
        this.deletado = false;
    }

    @PreUpdate
    public void preUpdate() {
        this.atualizadoEm = LocalDateTime.now();
    }

    // GETTERS / SETTERS

    public Long getId() {
        return id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public List<Item> getItens() {
        return itens;
    }

    public LocalDateTime getCriadoEm() {
        return criadoEm;
    }

    public LocalDateTime getAtualizadoEm() {
        return atualizadoEm;
    }

    public LocalDateTime getConcluidoEm() {
        return concluidoEm;
    }

    public void setConcluidoEm(LocalDateTime concluidoEm) {
        this.concluidoEm = concluidoEm;
    }

    public Boolean getDeletado() {
        return deletado;
    }

    public void setDeletado(Boolean deletado) {
        this.deletado = deletado;
    }
}