package br.com.application.listacompras.dto;

public class ItemResponseDTO {

    private Long id;
    private Integer quantidade;
    private Boolean comprado;
    private ProdutoResponseDTO produto;

    public ItemResponseDTO() {}

    public ItemResponseDTO(Long id, Integer quantidade, Boolean comprado, ProdutoResponseDTO produto) {
        this.id = id;
        this.quantidade = quantidade;
        this.comprado = comprado;
        this.produto = produto;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Integer getQuantidade() { return quantidade; }
    public void setQuantidade(Integer quantidade) { this.quantidade = quantidade; }

    public Boolean getComprado() { return comprado; }
    public void setComprado(Boolean comprado) { this.comprado = comprado; }

    public ProdutoResponseDTO getProduto() { return produto; }
    public void setProduto(ProdutoResponseDTO produto) { this.produto = produto; }
}