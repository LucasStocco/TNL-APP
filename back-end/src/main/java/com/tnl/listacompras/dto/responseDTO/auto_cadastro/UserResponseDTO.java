package com.tnl.listacompras.dto.responseDTO.auto_cadastro;

import com.tnl.listacompras.model.auto_cadastro.User;

public class UserResponseDTO {
    private Long id;
    private String name;
    private String email;
    private String pictureUrl;
    
     public UserResponseDTO(User user) {
        this.id = user.getId();
        this.name = user.getNome();
        this.email = user.getEmail();
        this.pictureUrl = user.getPictureUrl();
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

    public String getPictureUrl() {
        return pictureUrl;
    }

    public void setPictureUrl(String pictureUrl) {
        this.pictureUrl = pictureUrl;
    }

   
}