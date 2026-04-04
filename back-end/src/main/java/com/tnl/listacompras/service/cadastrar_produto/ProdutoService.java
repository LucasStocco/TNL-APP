package com.tnl.listacompras.service.cadastrar_produto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.tnl.listacompras.dto.requestDTO.cadastrar_produto.ProdutoRequestDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_categoria.CategoriaResponseDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_produto.ProdutoResponseDTO;
import com.tnl.listacompras.model.cadastrar_categoria.Categoria;
import com.tnl.listacompras.model.cadastrar_produto.Produto;
import com.tnl.listacompras.repository.cadastrar_categoria.CategoriaRepository;
import com.tnl.listacompras.repository.cadastrar_produto.ProdutoRepository;

import org.springframework.http.HttpStatus;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ProdutoService {

    @Autowired
    private ProdutoRepository produtoRepository;

    @Autowired
    private CategoriaRepository categoriaRepository;

    // BUSCAR ENTIDADE (para ItemService)
    public Produto buscarEntidadePorId(Long id) {
        return produtoRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Produto não encontrado"));
    }

    // BUSCAR DTO (para ProdutoController)
    public ProdutoResponseDTO buscarPorIdDTO(Long id) {
        Produto produto = buscarEntidadePorId(id);
        return converterParaDTO(produto);
    }

    // LISTAR TODOS
    public List<ProdutoResponseDTO> listarTodos() {
        return produtoRepository.findAll()
                .stream()
                .map(this::converterParaDTO)
                .collect(Collectors.toList());
    }

    // CRIAR
    public ProdutoResponseDTO criar(ProdutoRequestDTO dto) {
        Categoria categoria = categoriaRepository.findById(dto.getCategoriaId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Categoria não encontrada"));

        // --- VERIFICAÇÃO DE DUPLICIDADE ---
        boolean existe = produtoRepository.existsByNomeAndCategoriaId(dto.getNome(), dto.getCategoriaId());
        if (existe) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Produto já existe nesta categoria");
        }

        Produto produto = new Produto();
        produto.setNome(dto.getNome());
        produto.setDescricao(dto.getDescricao());
        produto.setPreco(dto.getPreco());
        produto.setCategoria(categoria);

        Produto salvo = produtoRepository.save(produto);
        return converterParaDTO(salvo);
    }

    // ATUALIZAR
    public ProdutoResponseDTO atualizar(Long id, ProdutoRequestDTO dto) {
        Produto produto = buscarEntidadePorId(id);
        Categoria categoria = categoriaRepository.findById(dto.getCategoriaId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Categoria não encontrada"));

        // --- VERIFICAR DUPLICIDADE AO ATUALIZAR ---
        boolean existeOutroProduto = produtoRepository.existsByNomeAndCategoriaId(dto.getNome(), dto.getCategoriaId())
                && !produto.getId().equals(id); // ignora o próprio produto que está sendo atualizado

        if (existeOutroProduto) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Outro produto com este nome já existe nesta categoria");
        }

        produto.setNome(dto.getNome());
        produto.setDescricao(dto.getDescricao());
        produto.setPreco(dto.getPreco());
        produto.setCategoria(categoria);

        Produto salvo = produtoRepository.save(produto);
        return converterParaDTO(salvo);
    }

    // DELETAR
    public boolean deletar(Long id) {
        Optional<Produto> opt = produtoRepository.findById(id);
        if(opt.isPresent()) {
            produtoRepository.delete(opt.get());
            return true;
        }
        return false;
    }

    // CONVERTER PARA DTO
    public ProdutoResponseDTO converterParaDTO(Produto produto) {
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