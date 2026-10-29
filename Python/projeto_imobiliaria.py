# conhecendo a base de dados e realizando o import
import pandas as pd

url = 'https://raw.githubusercontent.com/alura-cursos/pandas-conhecendo-a-biblioteca/main/base-de-dados/aluguel.csv'
pd.read_csv(url)

dados = pd.read_csv(url, sep=';')
dados

dados.info()

# buscando entender os valores medios de aluguel por tipo de imóvel
# foi utilizada a funcao groupby para agrupar os tipos de imóvel, a mean para obter a média e a funcao numeric_only para que no calculo da média sejam considerados apenas valores 
# numericos, evitando assim erros caso valores diferentes estejam presentes.
dados.groupby('Tipo').mean(numeric_only=True)

# nesse caso, utilizar a funcao valor é mais interessante, pois selecionamos uma coluna especifica com apenas valores
# sendo assim, não há necessidade de utilizarmos o numecic_only
dados.groupby('Tipo')['Valor'].mean()

# para facilitas as análises, transformou-se os valores em um data frame ordenado
dados.groupby('Tipo')[['Valor']].mean(numeric_only=True).sort_values('Valor')

# plotando o gráfico para fazermos as primeiras análises
df_preco_tipo = dados.groupby('Tipo')[['Valor']].mean().sort_values('Valor')
df_preco_tipo.plot(kind='barh', figsize=(14,10), color='purple');

# após o gráfico acima, notou-se que há muitos imóveis comerciais na base de dados.
# sendo assim, buscamos entender o tipo de imóvel e posteriormente retirar ele da base dados, por conta da distorção provocada
dados.Tipo.unique

# identificadas as listas dos imóveis comerciais
imoveis_comerciais = ['Conjunto Comercial/Sala',
                      'Prédio Inteiro', 'Loja/Salão'
                      'Galpão/Depósito/Armazém', 
                      'Casa Comercial', 'Terreno Padrão',
                      'Loja Shopping/ Ct Comercial',
                      'Box/Garagem', 'Chácara',
                      'Loteamento/Condomínio', 'Sítio',
                      'Pousada/Chalé', 'Hotel', 'Indústria']

# foi feita a retirada desses dados da tabela para que possamos analizar apenas os residenciais
# depois foi separada a função df para armazenas as informações que buscamos para trabalhar
dados.query('@imoveis_comerciais not in Tipo')
df = dados.query('@imoveis_comerciais not in Tipo')

# com isso, foi montado o mesmo gráfica acima, mas contendo apenas as informações que buscamos analisar
df_preco_tipo = df.groupby('Tipo')[['Valor']].mean().sort_values('Valor')
df_preco_tipo.plot(kind='barh', figsize=(14,10), color ='purple')

# finalizada a análise anterior, surgiu o questionamento sobre o percentual de cada tipo de imóvel presente na base de dados
df.Tipo.value_counts(normalize=True).to_frame().sort_values('Tipo')

# organizando em uma variável para facilitar a criação do gráfico
df_percentual_tipo = df.Tipo.value_counts(normalize=True).to_frame().sort_values('Tipo')

# plotando o gráfico para a análise
df_percentual_tipo.plot(kind='bar', figsize=(14,10), color='green', xlabel= 'Tipos', ylabel = 'Percentual')

# a partir da análise de que quase 80% dos dados são pertencentes ao tipo 'apartamento' das opções de aluguel, surge o seguinte questionamento.
# será que ainda é interessante manter esse dado para a análise, uma vez que ele distorce bastante e representa quase a totalidade dos valores disponíveis?
# com isso, aloquei os dados do tipo 'Apartamento' em uma variável que será utilizada posteriormente
df = df.query('Tipo == "Apartamento"')

# após isso, foi necessária a verificação da presença de dados nulos
df.isnull()
# verificação das quantidades de dados nulos na tabela
df.isnull().sum()
# para esse caso, foi realizada a substituição dos dados nulos por zero, apesar dessa atitude não ser a ideal
df = df.fillna(0)

# com isso, iniciei o tratamento de todos os dados nulos
df.query('Valor == 0 | Condominio == 0')

# removendo os índices = 0
df.query('Valor == 0 | Condominio == 0').index
registros_remover = df.query('Valor == 0 | Condominio == 0').index
df.drop(registros_remover, axis=0, inplace=True)

# com isso, parti para a análise de se não existe mais nada na base de dados que possa ser removido
# após a primeira consulta, fiz a remoção da coluna 'Tipo', uma vez que haviam apenas apartamentos listados nela
df.head()
df.Tipo.unique()
df.drop('Tipo', axis=1, inplace=True)

