package com.tnl.listacompras.dto.responseDTO.auto_cadastro;

public class AuthResponseDTO {

    private UsuarioResponseDTO usuario;
    private String token;

    public AuthResponseDTO() {}

    public AuthResponseDTO(UsuarioResponseDTO usuario, String token) {
        this.usuario = usuario;
        this.token = token;
    }

    public UsuarioResponseDTO getUsuario() { return usuario; }
    public void setUsuario(UsuarioResponseDTO usuario) { this.usuario = usuario; }

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }
}