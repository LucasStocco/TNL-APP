package com.tnl.listacompras.service.cadastrar_produto;

import com.tnl.listacompras.dto.requestDTO.cadastrar_produto.ProdutoRequestDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_produto.ProdutoResponseDTO;
import com.tnl.listacompras.model.cadastrar_categoria.Categoria;
import com.tnl.listacompras.model.cadastrar_categoria.Subcategoria;
import com.tnl.listacompras.model.cadastrar_produto.Produto;
import com.tnl.listacompras.repository.cadastrar_categoria.SubcategoriaRepository;
import com.tnl.listacompras.repository.cadastrar_produto.ProdutoRepository;
import com.tnl.listacompras.service.cadastrar_categoria.CategoriaService;

import exception.business.BusinessException;
import exception.business.NotFoundException;

import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProdutoService {

	private final ProdutoRepository produtoRepository;
	private final SubcategoriaRepository subcategoriaRepository;
	private final CategoriaService categoriaService;
	
	public ProdutoService(
	        ProdutoRepository produtoRepository,
	        SubcategoriaRepository subcategoriaRepository,
	        CategoriaService categoriaService
	) {
	    this.produtoRepository = produtoRepository;
	    this.subcategoriaRepository = subcategoriaRepository;
	    this.categoriaService = categoriaService;
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

        String descricao = Optional.ofNullable(dto.getDescricao())
                .orElse("")
                .trim();

        // 🔥 PEGA SUBCATEGORIA PADRÃO DA REGRA CENTRALIZADA
        Subcategoria subcategoria = categoriaService
                .getDefaultSubcategoria(dto.getIdCategoria());

        // 🔥 DUPLICIDADE
        boolean existe = produtoRepository.existsDuplicado(
                nome,
                descricao,
                subcategoria.getId()
        );

        if (existe) {
            throw new BusinessException(
                    "Produto já existe com esse nome, descrição e subcategoria"
            );
        }

        Produto produto = new Produto();
        produto.setNome(nome);
        produto.setDescricao(descricao);
        produto.setSubcategoria(subcategoria);

        return new ProdutoResponseDTO(produtoRepository.save(produto));
    }

    // =========================
    // ATUALIZAR
    // =========================
    public ProdutoResponseDTO atualizar(Long id, ProdutoRequestDTO dto) {

        Produto produto = produtoRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Produto não encontrado"));

        String nome = dto.getNome().trim();

        String descricao = Optional.ofNullable(dto.getDescricao())
                .orElse("")
                .trim();

        // 🔥 MESMA REGRA DO CREATE (PADRONIZADO)
        Subcategoria subcategoria = categoriaService
                .getDefaultSubcategoria(dto.getIdCategoria());

        boolean existe = produtoRepository.existsDuplicado(
                nome,
                descricao,
                subcategoria.getId()
        );

        if (existe && !(
                produto.getNome().equalsIgnoreCase(nome)
                && produto.getDescricao().equalsIgnoreCase(descricao)
                && produto.getSubcategoria().getId().equals(subcategoria.getId())
        )) {
            throw new BusinessException(
                    "Produto já existe com esse nome, descrição e subcategoria"
            );
        }

        produto.setNome(nome);
        produto.setDescricao(descricao);
        produto.setSubcategoria(subcategoria);

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

/*
 * =========================
 * Mudanças no ProdutoService
 * =========================
 *
 * 1. Arquitetura de relacionamento
 *    - Produto NÃO se relaciona mais diretamente com Categoria
 *    - Agora segue a hierarquia correta:
 *      Produto → Subcategoria → Categoria
 *
 * 2. Segurança (Null Safety)
 *    - Uso de Optional.ofNullable para evitar NullPointerException
 *      no campo descricao ao fazer trim()
 *
 * 3. Consistência de regra de negócio
 *    - Subcategoria sempre é validada no banco antes de ser usada
 *    - Evita produtos vinculados a IDs inválidos ou inexistentes
 *
 * 4. Regra de duplicidade corrigida
 *    - Validação agora respeita Subcategoria (e não Categoria)
 *    - Evita duplicação incorreta dentro da nova hierarquia
 *
 * 5. Simplificação de responsabilidade
 *    - Service agora só conhece Produto e Subcategoria
 *    - Categoria é acessada indiretamente via Subcategoria
 */