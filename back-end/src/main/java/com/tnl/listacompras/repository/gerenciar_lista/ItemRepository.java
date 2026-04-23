package com.tnl.listacompras.repository.gerenciar_lista;

import com.tnl.listacompras.model.gerenciar_lista.Item;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ItemRepository extends JpaRepository<Item, Long> {

    // =========================
    // LISTAR ITENS DA LISTA
    // =========================
    @Query("""
        SELECT i FROM Item i
        WHERE i.idLista = :listaId
        AND i.deletado = false
    """)
    List<Item> listarPorLista(@Param("listaId") Long listaId);

    // =========================
    // BUSCAR ITEM
    // =========================
    Optional<Item> findByIdAndIdListaAndDeletadoFalse(Long id, Long idLista);

    // =========================
    // GLOBAL
    // =========================
    Optional<Item> findByIdListaAndIdProdutoAndDeletadoFalse(Long idLista, Long idProduto);

    // =========================
    // 🔥 ITENS POR CATEGORIA (SIMPLES E FINAL)
    // =========================
    List<Item> findByIdListaAndIdCategoriaAndDeletadoFalse(
            Long idLista,
            Long idCategoria
    );
}