package br.com.application.listacompras;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import br.com.application.listacompras.model.Lista;
import br.com.application.listacompras.repository.ListaRepository;

@SpringBootApplication
public class TNLApplication {

    public static void main(String[] args) {
        SpringApplication.run(TNLApplication.class, args);
    }

    @Bean
    public CommandLineRunner run(ListaRepository listaRepository) {
        return args -> {

            Lista lista = new Lista();
            lista.setNome("Compras da semana");

            listaRepository.save(lista);

            System.out.println("Listas cadastradas:");
            listaRepository.findAll().forEach(l ->
                System.out.println(l.getId() + " - " + l.getNome())
            );
        };
    }
}
