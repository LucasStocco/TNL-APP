package com.tnl.listacompras.dto.responseDTO.relatorio_financeiro;

public class GastoPorCategoriaDTO {

    private String categoria;
    private Double total;

            public GastoPorCategoriaDTO(String categoria, Double total) {
                    this.categoria = categoria;
                            this.total = total;
            }

            public String getCategoria() {
                     return categoria;
            }

            public Double getTotal() {
                     return total;
                                                               
            }
  }