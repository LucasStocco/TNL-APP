package com.tnl.listacompras.service.gerenciar_lista;

import com.tnl.listacompras.dto.requestDTO.gerenciar_lista.ItemRequestDTO;
import com.tnl.listacompras.dto.requestDTO.gerenciar_lista.ItemUpdateDTO;
import com.tnl.listacompras.dto.responseDTO.gerenciar_lista.ItemResponseDTO;
import com.tnl.listacompras.model.cadastrar_produto.Produto;
import com.tnl.listacompras.model.gerenciar_lista.Item;
import com.tnl.listacompras.model.gerenciar_lista.Lista;
import com.tnl.listacompras.repository.cadastrar_produto.ProdutoRepository;
import com.tnl.listacompras.repository.gerenciar_lista.ItemRepository;
import com.tnl.listacompras.repository.gerenciar_lista.ListaRepository;
import com.tnl.listacompras.session.Session;

import exception.business.BusinessException;
import exception.business.NotFoundException;

import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ItemService {

    private final ItemRepository itemRepository;
    private final ProdutoRepository produtoRepository;
    private final ListaRepository listaRepository;

    public ItemService(ItemRepository itemRepository,
                       ProdutoRepository produtoRepository,
                       ListaRepository listaRepository) {
        this.itemRepository = itemRepository;
        this.produtoRepository = produtoRepository;
        this.listaRepository = listaRepository;
    }

    // =========================
    // HELPER SEGURANÇA
    // =========================
    private Lista validarLista(Long listaId) {
        Long userId = Session.getUsuarioId();

        return listaRepository.findById(listaId)
                .filter(l -> l.getUsuario().getId().equals(userId))
                .filter(l -> !Boolean.TRUE.equals(l.getDeletado()))
                .orElseThrow(() -> new NotFoundException("Lista não encontrada"));
    }

    private Item validarItem(Long listaId, Long itemId) {
        return itemRepository.findByIdAndListaIdAndDeletadoFalse(itemId, listaId)
                .orElseThrow(() -> new NotFoundException("Item não encontrado"));
    }

    // =========================
    // LISTAR
    // =========================
    public List<ItemResponseDTO> listarPorLista(Long listaId) {

        validarLista(listaId);

        return itemRepository.findByListaIdAndDeletadoFalse(listaId)
                .stream()
                .map(ItemResponseDTO::new)
                .toList();
    }

    // =========================
    // CRIAR (SEM DUPLICAR)
    // =========================
    public ItemResponseDTO criar(Long listaId, ItemRequestDTO dto) {

        Lista lista = validarLista(listaId);

        if (lista.getConcluidoEm() != null) {
            throw new BusinessException("Lista já concluída");
        }

        Produto produto = produtoRepository.findById(dto.getProdutoId())
                .orElseThrow(() -> new NotFoundException("Produto não encontrado"));

        Optional<Item> itemExistente =
                itemRepository.findByListaIdAndProdutoIdAndDeletadoFalse(
                        listaId, produto.getId()
                );

        if (itemExistente.isPresent()) {
            Item item = itemExistente.get();

            item.setQuantidade(item.getQuantidade() + dto.getQuantidade());

            // 🔥 ATUALIZA PREÇO TAMBÉM
            item.setPreco(dto.getPreco());

            return new ItemResponseDTO(itemRepository.save(item));
        }

        Item item = new Item();
        item.setLista(lista);
        item.setProduto(produto);
        item.setQuantidade(dto.getQuantidade());
        item.setPreco(dto.getPreco()); // 🔥 ESSENCIAL

        return new ItemResponseDTO(itemRepository.save(item));
    }
    // =========================
    // ATUALIZAR QUANTIDADE
    // =========================
    public ItemResponseDTO atualizar(Long listaId, Long itemId, ItemUpdateDTO dto) {

        Item item = validarItem(listaId, itemId);

        if (dto.getQuantidade() <= 0) {
            throw new BusinessException("Quantidade deve ser maior que zero");
        }

        item.setQuantidade(dto.getQuantidade());
        item.setPreco(dto.getPreco()); // 🔥 NOVO

        return new ItemResponseDTO(itemRepository.save(item));
    }

    // =========================
    // MARCAR COMO COMPRADO
    // =========================
    public void marcarComprado(Long listaId, Long itemId) {

        validarLista(listaId);

        Item item = validarItem(listaId, itemId);

        item.setComprado(true);

        itemRepository.save(item);
    }

    // =========================
    // DESMARCAR
    // =========================
    public void desmarcarComprado(Long listaId, Long itemId) {

        validarLista(listaId);

        Item item = validarItem(listaId, itemId);

        item.setComprado(false);

        itemRepository.save(item);
    }

    // =========================
    // DELETE LÓGICO
    // =========================
    public void deletar(Long listaId, Long itemId) {

        validarLista(listaId);

        Item item = validarItem(listaId, itemId);

        item.setDeletado(true);

        itemRepository.save(item);
    }
}