package com.tnl.listacompras.service.gerenciar_lista;

import com.tnl.listacompras.dto.requestDTO.gerenciar_lista.ItemRequestDTO;
import com.tnl.listacompras.dto.requestDTO.gerenciar_lista.ItemUpdateDTO;
import com.tnl.listacompras.dto.responseDTO.gerenciar_lista.ItemResponseDTO;
import com.tnl.listacompras.model.cadastrar_produto.Produto;
import com.tnl.listacompras.model.gerenciar_lista.Item;
import com.tnl.listacompras.model.gerenciar_lista.Lista;
import com.tnl.listacompras.repository.cadastrar_produto.ProdutoRepository;
import com.tnl.listacompras.repository.gerenciar_lista.ItemRepository;

import exception.business.BusinessException;
import exception.business.NotFoundException;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ItemService {

    private final ItemRepository itemRepository;
    private final ProdutoRepository produtoRepository;

    public ItemService(
            ItemRepository itemRepository,
            ProdutoRepository produtoRepository
    ) {
        this.itemRepository = itemRepository;
        this.produtoRepository = produtoRepository;
    }

    // =========================
    // HELPER ITEM
    // =========================
    private Item validarItem(Long listaId, Long itemId) {

        return itemRepository
                .findByIdAndListaIdAndDeletadoFalse(itemId, listaId)
                .orElseThrow(() ->
                        new NotFoundException("Item não encontrado"));
    }

    // =========================
    // LISTAR
    // =========================
    public List<ItemResponseDTO> listarPorLista(Long listaId) {

        return itemRepository
                .findByListaIdAndDeletadoFalse(listaId)
                .stream()
                .map(ItemResponseDTO::new)
                .toList();
    }

    // =========================
    // CRIAR
    // =========================
    // TODO: Revisar criação de Lista aqui.
    // Atualmente estamos usando new Lista(listaId) apenas para referência.
    // Ideal seria garantir a entidade gerenciada (Lista real) vinda do ListaService
    // para evitar inconsistências no contexto do Hibernate e melhorar consistência do domínio.
    public ItemResponseDTO criar(Lista lista, ItemRequestDTO dto) {

        Produto produto = produtoRepository.findById(dto.getProdutoId())
                .orElseThrow(() -> new NotFoundException("Produto não encontrado"));

        if (lista.getConcluidoEm() != null) {
            throw new BusinessException("Lista já concluída");
        }

        Item item = itemRepository
                .findByListaIdAndProdutoIdAndDeletadoFalse(lista.getId(), produto.getId())
                .orElse(null);

        if (item != null) {
            item.setQuantidade(item.getQuantidade() + dto.getQuantidade());
            item.setPreco(dto.getPreco());
            return new ItemResponseDTO(itemRepository.save(item));
        }

        Item novo = new Item();
        novo.setLista(lista); // ✔ entidade REAL e gerenciada
        novo.setProduto(produto);
        novo.setQuantidade(dto.getQuantidade());
        novo.setPreco(dto.getPreco());

        return new ItemResponseDTO(itemRepository.save(novo));
    }

    // =========================
    // ATUALIZAR
    // =========================
    public ItemResponseDTO atualizar(
            Long listaId,
            Long itemId,
            ItemUpdateDTO dto
    ) {

        Item item = validarItem(listaId, itemId);

        if (dto.getQuantidade() == null || dto.getQuantidade() <= 0) {
            throw new BusinessException(
                    "Quantidade deve ser maior que zero"
            );
        }

        if (dto.getPreco() == null || dto.getPreco() < 0) {
            throw new BusinessException(
                    "Preço não pode ser negativo"
            );
        }

        item.setQuantidade(dto.getQuantidade());
        item.setPreco(dto.getPreco());

        return new ItemResponseDTO(itemRepository.save(item));
    }

    // =========================
    // MARCAR COMO COMPRADO
    // =========================
    public void marcarComprado(Long listaId, Long itemId) {

        Item item = validarItem(listaId, itemId);

        item.setComprado(true);

        itemRepository.save(item);
    }

    // =========================
    // DESMARCAR
    // =========================
    public void desmarcarComprado(Long listaId, Long itemId) {

        Item item = validarItem(listaId, itemId);

        item.setComprado(false);

        itemRepository.save(item);
    }

    // =========================
    // DELETE LÓGICO
    // =========================
    public void deletar(Long listaId, Long itemId) {

        Item item = validarItem(listaId, itemId);

        item.setDeletado(true);

        itemRepository.save(item);
    }

    // =========================
    // RESUMO
    // =========================
    public Long contarItensAtivos(Long listaId) {
        return itemRepository.contarItensAtivos(listaId);
    }

    public Long contarItensComprados(Long listaId) {
        return itemRepository.contarItensComprados(listaId);
    }
}