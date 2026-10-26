-- ao fazer esse select, percebemos que possuem dois endereços iguais, mas são de pessoas diferentes --
SELECT *
FROM colaboradores
WHERE rua = 'Rua das flores - 210';

-- a funcao union all serve para justamente ter todas as informações, inclusive as repetidas --
SELECT rua, bairro, cidade, estado, cep
FROM colaboradores
UNION ALL
SELECT rua, bairro, cidade, estado, cep
FROM fornecedores;

-- agora, como saber a qual pessoa é o respectivo endereço --
SELECT nome, rua, bairro, cidade, estado, cep
FROM colaboradores
UNION ALL
SELECT nome, rua, bairro, cidade, estado, cep
FROM fornecedores;

-- qual foi o primeiro cliente a fazer pedido? --
SELECT idcliente
FROM pedidos 
WHERE datahorapedido = '2023-01-02 08:15:00';

-- como saber de forma rápida quem é o ID 10 (subconsultas) --
SELECT nome, telefone
FROM clientes
WHERE id = (
  SELECT idcliente
  FROM pedidos 
  WHERE datahorapedido = '2023-01-02 08:15:00');

-- agora o objetivo é retornar todos os pedidos realizados em um determinado mes --
SELECT idcliente
FROM pedidos
WHERE strftime('%m', datahorapedido) = '01';

-- segunda parte que é trazer os nomes dos clientes --
SELECT nome
FROM clientes
WHERE id = (
  SELECT idcliente
  FROM pedidos
  WHERE strftime('%m', datahorapedido) = '01');
   
-- ele retornou na query acima apenas o primeiro resultando, sendo necessario assim a utilizacao do comando IN --
SELECT nome
FROM clientes
WHERE id IN (
  SELECT idcliente
  FROM pedidos
  WHERE strftime('%m', datahorapedido) = '01');
  
-- agora devemos buscar informacoes da tabela de produtos, uma vez que buscamos a media de precos dos produtos --
SELECT AVG(preco)
FROM produtos;

-- agora realizaremos um filtro para termos todos os produtos com valores maiores do que a media de precos --
SELECT nome, preco
FROM produtos
GROUP BY nome, preco
HAVING preco > (
  SELECT AVG(preco)
  FROM produtos);