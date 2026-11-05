# conhecendo a base de dados a ser tratada
import pandas as pd
dados = pd.read_json('/content/dados_hospedagem.json')
dados.head()

dados = pd.json_normalize(dados['info_moveis'])
dados

colunas = list(dados.columns)
colunas

# utilizando o método explode apenas nas colunas necessárias para a atividade
dados = dados.explode(colunas[3:])
dados

dados.reset_index(inplace=True, drop=True)

# explorando e compreendendo a db
dados.info()

import numpy as np

dados['max_hospedes'] = dados['max_hospedes'].astype(np.int64)

col_numericas = ['quantidade_banheiros', 'quantidade_quartos', 'quantidade_camas']
dados[col_numericas] = dados[col_numericas].astype(np.int64)

dados['avaliacao_geral'] = dados['avaliacao_geral'].astype(np.float64)

# tratando as colunas que são monetárias
dados['preco'] = dados['preco'].apply(lambda x: x.replace('$', '').replace(',', '').strip())

dados['preco'] = dados['preco'].astype(np.float64)

dados[['taxa_deposito', 'taxa_limpeza']] = dados[['taxa_deposito', 'taxa_limpeza']].applymap(lambda x: x.replace('$', '').replace(',', '').strip())

dados[['taxa_deposito', 'taxa_limpeza']] = dados[['taxa_deposito', 'taxa_limpeza']].astype(np.float64)

# realizando correção textual da db
dados['descricao_local'] = dados['descricao_local'].str.lower()

# removendo caracteres especiais com regex
dados['descricao_local'] = dados['descricao_local'].str.replace('[^a-zA-Z0-9\-\']',' ', regex=True)

# removendo os hífens que não fazem parte de palavras compostas em inglês
dados['descricao_local'] = dados['descricao_local'].str.replace('(?<!\w)-(?!\w)',' ', regex=True)

# realizando a tokenização de strings
dados['descricao_local'] = dados['descricao_local'].str.split()

dados['comodidades'] = dados['comodidades'].str.replace('\{|}|\"', '', regex=True)
dados['comodidades'] = dados['comodidades'].str.split(',')

# tratando a outra db de móveis disponíveis para locação
dt_data = pd.read_json('/content/moveis_disponiveis.json')
dt_data

# transformando a coluna 'data' para datetime
dt_data['data'] = pd.to_datetime(dt_data['data'])

# realizando a manipulação de dados temporais
dt_data['data'].dt.strftime('%Y-%m')

subset = dt_data.groupby(dt_data['data'].dt.strftime('%Y-%m'))['vaga_disponivel'].sum()
subset