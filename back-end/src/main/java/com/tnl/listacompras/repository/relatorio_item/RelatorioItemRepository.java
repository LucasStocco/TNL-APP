package com.tnl.listacompras.repository.relatorio_item;

import com.tnl.listacompras.model.gerenciar_lista.Item;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RelatorioItemRepository extends JpaRepository<Item, Long> {

    //Itens mais comprados.
    @Query("""
    SELECT i.produto.nome, COUNT(i.id)
    FROM Item i
    WHERE i.comprado = true
    AND i.deletado = false
    GROUP BY i.produto.nome
    ORDER BY COUNT(i.id) DESC
    """)
    List<Object[]> buscarItensMaisComprados();

    

    //Agrupamento por categoria

    @Query("""
        SELECT i.produto.categoria.nome, COALESCE COUNT(i.id), 0.0)
        FROM Item i
        WHERE i.lista.id = :listaId
        AND i.deletado = false
        GROUP BY i.produto.categoria.nome
        ORDER BY SUM(i.preco * i.quantidade) DESC
    """)
    List<Object[]> totalPorCategoria(@Param("listaId") Long listaId);
}