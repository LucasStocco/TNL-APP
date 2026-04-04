package com.tnl.listacompras.repository.cadastrar_produto;

import com.tnl.listacompras.model.cadastrar_produto.Produto;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface ProdutoRepository extends JpaRepository<Produto, Long> {
    // Consultas personalizadas para produtos
	
	// Verifica se já existe um produto com o mesmo nome na mesma categoria
	// Query automática do Spring Data Jpa
	// Retorna true se já existe um produto com mesmo nome e mesma categoria
	// Service vai usar isso para impedir que o produto seja criado novamente
    boolean existsByNomeAndCategoriaId(String nome, Long categoriaId);
}
