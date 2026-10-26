-- calculando a taxa de ocupacao dos imoveis
SELECT 
	hospedagem_id, 
    MIN(data_inicio) AS Primeira_Data, 
    SUM(DATEDIFF(data_fim, data_inicio)) AS Dias_Ocupados, 
    DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS Total_Dias,
	ROUND((SUM(DATEDIFF(data_fim, data_inicio)) / DATEDIFF(MAX(data_fim), MIN(data_inicio))) * 100) AS Taxa_Ocupacao
FROM alugueis
GROUP BY hospedagem_id
ORDER BY Taxa_Ocupacao DESC;