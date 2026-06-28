-- 1) Traga todos os dados da cliente Maria Silva.
SELECT *
FROM clientes
WHERE nome = 'Maria Silva';

-- 2) Busque o ID do pedido e o ID do cliente dos pedidos onde o status esteja como entregue.
SELECT id, idcliente
FROM pedidos
WHERE status = 'Entregue';

-- 3) Retorne todos os produtos onde o preço seja maior que 10 e menor que 15.
SELECT *
FROM produtos
WHERE preco > 10 AND preco < 15;

-- 4) Busque o nome e cargo dos colaboradores que foram contratados entre 2022-01-01 e 2022-06-30.
SELECT nome, cargo
FROM colaboradores
WHERE datacontratacao 
BETWEEN '2022-01-01' and '2022-06-30';

-- 5) Recupere o nome do cliente que fez o primeiro pedido.
SELECT nome
FROM clientes
WHERE id = (
  SELECT idcliente
  FROM pedidos
  ORDER BY datahorapedido 
  ASC LIMIT 1);

-- 6) Liste os produtos que nunca foram pedidos.
SELECT nome
FROM produtos
WHERE id NOT IN (
	SELECT idProduto
    FROM itenspedidos);

-- 7) Liste os nomes dos clientes que fizeram pedidos entre 2023-01-01 e 2023-12-31.
SELECT c.nome
FROM clientes c
INNER JOIN pedidos p
ON c.id = p.idcliente
WHERE p.datahorapedido BETWEEN '2023-01-01' AND '2023-12-31';

-- 8) Recupere os nomes dos produtos que estão em menos de 15 pedidos.
SELECT p.nome, ip.quantidade
FROM produtos p
INNER JOIN itenspedidos ip
ON p.id = ip.idproduto
GROUP BY p.nome
HAVING COUNT (ip.idpedido) < 15;

-- 9) Liste os produtos e o ID do pedido que foram realizados pelo cliente "Pedro Alves" ou pela cliente "Ana Rodrigues".
SELECT p.nome, ip.idpedido
FROM produtos p
INNER JOIN itenspedidos ip
ON p.id = ip.idproduto
INNER JOIN pedidos pd
ON ip.idpedido = pd.id
INNER JOIN clientes c
ON pd.idcliente = c.id
WHERE c.nome IN ('Pedro Alves' , 'Ana Rodrigues');

-- 10) Recupere o nome e o ID do cliente que mais comprou(valor) no Serenatto.
SELECT c.id, c.nome, ROUND(SUM(ip.precounitario), 0) AS total_pedidos
FROM clientes c
INNER JOIN pedidos pd
ON pd.idcliente = c.id
INNER JOIN itenspedidos ip
ON ip.idpedido = pd.id
INNER JOIN produtos p
ON p.id = ip.idproduto
GROUP BY c.id, c.nome
ORDER BY total_pedidos DESC
LIMIT 1;