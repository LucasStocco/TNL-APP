package com.tnl.listacompras.repository.gerenciar_lista;

import com.tnl.listacompras.model.gerenciar_lista.Lista;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

// crud base 
public interface ListaRepository extends JpaRepository<Lista, Long> {

	// Listar listas de um usuário
    List<Lista> findByUsuarioId(Long usuarioId);

    // Listas do usuário não deletadas
    List<Lista> findByUsuarioIdAndDeletadoFalse(Long usuarioId);

    // Listas ativas do sistema
    List<Lista> findByDeletadoFalse();
}