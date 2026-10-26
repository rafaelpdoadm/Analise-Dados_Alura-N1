SELECT p.id, ip.quantidade, pr.preco, ip.precounitario
FROM pedidos p
INNER JOIN itenspedidos ip
ON p.id = ip.idpedido
JOIN produtos pr
ON pr.id = ip.idproduto;


SELECT p.id, c.nome, SUM(ip.precounitario) AS ValorTotalPedido
FROM clientes c
INNER JOIN pedidos p
ON c.id = p.idcliente
INNER JOIN itenspedidos ip
ON p.id = ip.idpedido
GROUP BY p.id, c.nome;

-- formas de otimizar essa funcao acima --
CREATE VIEW ViewCliente AS
SELECT nome, endereco
FROM clientes;

SELECT *
FROM ViewCliente;

CREATE VIEW ViewValorTotalPedido AS
SELECT p.id, c.nome,p.datahorapedido, SUM(ip.precounitario) AS ValorTotalPedido
FROM clientes c
INNER JOIN pedidos p
ON c.id = p.idcliente
INNER JOIN itenspedidos ip
ON p.id = ip.idpedido
GROUP BY p.id, c.nome;

-- utilizando em exemplos as views --
SELECT *
FROM ViewValorTotalPedido;

SELECT nome 
FROM ViewValorTotalPedido;

SELECT *
FROM ViewValorTotalPedido
WHERE ValorTotalPedido = 10;


SELECT *
FROM ViewValorTotalPedido
WHERE ValorTotalPedido > 10 AND ValorTotalPedido < 14;

SELECT *
FROM ViewValorTotalPedido
WHERE strftime('%m', datahorapedido) = '08';

-- calcular o faturamento diario --
SELECT DATE(datahorapedido) AS Dia, SUM(ip.precounitario) AS FaturamentoDiario
FROM pedidos p
INNER JOIN itenspedidos ip
ON p.id = ip.idpedido
GROUP BY Dia
ORDER BY Dia;

 -- fazer de forma automatica e guardar a informacao de forma rapida (trigger) --
CREATE TABLE FaturamentoDiario(
  Dia DATE,
  FaturamentoTotal DECIMAL(10,2)
);

CREATE TRIGGER CalculaFaturamentoDiario
AFTER INSERT ON itenspedidos
FOR EACH ROW
BEGIN
DELETE FROM FaturamentoDiario;
INSERT INTO FaturamentoDiario (Dia, FaturamentoTotal)
SELECT DATE(datahorapedido) AS Dia, SUM(ip.precounitario) AS FaturamentoDiario
FROM pedidos p
INNER JOIN itenspedidos ip
ON p.id = ip.idpedido
GROUP BY Dia
ORDER BY Dia;
END;

-- testando novos valores na trigger --
SELECT *
FROM FaturamentoDiario;

INSERT INTO pedidos (id, idcliente, datahorapedido, status)
VALUES (451, 27, '2023-10-07 14:30', 'Em Andamento');

SELECT *
FROM FaturamentoDiario;

-- a trigger so sera acionada se houver novos dados na tabela de itenspedidos --
INSERT INTO ItensPedidos(IDPedido, IDProduto, Quantidade, PrecoUnitario)
VALUES (451, 14, 1, 6.0),
         (451, 13, 1, 7.0);

SELECT *
FROM itenspedidos;

SELECT *
FROM FaturamentoDiario;

-- adicionando mais informacoes nas tabelas --
INSERT INTO Pedidos (ID, IDCliente, DataHoraPedido, Status) 
VALUES (452, 28, '2023-10-07 14:35:00', 'Em Andamento');

INSERT INTO ItensPedidos (IDPedido, IDProduto, Quantidade, PrecoUnitario) 
VALUES (452, 10, 1, 5.0),
       (452, 31, 1, 12.50);
       
SELECT *
FROM pedidos;

SELECT *
FROM FaturamentoDiario;