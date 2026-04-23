package com.tnl.listacompras.service.cadastrar_categoria;

import com.tnl.listacompras.dto.requestDTO.cadastrar_categoria.CategoriaRequestDTO;
import com.tnl.listacompras.dto.responseDTO.cadastrar_categoria.CategoriaResponseDTO;
import com.tnl.listacompras.model.cadastrar_categoria.Categoria;
import com.tnl.listacompras.repository.cadastrar_categoria.CategoriaRepository;
import com.tnl.listacompras.session.Session;

import exception.business.BusinessException;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoriaService {

    private final CategoriaRepository categoriaRepository;

    public CategoriaService(CategoriaRepository categoriaRepository) {
        this.categoriaRepository = categoriaRepository;
    }

    // ================= SESSION =================
    private Long usuarioAtual() {
        return Session.getUsuarioId();
    }

    // ================= LISTAR =================
    public List<CategoriaResponseDTO> listarTodos() {

        Long idUsuario = usuarioAtual();

        System.out.println(">>> [CATEGORIA SERVICE] listarTodos");
        System.out.println("usuario=" + idUsuario);

        var lista = categoriaRepository.listarTodas(idUsuario);

        System.out.println("✔ categorias encontradas=" + lista.size());

        return lista.stream()
                .map(this::toDTO)
                .toList();
    }

    // ================= BUSCAR =================
    public CategoriaResponseDTO buscarPorId(Long id) {

        Long idUsuario = usuarioAtual();

        System.out.println(">>> [CATEGORIA SERVICE] buscarPorId id=" + id);

        Categoria c = categoriaRepository.buscarVisivelPorId(id, idUsuario)
                .orElseThrow(() -> {
                    System.out.println("❌ Categoria não encontrada");
                    return new BusinessException("Categoria não encontrada");
                });

        System.out.println("✔ Categoria encontrada: " + c.getNome());

        return toDTO(c);
    }

    // ================= CRIAR =================
    public CategoriaResponseDTO criar(CategoriaRequestDTO dto) {

        Long idUsuario = usuarioAtual();

        System.out.println(">>> [CATEGORIA SERVICE] criar");
        System.out.println("nome=" + dto.getNome());
        System.out.println("usuario=" + idUsuario);

        boolean existe = categoriaRepository.existsByNomeContextual(
                idUsuario,
                dto.getNome()
        );

        if (existe) {
            System.out.println("⚠ Categoria já existe");
            throw new BusinessException("Categoria já existe");
        }

        Categoria c = new Categoria();
        c.setNome(dto.getNome());
        c.setIdUsuario(idUsuario);
        c.setCodigo(gerarCodigo(c));

        Categoria salvo = categoriaRepository.save(c);

        System.out.println("🟢 Categoria criada ID=" + salvo.getId());

        return toDTO(salvo);
    }

    // ================= UPDATE =================
    public CategoriaResponseDTO atualizarCategoria(Long idCategoria, CategoriaRequestDTO dto) {

        Long idUsuario = usuarioAtual();

        System.out.println(">>> [CATEGORIA SERVICE] atualizar id=" + idCategoria);

        Categoria categoria = categoriaRepository.buscarVisivelPorId(idCategoria, idUsuario)
                .orElseThrow(() -> {
                    System.out.println("❌ Categoria não encontrada");
                    return new BusinessException("Categoria não encontrada");
                });

        if (categoria.isGlobal()) {
            System.out.println("⛔ Categoria global bloqueada");
            throw new BusinessException("Categoria global não pode ser editada");
        }

        if (!categoria.getIdUsuario().equals(idUsuario)) {
            System.out.println("⛔ Sem permissão de edição");
            throw new BusinessException("Sem permissão para editar esta categoria");
        }

        categoria.setNome(dto.getNome());

        Categoria salvo = categoriaRepository.save(categoria);

        System.out.println("✔ Categoria atualizada ID=" + salvo.getId());

        return toDTO(salvo);
    }

    // ================= DELETE =================
    public void deletar(Long id) {

        Long idUsuario = usuarioAtual();

        System.out.println(">>> [CATEGORIA SERVICE] deletar id=" + id);

        Categoria c = categoriaRepository.buscarVisivelPorId(id, idUsuario)
                .orElseThrow(() -> {
                    System.out.println("❌ Categoria não encontrada para delete");
                    return new BusinessException("Categoria não encontrada");
                });

        if (!c.getIdUsuario().equals(idUsuario)) {
            System.out.println("⛔ Sem permissão de delete");
            throw new BusinessException("Sem permissão para deletar esta categoria");
        }

        c.setDeletado(true);
        categoriaRepository.save(c);

        System.out.println("🗑 Categoria deletada ID=" + c.getId());
    }

    // ================= UTILS =================
    private String gerarCodigo(Categoria c) {
        return c.getNome()
                .trim()
                .toUpperCase()
                .replaceAll("\\s+", "_");
    }

    private CategoriaResponseDTO toDTO(Categoria c) {
        return new CategoriaResponseDTO(
                c.getId(),
                c.getNome(),
                c.getCodigo(),
                c.getIdUsuario()
        );
    }
}