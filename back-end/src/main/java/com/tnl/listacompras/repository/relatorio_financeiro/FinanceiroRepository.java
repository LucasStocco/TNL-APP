package com.tnl.listacompras.repository.relatorio_financeiro;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.tnl.listacompras.model.gerenciar_lista.Item;
import com.tnl.listacompras.repository.gerenciar_lista.ItemRepository;

@Repository
public class FinanceiroRepository {

    private final ItemRepository itemRepository;

    public FinanceiroRepository(ItemRepository itemRepository) {
        this.itemRepository = itemRepository;
    }

   
    public List<Item> buscarItensDaLista(Long listaId) {
        return itemRepository.findByListaIdAndDeletadoFalse(listaId);
    }
}