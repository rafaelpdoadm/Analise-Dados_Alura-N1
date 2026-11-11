# conhecendo a db 
import pandas as pd
url = 'https://raw.githubusercontent.com/alura-cursos/estatistica-r-frequencias-medidas/refs/heads/main/dados/vendas_ecommerce.csv'
df = pd.read_csv(url)
df.head()
df.shape
df.info()

# realizando as primeiras análises na db
df['categoria_produto'].unique()
df['categoria_produto'].value_counts()

produtos = df['categoria_produto'].value_counts().reset_index()

import matplotlib.pyplot as plt

plt.barh(produtos['categoria_produto'], produtos['count'])
plt.show()
# eletronicos é a categoria que mais possui vendas

# explorando outras informações na db
df['avaliacao'].unique()
sorted(df['avaliacao'].unique())

df['avaliacao indicador'] = pd.Categorical(
    df['avaliacao'],
    categories =[1, 2, 3, 4, 5],
    ordered=True
)
avaliacao_labels = {1: 'Péssimo', 2: 'Ruim', 3: 'Regular', 4: 'Bom', 5: 'Ótimo'}
df['avaliacao indicador'] = df['avaliacao indicador'].map(avaliacao_labels)

df_unico = df[['avaliacao' , 'avaliacao indicador']].drop_duplicates()
df_unico

# diferenciando dados discretos e contínuos
df['quantidade'].unique()
print(f"Vendemos de {min(df['quantidade'])} até {max(df['quantidade'])} unidades de produto por registro")

df['total_compra'].unique()
print(f"Tivemos vendas a partir de R$ {min(df['total_compra']):,.2f} até R$ {max(df['total_compra']):,.2f}")

# a primeira demanda a ser respondida é a seguinte:
# A empresa quer acompanhas as avaliações dos clientes sobre seus produtos a fim de priorizar ações como melhorar produtos com maior proporção de feedbacks negativos,
# investigar causas e explorar pontos fortes apontados pelos clientes satisfeitos. Essas avaliações variam entre: 1-péssimo, 2- ruim, 3- regular, 4- bom e 5- ótimo.
# como a equipe de merketing e vendas poderá investigar a percepção geral dos clientes sobre os produtos e identificar possíveis comportamentos para ajustar
# suas estratégias de comunicação e melhoria de produtos?
# respondendo por meio de distribuição de frequencias
freq_avaliacoes = (df.groupby('avaliacao indicador', observed=False)
                  .size()
                  .reset_index(name='freq_absoluta')
                  .sort_values(by='avaliacao indicador', ascending=False))
freq_avaliacoes

# respondendo por meio de frequencias relativas
freq_avaliacoes['freq_relativa'] = round((freq_avaliacoes['freq_absoluta'] / freq_avaliacoes['freq_absoluta'].sum()) * 100, 1)
freq_avaliacoes

# construindo gráficos para realizar uma análise mais completa
freq_avaliacoes.columns = ['Avaliação', 'Quantidade', 'Porcentagem (%)']

import seaborn as sns

plt.figure(figsize=(10, 6))
sns.barplot(data=freq_avaliacoes, x='Avaliação', y='Quantidade')
# titulo e rótulo aos eixos
plt.title("Distribuição de frequências das Avaliações")
plt.xlabel("Avaliação")
plt.ylabel("Frequência")
# adicionando os rótulos com valores de frequência e porcentagem
for index, row in freq_avaliacoes.iterrows():
  plt.text(index, row['Quantidade'] + 0.1, f"{row['Quantidade']} ({row['Porcentagem (%)']:.1f}%)",
           ha='center', va='bottom', fontsize=12)

plt.show()

# agora é pedido para extender a análise de avaliação dos clientes para as regiões do país
tab_avaliacoes_regiao = pd.crosstab(df['avaliacao indicador'], df['regiao_cliente'])
tab_avaliacoes_regiao

tab_avaliacoes_regiao_relativa = pd.crosstab(df['avaliacao indicador'], df['regiao_cliente'], normalize = 'columns') * 100
tab_avaliacoes_regiao_relativa = round(tab_avaliacoes_regiao_relativa, 1)
tab_avaliacoes_regiao_relativa

# qual região possui mais avaliações positivas? (considerando apenas "ótimo" e "bom")
tab_avaliacoes_filtrada = tab_avaliacoes_regiao_relativa[tab_avaliacoes_regiao_relativa.index.isin(['Ótimo', 'Bom'])]
resultado = tab_avaliacoes_filtrada.sum()
resultado

# qual região concentra a maior parte das avaliações negativas?
tab_avaliacoes_filtrada = tab_avaliacoes_regiao_relativa[tab_avaliacoes_regiao_relativa.index.isin(['Ruim', 'Péssimo'])]
resultado = tab_avaliacoes_filtrada.sum()
resultado

# cruzando dados dos clientes
# é solicitado essa identificação para que melhores propagandas de marketing e comercial sejam feitas
# será necessário identificar o ticket médio por sexo e a região residida
ticket_medio = round(pd.crosstab(df['sexo_biologico'], df['regiao_cliente'], values=df['total_compra'], aggfunc='mean'), 2)
ticket_medio

# quarta demanda:
# uma das formas de melhorar a experiência do cliente é por meio da redução do tempo de entrega.
# com isso, teremos que calcula a média de tempo de entrega de cada produto, com base no histórico que possuimos.
# com isso poderemos entender quais produtos demoram mais para serem entregues e podemos tomar ações para evitar problemas nas entregas

media_entrega = df.tempo_entrega.mean()
media_entrega # média de tempo de entrega de todos os produtos

media_entrega_cat = df.groupby('categoria_produto')['tempo_entrega'].mean().reset_index().round(1)
media_entrega_cat

media_entrega_cat.columns = ['categoria_produto', 'media_tempo']
media_entrega_cat = media_entrega_cat.sort_values(by='media_tempo', ascending=False)
media_entrega_cat

# criando o gráfico de barras com o seaborn
plt.figure(figsize=(8, 6))
sns.barplot(data=media_entrega_cat, x='media_tempo', y='categoria_produto')
plt.axvline(media_entrega, color='red')
plt.xlabel=('Tempo de Entrega')
pltylabel=('Categoria de Produto')
plt.show()

# quinta demanda:
# investigar o comportamento dos consumidores na região nordeste, devido ao crescimento significativo nas vendas de eletrônicos
dados_nordeste = df[(df['regiao_cliente'] == 'Nordeste') & (df['categoria_produto'] == 'Eletrônicos')]
dados_nordeste = dados_nordeste.sort_values('total_compra')
dados_nordeste

n = len(dados_nordeste)
n

# calculando o elemento mediano
elemento_md = int(n / 2)
elemento_md

# calculando a mediana
round((dados_nordeste['total_compra'].iloc[elemento_md - 1] + dados_nordeste['total_compra'].iloc[elemento_md]) / 2,2)

# outra forma de calcular a mediana
dados_nordeste.total_compra.median()

# plotando um gráfico de histograma para avaliar a distribuição das frequências
sns.histplot(dados_nordeste.total_compra, bins=30)
plt.show()

# sexta demanda:
# para uma campanha de compre x leve y produtos, precisamos identificar os livros mais comprados (moda) pelos clientes
df['regiao_cliente'].value_counts()
dados_filtrados = df[df['categoria_produto'] == 'Livros']
dados_filtrados.head()

moda = dados_filtrados.quantidade.mode()
moda

# sétima demanda: 
# entendendo a relação entre a nota 5 (Ótimo) e o provável baixo tempo de entrega
# para essa resolução serão utilizados os conceitos de média, mediana e moda
sns.histplot(bins=21, data=df, x='tempo_entrega', kde=True, kde_kws={'bw_adjust':2})
plt.show()

tempo_entrega_resumo = {
    'media': df['tempo_entrega'].mean(),
    'mediana': df['tempo_entrega'].median(),
    'moda': df['tempo_entrega'].mode()[0]
}
tempo_entrega_resumo

dados_nota_5= df[df['avaliacao'] == 5]
dados_nota_5.head()

sns.histplot(bins=21, data=dados_nota_5, x='tempo_entrega', kde=True, kde_kws={'bw_adjust':2})
plt.show()

resumo = {
    'media': dados_nota_5['tempo_entrega'].mean(),
    'mediana': dados_nota_5['tempo_entrega'].median(),
    'moda': dados_nota_5['tempo_entrega'].mode()[0]
}

# continuando as aulas, agora será explorada outra db
url = 'https://raw.githubusercontent.com/alura-cursos/Estatisticas-Python-frequencias-medidas/refs/heads/main/dados/colaboradores.csv'
colaboradores = pd.read_csv(url)

# a partir disso, temos a oitava demanda a ser resolvida
# precisamos agora investigara distribuição dos salários dos colaboradores e identificar as faixas salariais de cada um deles.
# precisamos verificar também a concentração em determinados intervalos de salário.
# devemos então criar uma distribuição de frequências com base em classes de salários
n = len(colaboradores)
n

import math

k = 1 + (10/3) * math.log10(n)
k

k = int(k)
k
# com os códigos acima, chegou-se a conclusão de que serão necessárias 14 faixas salariais para responder a demanda.
# com isso, iniciamos a criação das faixas para alocar cada funcionário em sua respectiva
faixas = colaboradores.copy()
faixas

faixas['faixa_salarial'] = pd.cut(faixas['remuneracao'], bins = int(k), include_lowest = True)
faixas

# com as faixas salariais feitas, será construida agora a distribuição de frequências para a demanda
tabela_frequencias = faixas.groupby('faixa_salarial', observed = False).size().reset_index(name='frequencia')
tabela_frequencias['porcentagem'] = (tabela_frequencias['frequencia'] / len(colaboradores)) * 100
tabela_frequencias

# construindo o histograma
plt.figure(figsize=(15, 6))
sns.histplot(data=faixas, x='remuneracao')
plt.show()

sns.histplot(bins = int(k), data = colaboradores, x = 'remuneracao', kde = True)
plt.show()

# nona demanda:
# devemos buscar entender agora a distribuição de salários dentro das faixas específicas
# há um interesse em identificar faixas salariais e entender a remuneração das pessoas coordenadoras e se estão dentro dos 99% maiores salários da Empresa
# para essa demanda, será utilizada a lógica de medidas separatrizes (quartis, decis e percentis)
quartis = {
    'Q1' : colaboradores['remuneracao'].quantile(0.25),
    'Q2' : colaboradores['remuneracao'].quantile(0.50),
    'Q3' : colaboradores['remuneracao'].quantile(0.75),
}
quartis

# visualizando os quartis no histograma
plt.figure(figsize=(15, 6))
sns.histplot(binwidth = 500, data = colaboradores, x = 'remuneracao')
plt.axvline(quartis['Q1'], color = 'red', linestyle = 'dashed')
plt.axvline(quartis['Q2'], color = 'red', linestyle = 'dashed')
plt.axvline(quartis['Q3'], color = 'red', linestyle = 'dashed')
plt.show()

# realizando a análise específica solicitada para o cargo de coordenador
percentil_99 = colaboradores['remuneracao'].quantile(0.99)
percentil_99

coordenadores = colaboradores[colaboradores['cargo'] == 'Coordenador(a)']
num_coordenadores = len(coordenadores)
num_coordenadores

coordenadores_alta_remuneracao = colaboradores[(colaboradores['cargo'] == 'Coordenador(a)') & (colaboradores['remuneracao'] > percentil_99)]
num_coordenadores_alta_remuneracao = len(coordenadores_alta_remuneracao)
num_coordenadores_alta_remuneracao
# comprovação que as pessoas coordenadoras estão dentro dos 99% maiores salários da Empresa

# décima demanda:
# devemos investigar agora o grupo dos 20% colaboradores mais jovens da empresa
plt.figure(figsize=(15, 6))
sns.histplot(data = colaboradores, x = 'idade', bins = 10, cumulative = True, stat = 'proportion', kde = True)
plt.axhline(0.20, color = 'red', linestyle = 'dashed')
plt.show()

idades_classificacao = colaboradores.copy()
idades_classificacao.head()

idades_classificacao = idades_classificacao.sort_values(by = 'idade')
idades_classificacao['cumulativo'] = (idades_classificacao.reset_index().index + 1) / len(idades_classificacao)
idades_classificacao['qualificado'] = idades_classificacao['cumulativo'] <= 0.20
idades_classificacao

idades_qualificados = idades_classificacao[idades_classificacao['qualificado'] == True]
idades_qualificados

len(idades_qualificados)

# décima primeira demanda:
# devemos realizar uma análise de remuneração dos colaboradores por sexo
plt.figure(figsize=(8, 6))
sns.boxplot(x=colaboradores['remuneracao'], color = 'steelblue')
plt.title('Boxplot de Salários')
plt.xlabel('Salário(R$)')
plt.ylim(-1, 1)
plt.show()

colaboradores['remuneracao'].describe()

plt.figure(figsize=(8, 6))
ax = sns.boxplot(x='remuneracao', y = 'sexo_biologico', data = colaboradores, hue = 'sexo_biologico')
plt.title('Boxplot de Salários por Sexo')
plt.xlabel('Salário(R$)')
plt.ylabel('Sexo')
plt.show()

# melhorando a visualização para facilitar a análise
colaboradores_filtrados = colaboradores[colaboradores['remuneracao'] <= 10e3]
colaboradores_filtrados.head()

plt.figure(figsize=(8, 6))
ax = sns.boxplot(x = 'remuneracao', y = 'sexo_biologico', data = colaboradores_filtrados, hue = 'sexo_biologico')
plt.title('Boxplot de Salários por Sexo')
plt.xlabel('Salário(R$)')
plt.ylabel('Sexo')
plt.show()

# realizando estatísticas descritivas para cada grupo para facilitar ainda mais essa análise
estat_remuneracao = colaboradores.groupby('sexo_biologico')['remuneracao'].agg(
    Q1 = lambda x: x.quantile(0.25),
    mediana = 'median',
    media = 'mean',
    Q3 = lambda x: x.quantile(0.75),
    IIQ = lambda x: x.quantile(0.75) - x.quantile(0.25)
).reset_index()
estat_remuneracao

# décima segunda demanda:
# devemos investigar os salários do setor comercial, nos cargos de Inteligência comercial e Consultor(a) de vendas
comercial = colaboradores[colaboradores['cargo'].isin(['Inteligência comercial', 'Consultor(a) de vendas'])]
comercial

comercial.groupby('cargo')['remuneracao'].describe()[['mean', '50%']]

import numpy as np
np.random.seed(42)
amostra = comercial.sample(n=10)
amostra

plt.stem(amostra['remuneracao'], bottom = amostra['remuneracao'].mean())
plt.axhline(y = amostra['remuneracao'].mean(), color = 'red')
plt.show()

estat_colab = comercial.groupby('cargo')['remuneracao'].agg(
    media = 'mean',
    mediana = 'median',
    mad = lambda x: (abs(x - x.mean())).mean()
).reset_index()
estat_colab

plt.figure(figsize=(8, 6))
sns.boxplot(x = 'remuneracao', y = 'cargo', data = comercial)
plt.title('Distribuição de Salários por Cargo')
plt.xlabel('Salário(R$)')
plt.show()

# última demanda:
# investigar as diferenças salariais dos cargos de estoquista e repositor
# esses cargos representam o meio numero de funcionários da amostra
# vamos investigar as faixas salariais, determinar quais deles tem maior inconsistencia salarial e identificar desigualdades nas politicas salariais
operacional = colaboradores[colaboradores['cargo'].isin(['Estoquista', 'Repositor(a)'])]
operacional 

operacional.groupby('cargo')['remuneracao'].describe()[['mean', '50%']]

estatisticas_operacional = operacional.groupby('cargo')['remuneracao'].agg(
    media = 'mean',
    mediana = 'median',
    variancia = 'var',
).reset_index()
estatisticas_operacional

estatisticas_operacional = operacional.groupby('cargo')['remuneracao'].agg(
    media = 'mean',
    mediana = 'median',
    variancia = 'var',
    desvio_padrao = 'std',
    mad = lambda x: (abs(x - x.mean())).mean()
).reset_index()
estatisticas_operacional

plt.figure(figsize=(8, 6))
sns.violinplot(x='remuneracao', y='cargo', data=operacional)
plt.title('Distribuição de Salários por Cargo')
plt.xlabel('Salário(R$)')
plt.show()
