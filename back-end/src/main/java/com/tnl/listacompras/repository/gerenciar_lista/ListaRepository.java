package com.tnl.listacompras.repository.gerenciar_lista;

import com.tnl.listacompras.model.gerenciar_lista.Lista;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ListaRepository extends JpaRepository<Lista, Long> {

    // LISTAR VISÍVEIS (USER + GLOBAL)
    @Query("""
        SELECT l FROM Lista l
        WHERE l.deletado = false
        AND (l.idUsuario = :idUsuario OR l.idUsuario IS NULL)
        ORDER BY l.atualizadoEm DESC
    """)
    List<Lista> findAllVisible(@Param("idUsuario") Long idUsuario);

    // BUSCAR POR ID
    Optional<Lista> findByIdAndIdUsuarioAndDeletadoFalse(Long id, Long idUsuario);

    // EXISTS (COM REGRA GLOBAL)
    @Query("""
        SELECT COUNT(l) > 0 FROM Lista l
        WHERE l.nome = :nome
        AND l.deletado = false
        AND (l.idUsuario = :idUsuario OR l.idUsuario IS NULL)
    """)
    boolean existsVisibleByName(
            @Param("nome") String nome,
            @Param("idUsuario") Long idUsuario
    );
}