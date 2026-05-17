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

    //Itens mais baratos
    @Query("""
    SELECT i
    FROM Item i
    WHERE i.lista.id = :listaId
    AND i.deletado = false
    ORDER BY i.preco ASC
    """)
    List<Item> buscarItensMaisBaratos(@Param("listaId") Long listaId);

    //Itens mais caros
    @Query("""
    SELECT i    
    FROM Item i
    WHERE i.lista.id = :listaId
    AND i.deletado = false
    ORDER BY i.preco DESC
    """)
    List<Item> buscarItensMaisCaros(@Param("listaId") Long listaId);


    //Agrupamento por categoria

 @Query("""
    SELECT i.produto.categoria.nome, COUNT(i.id)
    FROM Item i
    WHERE i.lista.id = :listaId
    AND i.deletado = false
    GROUP BY i.produto.categoria.nome
    ORDER BY COUNT(i.id) DESC
""")
List<Object[]> totalPorCategoria(@Param("listaId") Long listaId);
}