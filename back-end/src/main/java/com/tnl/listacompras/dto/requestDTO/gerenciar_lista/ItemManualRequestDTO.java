/*
 * 📌 Criar item que NÃO existe no sistema
 *
 * 🔵 RESPONSABILIDADE:
 * Este DTO representa a criação de um item manual, ou seja,
 * um produto digitado livremente pelo usuário que NÃO existe no banco.
 *
 * 🔵 EXEMPLO:
 * usuário digita: "coxinha"
 *
 * Backend:
 *  - NÃO busca produto no banco
 *  - Cria item diretamente
 *  - Salva snapshot dos dados enviados
 *
 * Frontend:
 *  - Envia todos os dados do item
 *  - Não depende de produtos cadastrados
 *
 * 🔵 IMPORTANTE:
 * Este fluxo é totalmente independente do catálogo de produtos.
 */

package com.tnl.listacompras.dto.requestDTO.gerenciar_lista;

import java.math.BigDecimal;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class ItemManualRequestDTO {

    // =========================
    // NOME LIVRE DO USUÁRIO
    // =========================
    @NotBlank(message = "Nome do produto é obrigatório")
    private String nomeProdutoSnapshot;

    // =========================
    // PREÇO DIGITADO MANUALMENTE
    // =========================
    @NotNull(message = "Preço do produto é obrigatório")
    private BigDecimal precoProdutoSnapshot;

    // =========================
    // QUANTIDADE (OPCIONAL)
    // =========================
    @Min(value = 1, message = "Quantidade mínima é 1")
    private Integer quantidade;

    // =========================
    // CATEGORIA OBRIGATÓRIA
    // =========================
    @NotNull(message = "Categoria é obrigatória")
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