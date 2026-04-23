package com.tnl.listacompras.dto.responseDTO.cadastrar_categoria;

public class CategoriaResponseDTO {

    private final Long id;
    private final String nome;
    private final String codigo;
    private final Long idUsuario;

    public CategoriaResponseDTO(Long id, String nome, String codigo, Long idUsuario) {
        this.id = id;
        this.nome = nome;
        this.codigo = codigo;
        this.idUsuario = idUsuario;
    }

    public Long getId() { return id; }
    public String getNome() { return nome; }
    public String getCodigo() { return codigo; }
    public Long getIdUsuario() { return idUsuario; }
}