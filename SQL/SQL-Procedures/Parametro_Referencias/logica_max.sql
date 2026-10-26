SELECT * 
FROM alugueis;

SELECT aluguel_id, CAST(aluguel_id AS UNSIGNED)
FROM alugueis;

SELECT MAX(aluguel_id), MAX(CAST(aluguel_id AS UNSIGNED))
FROM alugueis;

SELECT MAX(CAST(aluguel_id AS UNSIGNED)) + 1
FROM alugueis;

SELECT CAST(MAX(CAST(aluguel_id AS UNSIGNED)) + 1 AS CHAR)
FROM alugueis;

SELECT DAYOFWEEK(STR_TO_DATE('2023-01-01','%Y-%m-%d'));

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_44`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_44`
(vClienteNome VARCHAR(150), vHospedagem VARCHAR (10), vDataInicio DATE, vDias INTEGER, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vAluguel VARCHAR(10);
	DECLARE vCliente VARCHAR(10);
	DECLARE vDataFinal DATE;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
	SET vNumCliente = (SELECT COUNT(*)
					   FROM clientes
                       WHERE nome = vClienteNome);
	CASE
    WHEN vNumCliente = 0 THEN
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
	WHEN vNumCliente = 1 THEN
		SELECT CAST(MAX(CAST(aluguel_id AS UNSIGNED)) + 1 AS CHAR) INTO vAluguel FROM alugueis;
        CALL calculaDataFinal_43 (vDataInicio, vDataFinal, vDias);
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
		INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
		SET vMensagem = CONCAT('Aluguel incluido na base com sucesso. ID' vAluguel);
		SELECT vMensagem;
	WHEN vNumCliente > 1 THEN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
	END CASE;    
END$$
DELIMITER ;

CALL novoAluguel_44('Lívia Fogaça','8635','2023-05-15',5,45);

SELECT *
FROM alugueis
WHERE aluguel_id = '10012';