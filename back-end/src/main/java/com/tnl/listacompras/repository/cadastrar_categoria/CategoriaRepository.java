package com.tnl.listacompras.repository.cadastrar_categoria;

import java.util.Optional;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

import com.tnl.listacompras.model.cadastrar_categoria.Categoria;

public interface CategoriaRepository extends JpaRepository<Categoria, Long> {

    List<Categoria> findByDeletadoFalse();

    Optional<Categoria> findByIdAndDeletadoFalse(Long id);

    boolean existsByCodigoIgnoreCase(String codigo);
}