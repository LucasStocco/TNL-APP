package com.tnl.listacompras.dto.responseDTO.cadastrar_categoria;

import com.tnl.listacompras.dto.responseDTO.cadastrar_produto.ProdutoResponseDTO;
import com.tnl.listacompras.model.cadastrar_categoria.Subcategoria;

import java.util.List;

public class SubcategoriaCompletaResponseDTO {

    private Long id;
    private String nome;

    private List<ProdutoResponseDTO> produtos;

    public SubcategoriaCompletaResponseDTO() {
    }

    // 🔥 ESSE É O CONSTRUTOR QUE FALTAVA
    public SubcategoriaCompletaResponseDTO(Subcategoria sub) {
        this.id = sub.getId();
        this.nome = sub.getNome();
    }

    public Long getId() {
        return id;
    }

    public String getNome() {
        return nome;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public List<ProdutoResponseDTO> getProdutos() {
        return produtos;
    }

    public void setProdutos(List<ProdutoResponseDTO> produtos) {
        this.produtos = produtos;
    }
}