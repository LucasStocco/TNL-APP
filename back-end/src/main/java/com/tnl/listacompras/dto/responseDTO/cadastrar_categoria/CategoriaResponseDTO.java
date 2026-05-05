package com.tnl.listacompras.dto.responseDTO.cadastrar_categoria;

import java.time.LocalDateTime;

import com.tnl.listacompras.model.cadastrar_categoria.Categoria;

public class CategoriaResponseDTO {

    private Long id;
    private String nome;
    private String codigo;

    private LocalDateTime criadoEm;
    private LocalDateTime atualizadoEm;

    public CategoriaResponseDTO(Categoria categoria) {
        this.setId(categoria.getId());
        this.setNome(categoria.getNome());
        this.setCodigo(categoria.getCodigo());
        this.setCriadoEm(categoria.getCriadoEm());
        this.setAtualizadoEm(categoria.getAtualizadoEm());
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

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public LocalDateTime getCriadoEm() {
		return criadoEm;
	}

	public void setCriadoEm(LocalDateTime criadoEm) {
		this.criadoEm = criadoEm;
	}

	public LocalDateTime getAtualizadoEm() {
		return atualizadoEm;
	}

	public void setAtualizadoEm(LocalDateTime atualizadoEm) {
		this.atualizadoEm = atualizadoEm;
	}

    // getters...
}