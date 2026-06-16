package com.tnl.listacompras.controller.auto_cadastro;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tnl.listacompras.dto.requestDTO.auto_cadastro.GoogleLoginRequestDTO;
import com.tnl.listacompras.dto.responseDTO.auto_cadastro.AuthResponseDTO;
import com.tnl.listacompras.dto.responseDTO.auto_cadastro.UsuarioResponseDTO;
import com.tnl.listacompras.service.auto_cadastro.UsuarioService;

// teste para ver se está atualizando
@RestController
@RequestMapping("/auth")
@CrossOrigin("*")
public class AuthController {

    @Autowired
    private UsuarioService usuarioService;

    @PostMapping("/google")
public ResponseEntity<AuthResponseDTO> loginGoogle(
    @RequestBody GoogleLoginRequestDTO request) {

System.out.println("🔥 CHEGOU NO CONTROLLER");

        AuthResponseDTO response =
            usuarioService.loginWithGoogle(request.getIdToken());

    System.out.println("TOKEN = " + response.getToken());
    System.out.println("USUARIO = " + response.getUsuario().getEmail());

    return ResponseEntity.ok(response);
    }
}

