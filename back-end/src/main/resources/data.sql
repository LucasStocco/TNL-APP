-- Categorias já existem, mas vamos garantir
INSERT INTO categoria (id, nome) VALUES (1, 'Alimentos');

-- Produtos iniciais
INSERT INTO produto (id, nome, preco, categoria_id) VALUES (1, 'Arroz', 10.0, 1);
INSERT INTO produto (id, nome, preco, categoria_id) VALUES (2, 'Feijão', 8.0, 1);

-- Itens iniciais
INSERT INTO itens (id, produto_id, quantidade, comprado) VALUES (1, 1, 2, false);
INSERT INTO itens (id, produto_id, quantidade, comprado) VALUES (2, 2, 1, false);