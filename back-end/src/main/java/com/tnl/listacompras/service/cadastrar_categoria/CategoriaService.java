package com.tnl.listacompras.service.cadastrar_categoria;

import com.tnl.listacompras.dto.requestDTO.cadastrar_categoria.CategoriaRequestDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_categoria.CategoriaResponseDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_produto.ProdutoResponseDTO;
import com.tnl.listacompras.model.cadastrar_categoria.Categoria;
import com.tnl.listacompras.repository.cadastrar_categoria.CategoriaRepository;
import com.tnl.listacompras.repository.cadastrar_produto.ProdutoRepository;
import exception.business.NotFoundException;
import utils.CodigoUtils;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoriaService {

    private final CategoriaRepository repository;
    private final ProdutoRepository produtoRepository;

    public CategoriaService(
            CategoriaRepository repository,
            ProdutoRepository produtoRepository
    ) {
        this.repository = repository;
        this.produtoRepository = produtoRepository;
    }

    // ================= LISTAR =================
    public List<CategoriaResponseDTO> listar() {
        return repository.findByDeletadoFalse()
                .stream()
                .map(CategoriaResponseDTO::new)
                .toList();
    }

    // ================= BUSCAR =================
    public CategoriaResponseDTO buscar(Long id) {
        Categoria categoria = repository.findByIdAndDeletadoFalse(id)
                .orElseThrow(() -> new NotFoundException("Categoria não encontrada"));

        return new CategoriaResponseDTO(categoria);
    }

    // ================= CRIAR =================
    public CategoriaResponseDTO criar(CategoriaRequestDTO dto) {

        Categoria categoria = new Categoria();
        categoria.setNome(dto.getNome());

        String codigo = gerarCodigoUnico(dto.getNome());
        categoria.setCodigo(codigo);

        return new CategoriaResponseDTO(repository.save(categoria));
    }

    // ================= ATUALIZAR =================
    public CategoriaResponseDTO atualizar(Long id, CategoriaRequestDTO dto) {

        Categoria categoria = repository.findByIdAndDeletadoFalse(id)
                .orElseThrow(() -> new NotFoundException("Categoria não encontrada"));

        categoria.setNome(dto.getNome());

        String codigo = gerarCodigoUnico(dto.getNome());
        categoria.setCodigo(codigo);

        return new CategoriaResponseDTO(repository.save(categoria));
    }

    // ================= LISTAR PRODUTOS =================
    public List<ProdutoResponseDTO> listarProdutosPorCategoria(Long idCategoria) {
        return produtoRepository.findByCategoriaId(idCategoria)
                .stream()
                .map(ProdutoResponseDTO::new)
                .toList();
    }

    // ================= DELETE =================
    public void deletar(Long id) {

        Categoria categoria = repository.findByIdAndDeletadoFalse(id)
                .orElseThrow(() -> new NotFoundException("Categoria não encontrada"));

        categoria.setDeletado(true);

        repository.save(categoria);
    }

    // ================= GERADOR DE CÓDIGO =================
    private String gerarCodigoUnico(String nome) {

        String base = CodigoUtils.gerarCodigo(nome);
        String codigo = base;

        int i = 1;
        while (repository.existsByCodigoIgnoreCase(codigo)) {
            codigo = base + "_" + i++;
        }

        return codigo;
    }
}