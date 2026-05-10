package com.tnl.listacompras.dto.responseDTO.relatorio_item;

public class RelatorioItemPorCategoriaResponseDTO {
    private String nomeCategoria;
    private Long quantidade;

    public  RelatorioItemPorCategoriaResponseDTO(String nomeCategoria, Long quantidade){
        this.nomeCategoria = nomeCategoria;
        this.quantidade = quantidade;
    }

    public String getNomeCategoria(){
        return nomeCategoria;
    }

    public Long getQuantidade(){
        return quantidade;
    }
}
