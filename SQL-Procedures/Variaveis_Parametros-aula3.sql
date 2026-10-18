SELECT DATEDIFF('2023-04-03', '2023-04-01') AS difereca_dias;

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_24`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_24`
(vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR (10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    SET vDias = (SELECT DATEDIFF(vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
	INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$
DELIMITER ;

CALL novoAluguel_24('10004','1004','8635','2023-03-13','2023-03-16',40);

SELECT *
FROM alugueis
WHERE alguel_id = '10004';