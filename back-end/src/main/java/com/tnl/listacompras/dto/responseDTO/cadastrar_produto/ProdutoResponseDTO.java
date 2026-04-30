package com.tnl.listacompras.dto.responseDTO.cadastrar_produto;

import com.tnl.listacompras.model.cadastrar_produto.Produto;

public class ProdutoResponseDTO {

    private Long id;
    private String nome;
    private String descricao;

    private Long categoriaId;
    private String nomeCategoria;

    public ProdutoResponseDTO(Produto produto) {
        this.setId(produto.getId());
        this.setNome(produto.getNome());
        this.setDescricao(produto.getDescricao());

        this.setCategoriaId(produto.getCategoria().getId());
        this.setNomeCategoria(produto.getCategoria().getNome());
    }

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
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

	public Long getCategoriaId() {
		return categoriaId;
	}

	public void setCategoriaId(Long categoriaId) {
		this.categoriaId = categoriaId;
	}

	public String getNomeCategoria() {
		return nomeCategoria;
	}

	public void setNomeCategoria(String nomeCategoria) {
		this.nomeCategoria = nomeCategoria;
	}

    // getters
}