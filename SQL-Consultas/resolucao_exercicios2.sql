-- Para a resulucao desses exercicios foi utilizada a DB 'sqlite' --

-- 1) Retornar a média de Notas dos Alunos em história --
SELECT AVG(nota) AS media
FROM Notas
WHERE id_disciplina = 2;

-- 2) Retornar as informações dos alunos cujo Nome começa com 'A' --
SELECT *
FROM Alunos
where nome_aluno LIKE 'A%';

-- 3) Buscar apenas os alunos que fazem aniversário em fevereiro --
SELECT *
FROM Alunos
WHERE STRFTIME('%m', data_nascimento) = '02';

-- 4) Realizar uma consulta que calcula a idade dos Alunos --
SELECT nome_aluno, data_nascimento, (STRFTIME('%Y', CURRENT_DATE) - STRFTIME('%Y', data_nascimento)) - (STRFTIME('%m-%d', CURRENT_DATE) < STRFTIME('%m-%d', data_nascimento)) AS idade
FROM Alunos;

-- 5) Retornar se o aluno está ou não aprovado. Aluno é considerado aprovado se a sua nota foi igual ou maior que 6 --
SELECT id_aluno AS aluno, nota,
CASE WHEN nota>= 6 THEN 'Aprovado'
ELSE 'Reprovado'
END AS Resultado
FROM Notas;
