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