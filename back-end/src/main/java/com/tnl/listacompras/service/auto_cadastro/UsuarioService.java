package com.tnl.listacompras.service.auto_cadastro;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.tnl.listacompras.dto.responseDTO.auto_cadastro.UsuarioResponseDTO;
import com.tnl.listacompras.model.auto_cadastro.Usuario;
import com.tnl.listacompras.repository.auto_cadastro.UsuarioRepository;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    private final String clientId = "605363260040-q8s2e93017d9786n152lk4ufhm9gsibc.apps.googleusercontent.com";

    // =========================
    // 🔹 CRUD
    // =========================

    public Usuario registrar(Usuario usuario) {
        return usuarioRepository.save(usuario);
    }

    public List<Usuario> listarTodos() {
        return usuarioRepository.findAll();
    }

    public Optional<Usuario> buscarPorId(Long id) {
        return usuarioRepository.findById(id);
    }

    public Usuario atualizar(Long id, Usuario usuarioAtualizado) {
        return usuarioRepository.findById(id)
                .map(usuario -> {
                    usuario.setNome(usuarioAtualizado.getNome());
                    usuario.setEmail(usuarioAtualizado.getEmail());
                    return usuarioRepository.save(usuario);
                }).orElse(null);
    }

    public boolean deletar(Long id) {
        return usuarioRepository.findById(id)
                .map(usuario -> {
                    usuarioRepository.delete(usuario);
                    return true;
                }).orElse(false);
    }

    // =========================
    // 🔹 LOGIN COM GOOGLE
    // =========================

    public UsuarioResponseDTO loginWithGoogle(String idTokenString) {

        GoogleIdToken.Payload payload = verifyToken(idTokenString);

        String googleId = payload.getSubject();
        String email = payload.getEmail();
        String nome = (String) payload.get("nome");
        String foto = (String) payload.get("foto");

        Usuario usuario = usuarioRepository.findByGoogleId(googleId)
                .orElseGet(() -> {
                    Usuario novo = new Usuario();
                    novo.setGoogleId(googleId);
                    novo.setEmail(email);
                    novo.setNome(nome);
                    novo.setFotoUrl(foto);
                    return usuarioRepository.save(novo);
                });

        return new UsuarioResponseDTO(usuario);
    }

    private GoogleIdToken.Payload verifyToken(String idTokenString) {
        try {
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    new NetHttpTransport(),
                    new GsonFactory()
            )
            .setAudience(Collections.singletonList(clientId))
            .build();

            GoogleIdToken idToken = verifier.verify(idTokenString);

            if (idToken != null) {
                return idToken.getPayload();
            } else {
                throw new RuntimeException("Token inválido");
            }

        } catch (Exception e) {
            throw new RuntimeException("Erro ao verificar token: " + e.getMessage());
        }
    }
}