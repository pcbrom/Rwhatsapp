##################################################################################
# APLICATIVO DE CONVERSACAO NO WHATSAPP
# AUTOR: PEDRO CARVALHO BROM
# CV LATTES: lattes.cnpq.br/0154064396756002
# GITHUB: https://github.com/pcbrom
##################################################################################

library(RSelenium)

# DEFINIR PASTA DE TRABALHO Crtl + Shift + H
setwd("local")

# VERIFICAR O SERVIDOR E BAIXAR SE NECESSARIO
RSelenium::checkForServer()
RSelenium::startServer()

# ABRIR NAVEGADOR
remDr = remoteDriver(browserName = "firefox")
Sys.sleep(2)
remDr$open(silent = T)
Sys.sleep(runif(1, 10, 12))

# IR ATE A URL (neste ponto acesse o aplicativo no celular e habilite para web)
url = 'web.whatsapp.com'
Sys.sleep(2)
remDr$sendKeysToActiveElement(list(url, key = "enter"))
remDr$navigate(url)

# CHAMAR O BANCO DE DADOS
loc = "contatos.csv"
dados = read.csv(loc, header = F, encoding = 'UTF-8')
dados[,1] = as.character(dados[,1])
dados[,2] = as.character(dados[,2])
contatos = as.list(dados[,1])

# INICIAR UMA NOVA CONVERSA ---------------------------------------------------

mensagem = "É um robô para envio de mensagens no whatsapp."

total.mensagens = length(contatos)
for (i in 1:total.mensagens) {
  # acionar uma nova conversa
  webElem = remDr$findElement(using = 'xpath', "//button[contains(., 'Nova conversa')]")$clickElement()
  Sys.sleep(runif(1, 1, 3))
  
  # acionar um contato
  webElem = remDr$findElement(using = 'xpath', "//input[@class='input input-search']")
  webElem$clearElement()
  webElem$sendKeysToElement(contatos[i])
  Sys.sleep(runif(1, 1, 3))
  
  # abrir janela de chat
  webElem = remDr$findElement(using = 'xpath', "//div[@class='chat-body']")$clickElement()
  Sys.sleep(runif(1, 1, 3))
  
  # OPCAO 1: enviar mensagem apenas de texto
  webElem = remDr$findElement(using = 'xpath', "//div[@class='input']")
  webElem$clickElement()
  webElem$clearElement()
  Sys.sleep(runif(1, 1, 3))
  webElem$sendKeysToElement(list(mensagem, key = "enter"))
  Sys.sleep(runif(1, 1, 3))
}

# FECHAR SERVIDOR E FINALIZAR A NAVEGACAO
remDr$close()
remDr$closeServer()