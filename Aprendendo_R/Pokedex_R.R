x = c(1, 2, 3)
y = c(2, 4, 6)
plot(x, y)

getwd()

dados <- read.csv("Dados/Pokemon_full.csv")

dados <- read.csv("~/Downloads/Pokemon_full.csv")

head(dados) # cabeçalho do csv
tail(dados, 12) # final do csv

View(dados)

library(tidyverse)

names(dados)

# Seleciona colunas de interesse
select(dados, name, hp, speed, attack)

# filtra colunas de interesse
filter(dados, attack < 50)

# operacoes basicas

mutate(dados, x = attack+speed) # cria uma nova variável
mutate(dados, attack = attack/2) # modifica essa variável
mutate(dados, IMC = weight/(height*height)) # modifica essa variável

dados <- mutate(dados, IMC = weight/(height*height))

# exemplos operadores

df <- select(dados, name, hp, attack, speed)
df <- filter(df, attack < 50)
df <- mutate(df, x = attack+speed)
df

# O operador pipe serve para pegar o que ta à esquerda dele e coloca como primeiro argumento da próxima função
df <- dados %>% 
  select(name, hp, attack, speed) %>% 
  filter(attack < 50) %>% 
  mutate(x = attack+speed)

# gsub modifica strings
x <- c("Thomas", "Fernando", "Thais","Thiago")
# Se colocar ponto, o pipe ele rastreia e substitui. Se não colocar, ele põe como primeiro argumento.
x %>% 
  gsub("Th", "th", .)
# |> pipe nativo do R


dados %>%
  filter(height > 10) %>%
  select(name, height, weight)%>%
  mutate(imc = weight/(height*height)) %>% 
  ggplot()+
  geom_density(aes( x = imc))


head(dados)
dados %>% head

# comando mostrando o número de linhas e colunas, nomes de variáveis, seus tipos de dados e as primeiras observações de cada coluna
glimpse(dados)
summary(dados)
str(dados)

dados %>% pull(IMC) # retorna como vetor
dados %>% select(IMC) # retorna como coluna

mean(c(1, 2, 3, 4))

dados %>% 
  mutate(media = mean(IMC)) # cria e preenche uma coluna com o valor da media

dados %>% 
  summarise(media = mean(IMC), desvio = sd(IMC)) # resume os dados, retornando uma coluna para variavel de interesse

dados %>%
  group_by(type) %>% 
  summarise(media = mean(IMC), desvio = sd(IMC)) # resume os dados, retornando uma coluna para variavel de interesse


dados %>% 
  group_by(type) %>% 
  mutate(media = mean(IMC)) %>% View # cria e preenche uma coluna com o mesmo valor


dados %>% 
  group_by(type) %>% 
  mutate(media = mean(IMC)) %>% 
  filter(IMC > media) %>% View

df <- dados %>% 
  group_by(type) %>% 
  mutate(media = mean(IMC))

df %>% 
  ungroup() %>% 
  mutate(media2 = mean(IMC)) %>% View

# busca padrões
# aceita Regular Expression (ReGex)
grep("saur|fly", dados$name)
grepl("saur|fly", dados$name)


grep("[Ss]aur", dados$name)

x
grep("Th[oa]", x)

n <- c("097.765.986-90", "123.765.98-37")
grepl("\\d{3}\\.\\d{3}\\.\\d{3}-\\d{2}", n)


x <- c(
  "Amonia",
  "Ferro",
  "Dióxido de enxofre",
  "Dioxido de Enxofre",
  "Manganês",
  "Dióxido  de  Enxofre",
  "dioxido de  Enxofre",
  "dioxidode  Enxofre"
)

# + um ou mais
# * zero ou mais
grepl("[Dd]i[óo]xido *de\\s+[eE]nxofre", x)

grepl(".", c("a", "b", "c", "0", " "))

dados %>% 
  filter(attack > 50)

dados$attack > 50

dados %>% 
  filter(grepl("saur|fly", name), attack > 50, type != "grass")

"saur" == "ivysaur"
grepl("saur", "ivysaur")

#### trabalhando juntando os dados

# bind row

df1 <- dados %>% 
  filter(attack > 70)

df2 <- dados %>% 
  filter(attack <= 70)


rbind(df1, df2) # juntar linhas

# com colunas diferentes

df1 <- dados %>% 
  select(attack, speed, weight) %>% 
  filter(attack > 70)

df2 <- dados %>% 
  select(attack, weight, height, hp) %>% 
  filter(attack <= 70)

rbind(df1, df2) # juntar linhas - nao aceita dimensoes e nomes diferentes!!!

bind_rows(df1, df2) # juntar linhas 


# juntar colunas

df1 <- dados %>% head(150)
df2 <- dados %>% tail(150)

cbind(df1, df2) %>% names

bind_cols(df1, df2, .name_repair = "check_unique")

###############

df_resumo <- dados %>%
  group_by(type) %>% 
  summarise(media = mean(IMC), desvio = sd(IMC)) # resume os dados, retornando uma coluna para cada variável



# Fazendo join


# left, right, full, inner

left_join(dados, df_resumo, by = c("type")) %>% View

df_resumo_mis <- df_resumo %>%  filter(type != "grass")

left_join(dados, df_resumo_mis, by = c("type")) %>% View
right_join(dados, df_resumo_mis, by = c("type")) %>% View

df_resumo_mis$type[5] = "thomas" 
right_join(dados, df_resumo_mis, by = c("type")) %>% View
left_join(dados, df_resumo_mis, by = c("type")) %>% View

full_join(dados, df_resumo_mis, by = c("type")) %>% View
inner_join(dados, df_resumo_mis, by = c("type")) %>% View
