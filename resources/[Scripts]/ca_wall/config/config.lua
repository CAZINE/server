----------------------------------------------------
-- Wall System - Configuração
-- Adaptado para PvP Framework
----------------------------------------------------

Config = {}

-- Distância máxima para mostrar jogadores no wall (em metros)
Config.DistanciaWall = 200

-- Permissão necessária para usar o comando /wall
Config.Permissao = "Admin"
Config.Permissao = "moderador"

-- Webhook do Discord para logs (opcional - deixe vazio para desabilitar)
Config.Webhook = "https://discord.com/api/webhooks/819378177007681556/1BULeaBZB3bfoMMPmNRqtDJcUqCs1b7B-qMZ9snMf7YcMPo5wO_msQCG9L9FBOFHQmRJ"

-- Configurações visuais
Config.LineColor = {r = 129, g = 61, b = 138, a = 255} -- Cor da linha
Config.TextColor = {r = 255, g = 255, b = 255, a = 255} -- Cor do texto

-- Configurações de performance
Config.UpdateInterval = 1000 -- Intervalo de atualização em ms
Config.MaxDistance = 300 -- Distância máxima para processar jogadores