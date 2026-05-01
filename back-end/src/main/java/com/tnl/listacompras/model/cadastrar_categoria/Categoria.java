package com.tnl.listacompras.model.cadastrar_categoria;

import com.fasterxml.jackson.annotation.JsonIgnore; // ✅ ADICIONADO (evitar loop JSON)
import com.tnl.listacompras.model.cadastrar_produto.Produto;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "categoria")
public class Categoria {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nome;

    @Column(nullable = false, unique = true)
    private String codigo;

    @Column(nullable = false)
    private Boolean deletado = false;
    
    // 🏷 1 categoria → muitos produtos
    @OneToMany(mappedBy = "categoria", fetch = FetchType.LAZY) 
    // ✅ ADICIONADO fetch LAZY (evita carregar produtos sem necessidade)
    @JsonIgnore 
    // ✅ ADICIONADO (evita loop infinito no JSON: categoria → produto → categoria...)
    private List<Produto> produtos;

    @Column(name = "criado_em", nullable = false, updatable = false) 
    // ✅ ADICIONADO name (garante compatibilidade com o banco)
    private LocalDateTime criadoEm;

    @Column(name = "atualizado_em", nullable = false) 
    // ✅ ADICIONADO name (padronização com banco)
    private LocalDateTime atualizadoEm;

    @PrePersist
    public void prePersist() {
        LocalDateTime agora = LocalDateTime.now();
        this.criadoEm = agora;
        this.atualizadoEm = agora;
        this.deletado = false;

        // ✅ ADICIONADO (padroniza codigo para evitar bug no Flutter)
        if (this.codigo != null) {
            this.codigo = this.codigo.toUpperCase();
        }
    }

    @PreUpdate
    public void preUpdate() {
        this.atualizadoEm = LocalDateTime.now();

        // ✅ ADICIONADO (garante que continue em maiúsculo mesmo após edição)
        if (this.codigo != null) {
            this.codigo = this.codigo.toUpperCase();
        }
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

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo; 
        // ⚠️ poderia já colocar toUpperCase aqui também (opcional)
    }

    public Boolean getDeletado() {
        return deletado;
    }

    public void setDeletado(Boolean deletado) {
        this.deletado = deletado;
    }

    public LocalDateTime getCriadoEm() {
        return criadoEm;
    }

    public LocalDateTime getAtualizadoEm() {
        return atualizadoEm;
    }
}