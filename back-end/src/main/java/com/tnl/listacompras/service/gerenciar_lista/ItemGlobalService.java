package com.tnl.listacompras.service.gerenciar_lista;

import java.time.LocalDateTime;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.tnl.listacompras.dto.requestDTO.gerenciar_lista.ItemGlobalRequestDTO;
import com.tnl.listacompras.dto.requestDTO.gerenciar_lista.ItemUpdateDTO;
import com.tnl.listacompras.dto.responseDTO.gerenciar_lista.ItemResponseDTO;
import com.tnl.listacompras.model.cadastrar_categoria.Categoria;
import com.tnl.listacompras.model.cadastrar_produto.Produto;
import com.tnl.listacompras.model.gerenciar_lista.Item;
import com.tnl.listacompras.repository.cadastrar_categoria.CategoriaRepository;
import com.tnl.listacompras.repository.cadastrar_produto.ProdutoRepository;
import com.tnl.listacompras.repository.gerenciar_lista.ItemRepository;

@Service
public class ItemGlobalService {

    private static final String TAG = "[ITEM-GLOBAL] ";

    private final ItemRepository repository;
    private final ProdutoRepository produtoRepository;
    private final CategoriaRepository categoriaRepository;

    public ItemGlobalService(ItemRepository repository,
                             ProdutoRepository produtoRepository,
                             CategoriaRepository categoriaRepository) {
        this.repository = repository;
        this.produtoRepository = produtoRepository;
        this.categoriaRepository = categoriaRepository;
    }

    // ================= CREATE =================
    @Transactional
    public ItemResponseDTO criar(Long idLista, ItemGlobalRequestDTO dto) {

        System.out.println(TAG + "CRIAR idLista=" + idLista);

        int qtd = dto.getQuantidade() != null ? dto.getQuantidade() : 1;

        var existente = repository.findByIdListaAndIdProdutoAndDeletadoFalse(
                idLista,
                dto.getIdProduto()
        );

        if (existente.isPresent()) {
            Item item = existente.get();

            item.setQuantidade(item.getQuantidade() + qtd);

            System.out.println(TAG + "ITEM EXISTENTE -> soma qtd");

            return new ItemResponseDTO(repository.save(item));
        }

        Produto produto = produtoRepository.findById(dto.getIdProduto())
                .orElseThrow(() -> new RuntimeException("Produto não encontrado"));

        Categoria categoria = categoriaRepository.findById(dto.getIdCategoria())
                .orElseThrow(() -> new RuntimeException("Categoria não encontrada"));

        Item item = new Item();

        item.setIdLista(idLista);
        item.setQuantidade(qtd);
        item.setComprado(false);
        item.setDeletado(false);

        item.setIdProduto(produto.getId());
        item.setNomeProdutoSnapshot(produto.getNome());

        // 🔥 CORREÇÃO AQUI
        java.math.BigDecimal preco = produto.getPreco();

        if (preco == null) {
            System.out.println(TAG + "PRODUTO SEM PREÇO -> usando ZERO");
            preco = java.math.BigDecimal.ZERO;
        }

        item.setPrecoProdutoSnapshot(preco);

        item.setIdCategoria(categoria.getId());
        item.setNomeCategoriaSnapshot(categoria.getNome());
        item.setCodigoCategoriaSnapshot(categoria.getCodigo());

        Item saved = repository.save(item);

        System.out.println(TAG + "CRIADO id=" + saved.getId());

        return new ItemResponseDTO(saved);
    }

    // ================= UPDATE =================
    @Transactional
    public ItemResponseDTO atualizar(Item item, ItemUpdateDTO dto) {

        System.out.println(TAG + "UPDATE idItem=" + item.getId());

        // =========================
        // QUANTIDADE (SEMPRE PERMITIDO)
        // =========================
        if (dto.getQuantidade() != null && dto.getQuantidade() > 0) {
            item.setQuantidade(dto.getQuantidade());
        }

        // =========================
        // CATEGORIA (PERMITIDO)
        // =========================
        if (dto.getIdCategoria() != null) {

            Categoria categoria = categoriaRepository.findById(dto.getIdCategoria())
                    .orElseThrow(() -> new RuntimeException("Categoria não encontrada"));

            item.setIdCategoria(categoria.getId());
            item.setNomeCategoriaSnapshot(categoria.getNome());
            item.setCodigoCategoriaSnapshot(categoria.getCodigo());
        }

        // =========================
        // 🚫 BLOQUEIO DE SNAPSHOT (REGRA GLOBAL)
        // =========================
        if (item.getIdProduto() != null) {

            if (dto.getNomeProdutoSnapshot() != null || dto.getPrecoProdutoSnapshot() != null) {
                System.out.println(TAG + "IGNORANDO edição de snapshot (item global)");
            }
        }

        Item saved = repository.save(item);

        System.out.println(TAG + "ATUALIZADO id=" + saved.getId());

        return new ItemResponseDTO(saved);
    }

    // ================= DELETE =================
    @Transactional
    public void deletar(Item item) {

        System.out.println(TAG + "DELETE id=" + item.getId());

        item.setDeletado(true);

        repository.save(item);
    }
}