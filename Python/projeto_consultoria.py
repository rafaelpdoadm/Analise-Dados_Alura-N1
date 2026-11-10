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

