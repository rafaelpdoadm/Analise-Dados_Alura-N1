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