package com.tnl.listacompras.repository.gerenciar_lista;
import com.tnl.listacompras.model.gerenciar_lista.Lista;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface ListaRepository extends JpaRepository<Lista, Long> {
}
