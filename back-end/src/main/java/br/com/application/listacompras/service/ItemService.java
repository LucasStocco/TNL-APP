package br.com.application.listacompras.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import br.com.application.listacompras.dto.ItemRequestDTO;
import br.com.application.listacompras.dto.ItemResponseDTO;
import br.com.application.listacompras.dto.ProdutoResponseDTO;
import br.com.application.listacompras.dto.CategoriaResponseDTO;
import br.com.application.listacompras.model.Item;
import br.com.application.listacompras.model.Lista;
import br.com.application.listacompras.model.Produto;
import br.com.application.listacompras.repository.ItemRepository;
import br.com.application.listacompras.repository.ListaRepository;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ItemService {

    @Autowired
    private ItemRepository itemRepository;

    @Autowired
    private ListaRepository listaRepository;

    @Autowired
    private ProdutoService produtoService;

    // ===============================
    // CRIAR ITEM
    // ===============================
    public ItemResponseDTO criar(Long listaId, ItemRequestDTO dto) {

        Lista lista = listaRepository.findById(listaId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Lista não encontrada"));

        validarItemDto(dto);

        Produto produto = null;
        if (dto.getProdutoId() != null) {
            produto = produtoService.buscarEntidadePorId(dto.getProdutoId());
        }

        Item item = new Item();
        item.setLista(lista);
        item.setProduto(produto);
        item.setQuantidade(dto.getQuantidade());
        item.setComprado(dto.getComprado() != null ? dto.getComprado() : false);

        Item salvo = itemRepository.save(item);

        return converterParaDTO(salvo);
    }

    // ===============================
    // LISTAR ITENS
    // ===============================
    public List<ItemResponseDTO> listarPorLista(Long listaId) {
        return itemRepository.findByListaId(listaId)
                .stream()
                .map(this::converterParaDTO)
                .collect(Collectors.toList());
    }

    // ===============================
    // BUSCAR POR ID
    // ===============================
    public ItemResponseDTO buscarPorId(Long listaId, Long itemId) {
        Item item = itemRepository.findById(itemId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Item não encontrado"));

        if (!item.getLista().getId().equals(listaId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Item não pertence a esta lista");
        }

        return converterParaDTO(item);
    }

    // ===============================
    // ATUALIZAR
    // ===============================
    public ItemResponseDTO atualizar(Long listaId, Long itemId, ItemRequestDTO dto) {

        Item item = itemRepository.findById(itemId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Item não encontrado"));

        if (!item.getLista().getId().equals(listaId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Item não pertence a esta lista");
        }

        validarItemDto(dto);

        Produto produto = null;
        if (dto.getProdutoId() != null) {
            produto = produtoService.buscarEntidadePorId(dto.getProdutoId());
        }

        item.setQuantidade(dto.getQuantidade());
        item.setComprado(dto.getComprado() != null ? dto.getComprado() : false);
        item.setProduto(produto);

        Item salvo = itemRepository.save(item);

        return converterParaDTO(salvo);
    }

    // ===============================
    // DELETAR
    // ===============================
    public boolean deletar(Long listaId, Long itemId) {
        Item item = itemRepository.findById(itemId).orElse(null);

        if (item == null || !item.getLista().getId().equals(listaId)) {
            return false;
        }

        itemRepository.delete(item);
        return true;
    }

    // ===============================
    // VALIDAÇÃO
    // ===============================
    private void validarItemDto(ItemRequestDTO dto) {

        if (dto.getQuantidade() == null || dto.getQuantidade() <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Quantidade deve ser maior que 0");
        }

        // comprado default
        if (dto.getComprado() == null) {
            dto.setComprado(false);
        }

        // 🔥 regra opcional (recomendo manter):
        // se não tem produto, ainda assim permite (item manual)
        // então NÃO bloqueamos produtoId null
    }

    // ===============================
    // CONVERSÃO
    // ===============================
    private ItemResponseDTO converterParaDTO(Item item) {

        ProdutoResponseDTO produtoDTO = null;

        if (item.getProduto() != null) {

            Produto p = item.getProduto();

            CategoriaResponseDTO categoriaDTO = null;

            if (p.getCategoria() != null) {
                categoriaDTO = new CategoriaResponseDTO(
                        p.getCategoria().getId(),
                        p.getCategoria().getNome()
                );
            }

            produtoDTO = new ProdutoResponseDTO(
                    p.getId(),
                    p.getNome(),
                    p.getDescricao(),
                    p.getPreco(),
                    categoriaDTO
            );
        }

        return new ItemResponseDTO(
                item.getId(),
                item.getQuantidade(),
                item.getComprado(),
                produtoDTO
        );
    }
}