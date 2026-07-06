-- 01) Qual é o número de Clientes que existem na base de dados ?
SELECT COUNT(id_cliente) AS Qtd_Clientes
FROM clientes;

-- 02) Quantos produtos foram vendidos no ano de 2022 ?
SELECT COUNT(iv.produto_id) AS Qtd_Produtos_Vendidos
FROM vendas v
INNER JOIN itens_venda iv
ON v.id_venda = iv.venda_id
WHERE strftime('%Y', v.data_venda) = '2022';

-- 03) Qual a categoria que mais vendeu em 2022 ?
SELECT COUNT(*) as Qtd_Vendas, c.nome_categoria AS Categoria
FROM vendas v
INNER JOIN itens_venda iv
ON v.id_venda = iv.venda_id
INNER JOIN produtos p
ON iv.produto_id = p.id_produto
INNER JOIN categorias c
ON c.id_categoria = p.categoria_id
WHERE strftime('%Y', data_venda) = '2022'
GROUP BY Categoria
ORDER BY COUNT(*) DESC;

-- 04) Qual o primeiro ano disponível na base ?
SELECT MIN(strftime('%Y', data_venda)) AS Ano
FROM vendas;

-- 05) Qual o nome do fornecedor que mais vendeu no primeiro ano disponível na base ?
SELECT COUNT(*) AS Qtd_Vendas, f.nome AS Fornecedor
FROM vendas v
INNER JOIN itens_venda iv
ON v.id_venda = iv.venda_id
INNER JOIN produtos p
ON iv.produto_id = p.fornecedor_id
INNER JOIN fornecedores f
ON p.fornecedor_id = f.id_fornecedor
WHERE strftime('%Y', v.data_venda) = '2020'
GROUP BY Fornecedor
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 06) Quanto ele vendeu no primeiro ano disponível na base de dados?
SELECT COUNT(*) AS Qtd_Vendas, strftime('%Y', v.data_venda) AS Ano, f.nome AS Fornecedor
FROM vendas v
INNER JOIN itens_venda iv
ON v.id_venda = iv.venda_id
INNER JOIN produtos p
ON p.id_produto = iv.produto_id
INNER JOIN fornecedores f
ON f.id_fornecedor = p.fornecedor_id
WHERE Ano = '2020'
GROUP BY Fornecedor
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 07) Quais as duas categorias que mais venderam no total de todos os anos ?
SELECT COUNT(*) AS Qtd_Vendas, c.nome_categoria AS Categoria
FROM vendas v
INNER JOIN itens_venda iv
ON v.id_venda = iv.venda_id
INNER JOIN produtos p
ON iv.produto_id = p.id_produto
INNER JOIN categorias c
ON c.id_categoria = p.categoria_id
GROUP BY Categoria
ORDER BY COUNT(*) DESC
LIMIT 2;

-- 08) Crie uma tabela comparando as vendas ao longo do tempo das duas categorias que mais venderam no total de todos os anos.
SELECT 'Ano/Mês',
SUM(CASE WHEN Categoria == 'Eletrônicos' THEN Qtd_Vendas ELSE 0 END) AS Eletrônicos,
SUM(CASE WHEN Categoria == 'Vestuário' THEN Qtd_Vendas ELSE 0 END) AS Vestuário
FROM(
  SELECT COUNT(*) AS Qtd_Vendas, strftime('%Y/%m', v.data_venda) AS 'Ano/Mês', c.nome_categoria AS Categoria
  FROM itens_venda iv
  INNER JOIN vendas v
  ON v.id_venda = iv.venda_id
  INNER JOIN produtos p
  ON p.id_produto = iv.produto_id
  INNER JOIN categorias c
  ON c.id_categoria = p.categoria_id
  WHERE Categoria IN ('Eletrônicos', 'Vestuário')
  GROUP BY 'Ano/Mês', Categoria
  ORDER BY 'Ano/Mês', Categoria
)
GROUP BY 'Ano/Mês';

-- 09) Calcule a porcentagem de vendas por categorias no ano de 2022.
WITH Total_Vendas AS (
  SELECT COUNT(*) AS Total_Vendas_2022
  FROM itens_venda iv
  INNER JOIN vendas v
  ON v.id_venda = iv.venda_id
  WHERE strftime('%Y', v.data_venda) = '2022'
)
SELECT Nome_Categoria, Qtd_Vendas, ROUND(100.0*Qtd_Vendas/tv.Total_Vendas_2022, 2)
FROM(
  SELECT c.nome_categoria AS Nome_Categoria, COUNT(iv.produto_id) AS Qtd_vendas
  FROM itens_venda iv
  INNER JOIN vendas v
  ON v.id_venda = iv.venda_id
  INNER JOIN produtos p
  ON p.id_produto = iv.produto_id
  INNER JOIN categorias c
  ON c.id_categoria = p.categoria_id
  WHERE strftime('%Y', v.data_venda) = '2022'
  GROUP BY Nome_Categoria
  ORDER BY Qtd_Vendas DESC
), Total_Vendas tv;

-- 10) Crie uma métrica mostrando a porcentagem de vendas a mais que a melhor categoria tem em relação a pior no ano de 2022.
WITH Total_Vendas AS (
  SELECT COUNT(*) AS Total_Vendas_2022
  FROM itens_venda iv
  INNER JOIN vendas v
  ON v.id_venda = iv.venda_id
  WHERE strftime('%Y', v.data_venda) = '2022'
),
Vendas_por_Categoria AS (
  SELECT c.nome_categoria AS Nome_Categoria, COUNT(iv.produto_id) AS Qtd_Vendas
  FROM itens_venda iv
  INNER JOIN vendas v
  ON v.id_venda = iv.venda_id
  INNER JOIN produtos p
  ON p.id_produto = iv.produto_id
  INNER JOIN categorias c
  ON c.id_categoria - p.categoria_id
  WHERE strftime('%Y', v.data_venda) = '2022'
  GROUP BY Nome_Categoria
),
Melhor_Pior_Categorias AS (
  SELECT MIN(Qtd_Vendas) AS Pior_Vendas, MAX(Qtd_Vendas) AS Melhor_Vendas
  FROM Vendas_por_Categoria
)
SELECT Nome_Categoria, Qtd_Vendas, ROUND(100.0*Qtd_Vendas/tv.Total_Vendas_2022, 2) || '%' AS Porcentagem, 
       ROUND(100.0*(Qtd_Vendas - Melhor_Vendas) / Melhor_Vendas, 2) || '%' AS Porcentagem_Melhor
FROM Vendas_por_Categoria
CROSS JOIN Total_Vendas tv
CROSS JOIN Melhor_Pior_Categorias
ORDER BY Porcentagem DESC;