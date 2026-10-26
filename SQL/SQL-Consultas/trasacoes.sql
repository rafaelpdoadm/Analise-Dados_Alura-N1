SELECT *
FROM produtos;

-- update de dados --
-- funcao especifica do sqlite pq ele nao valida chaves estrangeiras --
PRAGMA foreign_keys = ON;

SELECT *
FROM produtos
WHERE id = 31;

-- importante usar o where como filtro para alterar apenas o dado desejado, caso contrario, todos os itens da tabela teriam o preco 13 --
UPDATE produtos
SET preco = 13
WHERE id = 31;

-- utilizando uma busca especificada para update --
SELECT *
FROM produtos
WHERE nome LIKE 'croissant%';

-- update na descricao do croissant, ja que os dois estao repetidos --
UPDATE produtos
SET descricao = 'Croissant recheado com amêndoas.'
WHERE id = 28;

-- exclusao de colaborador que pediu demissao (tabela simples sem relacao com outras) --
SELECT *
FROM colaboradores
WHERE id = 3;

DELETE
FROM colaboradores
WHERE id = 3;

-- deletar dados de cliente (tabela com relacao a outras)--
SELECT *
FROM clientes
WHERE id = 27;

-- essa pratica depende de contexto, uma vez que em cascata ele deleta as informacoes relacionadas ao id deletado, havendo perda de outros dados importantes --
DELETE
FROM clientes
WHERE id = 27;

-- atualizar status dos pedidos já concluidos -- 
UPDATE pedidos 
SET status = 'Concluído'
;

-- transacoes & rollback --
-- esse comando gera uma tabela de testes para verificar o que ocorrera apos determinado comando --
BEGIN TRANSACTION;

-- apos o comando acima, caso nao de certo o teste realizado, deve-se utilizar o comando abaixo para tudo retornar ao estado anterior do inicio do teste --
ROLLBACK;

-- atualizar status dos pedidos já concluidos --
BEGIN TRANSACTION;
UPDATE pedidos 
SET status = 'Concluído'
WHERE status = 'Em Andamento';

-- verificando a atualizacao dos dados acima --
SELECT *
FROM pedidos;

-- como o teste deu certo, entao podemos oficializar o resultado --
COMMIT;