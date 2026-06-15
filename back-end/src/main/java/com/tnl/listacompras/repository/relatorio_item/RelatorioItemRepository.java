package com.tnl.listacompras.repository.relatorio_item;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.tnl.listacompras.model.gerenciar_lista.Item;

public interface RelatorioItemRepository extends JpaRepository<Item, Long> {

    @Query("""
        SELECT i.produto.nome,
               SUM(i.quantidade),
               COUNT(DISTINCT i.lista.id)
        FROM Item i
        WHERE i.deletado = false
          AND i.lista.id = :listaId
        GROUP BY i.produto.id, i.produto.nome
        ORDER BY SUM(i.quantidade) DESC
    """)
    List<Object[]> buscarItensMaisComprados(@Param("listaId") Long listaId);

    @Query("""
    SELECT c.nome,
           COUNT(DISTINCT i.produto.id),
           SUM(i.quantidade),
           SUM(i.preco * i.quantidade)
    FROM Item i
    JOIN i.produto.subcategoria s
    JOIN s.categoria c
    WHERE i.deletado = false
      AND i.lista.id = :listaId
    GROUP BY c.id, c.nome
    ORDER BY SUM(i.preco * i.quantidade) DESC
""")
List<Object[]> buscarItensPorCategoria(@Param("listaId") Long listaId);

    @Query("""
        SELECT i.produto.nome,
               i.produto.subcategoria.nome,
               MAX(i.preco)
        FROM Item i
        WHERE i.deletado = false
          AND i.lista.id = :listaId
        GROUP BY i.produto.id,
                 i.produto.nome,
                 i.produto.subcategoria.nome
        ORDER BY MAX(i.preco) DESC
    """)
    List<Object[]> buscarItensMaisCaros(@Param("listaId") Long listaId);

    @Query("""
        SELECT i.produto.nome,
               i.produto.subcategoria.nome,
               MIN(i.preco)
        FROM Item i
        WHERE i.deletado = false
          AND i.lista.id = :listaId
        GROUP BY i.produto.id,
                 i.produto.nome,
                 i.produto.subcategoria.nome
        ORDER BY MIN(i.preco) ASC
    """)
    List<Object[]> buscarItensMaisBaratos(@Param("listaId") Long listaId);
}