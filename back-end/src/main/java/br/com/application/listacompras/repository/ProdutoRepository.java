package br.com.application.listacompras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import br.com.application.listacompras.model.Produto;

@Repository
public interface ProdutoRepository extends JpaRepository<Produto, Long> {
    // Consultas personalizadas para produtos
}
