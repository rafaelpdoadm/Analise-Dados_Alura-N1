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
ORDER BY COUNT(*) DESC;

-- 06) Quanto ele vendeu no primeiro ano disponível na base de dados ?


-- 07) Quais as duas categorias que mais venderam no total de todos os anos ?

-- 08) Crie uma tabela comparando as vendas ao longo do tempo das duas categorias que mais venderam no total de todos os anos.

-- 09) Calcule a porcentagem de vendas por categorias no ano de 2022.

-- 10) Crie uma métrica mostrando a porcentagem de vendas a mais que a melhor categoria tem em relação a pior no ano de 2022.
