package com.tnl.listacompras.model.gerenciar_lista;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "listas")
public class Lista {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nome;

    @Column(name = "id_usuario", nullable = false)
    private Long idUsuario;

    // updatable = false garante que a data de criação nunca mude após o insert
    @Column(name = "criado_em", nullable = false, updatable = false)
    private LocalDateTime criadoEm;

    @Column(name = "atualizado_em", nullable = false)
    private LocalDateTime atualizadoEm;

    @Column(name = "concluido_em")
    private LocalDateTime concluidoEm;

    @Column(nullable = false)
    private boolean deletado = false;

    // =========================
    // CALLBACKS DE AUDITORIA (Resolve o Erro 500)
    // =========================

    @PrePersist
    protected void onCreate() {
        this.criadoEm = LocalDateTime.now();
        this.atualizadoEm = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.atualizadoEm = LocalDateTime.now();
    }

    // =========================
    // GETTERS E SETTERS
    // =========================

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public Long getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Long idUsuario) { this.idUsuario = idUsuario; }

    public LocalDateTime getCriadoEm() { return criadoEm; }
    public void setCriadoEm(LocalDateTime criadoEm) { this.criadoEm = criadoEm; }

    public LocalDateTime getAtualizadoEm() { return atualizadoEm; }
    public void setAtualizadoEm(LocalDateTime atualizadoEm) { this.atualizadoEm = atualizadoEm; }

    public LocalDateTime getConcluidoEm() { return concluidoEm; }
    public void setConcluidoEm(LocalDateTime concluidoEm) { this.concluidoEm = concluidoEm; }

    public boolean isDeletado() { return deletado; }
    public void setDeletado(boolean deletado) { this.deletado = deletado; }

    // =========================
    // REGRAS DE DOMÍNIO
    // =========================

    public void concluir() {
        this.concluidoEm = LocalDateTime.now();
        this.atualizadoEm = LocalDateTime.now();
    }

    public void reabrir() {
        this.concluidoEm = null;
        this.atualizadoEm = LocalDateTime.now();
    }

    public boolean isConcluida() {
        return this.concluidoEm != null;
    }

    public void deletar() {
        this.deletado = true;
        this.atualizadoEm = LocalDateTime.now();
    }
}