package com.tnl.listacompras.repository.gerenciar_lista;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tnl.listacompras.model.gerenciar_lista.Item;


public interface ItemRepository extends JpaRepository<Item, Long> {

    List<Item> findByListaId(Long listaId);
}
