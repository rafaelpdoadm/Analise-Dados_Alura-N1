-- funcao para calcular desconto baseado no numero de dias que o cliente ficou hospedado
 -- menos de 4 dias = 0% desconto
 -- 4 a 6 dias = 5% desconto
 -- 7 a 9 dias = 10% desconto
 -- 10 ou mais dias = 15% desconto

-- teste para verificar se a consulta ira funcionar
SELECT cliente_id, data_inicio, data_fim, DATEDIFF(data_fim, data_inicio) AS TotalDias,
	CASE
		WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 4 AND 6 THEN 5
		WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 7 AND 9 THEN 10
		WHEN DATEDIFF(data_fim, data_inicio) >= 10 THEN 15
		ELSE 0
	END AS Desconto_Percentual
FROM alugueis;

-- criacao da funcao para agilizar essa rotina
DELIMITER $$
CREATE FUNCTION CalcularDescontoPorDias(AluguelID INT)
RETURNS INT DETERMINISTIC
BEGIN

DECLARE desconto INT;

SELECT
	CASE
		WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 4 AND 6 THEN 5
		WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 7 AND 9 THEN 10
		WHEN DATEDIFF(data_fim, data_inicio) >= 10 THEN 15
		ELSE 0
	END
    INTO desconto
FROM alugueis
WHERE aluguel_id = AluguelID;

RETURN desconto;

END $$

DELIMITER ;

-- teste para checar se está funcionando corretamente
SELECT CalcularDescontoPorDias(1);

-- sera necessaria agora a criacao de uma nova funcao para obtermos o valor total que o cliente deve pagar, seguindo a funcao de desconto construida anteriormente
DELIMITER $$
CREATE FUNCTION CalcularValorFinalcomDesconto(AluguelID INT)
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN

DECLARE ValorTotal DECIMAL(10,2);
DECLARE desconto INT;
DECLARE ValorFinal DECIMAL (10,2);

SELECT preco_total 
INTO ValorTotal
FROM alugueis
WHERE aluguel_id = AluguelID;

SET desconto = CalcularDescontoPorDias(AluguelID);

SET ValorFinal = ValorTotal - (ValorTotal * desconto / 100);

RETURN ValorFinal;

END$$

DELIMITER ;

-- teste para validacao da funcao criada
SELECT CalcularValorFinalcomDesconto(1);

-- criacao de tabela para facilitar a identificacao das informacoes e valores a serem pagos por cada cliente
CREATE TABLE resumo_aluguel (
	aluguel_id VARCHAR(255),
    cliente_id VARCHAR(255),
    valor_total DECIMAL(10,2),
    desconto_aplicado DECIMAL (10,2),
    valor_final DECIMAL (10,2),
    PRIMARY KEY (aluguel_id, cliente_id),
    FOREIGN KEY (aluguel_id) REFERENCES alugueis(aluguel_id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

-- criando a trigger para alocar os valores na tabela de forma automatica
DELIMITER $$

CREATE TRIGGER AtualizarResumoAluguel
AFTER INSERT ON alugueis
FOR EACH ROW 
BEGIN

DECLARE desconto INT;
DECLARE ValorFinal DECIMAL(10,2);

SET desconto = CalcularDescontoPorDias(NEW.aluguel_id);
SET ValorFinal = CalcularValorFinalcomDesconto(NEW.aluguel_id);

INSERT INTO resumo_aluguel(aluguel_id, cliente_id, valor_total, desconto_aplicado, valor_final)
VALUES (NEW.aluguel_id, NEW.cliente_id, NEW.preco_total, Desconto, ValorFinal);

END $$

DELIMITER ;

-- ativando a trigger para adicional valores na tabela
INSERT INTO alugueis (aluguel_id, cliente_id, hospedagem_id, data_inicio, data_fim, preco_total)
VALUES (10001, 42, 15, '2024-01-01', '2024-01-08', 3000.00);