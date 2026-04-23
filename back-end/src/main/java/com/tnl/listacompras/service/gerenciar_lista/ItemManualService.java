package com.tnl.listacompras.service.gerenciar_lista;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.tnl.listacompras.dto.requestDTO.gerenciar_lista.*;
import com.tnl.listacompras.dto.responseDTO.gerenciar_lista.ItemResponseDTO;

import com.tnl.listacompras.model.cadastrar_categoria.Categoria;
import com.tnl.listacompras.model.cadastrar_produto.Produto;
import com.tnl.listacompras.model.gerenciar_lista.Item;

import com.tnl.listacompras.repository.cadastrar_categoria.CategoriaRepository;
import com.tnl.listacompras.repository.cadastrar_produto.ProdutoRepository;
import com.tnl.listacompras.repository.gerenciar_lista.ItemRepository;

import java.util.List;

@Service
public class ItemManualService {

    private static final String TAG = "[ITEM-MANUAL] ";

    private final ItemRepository repository;
    private final CategoriaRepository categoriaRepository;
    private final ProdutoRepository produtoRepository;
    
    public Item getEntity(Long idLista, Long idItem) {
        return repository.findByIdAndIdListaAndDeletadoFalse(idItem, idLista)
                .orElseThrow(() -> new RuntimeException("Item não encontrado"));
    }

    public ItemManualService(ItemRepository repository,
                             CategoriaRepository categoriaRepository,
                             ProdutoRepository produtoRepository) {
        this.repository = repository;
        this.categoriaRepository = categoriaRepository;
        this.produtoRepository = produtoRepository;
    }
    
 // ================= COMPRADO =================
    @Transactional
    public void marcarComprado(Long idLista, Long idItem, boolean valor) {

        System.out.println(TAG + "COMPRADO idItem=" + idItem + " valor=" + valor);

        Item item = repository.findByIdAndIdListaAndDeletadoFalse(idItem, idLista)
                .orElseThrow(() -> new RuntimeException("Item não encontrado"));

        item.setComprado(valor);

        repository.save(item);

        System.out.println(TAG + "ITEM ATUALIZADO COMPRADO=" + valor);
    }
    
    

    // ================= CREATE =================
    @Transactional
    public ItemResponseDTO criar(Long idLista, ItemManualRequestDTO dto) {

        System.out.println(TAG + "CRIAR idLista=" + idLista);

        Categoria categoria = categoriaRepository.findById(dto.getIdCategoria())
                .orElseThrow(() -> new RuntimeException("Categoria não encontrada"));

        Item item = new Item();

        aplicarBase(item, idLista, dto.getQuantidade());
        aplicarSnapshot(item, dto);
        aplicarCategoria(item, categoria);

        Item saved = repository.save(item);

        System.out.println(TAG + "CRIADO id=" + saved.getId());

        return new ItemResponseDTO(saved);
    }
    
    // LISTA POR LISTA
    public List<ItemResponseDTO> listarPorLista(Long idLista) {

        System.out.println(TAG + "LISTAR ITENS - lista=" + idLista);

        return repository.listarPorLista(idLista)
                .stream()
                .map(ItemResponseDTO::new)
                .toList();
    }
    
    // BUSCAR POR CATEGORIA
    public List<ItemResponseDTO> buscarPorCategoria(Long idLista, Long idCategoria) {

        System.out.println(TAG + "LISTAR POR CATEGORIA lista=" + idLista + " cat=" + idCategoria);

        return repository.findByIdListaAndIdCategoriaAndDeletadoFalse(idLista, idCategoria)
                .stream()
                .map(ItemResponseDTO::new)
                .toList();
    }

    // ================= UPDATE =================
    @Transactional
    public ItemResponseDTO atualizar(Long idLista, Long idItem, ItemUpdateDTO dto) {

        System.out.println(TAG + "UPDATE idItem=" + idItem);

        Item item = repository.findByIdAndIdListaAndDeletadoFalse(idItem, idLista)
                .orElseThrow(() -> new RuntimeException("Item não encontrado"));

        if (dto.getQuantidade() != null) {
            item.setQuantidade(dto.getQuantidade());
        }

        if (dto.getNomeProdutoSnapshot() != null) {
            item.setNomeProdutoSnapshot(dto.getNomeProdutoSnapshot());
        }

        if (dto.getPrecoProdutoSnapshot() != null) {
            item.setPrecoProdutoSnapshot(dto.getPrecoProdutoSnapshot());
        }

        if (dto.getIdCategoria() != null) {
            Categoria categoria = categoriaRepository.findById(dto.getIdCategoria())
                    .orElseThrow(() -> new RuntimeException("Categoria não encontrada"));

            aplicarCategoria(item, categoria);
        }

        Item saved = repository.save(item);

        System.out.println(TAG + "ATUALIZADO");

        return new ItemResponseDTO(saved);
    }

    // ================= DELETE =================
    @Transactional
    public void deletar(Long idLista, Long idItem) {

        System.out.println(TAG + "DELETE idItem=" + idItem);

        Item item = repository.findByIdAndIdListaAndDeletadoFalse(idItem, idLista)
                .orElseThrow(() -> new RuntimeException("Item não encontrado"));

        item.setDeletado(true);

        repository.save(item);

        System.out.println(TAG + "DELETADO");
    }
    
    // ================= COMPRADO =================
    @Transactional
    public void marcarComprado(Long idLista, Long idItem) {

        Item item = repository.findByIdAndIdListaAndDeletadoFalse(idItem, idLista)
                .orElseThrow(() -> new RuntimeException("Item não encontrado"));

        item.setComprado(!Boolean.TRUE.equals(item.getComprado()));

        repository.save(item);
    }

    // ================= HELPERS =================
    private void aplicarBase(Item item, Long idLista, Integer quantidade) {
        item.setIdLista(idLista);
        item.setQuantidade(quantidade != null ? quantidade : 1);
        item.setComprado(false);
        item.setDeletado(false);
    }

    private void aplicarSnapshot(Item item, ItemManualRequestDTO dto) {
        item.setNomeProdutoSnapshot(dto.getNomeProdutoSnapshot());
        item.setPrecoProdutoSnapshot(dto.getPrecoProdutoSnapshot());
    }

    private void aplicarCategoria(Item item, Categoria categoria) {
        item.setIdCategoria(categoria.getId());
        item.setNomeCategoriaSnapshot(categoria.getNome());
        item.setCodigoCategoriaSnapshot(categoria.getCodigo());
    }
}