-- funcionaria alega que realizou um treinamento muito bom e gostaria de indicar aos colegas --
-- ela diz que lembra que possui apenas a palavra 'o poder' no titulo --
SELECT *
FROM Treinamento;

-- realizando a busca com a informacao que nos foi passada que estava incluida no titulo --
SELECT * 
FROM Treinamento
WHERE curso LIKE 'o poder%';
