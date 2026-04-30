package com.tnl.listacompras.service.cadastrar_produto;

import com.tnl.listacompras.dto.requestDTO.cadastrar_produto.ProdutoRequestDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_produto.ProdutoResponseDTO;
import com.tnl.listacompras.model.cadastrar_categoria.Categoria;
import com.tnl.listacompras.model.cadastrar_produto.Produto;
import com.tnl.listacompras.repository.cadastrar_categoria.CategoriaRepository;
import com.tnl.listacompras.repository.cadastrar_produto.ProdutoRepository;

import exception.business.BusinessException;
import exception.business.NotFoundException;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProdutoService {

    private final ProdutoRepository produtoRepository;
    private final CategoriaRepository categoriaRepository;

    public ProdutoService(ProdutoRepository produtoRepository,
                          CategoriaRepository categoriaRepository) {
        this.produtoRepository = produtoRepository;
        this.categoriaRepository = categoriaRepository;
    }

    // =========================
    // LISTAR
    // =========================
    public List<ProdutoResponseDTO> listar() {
        return produtoRepository.findAll()
                .stream()
                .map(ProdutoResponseDTO::new)
                .toList();
    }

    // =========================
    // BUSCAR
    // =========================
    public ProdutoResponseDTO buscar(Long id) {
        Produto produto = produtoRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Produto não encontrado"));

        return new ProdutoResponseDTO(produto);
    }

    // =========================
    // CRIAR
    // =========================
    public ProdutoResponseDTO criar(ProdutoRequestDTO dto) {

        String nome = dto.getNome().trim();
        String descricao = dto.getDescricao() == null ? "" : dto.getDescricao().trim();

        if (produtoRepository.existsByNomeIgnoreCaseAndDescricaoIgnoreCaseAndCategoriaId(
                nome,
                descricao,
                dto.getIdCategoria()
        )) {
            throw new BusinessException("Produto já existe com esse nome, descrição e categoria");
        }

        Categoria categoria = categoriaRepository.findById(dto.getIdCategoria())
                .orElseThrow(() -> new NotFoundException("Categoria não encontrada"));

        Produto produto = new Produto();
        produto.setNome(nome);
        produto.setDescricao(descricao);
        produto.setCategoria(categoria);

        return new ProdutoResponseDTO(produtoRepository.save(produto));
    }

    // =========================
    // ATUALIZAR
    // =========================
    public ProdutoResponseDTO atualizar(Long id, ProdutoRequestDTO dto) {

        Produto produto = produtoRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Produto não encontrado"));

        String nome = dto.getNome().trim();
        String descricao = dto.getDescricao() == null ? "" : dto.getDescricao().trim();

        // ⚠️ evita duplicidade ao atualizar
        boolean existe = produtoRepository
                .existsByNomeIgnoreCaseAndDescricaoIgnoreCaseAndCategoriaId(
                        nome,
                        descricao,
                        dto.getIdCategoria()
                );

        if (existe &&
            !(produto.getNome().equalsIgnoreCase(nome)
              && ((produto.getDescricao() == null ? "" : produto.getDescricao()).equalsIgnoreCase(descricao))
              && produto.getCategoria().getId().equals(dto.getIdCategoria()))) {

            throw new BusinessException("Produto já existe com esse nome, descrição e categoria");
        }

        Categoria categoria = categoriaRepository.findById(dto.getIdCategoria())
                .orElseThrow(() -> new NotFoundException("Categoria não encontrada"));

        produto.setNome(nome);
        produto.setDescricao(descricao);
        produto.setCategoria(categoria);

        return new ProdutoResponseDTO(produtoRepository.save(produto));
    }

    // =========================
    // DELETE
    // =========================
    public void deletar(Long id) {

        Produto produto = produtoRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Produto não encontrado"));

        produtoRepository.delete(produto);
    }
}