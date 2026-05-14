package com.tnl.listacompras.dto.responseDTO.gerenciar_lista;

import java.time.LocalDateTime;

import com.tnl.listacompras.model.gerenciar_lista.Item;
import com.tnl.listacompras.dto.responseDTO.cadastrar_produto.ProdutoResponseDTO;

public class ItemResponseDTO {

    private Long id;
    private Integer quantidade;
    private Boolean comprado;
    private Double preco;

    private ProdutoResponseDTO produto;

    private LocalDateTime criadoEm;
    private LocalDateTime atualizadoEm;

    public ItemResponseDTO(Item item) {

        this.id = item.getId();
        this.quantidade = item.getQuantidade();
        this.comprado = item.getComprado();
        this.preco = item.getPreco();

        // 🔥 Produto completo (hierarquia limpa)
        if (item.getProduto() != null) {
            this.produto = new ProdutoResponseDTO(item.getProduto());
        }

        this.criadoEm = item.getCriadoEm();
        this.atualizadoEm = item.getAtualizadoEm();
    }

    public Long getId() { return id; }
    public Integer getQuantidade() { return quantidade; }
    public Boolean getComprado() { return comprado; }
    public Double getPreco() { return preco; }

    public ProdutoResponseDTO getProduto() { return produto; }

    public LocalDateTime getCriadoEm() { return criadoEm; }
    public LocalDateTime getAtualizadoEm() { return atualizadoEm; }
}