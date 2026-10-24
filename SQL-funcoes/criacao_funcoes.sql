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

-- foi solicitada a criacao de uma funcao que retornasse, quando pedido, o valor pago por cada diaria do hospede
DELIMITER $$

CREATE FUNCTION InfoAluguel(IdAluguel INT)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN

DECLARE NomeCliente VARCHAR(100);
DECLARE PrecoTotal DECIMAL(10,2);
DECLARE Dias INT;
DECLARE ValorDiaria DECIMAL(10,2);
DECLARE Resultado VARCHAR(255);

SELECT c.nome, a.preco_total, DATEDIFF(data_fim, data_inicio)
INTO NomeCliente, PrecoTotal, Dias
FROM alugueis a
INNER JOIN clientes c
ON a.cliente_id = c.cliente_id
WHERE a.aluguel_id = IdAluguel;

SET ValorDiaria = PrecoTotal / Dias;

SET Resultado = CONCAT('Nome: ', NomeCliente, ', Valor Diário: R$', FORMAT(ValorDiaria,2));

RETURN Resultado;

END $$

DELIMITER ;

SELECT InfoAluguel(1)