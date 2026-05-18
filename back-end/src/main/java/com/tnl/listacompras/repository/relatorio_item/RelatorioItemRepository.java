package com.tnl.listacompras.repository.relatorio_item;

import com.tnl.listacompras.model.gerenciar_lista.Item;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RelatorioItemRepository extends JpaRepository<Item, Long> {

    @Query("""
        SELECT i.produto.nome, SUM(i.quantidade), COUNT(DISTINCT i.lista.id)
        FROM Item i
        WHERE i.deletado = false
        AND i.lista.id = :listaId
        GROUP BY i.produto.id, i.produto.nome
        ORDER BY SUM(i.quantidade) DESC
    """)
    List<Object[]> buscarItensMaisComprados(@Param("listaId") Long listaId);

    @Query("""
        SELECT i.produto.categoria.nome, COUNT(DISTINCT i.produto.id), SUM(i.quantidade), SUM(i.preco * i.quantidade)
        FROM Item i
        WHERE i.deletado = false
        AND i.lista.id = :listaId
        GROUP BY i.produto.categoria.id, i.produto.categoria.nome
        ORDER BY SUM(i.preco * i.quantidade) DESC
    """)
    List<Object[]> buscarItensPorCategoria(@Param("listaId") Long listaId);

    @Query("""
        SELECT i.produto.nome, i.produto.categoria.nome, MAX(i.preco)
        FROM Item i
        WHERE i.deletado = false
        AND i.lista.id = :listaId
        GROUP BY i.produto.id, i.produto.nome, i.produto.categoria.nome
        ORDER BY MAX(i.preco) DESC
    """)
    List<Object[]> buscarItensMaisCaros(@Param("listaId") Long listaId);

    @Query("""
        SELECT i.produto.nome, i.produto.categoria.nome, MIN(i.preco)
        FROM Item i
        WHERE i.deletado = false
        AND i.lista.id = :listaId
        GROUP BY i.produto.id, i.produto.nome, i.produto.categoria.nome
        ORDER BY MIN(i.preco) ASC
    """)
    List<Object[]> buscarItensMaisBaratos(@Param("listaId") Long listaId);
}