package com.tnl.listacompras.service.auto_cadastro;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.tnl.listacompras.dto.responseDTO.auto_cadastro.UserResponseDTO;
import com.tnl.listacompras.repository.auto_cadastro.UserRepository;


@Service
public class UserService {

    @Value("${google.clientId}")
    private String clientId;

    @Autowired
    private UserRepository userRepository;

    public UserResponseDTO loginWithGoogle(String idTokenString) {

        GoogleIdToken.Payload payload = verifyToken(idTokenString);

        String googleId = payload.getSubject();
        String email = payload.getEmail();
        String name = (String) payload.get("name");
        String picture = (String) payload.get("picture");

        User user = userRepository.findByGoogleId(googleId)
                .orElseGet(() -> {
                    User newUser = new User();
                    newUser.setGoogleId(googleId);
                    newUser.setEmail(email);
                    newUser.setName(name);
                    newUser.setPictureUrl(picture);
                    return userRepository.save(newUser);
                });

        return new UserResponseDTO(user);
    }

    private GoogleIdToken.Payload verifyToken(String idTokenString) {
        try {
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    new NetHttpTransport(),
                    new GsonFactory()
            ).setAudience(Collections.singletonList(clientId)).build();

            GoogleIdToken idToken = verifier.verify(idTokenString);

            if (idToken != null) {
                return idToken.getPayload();
            } else {
                throw new RuntimeException("Token inválido");
            }

        } catch (Exception e) {
            throw new RuntimeException("Erro ao validar token", e);
        }
    }
}