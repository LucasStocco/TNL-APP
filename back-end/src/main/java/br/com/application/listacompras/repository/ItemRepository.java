package br.com.application.listacompras.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import br.com.application.listacompras.model.Item;

public interface ItemRepository extends JpaRepository<Item, Long> {

    List<Item> findByListaId(Long listaId);
}
