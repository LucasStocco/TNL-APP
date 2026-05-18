package com.tnl.listacompras.dto.responseDTO.auto_cadastro;

import com.tnl.listacompras.model.auto_cadastro.Usuario;



public class UsuarioResponseDTO {
    private Long id;
    private String name;
    private String email;
    private String fotoUrl;
    
     public UsuarioResponseDTO(Usuario usuario) {
        this.id = usuario.getId();
        this.name = usuario.getNome();
        this.email = usuario.getEmail();
        this.fotoUrl = usuario.getFotoUrl();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFotoUrl() {
        return fotoUrl;
    }

    public void setFotoUrl(String fotoUrl) {
        this.fotoUrl = fotoUrl;
    }

   
}