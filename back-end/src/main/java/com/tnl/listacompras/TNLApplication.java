package com.tnl.listacompras;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import com.tnl.listacompras.model.gerenciar_lista.Lista;
import com.tnl.listacompras.repository.gerenciar_lista.ListaRepository;


@SpringBootApplication
public class TNLApplication {

    public static void main(String[] args) {
        SpringApplication.run(TNLApplication.class, args);
    }

    // @Bean
    // public CommandLineRunner run(ListaRepository listaRepository) {
    //     return args -> {
    //
    //         Lista lista = new Lista();
    //         lista.setNome("Compras da semana");
    //
    //         listaRepository.save(lista);
    //
    //         System.out.println("Listas cadastradas:");
    //         listaRepository.findAll().forEach(l ->
    //             System.out.println(l.getId() + " - " + l.getNome())
    //         );
    //     };
    // }
}
