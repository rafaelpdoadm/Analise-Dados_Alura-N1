-- 1) Retorne todas as disciplinas
SELECT *
FROM Disciplinas;

-- 2) Retorne os alunos que estão aprovados na disciplina de matemática
SELECT nome_aluno, n.Nota
FROM Alunos a
INNER JOIN Notas n
ON a.ID_Aluno = n.ID_Aluno
WHERE n.ID_Disciplina = '1' AND n.Nota >= '7.0'
ORDER BY Nome_Aluno ASC;

-- 3) Identificar o total de disciplinas por turma
SELECT t.Nome_Turma AS Turma, COUNT(td.ID_Disciplina) AS Total_Disciplinas
FROM Turma_Disciplinas td
INNER JOIN Turmas t
ON t.ID_Turma = td.ID_Turma
GROUP BY id_disciplina;

-- 4) Porcentagem de alunos aprovados (média ≥ 7), considerando todos os alunos
SELECT COUNT(CASE WHEN Media_Notas >= 7 THEN 1 END) AS Qtd_Alunos_Aprovados,
       COUNT(*) as Qtd_Total_Alunos,
       ROUND(AVG(CASE WHEN Media_Notas >= 7 THEN 1.0 ELSE 0 END) * 100.0, 2) || '%' AS Porcentagem
FROM (
  SELECT a.ID_Aluno, AVG(n.Nota) AS Media_Notas
  FROM Alunos a
  LEFT JOIN Notas n
  ON n.ID_Aluno = a.ID_Aluno
  GROUP BY a.ID_Aluno
);

-- 5) Porcentagem dos alunos que estão aprovados por disciplina
SELECT d.Nome_Disciplina AS Disciplina, COUNT(*) AS Total_Alunos,
       SUM(CASE WHEN n.Nota >= 7.0 THEN 1 ELSE 0 END) AS Alunos_Aprovados,
       ROUND(SUM(CASE WHEN n.Nota >= 7.0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) || '%' Porcentagem
FROM Alunos a
INNER JOIN Notas n
ON n.ID_Aluno = a.ID_Aluno
INNER JOIN Disciplinas d
ON d.ID_Disciplina = n.ID_Disciplina
GROUP BY Disciplina
ORDER BY Porcentagem DESC;