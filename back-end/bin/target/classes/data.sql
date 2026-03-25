-- INSERE CATEGORIAS INICIAIS
INSERT INTO categoria (nome) VALUES ('Alimentos');
INSERT INTO categoria (nome) VALUES ('Bebidas');
INSERT INTO categoria (nome) VALUES ('Higiene');
INSERT INTO categoria (nome) VALUES ('Limpeza');

/*Esse arquivo é executado automaticamente pelo Spring Boot quando o Hibernate cria as tabelas (se spring.jpa.hibernate.ddl-auto=create ou update).
Se você usar ddl-auto=create-drop, os dados serão apagados toda vez que o app reiniciar. Use update para manter os dados.*/