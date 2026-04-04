package com.tnl.listacompras.repository.cadastrar_categoria;

import com.tnl.listacompras.model.cadastrar_categoria.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoriaRepository extends JpaRepository<Categoria, Long> {
    // Consultas personalizadas para categorias
}
