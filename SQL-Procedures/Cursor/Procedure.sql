--- criação da procedure que coleta os nomes das pessoas a partir de uma lista e utiliza a virgula como ponto de identificação de início e final de um nome

CREATE PROCEDURE `inclui_usuarios_lista` (lista VARCHAR(255))
BEGIN
	DECLARE nome VARCHAR (255);
    DECLARE restante VARCHAR (255);
    DECLARE pos INTEGER;
    SET restante = lista;
    WHILE INSTR(restante,',') > 0 DO
		SET pos = INSTR(restante,',');
		SET nome = LEFT(restante, pos - 1);
        INSERT INTO temp_nomes VALUES (nome);
        SET restante = SUBSTRING(restante, pos + 1);
    END WHILE;
    IF TRIM(RESTANTE) <> '' THEN
		INSERT INTO temp_nomes VALUES (TRIM(restante));
	END IF;
END

--- após isso foi realizado o teste para a verificação se está correta

DROP TEMPORARY TABLE IF EXISTS temp_nomes;

CREATE TEMPORARY TABLE temp_nomes (nome VARCHAR(255));
CALL inclui_usuarios_lista('Luana Moura,Enrico Correia,Paulo Vieira,Marina Nunes');

SELECT *
FROM temp_nomes;