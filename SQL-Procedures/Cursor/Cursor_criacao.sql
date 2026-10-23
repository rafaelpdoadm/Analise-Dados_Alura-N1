--- Criação da procedure do cursor que irá passar por todos os nomes

CREATE DEFINER=`root`@`localhost` PROCEDURE `looping_cursor`()
BEGIN
	DECLARE fimCursor INTEGER DEFAULT 0;
    DECLARE vNome VARCHAR(255);
    DECLARE cursor1 CURSOR FOR SELECT nome FROM temp_nomes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;
    OPEN cursor1;
    FETCH cursor1 INTO vNome;
    WHILE fimCursor = 1 DO
        SELECT vNome;
        FETCH cursor1 INTO vNome;
    END WHILE;
    CLOSE cursor1;
END

--- teste do cursor

DROP TEMPORARY TABLE IF EXISTS temp_nomes;

CREATE TEMPORARY TABLE temp_nomes (nome VARCHAR(255));

CALL inclui_usuarios_lista('João,Pedro,Maria,Lucia,Joana,Beatriz');

SELECT *
FROM temp_nomes;

CALL looping_cursor();