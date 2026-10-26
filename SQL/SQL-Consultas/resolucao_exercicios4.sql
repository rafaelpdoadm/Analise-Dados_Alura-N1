-- 1) Buscar o nome do professor e a turma que ele é orientador
SELECT P.Nome_Professor, T.Nome_Turma
FROM Professores P
INNER JOIN Turmas T
ON P.ID_Professor = T.ID_Professor_Orientador;

-- 2) Retornar o nome e a nota do aluno que possui a melhor nota na disciplina de Matemática
SELECT A.Nome_Aluno, MAX(N.Nota) AS MaiorNota
FROM Alunos A
INNER JOIN Notas N
ON A.ID_Aluno = N.ID_Aluno
INNER JOIN Disciplinas D
ON D.ID_Disciplina = N.ID_Disciplina
WHERE N.ID_Disciplina = 1;

-- 3) Identificar o total de alunos por turma
SELECT T.Nome_Turma, COUNT(TA.ID_Turma) AS TotalAlunos_Turma
FROM Turmas T
INNER JOIN Turma_Alunos TA
ON T.ID_Turma = TA.ID_Turma
GROUP BY nome_turma;

-- 4) Listar os Alunos e as disciplinas em que estão matriculados
SELECT A.Nome_Aluno, D.Nome_Disciplina
FROM Alunos A
INNER JOIN Turma_Alunos TA
ON A.ID_Aluno = TA.ID_Turma
INNER JOIN  Turma_Disciplinas TD
ON TA.ID_Turma = TD.ID_Turma
INNER JOIN Disciplinas D
ON D.ID_Disciplina = TD.ID_Disciplina;

-- 5) Criar uma view que apresenta o nome, a disciplina e a nota dos alunos
CREATE VIEW AlunosDisciplina_Nota AS
SELECT A.Nome_Aluno, D.Nome_Disciplina, N.Nota
FROM Alunos A
INNER JOIN Notas N
ON A.ID_Aluno = N.ID_Aluno
INNER JOIN Disciplinas D
ON N.ID_Disciplina = D.ID_Disciplina;

SELECT *
FROM AlunosDisciplina_Nota;