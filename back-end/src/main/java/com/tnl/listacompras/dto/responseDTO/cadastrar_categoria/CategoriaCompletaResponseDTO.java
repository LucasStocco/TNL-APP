package com.tnl.listacompras.dto.responseDTO.cadastrar_categoria;

import java.util.List;

public class CategoriaCompletaResponseDTO {

    private Long id;
    private String nome;
    private String codigo;

    private List<SubcategoriaCompletaResponseDTO> subcategorias;

    // ✔ construtor vazio (obrigatório pro Jackson e uso geral)
    public CategoriaCompletaResponseDTO() {
    }

    // ✔ construtor manual (o que seu service quer usar)
    public CategoriaCompletaResponseDTO(Long id, String nome, String codigo) {
        this.id = id;
        this.nome = nome;
        this.codigo = codigo;
    }

    // getters e setters
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

    public List<SubcategoriaCompletaResponseDTO> getSubcategorias() {
        return subcategorias;
    }

    public void setSubcategorias(List<SubcategoriaCompletaResponseDTO> subcategorias) {
        this.subcategorias = subcategorias;
    }
}