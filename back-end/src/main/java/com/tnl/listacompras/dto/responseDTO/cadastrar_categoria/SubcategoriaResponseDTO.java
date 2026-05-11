package com.tnl.listacompras.dto.responseDTO.cadastrar_categoria;

import com.tnl.listacompras.model.cadastrar_categoria.Subcategoria;

public class SubcategoriaResponseDTO {

    private Long id;
    private String nome;

    public SubcategoriaResponseDTO(Subcategoria sub) {
        this.id = sub.getId();
        this.nome = sub.getNome();
    }

    public Long getId() { return id; }
    public String getNome() { return nome; }
}