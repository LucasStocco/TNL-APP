package com.tnl.listacompras.repository.gerenciar_lista;

import com.tnl.listacompras.model.gerenciar_lista.Item;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ItemRepository extends JpaRepository<Item, Long> {

    // =========================
    // 🔎 BUSCAS
    // =========================

    // listar itens da lista
    List<Item> findByListaIdAndDeletadoFalse(Long listaId);

    // buscar item específico dentro da lista
    Optional<Item> findByIdAndListaIdAndDeletadoFalse(Long id, Long listaId);

    // evitar duplicação de produto na lista
    Optional<Item> findByListaIdAndProdutoIdAndDeletadoFalse(Long listaId, Long produtoId);

    // UX: filtrar por status
    List<Item> findByListaIdAndCompradoAndDeletadoFalse(Long listaId, Boolean comprado);

    // =========================
    // 📊 RESUMO (ESSENCIAL)
    // =========================

    // total de itens ativos da lista
    @Query("""
        SELECT COUNT(i)
        FROM Item i
        WHERE i.lista.id = :listaId
        AND i.deletado = false
    """)
    int contarItensAtivos(@Param("listaId") Long listaId);

    // total de itens comprados
    @Query("""
        SELECT COUNT(i)
        FROM Item i
        WHERE i.lista.id = :listaId
        AND i.deletado = false
        AND i.comprado = true
    """)
    int contarItensComprados(@Param("listaId") Long listaId);
}