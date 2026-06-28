SELECT *
FROM clientes;

SELECT *
FROM pedidos;

-- utlizacao da clausula join para juntar as partes semelhantes (id) e identificar quem fez determinado pedido --
SELECT *
FROM clientes c 
INNER JOIN pedidos p
ON c.id = p.idcliente;

-- ao trabalhar com join, se quiser referenciar os campos que busca no select, deve-se referenciar de forma correta onde os dados que vc busca estão --
SELECT c.nome, p.id, p.datahorapedido
FROM clientes c
INNER JOIN pedidos p
ON c.id = p.idcliente;

SELECT *
FROM produtos;

INSERT INTO produtos (id, nome, descricao, preco, categoria) VALUES
(31, 'Lasanha à Bolonhesa', 'Deliciosa lasanha caseira com molho bolonhesa', 12.50, 'Almoço');

-- apos adicionado o novo prato, surgiu a questao de se todos os pratos já foram pedidos desde o inicio das atividades do empreendimento --
SELECT pr.nome, ip.idproduto, ip.idpedido
FROM itenspedidos ip
RIGHT JOIN produtos pr
ON pr.id = ip.idproduto;

-- aplicar o filtro de join para verificar se há produtos que não foram vendidos em determinados meses --
SELECT pr.nome, x.idproduto, x.idpedido
FROM (
  SELECT ip.idpedido, ip.idproduto
  FROM pedidos p
  INNER JOIN itenspedidos ip
  ON p.id = ip.idpedido
  WHERE strftime('%m', p.datahorapedido) = '10') x
RIGHT JOIN produtos pr
ON pr.id = x.idproduto;

-- utilizacao de left join --
INSERT INTO clientes (id, nome, telefone, email, endereco)
VALUES (28, 'João Santos', '215555678', 'joao.santos@email.com', 'Avenida Principal, 456, Cidade B'),
       (29, 'Carla Ferreira', '315557890', 'carla.ferreira@email.com', 'Travessa das Ruas, 789, Cidade C');
       
SELECT *
FROM clientes;

-- buscar quais clientes nao fizeram compras --
SELECT c.nome, p.id
FROM clientes c
LEFT JOIN pedidos p
ON c.id = p.idcliente;

-- apos isso, foi feito uma nova consulta para buscar os clientes que nao compraram em um determinado mes --
SELECT c.nome, x.id
FROM clientes c
LEFT JOIN (
  SELECT p.id, p.idcliente
  FROM pedidos p
  WHERE strftime('%m', p.datahorapedido) = '10') x
ON c.id = x.idcliente
WHERE x.idcliente IS NULL;

-- visualizacao full join --
SELECT c.nome, p.id
FROM clientes c
FULL JOIN pedidos p
ON c.id = p.idcliente
WHERE c.id IS NULL;