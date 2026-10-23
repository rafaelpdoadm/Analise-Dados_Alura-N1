USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novosAlugueis`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novosAlugueis`(lista VARCHAR(255),
vHospedagem VARCHAR(10), vDataInicio DATE,
vDias INTEGER, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vClienteNome VARCHAR(150);
	DECLARE fimCursor INTEGER DEFAULT 0;
    DECLARE vNome VARCHAR(255);
    DECLARE cursor1 CURSOR FOR SELECT nome FROM temp_nomes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;
    DROP TEMPORARY TABLE IF EXISTS temp_nomes; 
    CREATE TEMPORARY TABLE temp_nomes (nome VARCHAR(255));
    CALL inclui_usuarios_lista(lista);
    OPEN cursor1;
    FETCH cursor1 INTO vNome;
    WHILE fimCursor = 1 DO
        SET vClienteNome = vNome;
        CALL novo_aluguel_44 (vClienteNome, vHospedagem, vDataInicio, vDias, vPrecoUnitario);
        FETCH cursor1 INTO vNome;
    END WHILE;
    CLOSE cursor1;
    DROP TEMPORARY TABLE IF EXISTS temp_nomes;
END$$

DELIMITER ;
;

CALL novosAlugueis('Gabriel Carvalho,ErickOliveira,Catarina Correia,Lorena Jesus','8635','2023-06-03',7,45);