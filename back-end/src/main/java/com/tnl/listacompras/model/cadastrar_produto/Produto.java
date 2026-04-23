package com.tnl.listacompras.model.cadastrar_produto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.tnl.listacompras.model.cadastrar_categoria.Categoria;
import jakarta.persistence.*;

@Entity
@Table(
    name = "produtos",
    uniqueConstraints = @UniqueConstraint(
        columnNames = {"nome", "id_categoria", "id_usuario"}
    )
)
public class Produto {

    // ID
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // DADOS
    @Column(nullable = false, length = 100)
    private String nome;

    private String descricao;

    @Column(nullable = true)
    private BigDecimal preco;

    // categoria é objeto real
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_categoria", nullable = false)
    private Categoria categoria;

    @Column(name = "id_usuario", nullable = true)
    private Long idUsuario;

    // TEMPO
    @Column(name = "criado_em", nullable = false)
    private LocalDateTime criadoEm;

    @Column(name = "atualizado_em", nullable = false)
    private LocalDateTime atualizadoEm;

    // CONTROLE
    @Column(nullable = false)
    private Boolean deletado = false;

    // LIFECYCLE
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

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public BigDecimal getPreco() {
        return preco;
    }

    public void setPreco(BigDecimal preco) {
        this.preco = preco;
    }

    // 🔥 NOVO
    public Categoria getCategoria() {
        return categoria;
    }

    public void setCategoria(Categoria categoria) {
        this.categoria = categoria;
    }

    public Long getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(Long idUsuario) {
        this.idUsuario = idUsuario;
    }

    public LocalDateTime getCriadoEm() {
        return criadoEm;
    }

    public LocalDateTime getAtualizadoEm() {
        return atualizadoEm;
    }

    public Boolean getDeletado() {
        return deletado;
    }

    public void setDeletado(Boolean deletado) {
        this.deletado = deletado;
    }

    // REGRAS DE NEGÓCIO
    public boolean isGlobal() {
        return this.idUsuario == null;
    }

    public boolean temPreco() {
        return this.preco != null;
    }
}