SELECT *
FROM clientes
WHERE cliente_id = '10001';

CALL novoAluguel_24('10005','10001','8635','2023-03-17','2023-03-25',40);

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_25`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_25`
(vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR (10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vDias = (SELECT DATEDIFF(vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
	INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
    SET vMensagem = 'Aluguel incluido na base com sucesso.';
    SELECT vMensagem;
END$$
DELIMITER ;

CALL novoAluguel_25('10005','1004','8635','2023-03-13','2023-03-16',40);