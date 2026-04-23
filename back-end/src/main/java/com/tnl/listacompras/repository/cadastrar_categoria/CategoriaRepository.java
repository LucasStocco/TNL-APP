package com.tnl.listacompras.repository.cadastrar_categoria;

import com.tnl.listacompras.model.cadastrar_categoria.Categoria;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface CategoriaRepository extends JpaRepository<Categoria, Long> {

    // =========================
    // LISTAR (USUÁRIO + GLOBAIS)
    // =========================
    @Query("""
        SELECT c FROM Categoria c
        WHERE c.deletado = false
        AND (c.idUsuario = :usuarioId OR c.idUsuario IS NULL)
    """)
    List<Categoria> listarTodas(@Param("usuarioId") Long usuarioId);

    // =========================
    // BUSCAR POR ID (VISÍVEL AO USUÁRIO)
    // =========================
    @Query("""
        SELECT c FROM Categoria c
        WHERE c.id = :id
        AND c.deletado = false
        AND (c.idUsuario = :usuarioId OR c.idUsuario IS NULL)
    """)
    Optional<Categoria> buscarVisivelPorId(
            @Param("id") Long id,
            @Param("usuarioId") Long usuarioId
    );

    // =========================
    // BUSCAR POR NOME (CONTEXTO USUÁRIO + GLOBAL)
    // =========================
    @Query("""
        SELECT c FROM Categoria c
        WHERE c.nome = :nome
        AND c.deletado = false
        AND (c.idUsuario = :usuarioId OR c.idUsuario IS NULL)
    """)
    Optional<Categoria> buscarPorNomeContextual(
            @Param("usuarioId") Long usuarioId,
            @Param("nome") String nome
    );

    // =========================
    // EXISTS OTIMIZADO (SEM TRAZER ENTIDADE)
    // =========================
    @Query("""
        SELECT COUNT(c) > 0 FROM Categoria c
        WHERE c.nome = :nome
        AND c.deletado = false
        AND (c.idUsuario = :usuarioId OR c.idUsuario IS NULL)
    """)
    boolean existsByNomeContextual(
            @Param("usuarioId") Long usuarioId,
            @Param("nome") String nome
    );

    // =========================
    // SYNC (USUÁRIO SOMENTE)
    // =========================
    List<Categoria> findByIdUsuarioAndAtualizadoEmAfter(
            Long idUsuario,
            LocalDateTime data
    );
}