/*
 * 📌 ItemUpdateDTO
 *
 * 🔵 RESPONSABILIDADE:
 * Este DTO representa a atualização de um item já existente na lista de compras.
 *
 * 🔵 USO:
 * Ele não cria novos itens, apenas altera estado de um item já persistido.
 *
 * 🔵 TIPOS DE ALTERAÇÃO POSSÍVEIS:
 * - quantidade do item
 * - nome do snapshot (apenas itens manuais)
 * - preço do snapshot (apenas itens manuais)
 * - categoria do item
 *
 * 🔵 IMPORTANTE:
 * - Itens globais podem ter apenas quantidade alterada
 * - Itens manuais podem ter todos os campos editáveis
 */

package com.tnl.listacompras.dto.requestDTO.gerenciar_lista;

import java.math.BigDecimal;

public class ItemUpdateDTO {

    // =========================
    // DADOS EDITÁVEIS
    // =========================

    private String nomeProdutoSnapshot;

    private BigDecimal precoProdutoSnapshot;

    private Integer quantidade;

    private Long idCategoria;

    // =========================
    // GETTERS E SETTERS
    // =========================

    public String getNomeProdutoSnapshot() {
        return nomeProdutoSnapshot;
    }

    public void setNomeProdutoSnapshot(String nomeProdutoSnapshot) {
        this.nomeProdutoSnapshot = nomeProdutoSnapshot;
    }

    public BigDecimal getPrecoProdutoSnapshot() {
        return precoProdutoSnapshot;
    }

    public void setPrecoProdutoSnapshot(BigDecimal precoProdutoSnapshot) {
        this.precoProdutoSnapshot = precoProdutoSnapshot;
    }

    public Integer getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(Integer quantidade) {
        this.quantidade = quantidade;
    }

    public Long getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(Long idCategoria) {
        this.idCategoria = idCategoria;
    }
}