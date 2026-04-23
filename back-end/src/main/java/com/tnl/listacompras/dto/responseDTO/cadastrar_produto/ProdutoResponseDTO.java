package com.tnl.listacompras.dto.responseDTO.cadastrar_produto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import com.tnl.listacompras.dto.responseDTO.cadastrar_categoria.CategoriaResponseDTO;

public class ProdutoResponseDTO {

    private final Long id;
    private final String nome;
    private final String descricao;
    private final BigDecimal preco;
    private final CategoriaResponseDTO categoria;
    private final LocalDateTime criadoEm;
    private final LocalDateTime atualizadoEm;
    private final Long idUsuario;

    public ProdutoResponseDTO(Long id, String nome, String descricao,
                              BigDecimal preco, CategoriaResponseDTO categoria,
                              LocalDateTime criadoEm, LocalDateTime atualizadoEm,
                              Long idUsuario) {
        this.id = id;
        this.nome = nome;
        this.descricao = descricao;
        this.preco = preco;
        this.categoria = categoria;
        this.criadoEm = criadoEm;
        this.atualizadoEm = atualizadoEm;
        this.idUsuario = idUsuario;
    }

    public Long getId() { return id; }
    public String getNome() { return nome; }
    public String getDescricao() { return descricao; }
    public BigDecimal getPreco() { return preco; }
    public CategoriaResponseDTO getCategoria() { return categoria; }
    public LocalDateTime getCriadoEm() { return criadoEm; }
    public LocalDateTime getAtualizadoEm() { return atualizadoEm; }
    public Long getIdUsuario() { return idUsuario; }
}