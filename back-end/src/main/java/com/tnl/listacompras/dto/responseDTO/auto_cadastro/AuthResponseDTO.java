package com.tnl.listacompras.dto.responseDTO.auto_cadastro;

public class AuthResponseDTO {

    private UsuarioResponseDTO usuario;
    private String token;

    public AuthResponseDTO(UsuarioResponseDTO usuario, String token) {
        this.usuario = usuario;
        this.token = token;
    }

    public UsuarioResponseDTO getUsuario() {
        return usuario;
    }

    public String getToken() {
        return token;
    }
}