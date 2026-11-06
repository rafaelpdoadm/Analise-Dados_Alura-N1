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

