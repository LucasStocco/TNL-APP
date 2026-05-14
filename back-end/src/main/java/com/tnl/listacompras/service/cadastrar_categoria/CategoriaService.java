package com.tnl.listacompras.service.cadastrar_categoria;

import com.tnl.listacompras.dto.requestDTO.cadastrar_categoria.CategoriaRequestDTO;
import com.tnl.listacompras.dto.requestDTO.cadastrar_categoria.SubcategoriaRequestDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_categoria.CategoriaCompletaResponseDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_categoria.CategoriaResponseDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_categoria.SubcategoriaCompletaResponseDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_categoria.SubcategoriaResponseDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_produto.ProdutoResponseDTO;
import com.tnl.listacompras.model.cadastrar_categoria.Categoria;
import com.tnl.listacompras.model.cadastrar_categoria.Subcategoria;
import com.tnl.listacompras.repository.cadastrar_categoria.CategoriaRepository;
import com.tnl.listacompras.repository.cadastrar_categoria.SubcategoriaRepository;
import com.tnl.listacompras.repository.cadastrar_produto.ProdutoRepository;

import exception.business.BusinessException;
import exception.business.NotFoundException;
import utils.CodigoUtils;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoriaService {

    private final CategoriaRepository repository;
    private final ProdutoRepository produtoRepository;
    private final SubcategoriaRepository subcategoriaRepository;

    public CategoriaService(
            CategoriaRepository repository,
            ProdutoRepository produtoRepository,
            SubcategoriaRepository subcategoriaRepository
    ) {
        this.repository = repository;
        this.produtoRepository = produtoRepository;
        this.subcategoriaRepository = subcategoriaRepository;
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

        String nome = dto.getNome().trim();

        boolean existe = repository.existsByNomeIgnoreCaseAndDeletadoFalse(nome);

        if (existe) {
            throw new BusinessException("Já existe uma categoria com esse nome");
        }

        Categoria categoria = new Categoria();
        categoria.setNome(nome);

        String codigo = gerarCodigoUnico(nome);
        categoria.setCodigo(codigo);

        Categoria saved = repository.save(categoria);

        // 🔥 CRIA SUBCATEGORIA PADRÃO AUTOMÁTICA
        Subcategoria sub = new Subcategoria();
        sub.setNome("Geral " + nome);
        sub.setCategoria(saved);

        subcategoriaRepository.save(sub);

        return new CategoriaResponseDTO(saved);
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

    // ======================================================
    // SUBCATEGORIA
    // ======================================================

    // CRIAR SUBCATEGORIA
    public SubcategoriaResponseDTO criarSubcategoria(Long idCategoria, SubcategoriaRequestDTO dto) {

        Categoria categoria = repository.findByIdAndDeletadoFalse(idCategoria)
                .orElseThrow(() -> new NotFoundException("Categoria não encontrada"));

        // valida duplicidade de subcategoria na mesma categoria
        boolean existe = subcategoriaRepository
                .existsByNomeIgnoreCaseAndCategoriaId(dto.getNome(), idCategoria);

        if (existe) {
            throw new BusinessException("Já existe uma subcategoria com esse nome nessa categoria");
        }

        Subcategoria sub = new Subcategoria();
        sub.setNome(dto.getNome());
        sub.setCategoria(categoria);

        Subcategoria saved = subcategoriaRepository.save(sub);

        return new SubcategoriaResponseDTO(saved);
    }
    
    // LISTAR SUBCATEGORIAS POR CATEGORIA
    public List<SubcategoriaResponseDTO> listarSubcategoriasPorCategoria(Long idCategoria) {

        repository.findByIdAndDeletadoFalse(idCategoria)
                .orElseThrow(() -> new NotFoundException("Categoria não encontrada"));

        return subcategoriaRepository.findByCategoriaId(idCategoria)
                .stream()
                .map(SubcategoriaResponseDTO::new)
                .toList();
    }
    
    // VISAO COMPLETA DE CATEGORIA
    public CategoriaCompletaResponseDTO buscarCategoriaCompleta(Long id) {

        Categoria categoria = repository.findByIdAndDeletadoFalse(id)
                .orElseThrow(() -> new NotFoundException("Categoria não encontrada"));

        CategoriaCompletaResponseDTO dto =
                new CategoriaCompletaResponseDTO(
                        categoria.getId(),
                        categoria.getNome(),
                        categoria.getCodigo()
                );
        
        List<SubcategoriaCompletaResponseDTO> subcategoriasDTO =
                categoria.getSubcategorias()
                        .stream()
                        .map(sub -> {

                            SubcategoriaCompletaResponseDTO subDTO =
                                    new SubcategoriaCompletaResponseDTO(sub);

                            List<ProdutoResponseDTO> produtos = sub.getProdutos()
                                    .stream()
                                    .map(ProdutoResponseDTO::new)
                                    .toList();

                            subDTO.setProdutos(produtos);

                            return subDTO;
                        })
                        .toList();

        dto.setSubcategorias(subcategoriasDTO);

        return dto;
    }

    // ATUALIZAR SUBCATEGORIA
    public SubcategoriaResponseDTO atualizarSubcategoria(
            Long idCategoria,
            Long idSubcategoria,
            SubcategoriaRequestDTO dto) {

        Subcategoria sub = subcategoriaRepository.findById(idSubcategoria)
                .orElseThrow(() -> new NotFoundException("Subcategoria não encontrada"));

        if (!sub.getCategoria().getId().equals(idCategoria)) {
            throw new BusinessException("Subcategoria não pertence a essa categoria");
        }

        sub.setNome(dto.getNome());

        return new SubcategoriaResponseDTO(subcategoriaRepository.save(sub));
    }

    // DELETAR SUBCATEGORIA
    public void deletarSubcategoria(Long idCategoria, Long idSubcategoria) {

        Subcategoria sub = subcategoriaRepository.findById(idSubcategoria)
                .orElseThrow(() -> new NotFoundException("Subcategoria não encontrada"));

        if (!sub.getCategoria().getId().equals(idCategoria)) {
            throw new BusinessException("Subcategoria não pertence a essa categoria");
        }

        subcategoriaRepository.delete(sub);
    }
    
 // =============================
 // REGRA: SUBCATEGORIA PADRÃO
 // =============================
    public Subcategoria getDefaultSubcategoria(Long categoriaId) {

        if (categoriaId == null) {
            throw new BusinessException("Categoria inválida");
        }

        return subcategoriaRepository
                .findTopByCategoriaIdOrderByIdAsc(categoriaId)
                .orElseThrow(() -> new BusinessException(
                        "Categoria sem subcategoria padrão"
                ));
    }
}