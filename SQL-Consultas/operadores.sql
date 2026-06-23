-- funcionaria alega que realizou um treinamento muito bom e gostaria de indicar aos colegas --
-- ela diz que lembra que possui apenas a palavra 'o poder' no titulo --
SELECT *
FROM Treinamento;

-- realizando a busca com a informacao que nos foi passada que estava incluida no titulo --
SELECT * 
FROM Treinamento
WHERE curso LIKE 'o poder%';

-- apos isso surgiu a necessidade de buscar cursos que possuiam no meio do seu nome a palavra 'realizar' --
SELECT *
FROM Treinamento
WHERE curso LIKE '%realizar%';

-- a Fokus quer buscar as informacoes de uma funcionaria mas se lembra apenas do nome 'Isadora'
SELECT *
FROM Colaboradores
WHERE nome LIKE 'Isadora%';

-- a Fokus agora quer saber o cargo das pessoas disponiveis para contratar na vaga de professor --
SELECT *
FROM HistoricoEmprego
WHERE cargo = 'Professor' 
AND datatermino NOT NULL;

-- a Fokus agora quer consultas com mais condicoes e mais ampla. Busca por profissionais cadastrados como oftalmologista ou dermatologista --
SELECT *
FROM HistoricoEmprego
WHERE cargo = 'Oftalmologista'
OR cargo = 'Dermatologista';

-- uma forma de otimizar a query anterior --
SELECT *
FROM HistoricoEmprego
WHERE cargo in ('Oftalmologista', 'Dermatologista', 'Professor');

-- mesmo tipo de consulta, mas excluindo resultados especificos --
SELECT *
FROM HistoricoEmprego
WHERE cargo NOT IN ('Oftalmologista', 'Dermatologista', 'Professor');

-- foi pedido agora para que sejam buscados dois cursos especificos da tabela de treinamento --
SELECT *
FROM Treinamento
WHERE (curso LIKE '%O direito%' AND instituicao = 'da Rocha')
OR (curso LIKE '%O conforto%' AND instituicao = 'das Neves');