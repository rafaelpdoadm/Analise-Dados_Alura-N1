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
