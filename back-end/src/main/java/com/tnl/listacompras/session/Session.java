package com.tnl.listacompras.session;

/**
 * MOCK de autenticação enquanto não existe login.
 *
 * REGRA:
 * - substitui temporariamente Spring Security
 * - controla usuário atual do sistema
 * - NÃO usar como solução definitiva de segurança
 */
public class Session {

    // 🔥 USUÁRIO ATUAL SIMULADO
    private static Long usuarioId = 1L;

    public static Long getUsuarioId() {
        return usuarioId;
    }

    public static void setUsuarioId(Long id) {
        usuarioId = id;
    }
}