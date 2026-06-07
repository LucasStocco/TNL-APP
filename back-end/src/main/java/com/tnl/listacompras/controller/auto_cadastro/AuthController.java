package com.tnl.listacompras.controller.auto_cadastro;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tnl.listacompras.dto.requestDTO.auto_cadastro.GoogleLoginRequestDTO;
import com.tnl.listacompras.dto.responseDTO.auto_cadastro.UsuarioResponseDTO;
import com.tnl.listacompras.service.auto_cadastro.UsuarioService;

@RestController
@RequestMapping("/auth")
@CrossOrigin("*")
public class AuthController {

    @Autowired
    private UsuarioService usuarioService;

    @PostMapping("/google")
    public ResponseEntity<UsuarioResponseDTO> loginGoogle(
            @RequestBody GoogleLoginRequestDTO request
    ) {

        UsuarioResponseDTO usuario =
                usuarioService.loginWithGoogle(request.getIdToken());

        return ResponseEntity.ok(usuario);
    }
}