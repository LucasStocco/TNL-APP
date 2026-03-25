package br.com.application.listacompras.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import br.com.application.listacompras.dto.CategoriaResponseDTO;
import br.com.application.listacompras.dto.ItemRequestDTO;
import br.com.application.listacompras.dto.ItemResponseDTO;
import br.com.application.listacompras.dto.ProdutoRequestDTO;
import br.com.application.listacompras.dto.ProdutoResponseDTO;
import br.com.application.listacompras.model.Item;
import br.com.application.listacompras.model.Lista;
import br.com.application.listacompras.model.Produto;
import br.com.application.listacompras.model.Categoria;
import br.com.application.listacompras.repository.ItemRepository;
import br.com.application.listacompras.repository.ListaRepository;
import br.com.application.listacompras.repository.ProdutoRepository;
import br.com.application.listacompras.repository.CategoriaRepository;

@Service
public class ItemService {

    @Autowired
    private ItemRepository itemRepository;

    @Autowired
    private ListaRepository listaRepository;

    @Autowired
    private ProdutoRepository produtoRepository;

    @Autowired
    private CategoriaRepository categoriaRepository;

    // CRIAR ITEM
    public ItemResponseDTO criar(Long listaId, ItemRequestDTO dto) {
        Lista lista = listaRepository.findById(listaId)
                .orElseThrow(() -> new RuntimeException("Lista não encontrada"));

        // Primeiro, cria ou busca o produto
        Produto produto = new Produto();
        ProdutoRequestDTO pDto = dto.getProduto();

        // Buscar categoria
        Categoria categoria = categoriaRepository.findById(pDto.getCategoriaId())
                .orElseThrow(() -> new RuntimeException("Categoria não encontrada"));

        produto.setNome(pDto.getNome());
        produto.setDescricao(pDto.getDescricao());
        produto.setPreco(pDto.getPreco());
        produto.setCategoria(categoria);

        Produto produtoSalvo = produtoRepository.save(produto);

        // Criar item
        Item item = new Item();
        item.setQuantidade(dto.getQuantidade());
        item.setComprado(dto.getComprado() != null ? dto.getComprado() : false);
        item.setProduto(produtoSalvo);
        item.setLista(lista);

        Item salvo = itemRepository.save(item);

        // Atualiza dataConclusao da lista
        lista.verificarConclusao();
        listaRepository.save(lista);

        return converterParaDTO(salvo);
    }

    // LISTAR ITENS POR LISTA
    public List<ItemResponseDTO> listarPorLista(Long listaId) {
        return itemRepository.findByListaId(listaId)
                .stream()
                .map(this::converterParaDTO)
                .collect(Collectors.toList());
    }

    // BUSCAR ITEM POR ID
    public ItemResponseDTO buscarPorId(Long listaId, Long itemId) {
        Item item = itemRepository.findById(itemId).orElse(null);
        if (item == null || !item.getLista().getId().equals(listaId)) return null;
        return converterParaDTO(item);
    }

    // ATUALIZAR ITEM
    public ItemResponseDTO atualizar(Long listaId, Long id, ItemRequestDTO dto) {
        Item item = itemRepository.findById(id).orElse(null);
        if (item == null || !item.getLista().getId().equals(listaId)) return null;

        item.setQuantidade(dto.getQuantidade());
        item.setComprado(dto.getComprado() != null ? dto.getComprado() : item.getComprado());

        // Atualizar produto
        ProdutoRequestDTO pDto = dto.getProduto();
        Categoria categoria = categoriaRepository.findById(pDto.getCategoriaId())
                .orElseThrow(() -> new RuntimeException("Categoria não encontrada"));

        Produto produto = item.getProduto();
        produto.setNome(pDto.getNome());
        produto.setDescricao(pDto.getDescricao());
        produto.setPreco(pDto.getPreco());
        produto.setCategoria(categoria);

        produtoRepository.save(produto);
        Item atualizado = itemRepository.save(item);

        // Atualiza dataConclusao da lista
        Lista lista = atualizado.getLista();
        lista.verificarConclusao();
        listaRepository.save(lista);

        return converterParaDTO(atualizado);
    }

    // DELETAR ITEM
    public boolean deletar(Long listaId, Long id) {
        Item item = itemRepository.findById(id).orElse(null);
        if (item == null || !item.getLista().getId().equals(listaId)) return false;

        itemRepository.delete(item);

        // Atualiza dataConclusao da lista
        Lista lista = item.getLista();
        lista.verificarConclusao();
        listaRepository.save(lista);

        return true;
    }

    // CONVERTER ITEM PARA DTO
    private ItemResponseDTO converterParaDTO(Item item) {
        CategoriaResponseDTO categoriaDTO = new CategoriaResponseDTO(
                item.getProduto().getCategoria().getId(),
                item.getProduto().getCategoria().getNome()
        );

        ProdutoResponseDTO produtoDTO = new ProdutoResponseDTO(
                item.getProduto().getId(),
                item.getProduto().getNome(),
                item.getProduto().getDescricao(),
                item.getProduto().getPreco(),
                categoriaDTO
        );

        return new ItemResponseDTO(
                item.getId(),
                item.getQuantidade(),
                item.getComprado(),
                produtoDTO
        );
    }
}