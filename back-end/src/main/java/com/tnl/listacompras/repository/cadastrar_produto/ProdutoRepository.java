package com.tnl.listacompras.repository.cadastrar_produto;

import com.tnl.listacompras.model.cadastrar_produto.Produto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ProdutoRepository extends JpaRepository<Produto, Long> {

    // =========================
    // LISTAR POR CATEGORIA (via Subcategoria)
    // =========================
    @Query("""
        SELECT p FROM Produto p
        JOIN p.subcategoria s
        JOIN s.categoria c
        WHERE c.id = :categoriaId
    """)
    List<Produto> findByCategoriaId(@Param("categoriaId") Long categoriaId);

    // =========================
    // VERIFICAR DUPLICIDADE (mais seguro)
    // =========================
    @Query("""
        SELECT CASE WHEN COUNT(p) > 0 THEN true ELSE false END
        FROM Produto p
        WHERE LOWER(p.nome) = LOWER(:nome)
        AND LOWER(p.descricao) = LOWER(:descricao)
        AND p.subcategoria.id = :subcategoriaId
    """)
    boolean existsDuplicado(
            @Param("nome") String nome,
            @Param("descricao") String descricao,
            @Param("subcategoriaId") Long subcategoriaId
    );
}