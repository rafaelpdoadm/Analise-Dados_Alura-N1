# importando e conhecendo a base de dados desse curso
import pandas as pd
url = 'https://raw.githubusercontent.com/alura-cursos/bibliotecas_visualizacao/refs/heads/main/Dados/imigrantes_canada.csv'
df = pd.read_csv(url)
df
df.info()

# primeira demanda:
# analisar as tendências de imigração do Brasil ao longo dos anos
df.set_index('País', inplace=True)
anos = list(map(str, range(1980, 2014)))
brasil = df.loc['Brasil', anos]
brasil
brasil_dict = {'ano' : brasil.index.tolist(), 'imigrantes' : brasil.values.tolist()}
dados_brasil = pd.DataFrame(brasil_dict)
dados_brasil

# entendendo as tendências de imigração
import matplotlib.pyplot as plt
plt.figure(figsize=(8, 4))
plt.plot(dados_brasil['ano'], dados_brasil['imigrantes'])
plt.xticks(['1980','1985','1990','1995','2000','2005','2010'])
plt.yticks([500, 1000, 1500, 2000, 2500, 3000])
plt.title('Imigranção do Brasil para o Canadá')
plt.xlabel('Ano')
plt.ylabel('Número de imigrantes')
plt.show()
# outra forma de plotar o gráfico acima
fig, ax = plt.subplots(figsize=(8, 4))
ax.plot(dados_brasil['ano'], dados_brasil['imigrantes'])
ax.xaxis.set_major_locator(plt.MultipleLocator(5))
ax.set_title('Imigração do Brasil para o Canadá\n1980-2013')
ax.set_xlabel('Ano')
ax.set_ylabel('Número de imigrantes')
plt.show()

# plotando dois gráficos na mesma figura
fig, axs = plt.subplots(1, 2, figsize=(15, 5))
axs[0].plot(dados_brasil['ano'], dados_brasil['imigrantes'])
axs[0].set_title('Imigração do Brasil para o Canadá\n1980-2013')
axs[0].set_xlabel('Ano')
axs[0].set_ylabel('Número de imigrantes')
axs[0].xaxis.set_major_locator(plt.MultipleLocator(5))
axs[0].grid()
axs[1].boxplot(dados_brasil['imigrantes'])
axs[1].set_title('Boxplot da imigração do Brasil para o Canadá\n1980-2013')
axs[1].set_xlabel('Brasil')
axs[1].set_ylabel('Número de imigrantes')
axs[1].grid()
plt.show()

# coletando dados para interpretar os gráficos
dados_brasil.describe()

# criando subplots para analisar comparativamente os dados do Brasil, Argentina, Colômbia e Peru
fig, axs = plt.subplots(2, 2, figsize=(10, 6))
fig.subplots_adjust(hspace=0.5, wspace=0.3)
fig.suptitle('Imigração dos quatro maiores países da América do Sul para o Canadá de 1980 a 2013')
axs[0,0].plot(df.loc['Brasil', anos])
axs[0,0].set_title('Brasil')
axs[0,1].plot(df.loc['Colômbia', anos])
axs[0,1].set_title('Colômbia')
axs[1,0].plot(df.loc['Argentina', anos])
axs[1,0].set_title('Argentina')
axs[1,1].plot(df.loc['Peru', anos])
axs[1,1].set_title('Peru')
for ax in axs.flat:
  ax.xaxis.set_major_locator(plt.MultipleLocator(5))
  ax.set_xlabel('Ano')
  ax.set_ylabel('Número de imigrantes')
ymin=0
ymax=7000
for ax in axs.ravel():
  ax.set_ylim(ymin, ymax)
plt.show()

# repetindo um gráfico e iniciando a modificação de cores daslinhas dele
fig, ax = plt.subplots(figsize=(8, 4))
ax.plot(dados_brasil['ano'], dados_brasil['imigrantes'], lw=3, color='g')
ax.set_title('Imigração do Brasil para o Canadá\n1980 a 2013', fontsize=18, loc='left')
ax.set_xlabel('Ano', fontsize=14)
ax.set_ylabel('Número de imigrantes', fontsize=14)
ax.xaxis.set_tick_params(labelsize=12)
ax.yaxis.set_tick_params(labelsize=12)
ax.xaxis.set_major_locator(plt.MultipleLocator(5))
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
fig.savefig('Imigracao_brasil_canada.png', transparent=False, dpi=300, bbox_inches='tight')
plt.show()

# explorando os dados e gráficos de toda a américa do sul
df.head()
america_sul = df.query('Região == "América do Sul"')
america_sul

america_sul_sorted = america_sul.sort_values('Total', ascending=True)

cores = []
for pais in america_sul_sorted.index:
    if pais == 'Brasil':
        cores.append('green')
    else:
        cores.append('silver')
fig, ax = plt.subplots(figsize=(12, 5))
ax.barh(america_sul_sorted.index, america_sul_sorted['Total'], color=cores)
ax.set_title('América do Sul: Brasil foi o quarto país com mais imigrantes\npara o Canadá no período de 1980 a 2013', loc='left', fontsize=18)
ax.set_ylabel('')
ax.set_xlabel('Número de imigrantes', fontsize=14)
ax.xaxis.set_tick_params(labelsize=12)
ax.yaxis.set_tick_params(labelsize=12)
for i, v in enumerate(america_sul_sorted['Total']):
    ax.text(v + 20, i, str(v), color = 'black', fontsize = 10, ha = 'left', va = 'center')
ax.set_frame_on(False)
ax.get_xaxis().set_visible(False)
ax.tick_params(axis='both', which='both', length=0)
plt.show()

# explorando o uso a biblioteca seaborn para mais opções de configuração dos gráficos
import seaborn as sns
sns.set_theme()

# criando um gráfico com a biblioteca investigando os top 10 países que mais imigraram para o Canadá
top_10 = df.sort_values('Total', ascending = False).head(10)
sns.barplot(data = top_10, y=top_10.index, x='Total', orient='h')

fig, ax = plt.subplots(figsize=(8, 4))
ax = sns.barplot(data=top_10, y=top_10.index, x='Total', orient='h')
ax.set_title('Países com maior imigração para o Canadá\n1980 a 2013',
        loc='left',
        fontsize=16)
ax.set_xlabel('Número de imigrantes', fontsize=14)
ax.set_ylabel('')
plt.show()

# utilizando as paletas de cores 
def gerar_grafico_paleta(palette):
    fig, ax = plt.subplots(figsize=(8, 4))
    ax = sns.barplot(data=top_10, y=top_10.index, x='Total', orient='h', palette=palette)
    ax.set_title('Países com maior imigração para o Canadá\n1980 a 2013', loc='left', fontsize=18)
    ax.set_xlabel('Número de imigrantes', fontsize=14)
    ax.set_ylabel('')
    plt.show()

# tipos de paleta
gerar_grafico_paleta('Blues_r')
gerar_grafico_paleta('rocket')
gerar_grafico_paleta('coolwarm')
gerar_grafico_paleta('tab10')

# tipos de tema
sns.set_theme(style='dark')
sns.set_theme(style='whitegrid')
sns.set_theme(style='white')
sns.set_theme(style='ticks')
# mais temas e paletas podem ser encontradas na documentação da biblioteca