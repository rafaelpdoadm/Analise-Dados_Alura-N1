# iniciamos apenas lendo o início da tabela para entendermos o db
import pandas as pd
dados_churn = pd.read_json("/content/dataset-telecon.json")
dados_churn.head()
dados_churn['conta'][0]

# fazendo a normalização da db para podermos padronizar os dados e iniciarmos os trabalhos
import json
with open("dataset-telecon.json") as f:
  json_bruto = json.load(f)

dados_normalizados = pd.json_normalize(json_bruto)
dados_normalizados.head()

# explorando os dados
dados_normalizados.info()

# convertendo a string para float por conta de ser valores monetários
dados_normalizados['conta.cobranca.Total'] = dados_normalizados['conta.cobranca.Total'].astype(float)

# foi recebido um erro e com isso necessário analisar de perto os dados da coluna para entender o motivo do erro
dados_normalizados[dados_normalizados['conta.cobranca.Total'] == ' '].head()

dados_normalizados[dados_normalizados['conta.cobranca.Total'] == ' '][
    ['cliente.tempo_servico', 'conta.contrato', 'conta.cobranca.mensal', 'conta.cobranca.Total']
]

idx = dados_normalizados[dados_normalizados['conta.cobranca.Total'] == ' '].index

dados_normalizados.loc[idx, 'conta.cobranca.Total'] = dados_normalizados.loc[idx, 'conta.cobranca.mensal'] * 24

dados_normalizados.loc[idx, 'cliente.tempo_servico'] = 24

# verificando se os ajustes realizados acima foram feitos de forma correta
dados_normalizados.loc[idx, ['cliente.tempo_servico', 'conta.contrato', 'conta.cobranca.mensal', 'conta.cobranca.Total']]

# repetindo o código anterior transformando a coluna em valores
dados_normalizados['conta.cobranca.Total'] = dados_normalizados['conta.cobranca.Total'].astype(float)

# agora será realizado a identificação e tratamento das strings vazias
for col in dados_normalizados.columns:
  print(f"Coluna: {col}")
  print(dados_normalizados[col].unique())
  print("-" * 30)

dados_normalizados.query("Churn == ''")

dados_normalizados[dados_normalizados['Churn'] != '']

dados_sem_vazio = dados_normalizados[dados_normalizados['Churn'] != ''].copy()

dados_sem_vazio.reset_index(drop=True, inplace=True)

# identificando e trabalhando com dados duplicados
dados_sem_vazio.duplicated()

# utilizando o sum para entender qual a quantidade de amostras duplicadas
dados_sem_vazio.duplicated().sum()

filtro_duplicadas = dados_sem_vazio.duplicated()
dados_sem_vazio[filtro_duplicadas]

# removendo as amostras duplicadas
dados_sem_vazio.drop_duplicates(inplace=True)

dados_sem_vazio.duplicated().sum()

# identificando e tratando dados nulos
dados_sem_vazio.isna()

# realizando o somatório dos dados nulos para identificar as colunas em que estão localizados
dados_sem_vazio.isna().sum()

# realizado para identificar o total do db
dados_sem_vazio.isna().sum().sum()

# coletando as colunas que possuem ao menos um valor nulo
dados_sem_vazio[dados_sem_vazio.isna().any(axis=1)]

# preenchendo os nulos com algum valor evitando perdermos informações
filtro = dados_sem_vazio['cliente.tempo_servico'].isna()
dados_sem_vazio[filtro]
dados_sem_vazio[filtro][['cliente.tempo_servico', 'conta.cobranca.mensal', 'conta.cobranca.Total']]

# iniciando a resolução dos valores nulos na coluna específica
import numpy as np

dados_sem_vazio['cliente.tempo_servico'].fillna(
    np.ceil(
        dados_sem_vazio['conta.cobranca.Total'] / dados_sem_vazio['conta.cobranca.mensal']
    ), inplace=True
)

# conferindo se o código deu certo
dados_sem_vazio[filtro][['cliente.tempo_servico', 'conta.cobranca.mensal', 'conta.cobranca.Total']]

# removendo os demais valores nulos evitando distorções e deixar enviesado para futuras análises
dados_sem_vazio['conta.contrato'].value_counts()

colunas_dropar = ['conta.contrato', 'conta.faturamente_eletronico', 'conta.metodo_pagamento']

dados_sem_vazio[colunas_dropar].isna()

dados_sem_vazio[colunas_dropar].isna().any(axis=1).sum()

df_sem_nulo = dados_sem_vazio.dropna(subset=colunas_dropar).copy()

df_sem_nulo.reset_index(drop=True, inplace=True)

# conferindo se a remoção deu certo
df_sem_nulo.isna().sum()

# identificando outliers
df_sem_nulo.describe()

import seaborn as sns

sns.boxplot(x=df_sem_nulo['cliente.tempo_servico'])

Q1 = df_sem_nulo['cliente.tempo_servico'].quantile(.25)
Q3 = df_sem_nulo['cliente.tempo_servico'].quantile(.75)
IQR = Q3 - Q1
limite_inferior = Q1 - 1.5 * IQR
limite_superior = Q3 + 1.5 * IQR

# buscando agora os valores que são menores que o limite inferior OU maiores que o limite superior
outliers_index = (df_sem_nulo['cliente.tempo_servico'] < limite_inferior) | (df_sem_nulo['cliente.tempo_servico'] > limite_superior)

df_sem_nulo[outliers_index]['cliente.tempo_servico']

# tratando os outliers
df_sem_out = df_sem_nulo.copy()
df_sem_out[outliers_index]['cliente.tempo_servico']

df_sem_out.loc[outliers_index, 'cliente.tempo_servico'] = np.ceil(
    df_sem_out.loc[outliers_index, 'conta.cobranca.Total'] / df_sem_out.loc[outliers_index, 'conta.cobranca.mensal']
)

sns.boxplot(x=df_sem_out['cliente.tempo_servico'])

# ainda há valores causando distorção na db
df_sem_out[outliers_index][['cliente.tempo_servico', 'conta.cobranca.mensal', 'conta.cobranca.Total']]

# com isso, serão retiradas as amostras outliers por conta da distorção causada 
df_sem_out[outliers_index]['cliente.tempo_servico']

Q1 = df_sem_out['cliente.tempo_servico'].quantile(.25)
Q3 = df_sem_out['cliente.tempo_servico'].quantile(.75)
IQR = Q3 - Q1
limite_inferior = Q1 - 1.5 * IQR
limite_superior = Q3 + 1.5 * IQR

outliers_index = (df_sem_out['cliente.tempo_servico'] < limite_inferior) | (df_sem_out['cliente.tempo_servico'] > limite_superior)
outliers_index

df_sem_out = df_sem_out[~outliers_index]

# conferindo se deu certo os ajustes
sns.boxplot(x=df_sem_out['cliente.tempo_servico'])

df_sem_out.reset_index(drop=True, inplace=True)

# substituindo valores de variáveis categóricas
df_sem_id = df_sem_out.drop('id_cliente', axis=1).copy()

for col in df_sem_id.columns:
  print(f"Coluna: {col}")
  print(df_sem_id[col].unique())
  print("-" * 30)

colunas = ['telefone.servico_telefone', 'Churn', 'cliente.parceiro', 'cliente.dependentes', 'conta.faturamente_eletronico', 'cliente.genero']
df_sem_id[colunas] = df_sem_id[colunas].replace(mapeamento)
df_sem_id

df_dummies = pd.get_dummies(df_sem_id).copy()