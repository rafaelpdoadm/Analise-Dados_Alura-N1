-- foi solicitado pela Fokus para buscarmos se todos os CPFs dos colaboradores cadastrados estao corretos --
SELECT nome, LENGTH(cpf) AS qtd
FROM Colaboradores
WHERE qtd = 11;

-- eh necessaria uma reformulacao na query para termos certeza de que nao ha ninguem registrado de forma errada --
SELECT COUNT(*), LENGTH(cpf) AS qtd
FROM Colaboradores
WHERE qtd = 11;

-- a outra demanda da Fokus eh de que ela gostaria de visualizar os dados de forma mais dinamica, sem parecer uma tabela --
SELECT ('A pessoa colaboradora '|| nome || ' de CPF ' || cpf || ' possui o seguinte endereço: ' || endereco) AS texto
FROM Colaboradores;

-- a Fokus agora deseja ver a data de licença dos colaboradores, diferente do visto na tabela --
SELECT id_colaborador, STRFTIME('%Y/%m', datainicio)
FROM Licencas;

-- a Fokus agora quer saber o intervalo de tempo que os colaboradores ficaram na empresa --
SELECT id_colaborador, JULIANDAY(datatermino) - JULIANDAY (datacontratacao)
FROM HistoricoEmprego
WHERE datatermino IS NOT NULL;

-- a Fokus agora quer que trabalhemos com funcoes de dados numericos --
-- a intencao eh arrendondar os valores de faturamento, lucro, por ex --
SELECT AVG(faturamento_bruto), ROUND (AVG(faturamento_bruto), 2)
FROM faturamento;

-- utilizacao da funcao CEIL que arredonda os valores --
SELECT CEIL(faturamento_bruto), CEIL(despesas)
FROM faturamento;

-- utilizacao da funcao FLOOR para obter o inteiro maior --
SELECT FLOOR(faturamento_bruto), FLOOR(despesas)
FROM faturamento;

-- a Fokus quer ver o dado do faturamento bruto medio como uma linha de texto --
SELECT ('O faturamento bruto médio foi ' || CAST(ROUND(AVG(faturamento_bruto), 2) as TEXT))
FROM faturamento;

-- precisamos criar condicoes para obter os resultados especificos que a Fokus deseja sobre os salarios pagos aos colaboradores --
SELECT id_colaborador, cargo, salario,
CASE
WHEN salario < 3000 THEN 'Baixo'
WHEN salario BETWEEN 3000 AND 6000 THEN 'Médio'
ELSE 'Alto'
END AS categoria_salario
FROM HistoricoEmprego;

-- por fim, a Fokus deseja que renomeemos algumas partes do banco de dados --
ALTER TABLE HistoricoEmprego RENAME TO CargosColaboradores;
