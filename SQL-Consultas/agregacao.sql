-- a Fokus quer saber agora os meses em que teve o maior faturamento --
SELECT *
FROM faturamento;

-- utilizacao de funcoes de agregacao para obter os valores numericos buscados --
SELECT mes, MAX(faturamento_bruto)
FROM faturamento;

SELECT mes, MIN(faturamento_bruto)
FROM faturamento;

-- a Fokus quer a soma de novos clientes de todos os meses de 2023 --
SELECT SUM(numero_novos_clientes) AS 'Novos clientes 2023'
FROM faturamento
WHERE mes LIKE '%2023';

-- a Fokus quer saber agora a media do lucro e despesa da empresa --
SELECT AVG(despesas)
FROM faturamento;

SELECT AVG(lucro_liquido)
FROM faturamento;

-- utilizando a funcao de agregacao count para saber a quantidade exata de colaboradores que estao desempregados --
SELECT COUNT(*)
FROM HistoricoEmprego
WHERE datatermino not NULL;

-- utlizando a funcao count para contar quantas licencas do tipo ferias os colaboradores tiraram --
SELECT COUNT(*)
FROM Licencas
WHERE tipolicenca = 'férias';

-- a Fokus quer saber quais os tipos existentes de parentesco os colaboradores possuem --
SELECT parentesco
FROM Dependentes
GROUP BY parentesco;

-- visando possiveis iniciativas voltadas para o parentesco que os colaboradores colocaram como 'dependentes' foi feita a query --
SELECT parentesco, COUNT(*)
FROM Dependentes
GROUP BY parentesco;

-- a Fokus quer saber agora qual instituicao possui o maior numero de cursos realizados pelos colaboradores --
SELECT instituicao, COUNT(curso)
FROM Treinamento
GROUP BY instituicao;

-- foi melhorada a query para buscar apenas as instituicoes com mais de dois cursos registrados, uma vez que houveram muitas com apenas um --
SELECT instituicao, COUNT(curso)
FROM Treinamento
GROUP BY instituicao
HAVING COUNT(curso) > 2;

-- agora a Fokus quer saber as profissoes que mais sao cadastradas nos bancos de dados, ou seja, as que tem mais procura --
SELECT cargo, COUNT(*) as qtd
FROM HistoricoEmprego
GROUP BY cargo
HAVING qtd >= 2;