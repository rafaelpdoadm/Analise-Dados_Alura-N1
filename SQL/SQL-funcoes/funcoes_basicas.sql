SELECT AVG(nota)
FROM avaliacoes;

-- select para identificar as notas por tipo de hospedagem
SELECT AVG(nota) AS media, tipo
FROM avaliacoes a
INNER JOIN hospedagens h
ON h.hospedagem_id = a.hospedagem_id
GROUP BY tipo;

-- select para verificar os precos pagos por cada tipo de hospedagem
SELECT tipo, SUM(preco_total) AS Valor_Total, MAX(preco_total) AS Maior_Valor, MIN(preco_total) AS Menor_Valor
FROM alugueis a
INNER JOIN hospedagens h
ON h.hospedagem_id = a.hospedagem_id
GROUP BY tipo;

-- select para arrumar os nomes que estao escritos com um espaco antes
SELECT CONCAT(TRIM(nome), ', o Email é: ',contato) AS NomeContato
FROM clientes;

-- select para arrumar o cpf no formato com . e -
SELECT CONCAT(SUBSTRING(cpf, 1, 3), '.', SUBSTRING(cpf, 4, 3), '.', SUBSTRING(cpf, 7, 3), '-', SUBSTRING(cpf, 10, 2)) AS CPF_Mascarado
FROM clientes;

-- select para manipular as datas e ter a quantidade de dias que o cliente ficou hospedado
SELECT DATEDIFF(data_fim, data_inicio) AS Qtd_Dias
FROM alugueis;

-- identificacao de quantos dias cada cliente ficou hospedado
SELECT TRIM(nome) AS Nome, DATEDIFF(data_fim, data_inicio) AS Qtd_Dias
FROM alugueis a
INNER JOIN clientes c
ON a.cliente_id = c.cliente_id;

-- organizando o total de dias por tipo de hospedagem
SELECT tipo AS Tipo_Hospedagem, SUM(DATEDIFF(data_fim, data_inicio)) AS Qtd_Dias
FROM alugueis a
INNER JOIN hospedagens h
ON a.hospedagem_id = h.hospedagem_id
GROUP BY Tipo_Hospedagem;

-- consulta para categorizacao das notas
SELECT hospedagem_id, nota,
CASE nota
	WHEN 5 THEN 'Excelente'
    WHEN 4 THEN 'Ótimo'
    WHEN 3 THEN 'Muito bom'
    WHEN 2 THEN 'Bom'
    ELSE 'Ruim'
END AS StatusNota
FROM avaliacoes;