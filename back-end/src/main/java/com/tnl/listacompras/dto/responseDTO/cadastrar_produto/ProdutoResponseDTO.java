package com.tnl.listacompras.dto.responseDTO.cadastrar_produto;

import com.tnl.listacompras.model.cadastrar_produto.Produto;

public class ProdutoResponseDTO {

    private Long id;
    private String nome;
    private String descricao;

    private Long subcategoriaId;
    private String nomeSubcategoria;

    private Long categoriaId;
    private String nomeCategoria;

    public ProdutoResponseDTO(Produto produto) {

        this.id = produto.getId();
        this.nome = produto.getNome();
        this.descricao = produto.getDescricao();

        if (produto.getSubcategoria() != null) {
            this.subcategoriaId = produto.getSubcategoria().getId();
            this.nomeSubcategoria = produto.getSubcategoria().getNome();

            if (produto.getSubcategoria().getCategoria() != null) {
                this.categoriaId = produto.getSubcategoria().getCategoria().getId();
                this.nomeCategoria = produto.getSubcategoria().getCategoria().getNome();
            }
        }
    }

    public Long getId() { return id; }
    public String getNome() { return nome; }
    public String getDescricao() { return descricao; }
    public Long getSubcategoriaId() { return subcategoriaId; }
    public String getNomeSubcategoria() { return nomeSubcategoria; }
    public Long getCategoriaId() { return categoriaId; }
    public String getNomeCategoria() { return nomeCategoria; }
}
/*
 * com as novas mudanças é possível garantir que, o DTO siga a hierarquia correta: categoria -> subcategoria -> produto.
 * não quebra caso subcategoria for null
 * não depende mais diretamente de Categoria no Produto
 * evita erro futuro no Flutter
 * 
*/