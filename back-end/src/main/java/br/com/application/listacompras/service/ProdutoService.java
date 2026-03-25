package br.com.application.listacompras.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import br.com.application.listacompras.dto.CategoriaResponseDTO;
import br.com.application.listacompras.dto.ProdutoRequestDTO;
import br.com.application.listacompras.dto.ProdutoResponseDTO;
import br.com.application.listacompras.model.Categoria;
import br.com.application.listacompras.model.Produto;
import br.com.application.listacompras.repository.CategoriaRepository;
import br.com.application.listacompras.repository.ProdutoRepository;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ProdutoService {

    @Autowired
    private ProdutoRepository produtoRepository;

    @Autowired
    private CategoriaRepository categoriaRepository;

    // LISTAR TODOS
    public List<ProdutoResponseDTO> listarTodos() {
        return produtoRepository.findAll()
                .stream()
                .map(this::converterParaDTO)
                .collect(Collectors.toList());
    }

    // BUSCAR POR ID
    public ProdutoResponseDTO buscarPorId(Long id) {
        return produtoRepository.findById(id)
                .map(this::converterParaDTO)
                .orElse(null);
    }

    // CRIAR
    public ProdutoResponseDTO criar(ProdutoRequestDTO dto) {
        Categoria categoria = categoriaRepository.findById(dto.getCategoriaId())
                .orElseThrow(() -> new RuntimeException("Categoria não encontrada"));

        Produto produto = new Produto();
        produto.setNome(dto.getNome());
        produto.setDescricao(dto.getDescricao());   // ✅ agora pega a descrição
        produto.setPreco(dto.getPreco());           // ✅ agora pega o preço
        produto.setCategoria(categoria);

        return converterParaDTO(produtoRepository.save(produto));
    }

    // ATUALIZAR
    public ProdutoResponseDTO atualizar(Long id, ProdutoRequestDTO dto) {
        return produtoRepository.findById(id)
                .map(produto -> {
                    Categoria categoria = categoriaRepository.findById(dto.getCategoriaId())
                            .orElseThrow(() -> new RuntimeException("Categoria não encontrada"));
                    produto.setNome(dto.getNome());
                    produto.setDescricao(dto.getDescricao());
                    produto.setPreco(dto.getPreco());
                    produto.setCategoria(categoria);
                    return converterParaDTO(produtoRepository.save(produto));
                }).orElse(null);
    }

    // DELETAR
    public boolean deletar(Long id) {
        return produtoRepository.findById(id)
                .map(produto -> {
                    produtoRepository.delete(produto);
                    return true;
                }).orElse(false);
    }

    // CONVERSOR PARA DTO
    private ProdutoResponseDTO converterParaDTO(Produto produto) {
        CategoriaResponseDTO categoriaDTO = new CategoriaResponseDTO(
                produto.getCategoria().getId(),
                produto.getCategoria().getNome()
        );

        return new ProdutoResponseDTO(
                produto.getId(),
                produto.getNome(),
                produto.getDescricao(),
                produto.getPreco(),
                categoriaDTO
        );
    }
}