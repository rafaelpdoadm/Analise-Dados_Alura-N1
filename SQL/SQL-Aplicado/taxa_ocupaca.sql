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

-- consulta para identificar se há proprietarios com mais de um imovel disponivel para ser alugado
SELECT 
	p.nome AS Proprietario,
    COUNT(DISTINCT h.hospedagem_id) AS Total_Hospedagens
FROM hospedagens h
INNER JOIN proprietarios p
ON h.proprietario_id = p.proprietario_id
GROUP BY p.proprietario_id
ORDER BY Total_Hospedagens DESC;

-- realizando um cruzamento entre o resultado da primeira query e o da segunda
SELECT
	p.nome AS Proprietario,
    MIN(primeira_data) AS Primeira_Data,
    SUM(total_dias) AS Total_Dias,
    SUM(dias_ocupados) AS Dias_Ocupados,
    ROUND((SUM(Dias_Ocupados) / SUM(Total_Dias)) * 100) AS Taxa_Ocupacao
FROM (
	SELECT
		hospedagem_id,
        MIN(data_inicio) AS Primeira_Data,
        SUM(DATEDIFF(data_fim,data_inicio)) AS Dias_Ocupados,
        DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS Total_Dias
	FROM alugueis
    GROUP BY hospedagem_id
) Tabela_Taxa_Ocupacao
INNER JOIN hospedagens h
ON Tabela_Taxa_Ocupacao.hospedagem_id = h.hospedagem_id
INNER JOIN proprietarios p
ON h.proprietario_id = p.proprietario_id
GROUP BY p.proprietario_id
ORDER BY Total_Dias DESC;

-- foi necessario realizar uma consulta para identificar epocas de baixa e alta demanda buscando sazonalidades
SELECT
	YEAR(data_inicio) AS Ano,
    MONTH(data_inicio) AS Mes,
    COUNT(*) AS Total_Alugueis
FROM alugueis
GROUP BY Ano, Mes
ORDER BY Ano, Mes;

-- de forma complementar, e a partir da analise da query anterior, foi realizada outra consulta para identificar os meses de maior procura
SELECT
	MONTH(data_inicio) AS Mes,
    COUNT(*) AS Total_Alugueis
FROM alugueis
GROUP BY Mes
ORDER BY Total_Alugueis DESC;

-- consulta para analisarmos o valor das diarias ofertadas nos imoveis
SELECT 
	a.hospedagem_id,
    a.preco_total,
    DATEDIFF(a.data_fim, a.data_inicio) AS Dias_Aluguel,
    a.preco_total / DATEDIFF(a.data_fim, a.data_inicio) AS Preco_Dia
FROM alugueis a
ORDER BY Preco_Dia DESC;

-- buscando variacoes nos precos das diarias separadas por estado
SELECT
	e.estado,
    AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS Media_Preco_Aluguel,
    MAX(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS Max_Preco_Dia,
    MIN(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS Min_Preco_Dia,
    AVG(DATEDIFF(a.data_fim, a.data_inicio)) AS Media_Dias_Aluguel
FROM alugueis a
INNER JOIN hospedagens h
ON a.hospedagem_id = h.hospedagem_id
INNER JOIN enderecos e
ON h.endereco_id = e.endereco_id
GROUP BY e.estado;

-- faremos agora a analise por regiao do brasil
SELECT
	r.regiao,
    AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS Media_Preco_Aluguel,
    MAX(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS Max_Preco_Dia,
    MIN(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS Min_Preco_Dia,
    AVG(DATEDIFF(a.data_fim, a.data_inicio)) AS Media_Dias_Aluguel
FROM alugueis a
INNER JOIN hospedagens h
ON a.hospedagem_id = h.hospedagem_id
INNER JOIN enderecos e
ON h.endereco_id = e.endereco_id
INNER JOIN regioes_geograficas r
ON r.estado = e.estado
GROUP BY r.regiao;

-- cruzando dados de taxa de ocupacao e medias de precos para a regiao sudeste, por exemplo
SELECT
	YEAR(data_inicio) AS Ano,
    MONTH(data_inicio) AS Mes,
    COUNT(*) AS Total_Alugueis
FROM alugueis a
INNER JOIN hospedagens h
ON a.hospedagem_id = h.hospedagem_id
INNER JOIN enderecos e
ON h.endereco_id = e.endereco_id
INNER JOIN regioes_geograficas r
ON e.estado = r.estado
WHERE r.regiao = "Sudeste"
GROUP BY Ano, Mes
ORDER BY Ano, Mes;

-- simplificando o script por meio da procedure e facilitando, por exemplo, o filtro por regiao do pais
DELIMITER //

DROP PROCEDURE IF EXISTS Get_Dados_Por_Regiao;

CREATE PROCEDURE Get_Dados_Por_Regiao(regiao_nome VARCHAR(255))
BEGIN

	SELECT
		YEAR(data_inicio) AS Ano,
        MONTH(data_inicio) AS Mes,
        COUNT(*) AS Total_Alugueis
	FROM alugueis a
    INNER JOIN hospedagens h
    ON a.hospedagem_id = h.hospedagem_id
    INNER JOIN enderecos e
    ON h.endereco_id = e.endereco_id
    INNER JOIN regioes_geograficas r 
    ON e.estado = r.estado
    WHERE r.regiao = regiao_nome
    GROUP BY Ano, Mes
    ORDER BY Ano, Mes;
    
END //

DELIMITER ;

CALL Get_Dados_Por_Regiao("Sul");
CALL Get_Dados_Por_Regiao("Norte");

-- procedure para analisar um proprietario especifico para uma reuniao com ele
USE insightplaces;

DROP PROCEDURE IF EXISTS Calcular_Taxa_Ocupacao;

DELIMITER $$

CREATE PROCEDURE Calcular_Taxa_Ocupacao(ID VARCHAR(255))

BEGIN
	SELECT
		p.nome AS Proprietario,
        MIN(primeira_data) AS Primeira_Data,
        SUM(total_dias) AS Total_Dias,
        SUM(dias_ocupados) AS Dias_Ocupados,
        ROUND((SUM(dias_ocupados) / SUM(Total_Dias)) * 100) AS Taxa_Ocupacao
	FROM (
		SELECT
			hospedagem_id,
            MIN(data_inicio) AS Primeira_Data,
            SUM(DATEDIFF(data_fim, data_inicio)) AS Dias_Ocupados,
            DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS Total_Dias
		FROM alugueis
        GROUP BY hospedagem_id
		) AS Tabela_Taxa_Ocupacao
	INNER JOIN hospedagens h
    ON a.hospedagem_id = h.hospedagem_id
    INNER JOIN enderecos e
    ON h.endereco_id = e.endereco_id
    INNER JOIN regioes_geograficas r
    ON e.estado = r.estado
    WHERE r.regiao = "Sudeste"
    GROUP BY Ano, Mes
    ORDER BY Ano, Mes;
END $$

DELIMITER ; 

CALL Calcular_Taxa_Ocupacao("11")