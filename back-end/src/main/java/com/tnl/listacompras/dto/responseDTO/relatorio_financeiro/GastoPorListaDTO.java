package com.tnl.listacompras.dto.responseDTO.relatorio_financeiro;

public class GastoPorListaDTO {

    private String lista;
    private double total;

    public GastoPorListaDTO(String lista, double total) {
        this.lista = lista;
        this.total = total;
    }

    public String getLista() {
        return lista;
    }

    public double getTotal() {
        return total;
    }
}