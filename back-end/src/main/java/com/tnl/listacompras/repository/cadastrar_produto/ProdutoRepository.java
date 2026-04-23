package com.tnl.listacompras.repository.cadastrar_produto;

import com.tnl.listacompras.model.cadastrar_produto.Produto;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ProdutoRepository extends JpaRepository<Produto, Long> {

    // =========================
    // LISTAR DISPONÍVEIS (GLOBAL + USUÁRIO)
    // =========================
    @Query("""
        SELECT p FROM Produto p
        WHERE p.deletado = false
        AND (
            p.idUsuario = :usuarioId
            OR p.idUsuario IS NULL
        )
    """)
    List<Produto> listarDisponiveis(@Param("usuarioId") Long usuarioId);

    // =========================
    // BUSCAR POR ID (RESPEITANDO CONTEXTO)
    // =========================
    @Query("""
        SELECT p FROM Produto p
        WHERE p.id = :id
        AND p.deletado = false
        AND (
            p.idUsuario = :usuarioId
            OR p.idUsuario IS NULL
        )
    """)
    Optional<Produto> buscarDisponivelPorId(
        @Param("id") Long id,
        @Param("usuarioId") Long usuarioId
    );

    // =========================
    // BUSCAR POR NOME + CATEGORIA (SEM DELETADOS)
    // =========================
    @Query("""
        SELECT p FROM Produto p
        WHERE LOWER(TRIM(p.nome)) = LOWER(TRIM(:nome))
        AND p.categoria.id = :categoriaId
        AND p.deletado = false
        AND (
            p.idUsuario = :usuarioId
            OR p.idUsuario IS NULL
        )
    """)
    Optional<Produto> buscarPorNomeContextual(
        @Param("nome") String nome,
        @Param("categoriaId") Long categoriaId,
        @Param("usuarioId") Long usuarioId
    );

    // =========================
    // EXISTE POR NOME + CATEGORIA
    // =========================
    @Query("""
        SELECT CASE WHEN COUNT(p) > 0 THEN true ELSE false END
        FROM Produto p
        WHERE LOWER(TRIM(p.nome)) = LOWER(TRIM(:nome))
        AND p.categoria.id = :categoriaId
        AND p.deletado = false
        AND (
            p.idUsuario = :usuarioId
            OR p.idUsuario IS NULL
        )
    """)
    boolean existePorNomeContextual(
        @Param("nome") String nome,
        @Param("categoriaId") Long categoriaId,
        @Param("usuarioId") Long usuarioId
    );

    // =========================
    // BUSCAR INCLUINDO DELETADOS (RESTAURAÇÃO)
    // =========================
    @Query("""
        SELECT p FROM Produto p
        WHERE LOWER(TRIM(p.nome)) = LOWER(TRIM(:nome))
        AND p.categoria.id = :categoriaId
        AND (
            p.idUsuario = :usuarioId
            OR p.idUsuario IS NULL
        )
    """)
    Optional<Produto> buscarIncluindoDeletados(
        @Param("nome") String nome,
        @Param("categoriaId") Long categoriaId,
        @Param("usuarioId") Long usuarioId
    );

    // =========================
    // 🔥 PRINCIPAL: LISTAR POR CATEGORIA
    // =========================
    @Query("""
        SELECT p FROM Produto p
        WHERE p.categoria.id = :categoriaId
        AND p.deletado = false
        AND (
            p.idUsuario = :usuarioId
            OR p.idUsuario IS NULL
        )
        ORDER BY p.nome ASC
    """)
    List<Produto> listarPorCategoria(
        @Param("categoriaId") Long categoriaId,
        @Param("usuarioId") Long usuarioId
    );
}