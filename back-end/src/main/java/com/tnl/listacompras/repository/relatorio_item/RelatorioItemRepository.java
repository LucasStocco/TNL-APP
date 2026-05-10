package com.tnl.listacompras.repository.relatorio_item;

import com.tnl.listacompras.model.gerenciar_lista.Item;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RelatorioItemRepository extends JpaRepository<Item, Long> {

    // =========================
    // 📊 TOTAIS / MÉTRICAS
    // =========================

    @Query("""
        SELECT COALESCE(SUM(i.preco * i.quantidade), 0.0)
        FROM Item i
        WHERE i.lista.id = :listaId
        AND i.deletado = false
    """)
    Double somarTotalLista(@Param("listaId") Long listaId);

    @Query("""
        SELECT COALESCE(SUM(i.preco * i.quantidade), 0.0)
        FROM Item i
        WHERE i.lista.id = :listaId
        AND i.deletado = false
        AND i.comprado = true
    """)
    Double somarTotalComprado(@Param("listaId") Long listaId);

    @Query("""
        SELECT COALESCE(SUM(i.preco * i.quantidade), 0.0)
        FROM Item i
        WHERE i.lista.id = :listaId
        AND i.deletado = false
        AND i.comprado = false
    """)
    Double somarTotalPendente(@Param("listaId") Long listaId);

    @Query("""
        SELECT COUNT(i)
        FROM Item i
        WHERE i.lista.id = :listaId
        AND i.deletado = false
    """)
    int contarItensAtivos(@Param("listaId") Long listaId);

    @Query("""
        SELECT COUNT(i)
        FROM Item i
        WHERE i.lista.id = :listaId
        AND i.deletado = false
        AND i.comprado = true
    """)
    int contarItensComprados(@Param("listaId") Long listaId);

    @Query("""
        SELECT COUNT(i)
        FROM Item i
        WHERE i.lista.id = :listaId
        AND i.deletado = false
        AND i.comprado = false
    """)
    int contarItensPendentes(@Param("listaId") Long listaId);

    // =========================
    // 📦 AGRUPAMENTO POR CATEGORIA
    // =========================

    @Query("""
        SELECT i.produto.categoria.nome, COALESCE(SUM(i.preco * i.quantidade), 0.0)
        FROM Item i
        WHERE i.lista.id = :listaId
        AND i.deletado = false
        GROUP BY i.produto.categoria.nome
        ORDER BY SUM(i.preco * i.quantidade) DESC
    """)
    List<Object[]> totalPorCategoria(@Param("listaId") Long listaId);
}