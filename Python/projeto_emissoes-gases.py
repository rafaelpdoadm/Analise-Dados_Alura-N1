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
