package com.tnl.listacompras.repository.auto_cadastro;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.tnl.listacompras.model.auto_cadastro.Usuario;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    Optional<Usuario> findByGoogleId(String googleId);

    Optional<Usuario> findByEmail(String email);
}