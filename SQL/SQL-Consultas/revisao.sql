-- iniciando as consultas do módulo de resumo --
SELECT *
FROM categorias;

SELECT *
FROM produtos;

SELECT COUNT(*)
FROM produtos;

SELECT COUNT(*)
FROM vendas;

-- verificacao do espaco tempo das do banco de dados --
SELECT DISTINCT(strftime('%Y', data_venda)) as Ano
FROM vendas
ORDER BY Ano;

-- visualizacao de quantas vendas aconteceram nos anos das amostras que possuimos --
SELECT strftime('%Y', data_venda) AS Ano, COUNT(id_venda) AS Total_Vendas
FROM vendas
GROUP BY Ano
ORDER BY Ano;

-- apos encontrar as vendas por ano, buscamos as vendas nos meses dos anos --
SELECT strftime('%Y', data_venda) AS Ano, strftime('%m', data_venda) AS Mes, COUNT(id_venda) AS Total_Vendas
FROM vendas
GROUP BY Ano, Mes
ORDER BY Ano;

-- foi solicitado que analizassemos meses especificos --
SELECT strftime('%Y', data_venda) AS Ano, strftime('%m', data_venda) AS Mes, COUNT(id_venda) AS Total_Vendas
FROM vendas
WHERE Mes = '01' OR Mes = '11' OR Mes = '12'
GROUP BY Ano, Mes
ORDER BY Ano;

-- papel dos fornecedores na black friday --
SELECT strftime('%Y/%m', v.data_venda) AS 'Ano/Mês', f.nome AS Nome_Fornecedor, COUNT(iv.produto_id) AS Qtd_vendas
FROM itens_venda iv
JOIN vendas v
ON v.id_venda = iv.venda_id
INNER JOIN produtos p
ON p.id_produto = iv.produto_id
INNER JOIN fornecedores f
ON f.id_fornecedor = p.fornecedor_id
GROUP BY Nome_Fornecedor, "Ano/Mês"
ORDER BY Nome_Fornecedor;

-- categorias de produtos na black friday --
SELECT strftime('%Y', v.data_venda) AS 'Ano', c.nome_categoria AS Nome_Categoria, COUNT(iv.produto_id) AS Qtd_Vendas
FROM itens_venda iv
INNER JOIN vendas v
ON v.id_venda = iv.venda_id
INNER JOIN produtos p
ON p.id_produto = iv.produto_id
INNER JOIN categorias c
ON c.id_categoria = p.categoria_id
WHERE strftime('%m', v.data_venda) = '11'
GROUP BY Nome_Categoria, "Ano"
ORDER BY "Ano", Qtd_Vendas DESC;

-- qual fornecedor teve o pior desempenho na ultima black friday --
SELECT strftime('%Y/%m', v.data_venda) AS 'Ano/Mês', COUNT(iv.produto_id) AS Qtd_vendas
FROM itens_venda iv
JOIN vendas v
ON v.id_venda = iv.venda_id
INNER JOIN produtos p
ON p.id_produto = iv.produto_id
INNER JOIN fornecedores f
ON f.id_fornecedor = p.fornecedor_id
WHERE f.nome = 'NebulaNetworks'
GROUP BY f.nome, "Ano/Mês"
ORDER BY "Ano/Mês", Qtd_Vendas;

-- ao inves de ver apenas um fornecedor, vamos trazer, pra alem dele, os dois melhores para podermos comparar o quao distantes estao --
SELECT 'Ano/Mês', SUM(CASE WHEN Nome_Fornecedor == 'NebulaNetworks' THEN Qtd_Vendas ELSE 0 END) AS Qtd_vendas_NebulaNetworks,
                  SUM(CASE WHEN Nome_Fornecedor == 'HorizonDistributors' THEN Qtd_Vendas ELSE 0 END) AS Qtd_vendas_HorizonDistributors,
                  SUM(CASE WHEN Nome_Fornecedor == 'AstroSupply' THEN Qtd_Vendas ELSE 0 END) AS Qtd_vendas_AstroSupply
FROM(
  SELECT strftime('%Y/%m', v.data_venda) AS "Ano/Mês", f.nome AS Nome_Fornecedor, COUNT(iv.produto_id) AS Qtd_vendas
  FROM itens_venda iv
  JOIN vendas v
  ON v.id_venda = iv.venda_id
  INNER JOIN produtos p
  ON p.id_produto = iv.produto_id
  INNER JOIN fornecedores f
  ON f.id_fornecedor = p.fornecedor_id
  WHERE Nome_Fornecedor = 'NebulaNetworks' OR Nome_Fornecedor = 'HorizonDistributors' OR Nome_Fornecedor = 'AstroSupply'
  GROUP BY Nome_Fornecedor, "Ano/Mês"
  ORDER BY "Ano/Mês", Qtd_Vendas
)
GROUP BY "Ano/Mês";

-- porcentagem das categorias de produtos ofertados --
SELECT Nome_Categoria, Qtd_Vendas, ROUND(100.0*Qtd_Vendas/(SELECT COUNT(*) FROM itens_venda), 2) || '%' AS Porcentagem
FROM (
  SELECT c.nome_categoria AS Nome_Categoria, COUNT(iv.produto_id) AS Qtd_Vendas
  FROM itens_venda iv
  INNER JOIN vendas v
  ON v.id_venda = iv.venda_id
  INNER JOIN produtos p
  ON p.id_produto = iv.produto_id
  INNER JOIN categorias c
  ON c.id_categoria = p.categoria_id
  GROUP BY Nome_Categoria
  ORDER BY Qtd_Vendas DESC
);

-- quadro geral de vendas da loja --
SELECT strftime('%m', data_venda) AS Mes, strftime('%Y', data_venda) AS Ano, COUNT (*) AS Qtd_Vendas
FROM vendas
GROUP BY Mes
ORDER BY Mes;

SELECT Mes, SUM(CASE WHEN Ano == '2020' THEN Qtd_Vendas ELSE 0 END) AS '2020', 
	   SUM(CASE WHEN Ano == '2021' THEN Qtd_Vendas ELSE 0 END) AS '2021',
       SUM(CASE WHEN Ano == '2022' THEN Qtd_Vendas ELSE 0 END) AS '2022',
       SUM(CASE WHEN Ano == '2023' THEN Qtd_Vendas ELSE 0 END) AS '2023'
FROM (
  SELECT strftime('%m', data_venda) AS Mes, strftime('%Y', data_venda) AS Ano, COUNT (*) AS Qtd_Vendas
  FROM vendas
  GROUP BY Mes, Ano
  ORDER BY Mes
)
GROUP BY Mes;

-- metricas --
-- quanto foi vendido em media nas ultimas black friday´s --
SELECT AVG(Qtd_Vendas) AS Media_Qtd_Vendas
FROM (
  SELECT COUNT(*) AS Qtd_Vendas, strftime('%Y', v.data_venda) AS Ano
  FROM vendas v
  WHERE strftime('%m', v.data_venda) = '11' AND Ano != '2022'
  GROUP BY Ano);
  
-- agora precisamos verificar como esta indo a black friday do ano de 2022 --
SELECT Qtd_Vendas AS Qtd_Vendas_Atual 
FROM (
  SELECT COUNT(*) AS Qtd_Vendas, strftime('%Y', v.data_venda) AS Ano
  FROM vendas v
  WHERE strftime('%m', v.data_venda) = '11' AND Ano = '2022'
  GROUP BY Ano);
  
-- precisamos agora realizar uma comparacao em porcentagem entre as black friday´s --
WITH Media_Vendas_Anteriores AS (
  SELECT AVG(Qtd_Vendas) AS Media_Qtd_Vendas
  FROM (
  SELECT COUNT(*) AS Qtd_Vendas, strftime('%Y', v.data_venda) AS Ano
  FROM vendas v
  WHERE strftime('%m', v.data_venda) = '11' AND Ano != '2022'
  GROUP BY Ano
)), Vendas_Atual AS (
  SELECT Qtd_Vendas AS Qtd_Vendas_Atual 
  FROM (
  SELECT COUNT(*) AS Qtd_Vendas, strftime('%Y', v.data_venda) AS Ano
  FROM vendas v
  WHERE strftime('%m', v.data_venda) = '11' AND Ano = '2022'
  GROUP BY Ano
))
SELECT mva.Media_Qtd_Vendas, va.Qtd_Vendas_Atual, ROUND((va.Qtd_Vendas_Atual - mva.Media_Qtd_Vendas)/mva.Media_Qtd_Vendas *100.0, 2) || '%' AS Porcentagem
FROM Vendas_Atual va, Media_Vendas_Anteriores mva;