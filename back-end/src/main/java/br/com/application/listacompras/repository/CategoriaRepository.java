package br.com.application.listacompras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import br.com.application.listacompras.model.Categoria;

@Repository
public interface CategoriaRepository extends JpaRepository<Categoria, Long> {
    // Consultas personalizadas para categorias
}
