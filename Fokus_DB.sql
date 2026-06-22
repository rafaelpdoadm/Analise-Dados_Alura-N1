--- abertura do database e inicio da escrita dos codigos solicitados para a resolucao dos exercicios propostos
--- o primeiro foi solicitado para 'identificar as cinco pessoas colaboradoras que possuem maiores remuneracoes'
SELECT *
FROM Colaboradores;

--- segundo select para identificacao de qual tabela possui a informacao de salarios buscadaColaboradores
SELECT * 
FROM HistoricoEmprego
ORDER BY salario DESC
LIMIT 5;

-- escrita de outro select adicionando um comando para retirada das datas, aceitando assim as pessaoas com o DataTermino = nullColaboradores
select * 
from HistoricoEmprego
where datatermino ISNULL
order by salario DESC
limit 5;

