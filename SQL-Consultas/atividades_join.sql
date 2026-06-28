-- atividade: buscar o nome dos clientes que ainda não fizeram pedido na loja --
SELECT *
FROM Pedidos p
RIGHT JOIN clientes c
ON c.ID = p.IDcliente;

-- o select acima deu os resultados de todos os clientes que fizeram pedidos --
SELECT *
FROM Pedidos p
RIGHT JOIN clientes c
ON c.ID = p.IDcliente
WHERE p.IDcliente IS NULL;

-- o select acima chega no resultado que buscamos, mas ele da todas as informacoes do clientes e precisamos apenas do nome
SELECT c.nome
FROM Pedidos p
RIGHT JOIN clientes c
ON c.ID = p.IDcliente
WHERE p.IDcliente IS NULL;
-- com isso, foi necessario refinar o select para chegarmos apenas no nome do cliente que nao fez um pedido --

