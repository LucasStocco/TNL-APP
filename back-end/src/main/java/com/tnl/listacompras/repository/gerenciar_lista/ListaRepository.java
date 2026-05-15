package com.tnl.listacompras.repository.gerenciar_lista;

import com.tnl.listacompras.model.gerenciar_lista.Lista;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ListaRepository extends JpaRepository<Lista, Long> {

    // TODO: Revisar consistência das queries de Listas
    // Garantir que todas as consultas respeitem:
    // - isolamento por usuário
    // - soft delete
    // - regras de segurança do domínio

    // TODO: Avaliar concorrência na validação de nome
    // existsBy... pode sofrer race condition em cenários concorrentes.
    // Ideal complementar com constraint UNIQUE no banco.

    // TODO: Manter repository focado apenas em persistência
    // Evitar mover regras de negócio para esta camada.

    // =========================
    // 🔎 BUSCAS PRINCIPAIS
    // =========================

    // Listas ativas do usuário
    List<Lista> findByUsuarioIdAndDeletadoFalse(Long usuarioId);

    // Buscar lista específica do usuário
    Optional<Lista> findByIdAndUsuarioIdAndDeletadoFalse(
            Long id,
            Long usuarioId
    );

    // =========================
    // ✅ VALIDAÇÕES
    // =========================

    // Verificar duplicidade de nome da lista
    boolean existsByUsuarioIdAndNomeIgnoreCaseAndDeletadoFalse(
            Long usuarioId,
            String nome
    );
}