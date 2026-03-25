	package br.com.application.listacompras.dto;
	
	import java.math.BigDecimal;
	
	public class ItemDTO {
	    private String nome;
	    private String descricao;
	    private BigDecimal preco;
	    private Integer quantidade;
	    private Long categoriaId; // opcional
	    private Boolean comprado; // opcional: true ou false
	
	    public String getNome() { return nome; }
	    public void setNome(String nome) { this.nome = nome; }
	
	    public String getDescricao() { return descricao; }
	    public void setDescricao(String descricao) { this.descricao = descricao; }
	
	    public BigDecimal getPreco() { return preco; }
	    public void setPreco(BigDecimal preco) { this.preco = preco; }
	
	    public Integer getQuantidade() { return quantidade; }
	    public void setQuantidade(Integer quantidade) { this.quantidade = quantidade; }
	
	    public Long getCategoriaId() { return categoriaId; }
	    public void setCategoriaId(Long categoriaId) { this.categoriaId = categoriaId; }
	
	    public Boolean getComprado() { return comprado; }
	    public void setComprado(Boolean comprado) { this.comprado = comprado; }
	}
	
	/* ESTRUTURA DO JSON ATUALIZADA
	{
	  "nome": "Arroz",
	  "descricao": "Arroz branco tipo 1",
	  "preco": 25.50,
	  "quantidade": 2,
	  "categoriaId": 1,   // opcional
	  "comprado": false    // opcional: se não enviar, assume false por padrão
	}
	*/
