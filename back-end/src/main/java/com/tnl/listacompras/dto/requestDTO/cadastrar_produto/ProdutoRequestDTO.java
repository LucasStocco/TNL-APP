package com.tnl.listacompras.dto.requestDTO.cadastrar_produto;

import jakarta.validation.constraints.*;
import java.math.BigDecimal;

public class ProdutoRequestDTO {

    @NotBlank
    @Size(max = 100)
    private String nome;

    private String descricao;

    private BigDecimal preco;

    @NotNull
    private Long idCategoria;

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public BigDecimal getPreco() { return preco; }
    public void setPreco(BigDecimal preco) { this.preco = preco; }

    public Long getIdCategoria() { return idCategoria; }
    public void setIdCategoria(Long idCategoria) { this.idCategoria = idCategoria; }
}