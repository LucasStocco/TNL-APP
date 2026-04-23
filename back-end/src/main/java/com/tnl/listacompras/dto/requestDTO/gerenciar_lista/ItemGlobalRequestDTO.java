/*
 * 📌 Criar item a partir de um produto já existente no sistema
 *
 * 🔵 RESPONSABILIDADE:
 * Este DTO representa a requisição do frontend para adicionar um produto
 * já cadastrado no sistema dentro de uma lista de compras.
 *
 * 🔵 FLUXO:
 * Backend:
 *  - Recebe apenas o idProduto
 *  - Busca o Produto no banco
 *  - Gera snapshots automaticamente (nome, preço, categoria)
 *  - Cria Item na lista
 *
 * Frontend:
 *  - Apenas envia o idProduto
 *  - Quantidade é opcional
 *
 * 🔵 REGRA IMPORTANTE:
 * Nunca envia snapshots do frontend, pois os dados vêm do banco.
 */

package com.tnl.listacompras.dto.requestDTO.gerenciar_lista;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public class ItemGlobalRequestDTO {

    // =========================
    // ID DO PRODUTO EXISTENTE
    // =========================
    @NotNull(message = "O id do produto é obrigatório")
    private Long idProduto;

    // =========================
    // ID DA CATEGORIA
    // =========================
    @NotNull(message = "O id da categoria é obrigatório")
    private Long idCategoria;

    // =========================
    // QUANTIDADE (OPCIONAL)
    // =========================
    @Min(value = 1, message = "Quantidade mínima é 1")
    private Integer quantidade;

    // =========================
    // GETTERS E SETTERS
    // =========================

    public Long getIdProduto() {
        return idProduto;
    }

    public void setIdProduto(Long idProduto) {
        this.idProduto = idProduto;
    }

    public Long getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(Long idCategoria) {
        this.idCategoria = idCategoria;
    }

    public Integer getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(Integer quantidade) {
        this.quantidade = quantidade;
    }
}