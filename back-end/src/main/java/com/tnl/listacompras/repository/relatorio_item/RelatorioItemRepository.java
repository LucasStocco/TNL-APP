package com.tnl.listacompras.repository.relatorio_item;

import com.tnl.listacompras.model.gerenciar_lista.Item;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RelatorioItemRepository extends JpaRepository<Item, Long> {

    //Itens mais comprados.
    @Query("""
    SELECT i.produto.nome, SUM(i.quantidade), COUNT(DISTINCT i.lista.id)
    FROM Item i
    WHERE i.deletado = false
    AND i.lista.usuario.id = :usuarioId
    GROUP BY i.produto.id, i.produto.nome
    ORDER BY SUM(i.quantidade) DESC
    """)
    List<Object[]> buscarItensMaisComprados(@Param("usuarioId") Long usuarioId);

    //Mais Baratos
    @Query("""
    SELECT i.produto.nome, i.produto.subcategoria.categoria.nome, MIN(i.preco)
    FROM Item i
    WHERE i.deletado = false
    AND i.lista.usuario.id = :usuarioId
    GROUP BY i.produto.id, i.produto.nome, i.produto.subcategoria.categoria.nome
    ORDER BY MIN(i.preco) ASC
    """)
    List<Object[]> buscarItensMaisBaratos(@Param("usuarioId") Long usuarioId);

    //Mais Caros
    @Query("""
    SELECT i.produto.nome, i.produto.subcategoria.categoria.nome, MAX(i.preco)
    FROM Item i
    WHERE i.deletado = false
    AND i.lista.usuario.id = :usuarioId
    GROUP BY i.produto.id, i.produto.nome, i.produto.subcategoria.categoria.nome
    ORDER BY MAX(i.preco) DESC
    """)
    List<Object[]> buscarItensMaisCaros(@Param("usuarioId") Long usuarioId);


    //Agrupamento por categoria
    @Query("""
    SELECT i.produto.subcategoria.categoria.nome, COUNT(DISTINCT i.produto.id), SUM(i.quantidade), SUM(i.preco * i.quantidade)
    FROM Item i
    WHERE i.deletado = false
    AND i.lista.usuario.id = :usuarioId
    GROUP BY i.produto.subcategoria.categoria.id, i.produto.subcategoria.categoria.nome
    ORDER BY SUM(i.preco * i.quantidade) DESC
    """)
    List<Object[]> buscarItensPorCategoria(@Param("usuarioId") Long usuarioId);
}