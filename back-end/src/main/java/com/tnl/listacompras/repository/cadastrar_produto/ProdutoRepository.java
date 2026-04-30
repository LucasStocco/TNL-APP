package com.tnl.listacompras.repository.cadastrar_produto;

import com.tnl.listacompras.model.cadastrar_produto.Produto;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProdutoRepository extends JpaRepository<Produto, Long> {

    List<Produto> findByCategoriaId(Long categoriaId);

    boolean existsByNomeIgnoreCaseAndDescricaoIgnoreCaseAndCategoriaId(
        String nome,
        String descricao,
        Long categoriaId
    );
}