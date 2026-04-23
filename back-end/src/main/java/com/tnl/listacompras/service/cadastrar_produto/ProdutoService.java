package com.tnl.listacompras.service.cadastrar_produto;

import org.springframework.stereotype.Service;

import com.tnl.listacompras.session.Session;
import exception.business.BusinessException;

import com.tnl.listacompras.dto.requestDTO.cadastrar_produto.ProdutoRequestDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_categoria.CategoriaResponseDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_produto.ProdutoResponseDTO;
import com.tnl.listacompras.model.cadastrar_produto.Produto;
import com.tnl.listacompras.model.cadastrar_categoria.Categoria;
import com.tnl.listacompras.repository.cadastrar_categoria.CategoriaRepository;
import com.tnl.listacompras.repository.cadastrar_produto.ProdutoRepository;

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

    // ================= USUARIO =================
    private Long usuarioAtual() {
        return Session.getUsuarioId();
    }

    // ================= LISTAR TODOS =================
    public List<ProdutoResponseDTO> listarTodos() {

        Long idUsuario = usuarioAtual();

        System.out.println(">>> [PRODUTO SERVICE] listarTodos");
        System.out.println("usuario=" + idUsuario);

        var lista = produtoRepository.listarDisponiveis(idUsuario);

        System.out.println("✔ produtos encontrados=" + lista.size());

        return lista.stream()
                .map(this::toDTO)
                .toList();
    }

    // ================= LISTAR POR CATEGORIA 🔥 =================
    public List<ProdutoResponseDTO> listarPorCategoria(Long idCategoria) {

        Long idUsuario = usuarioAtual();

        System.out.println(">>> [PRODUTO SERVICE] listarPorCategoria");
        System.out.println("categoriaId=" + idCategoria);
        System.out.println("usuario=" + idUsuario);

        validarCategoriaExiste(idCategoria);

        var lista = produtoRepository.listarPorCategoria(idCategoria, idUsuario);

        System.out.println("✔ produtos na categoria=" + lista.size());

        return lista.stream()
                .map(this::toDTO)
                .toList();
    }

    // ================= BUSCAR =================
    public ProdutoResponseDTO buscarPorId(Long id) {

        Long idUsuario = usuarioAtual();

        System.out.println(">>> [PRODUTO SERVICE] buscarPorId id=" + id);

        Produto produto = produtoRepository.buscarDisponivelPorId(id, idUsuario)
                .orElseThrow(() -> {
                    System.out.println("❌ Produto não encontrado");
                    return new BusinessException("Produto não encontrado");
                });

        System.out.println("✔ Produto encontrado: " + produto.getNome());

        return toDTO(produto);
    }

    // ================= CRIAR =================
    public ProdutoResponseDTO criar(ProdutoRequestDTO dto) {

        Long idUsuario = usuarioAtual();

        System.out.println(">>> [PRODUTO SERVICE] criar");
        System.out.println("nome=" + dto.getNome());
        System.out.println("categoria=" + dto.getIdCategoria());
        System.out.println("usuario=" + idUsuario);

        validarCategoria(dto.getIdCategoria(), idUsuario);

        Categoria categoria = categoriaRepository
                .findById(dto.getIdCategoria())
                .orElseThrow(() -> {
                    System.out.println("❌ Categoria não encontrada no banco");
                    return new BusinessException("Categoria não encontrada");
                });

        var existente = produtoRepository.buscarIncluindoDeletados(
                dto.getNome(),
                dto.getIdCategoria(),
                idUsuario
        );

        // REATIVAR
        if (existente.isPresent()) {

            Produto prod = existente.get();

            System.out.println("⚠ Produto já existe no sistema");

            if (Boolean.TRUE.equals(prod.getDeletado())) {

                System.out.println("♻ Reativando produto deletado");

                prod.setDeletado(false);
                prod.setDescricao(dto.getDescricao());
                prod.setPreco(dto.getPreco());
                prod.setCategoria(categoria);

                return toDTO(produtoRepository.save(prod));
            }

            throw new BusinessException("Produto já existe");
        }

        // NOVO
        Produto produto = new Produto();

        produto.setNome(dto.getNome());
        produto.setDescricao(dto.getDescricao());
        produto.setPreco(dto.getPreco());
        produto.setCategoria(categoria);
        produto.setIdUsuario(idUsuario);
        produto.setDeletado(false);

        Produto salvo = produtoRepository.save(produto);

        System.out.println("🟢 Produto criado ID=" + salvo.getId());

        return toDTO(salvo);
    }

    // ================= UPDATE =================
    public ProdutoResponseDTO atualizar(Long id, ProdutoRequestDTO dto) {

        Long idUsuario = usuarioAtual();

        System.out.println(">>> [PRODUTO SERVICE] atualizar id=" + id);

        Produto prod = produtoRepository.buscarDisponivelPorId(id, idUsuario)
                .orElseThrow(() -> {
                    System.out.println("❌ Produto não encontrado para update");
                    return new BusinessException("Produto não encontrado");
                });

        if (prod.getIdUsuario() == null) {
            System.out.println("⛔ Produto global bloqueado");
            throw new BusinessException("Produto global não pode ser editado");
        }

        if (!prod.getIdUsuario().equals(idUsuario)) {
            System.out.println("⛔ Sem permissão de edição");
            throw new BusinessException("Sem permissão para editar este produto");
        }

        Categoria categoria = categoriaRepository
                .findById(dto.getIdCategoria())
                .orElseThrow(() -> new BusinessException("Categoria não encontrada"));

        prod.setNome(dto.getNome());
        prod.setDescricao(dto.getDescricao());
        prod.setPreco(dto.getPreco());
        prod.setCategoria(categoria);

        Produto salvo = produtoRepository.save(prod);

        System.out.println("✔ Produto atualizado ID=" + salvo.getId());

        return toDTO(salvo);
    }

    // ================= DELETE =================
    public void deletar(Long id) {

        Long idUsuario = usuarioAtual();

        System.out.println(">>> [PRODUTO SERVICE] deletar id=" + id);

        Produto prod = produtoRepository.buscarDisponivelPorId(id, idUsuario)
                .orElseThrow(() -> {
                    System.out.println("❌ Produto não encontrado para delete");
                    return new BusinessException("Produto não encontrado");
                });

        if (prod.getIdUsuario() == null) {
            System.out.println("⛔ Tentativa de deletar produto global");
            throw new BusinessException("Produto global não pode ser deletado");
        }

        if (!prod.getIdUsuario().equals(idUsuario)) {
            System.out.println("⛔ Sem permissão de delete");
            throw new BusinessException("Sem permissão para deletar este produto");
        }

        prod.setDeletado(true);
        produtoRepository.save(prod);

        System.out.println("🗑 Produto deletado ID=" + prod.getId());
    }

    // ================= VALIDAR CATEGORIA EXISTE 🔥 =================
    private void validarCategoriaExiste(Long idCategoria) {
        if (!categoriaRepository.existsById(idCategoria)) {
            System.out.println("❌ Categoria não encontrada");
            throw new BusinessException("Categoria não encontrada");
        }
    }

    // ================= VALIDAR CATEGORIA =================
    private void validarCategoria(Long idCategoria, Long idUsuario) {

        System.out.println(">>> validando categoria id=" + idCategoria);

        categoriaRepository.listarTodas(idUsuario)
                .stream()
                .filter(c -> c.getId().equals(idCategoria))
                .findFirst()
                .orElseThrow(() -> {
                    System.out.println("❌ Categoria inválida");
                    return new BusinessException("Categoria não encontrada");
                });

        System.out.println("✔ Categoria válida");
    }

    // ================= MAPPER =================
    private ProdutoResponseDTO toDTO(Produto produto) {

        Categoria categoria = produto.getCategoria();

        CategoriaResponseDTO categoriaDTO = null;

        if (categoria != null) {
            categoriaDTO = new CategoriaResponseDTO(
                    categoria.getId(),
                    categoria.getNome(),
                    categoria.getCodigo(),
                    categoria.getIdUsuario()
            );
        }

        return new ProdutoResponseDTO(
                produto.getId(),
                produto.getNome(),
                produto.getDescricao(),
                produto.getPreco(),
                categoriaDTO,
                produto.getCriadoEm(),
                produto.getAtualizadoEm(),
                produto.getIdUsuario()
        );
    }
}