package com.tnl.listacompras.repository.gerenciar_lista;

import com.tnl.listacompras.model.gerenciar_lista.Lista;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ListaRepository extends JpaRepository<Lista, Long> {

    // =========================
    // 🔎 BUSCAS PRINCIPAIS
    // =========================

    // Listas do usuário (já filtrando deletado)
    List<Lista> findByUsuarioIdAndDeletadoFalse(Long usuarioId);

    // Buscar lista específica do usuário (segurança)
    Optional<Lista> findByIdAndUsuarioIdAndDeletadoFalse(Long id, Long usuarioId);

    // =========================
    // 🔎 APOIO / OPCIONAIS
    // =========================

    // Todas listas do usuário (inclui deletadas)
    List<Lista> findByUsuarioId(Long usuarioId);

    // Listas ativas globais (caso admin)
    List<Lista> findByDeletadoFalse();

    // Verificar se já existe lista com nome (evitar duplicidade)
    boolean existsByNomeIgnoreCaseAndUsuarioIdAndDeletadoFalse(
            String nome,
            Long usuarioId
    );
}