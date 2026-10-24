-- criacao de funcoes para encapsulamento de funcoes, gerando agilidade para algumas atividades do dia-a-dia e facilitando manutencao
DELIMITER $$
CREATE FUNCTION Retorno_Constante()
RETURNS VARCHAR(50) DETERMINISTIC 
BEGIN
	
RETURN 'Seja Bem-Vindo(a)';
    
END$$
    
DELIMITER ;

SELECT Retorno_Constante();

-- criando outra funcao para calcular as medias das avaliacoes
DELIMITER $$
CREATE FUNCTION MediaAvaliacoes()
RETURNS FLOAT DETERMINISTIC
BEGIN

DECLARE media FLOAT;
SELECT ROUND(AVG(nota), 2) Media_Notas
INTO media
FROM avaliacoes;
RETURN media;

END $$
DELIMITER ;

SELECT MediaAvaliacoes();

-- utilizando parametros para a criacao de funcoes
DELIMITER $$
CREATE FUNCTION FormatandoCPF(ClienteID INT)
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN

DECLARE NovoCPF VARCHAR(50);
SET NovoCPF = (
SELECT CONCAT(SUBSTRING(cpf, 1, 3), '.', SUBSTRING(cpf, 4, 3), '.', SUBSTRING(cpf, 7, 3), '-', SUBSTRING(cpf, 10, 2)) AS CPF_Mascarado
FROM clientes
WHERE cliente_id = ClienteID
);

RETURN NovoCPF;
END $$

DELIMITER ;

SELECT FormatandoCPF(1) AS CPF;

SELECT TRIM(nome), FormatandoCPF(1) AS CPF
FROM clientes
WHERE cliente_id = 1;