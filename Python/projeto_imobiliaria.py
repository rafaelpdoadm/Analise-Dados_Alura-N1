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

# a partir disso, foi necessária a seguinte análise:
# apartamentos que possuem 1 quarto e aluguel menor do que R$ 1200
# apartamentos que possuem pelo menos 2 quartos, aluguel menor do que R$ 3000 e área maior do que 70m²
df['Quartos'] == 1
selecao1=df['Quartos']==1
df[selecao1]

selecao2 = df['Valor'] < 1200
df[selecao2]

selecao_final = (selecao1) & (selecao2)
df[selecao_final]

# apartamentos que possuem pelo menos 2 quartos, aluguel menor do que R$ 3000 e área maior do que 70m²
selecao =(df['Quartos'] >= 2) & (df['Valor'] < 3000) & (df['Area'] >70)
df[selecao]

# após todas as análises, transformei os dados para um arquivo .csv
df.to_csv('dados_apartamentos.csv')
# conferindo se tudo deu certo
pd.read_csv('dados_apartamentos.csv')
# tirando colunas indesejadas e ajustando o separador dos dados
df.to_csv('dados_apartamentos.csv', index=False)
df.to_csv('dados_apartamentos.csv', index=False, sep=';')

# após as etapas anteriores se fez necessária a criação de colunas numéricas
# 1- deve contar os gastos mensais de cada imóvel, incluindo aluguel e condomínio
# 2- deve conter os gastos anuais por imóvel, ou seja, IPTU mais 12 meses de aluguel e condomínio
url = 'https://raw.githubusercontent.com/alura-cursos/pandas-conhecendo-a-biblioteca/main/base-de-dados/aluguel.csv'
dados = pd.read_csv(url, sep=';')
dados.head()

dados['Valor_mes'] = dados['Valor'] + dados['Condominio']
dados.head()

dados['Valor_ano'] = dados['Valor_mes'] * 12+ dados['IPTU']
dados.head()

# por fim, se fez necessária a criação de colunas categóricas
# descrição: a coluna deve possuir uma sumarização das principais informações dos imóveis que serão apresentadas no site: tipo de imóvel, bairro, quantidade de quartos e vagas de garagem
# possui_suite: essa deve ser uma coluna que informe apenas se o imóvel possui ou não suites, sem se importar com a quantidade
dados['Descricao'] = dados['Tipo'] + ' em ' + dados['Bairro'] + ' com ' + dados['Quartos'].astype(str) + ' quarto(s) ' + ' e ' + dados['Vagas'].astype(str) + ' vaga(s) de garagem.'
dados.head()

dados['Possui_suite'] = dados['Suites'].apply(lambda x: "Sim" if x > 0 else "Não")
dados.head()

dados.to_csv('dados_completos.csv', index=False, sep=';')