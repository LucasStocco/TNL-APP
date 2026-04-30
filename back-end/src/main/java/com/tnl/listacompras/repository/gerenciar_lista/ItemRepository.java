package com.tnl.listacompras.repository.gerenciar_lista;

import com.tnl.listacompras.model.gerenciar_lista.Item;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ItemRepository extends JpaRepository<Item, Long> {

    // listar itens da lista
    List<Item> findByListaIdAndDeletadoFalse(Long listaId);

    // buscar item específico dentro da lista
    Optional<Item> findByIdAndListaIdAndDeletadoFalse(Long id, Long listaId);

    // evitar duplicação de produto na lista
    Optional<Item> findByListaIdAndProdutoIdAndDeletadoFalse(Long listaId, Long produtoId);

    // opcional (UX melhor)
    List<Item> findByListaIdAndCompradoAndDeletadoFalse(Long listaId, Boolean comprado);
}