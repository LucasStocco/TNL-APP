package br.com.application.listacompras.dto;

public class CategoriaResponseDTO {

    private Long id;
    private String nome;

    public CategoriaResponseDTO() {}

    public CategoriaResponseDTO(Long id, String nome) {
        this.id = id;
        this.nome = nome;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
}

/*
 * retorna a categoria dentro do produto
 * 
*/
