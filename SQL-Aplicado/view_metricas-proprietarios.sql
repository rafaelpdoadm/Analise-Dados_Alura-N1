USE insightplaces;

-- criacao da view para facilitar o acesso ao resultado
CREATE VIEW view_metricas_proprietario AS 
SELECT
    p.nome AS Proprietario,
    COUNT(DISTINCT h.hospedagem_id) AS Total_Hospedagens,
    MIN(primeira_data) AS Primeira_Data,
    SUM(total_dias) AS Total_Dias,
    SUM(dias_ocupados) AS Dias_Ocupados,
    ROUND((SUM(Dias_Ocupados) / SUM(Total_Dias)) * 100) AS Taxa_Ocupacao
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
ON Tabela_Taxa_Ocupacao.hospedagem_id = h.hospedagem_id
INNER JOIN proprietarios p
ON h.proprietario_id = p.proprietario_id
GROUP BY p.proprietario_id;

SELECT *
FROM view_metricas_proprietario;

-- criando outra view com os principais dados descritivos por regiao
CREATE VIEW view_dados_regiao AS
SELECT
    r.regiao,
    AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS Media_Preco_Aluguel,
    MAX(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS Max_Preco_Dia,
    MIN(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS Min_Preco_dia,
    AVG(DATEDIFF(a.data_fim, a.data_inicio)) AS Media_Dias_Aluguel
FROM alugueis a
INNER JOIN hospedagens h
ON a.hospedagem_id = h.hospedagem_id
INNER JOIN enderecos e
ON h.endereco_id = e.endereco_id
INNER JOIN regioes_geograficas r
ON r.estado = e.estado
GROUP BY r.regiao;

SELECT *
FROM view_dados_regiao;

-- view de mistura dos dados de regiao por dados temporais dos alugueis
CREATE VIEW ocupacao_por_regiao_tempo AS
SELECT
    r.regiao,
    YEAR(data_inicio) AS Ano,
    MONTH(data_inicio) AS Mes,
    COUNT(*) AS Total_Alugueis
FROM alugueis a
INNER JOIN hospedagens h
ON a.hospedagem_id = h.hospedagem_id
INNER JOIN enderecos e
ON h.endereco_id = e.endereco_id
INNER JOIN regioes_geograficas r
ON r.estado = e.estado
GROUP BY r.regiao, YEAR(data_inicio), MONTH(data_inicio)
ORDER BY r.regiao, Ano, Mes;

SELECT * FROM ocupacao_por_regiao_tempo;

-- aplicando filtro na view para uma nova analise
SELECT *
FROM ocupacao_por_regiao_tempo
WHERE regiao = 'Sudeste' AND Ano = '2023';