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
import com.tnl.listacompras.dto.responseDTO.auto_cadastro.AuthResponseDTO;
import com.tnl.listacompras.dto.responseDTO.auto_cadastro.UsuarioResponseDTO;
import com.tnl.listacompras.model.auto_cadastro.Usuario;
import com.tnl.listacompras.repository.auto_cadastro.UsuarioRepository;
import com.tnl.listacompras.session.Session;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;
    @Autowired
private JwtService jwtService;

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

    public AuthResponseDTO loginWithGoogle(String idTokenString) {

    GoogleIdToken.Payload payload = verifyToken(idTokenString);

    String googleId = payload.getSubject();
    String email = payload.getEmail();
    String nome = (String) payload.get("name");
    String foto = (String) payload.get("picture");

    Usuario usuario = usuarioRepository.findByGoogleId(googleId)
            .orElseGet(() -> {
                Usuario novo = new Usuario();
                novo.setGoogleId(googleId);
                novo.setEmail(email);
                novo.setNome(nome);
                novo.setFotoUrl(foto);
                return usuarioRepository.save(novo);
            });

    // 🔥 gera JWT
    String token = jwtService.gerarToken(usuario.getEmail());

    // 🔥 retorna resposta correta
    UsuarioResponseDTO usuarioDTO = new UsuarioResponseDTO(usuario);
    return new AuthResponseDTO(usuarioDTO, token);
}

    private final GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
        new NetHttpTransport(),
        new GsonFactory()
)
        .setAudience(Collections.singletonList(clientId))
        .build();

           private GoogleIdToken.Payload verifyToken(String idTokenString) {

    try {
        GoogleIdToken idToken = verifier.verify(idTokenString);

        if (idToken == null) {
            throw new RuntimeException("Token inválido");
        }

        return idToken.getPayload();

    } catch (Exception e) {
        throw new RuntimeException("Erro ao verificar token: " + e.getMessage());
    }
}
    
}