-- foi solicitado como atividade buscar o nome de cada cliente e o valor total dos pedidos de cada um --
SELECT c.nome AS NomeCliente, SUM(ip.precounitario) AS SomaTotalPedidos
FROM clientes c
INNER JOIN pedidos p
ON c.id = p.idcliente
INNER JOIN itenspedidos ip
ON p.id = ip.idpedido
GROUP BY c.nome;

