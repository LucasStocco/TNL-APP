package com.tnl.listacompras.dto.requestDTO.gerenciar_lista;

public class RelatorioItemRequestDTO {

    private Long categoriaId; // opcional — usado só no filtro por categoria

    public Long getCategoriaId() {
        return categoriaId;
    }

    public void setCategoriaId(Long categoriaId) {
        this.categoriaId = categoriaId;
    }
}