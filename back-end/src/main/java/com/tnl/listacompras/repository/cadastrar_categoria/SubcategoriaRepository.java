package com.tnl.listacompras.repository.cadastrar_categoria;

import com.tnl.listacompras.model.cadastrar_categoria.Subcategoria;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface SubcategoriaRepository extends JpaRepository<Subcategoria, Long> {

    // evita duplicidade dentro da mesma categoria
    boolean existsByNomeIgnoreCaseAndCategoriaId(String nome, Long categoriaId);

    // lista todas subcategorias de uma categoria
    List<Subcategoria> findByCategoriaId(Long categoriaId);
    
    Optional<Subcategoria> findTopByCategoriaIdOrderByIdAsc(Long categoriaId);
}