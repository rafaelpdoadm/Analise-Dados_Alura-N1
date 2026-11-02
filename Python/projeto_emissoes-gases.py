# conhecendo a base de dados a ser utilizada no projeto
import pandas as pd
emissoes_gases = pd.read_excel('/1-SEEG10_GERAL-BR_UF_2022.10.27-FINAL-SITE.xlsx', sheet_name='GEE Estados')
emissoes_gases.info()

# foi solicitado para ser realizado um filtro na db para termos apenas os dados de emissões e que estão cadastrados no inventário nacional
# Segundo o site SEEG: https://seeg.eco.br/entenda-as-estimativas temos o seguinte direcionamento:
# Remoções são dados referentes à retirada dos gases estufa, que é o contrário da emissão.
# CNI são dados não contemplados no inventário nacional.
# Bunkers são emissões de transporte marítimo e aéreo internacional, portanto não são emissões diretas dos estados.
emissoes_gases['Emissão / Remoção / Bunker'].unique()
(emissoes_gases['Emissão / Remoção / Bunker'] == 'Remoção NCI') | (emissoes_gases['Emissão / Remoção / Bunker'] == 'Remoção')
emissoes_gases[emissoes_gases['Emissão / Remoção / Bunker'].isin(['Remoção NCI', 'Remoção'])]

# verificando se todos os dados são realmente relativos as remoções dos gases estufa da atmosfera
emissoes_gases.loc[emissoes_gases['Emissão / Remoção / Bunker'].isin(['Remoção NCI', 'Remoção']), 1970:2021]
emissoes_gases.loc[emissoes_gases['Emissão / Remoção / Bunker'].isin(['Remoção NCI', 'Remoção']), 1970:2021].max()

# confirmada a verificação anterior, partimos para outra análise
# identificar se algum valor do tipo Bunker corresponde a alguma emissão feita por algum estado
emissoes_gases.loc[emissoes_gases['Emissão / Remoção / Bunker'] == 'Bunker', 'Estado'].unique()

emissoes_gases = emissoes_gases[emissoes_gases['Emissão / Remoção / Bunker'] == 'Emissão']
emissoes_gases

# removendo os dados que não são mais necessários para a análise
emissoes_gases = emissoes_gases.drop(columns= 'Emissão / Remoção / Bunker')
emissoes_gases

# analisando as emissões por tipo de gás na base de dados, por meio de agrupamento de dados
emissoes_gases.loc[:,'Nível 1 - Setor':'Produto'].columns
colunas_info = list(emissoes_gases.loc[:,'Nível 1 - Setor':'Produto'].columns)
colunas_info

emissoes_gases.loc[:,1970:2021].columns
colunas_emissao = list(emissoes_gases.loc[:,1970:2021].columns)
colunas_emissao

emissoes_gases.melt(id_vars=colunas_info, value_vars=colunas_emissao, var_name = 'Ano', value_name='Emissão')

# com isso, iremos armazenar a tabela em uma nova variável para podermos utilizar nas análises
emissoes_por_ano = emissoes_gases.melt(id_vars=colunas_info, value_vars=colunas_emissao, var_name = 'Ano', value_name='Emissão')

# após isso, foi solicitada a informação de emissão total para cada tipo de gás
emissao_por_gas = emissoes_por_ano.groupby('Gás')[['Emissão']].sum().sort_values('Emissão', ascending = False)
emissao_por_gas

emissao_por_gas.plot(kind = 'barh', figsize = (10,6));

# analisando apenas o CO2 pelo fato dele ser o gás com mais tipos de emissão na tabela
emissao_por_gas.iloc[0:9]

print(f'A emissão de C0² corresponde a {float((emissao_por_gas.iloc[0:9].sum()/emissao_por_gas.sum()).iloc[0])* 100:.2f}% de emissão total de gases estufa do Brasil de 1970 a 2021.')

# finalizada a análise anterior, partimos para a análise do total de emissões de gases por setor
gas_por_setor = emissoes_por_ano.groupby(['Gás', 'Nível 1 - Setor'])[['Emissão']].sum()
gas_por_setor

# co2 apenas
gas_por_setor.xs('CO2 (t)', level = 0)

# analisando o setor de 'Mudança de Uso da Terra e Floresta' para emissões do CO2, uma vez que é o que registra mais emissões
gas_por_setor.xs(('CO2 (t)', 'Mudança de Uso da Terra e Floresta'), level = [0,1])
gas_por_setor.xs('CO2 (t)', level = 0).max(0)
gas_por_setor.xs('CO2 (t)', level = 0).idxmax(0)
gas_por_setor.groupby(level = 0).idxmax()
gas_por_setor.groupby(level = 0).max()

valores_max = gas_por_setor.groupby(level = 0).max().values
tabela_sumarizada = gas_por_setor.groupby(level = 0).idxmax()
tabela_sumarizada.insert(1, 'Quantidade de Emissão', valores_max)
tabela_sumarizada

gas_por_setor.swaplevel(0,1).groupby(level = 0).idxmax()

# finalizada a análise anterior, buscaremos agora se houve um crescimento ou não da emissão média ao longo dos anos
emissoes_por_ano.groupby('Ano')[['Emissão']].mean().plot(figsize=(10,6))

# ano em que houve a maior média de emissão
emissoes_por_ano.groupby('Ano')[['Emissão']].mean().idxmax()

emissoes_por_ano.groupby(['Ano', 'Gás'])[['Emissão']].mean()

media_emissao_anual = emissoes_por_ano.groupby(['Ano', 'Gás'])[['Emissão']].mean().reset_index()
media_emissao_anual

media_emissao_anual = media_emissao_anual.pivot_table(index = 'Ano', columns = 'Gás', values = 'Emissão')
media_emissao_anual

# construindo o gráfico de linhas para facilitar a análise
media_emissao_anual.plot(subplots = True, figsize = (10,40));

# calculando a emissão per capta de cada estado
populacao_estados = pd.read_excel('/content/POP2022_Municipios.xls', header = 1, skipfooter = 34)
populacao_estados

populacao_estados.groupby('UF').sum(numeric_only = True)

# ajustando a informação da população dos estados
populacao_estados[populacao_estados['POPULAÇÃO'].str.contains('\(', na = False)]

# foi necessário um tratamento dos dados populacionais
# a consulta acima nos mostrou que há numeros com parenteses na tabela
populacao_estados = populacao_estados.assign(populacao_sem_parenteses = populacao_estados['POPULAÇÃO'].replace('\(\d{1,2}\)', '', regex = True),
                                             populacao = lambda x: x.loc[:, 'populacao_sem_parenteses'].replace('\.', '', regex=True))
populacao_estados[populacao_estados['POPULAÇÃO'].str.contains('\(', na = False)]

populacao_estados = populacao_estados.astype({'populacao':'int64'})

populacao_estados = populacao_estados.groupby('UF')[['populacao']].sum().reset_index()
populacao_estados

# conseguimos gerar a métrica das emissoes por capta nos estados
emissao_estados = emissoes_por_ano[emissoes_por_ano['Ano'] == 2021].groupby('Estado')[['Emissão']].sum().reset_index()
emissao_estados

dados_agrupados = pd.merge(emissao_estados, populacao_estados, left_on = 'Estado', right_on = 'UF')
dados_agrupados

dados_agrupados.plot(x = 'populacao', y = 'Emissão', kind = 'scatter', figsize = (8,6));

# melhorando a visualização dos dados
import plotly.express as px
px.scatter(data_frame = dados_agrupados, x = 'populacao', y = 'Emissão', text = 'Estado', opacity = 0)

dados_agrupados = dados_agrupados.assign(emissao_per_capta = dados_agrupados['Emissão']/dados_agrupados['populacao']).sort_values('emissao_per_capta', ascending=False)
dados_agrupados

px.bar(data_frame = dados_agrupados, x = 'Estado', y = 'emissao_per_capta')
px.scatter(data_frame = dados_agrupados, x = 'populacao', y = 'Emissão', text = 'Estado', size = 'emissao_per_capta')
# roraima é o estado que possui a maior emissão per capta