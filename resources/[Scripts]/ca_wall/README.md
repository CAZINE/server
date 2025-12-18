# Wall System - PvP Framework

## Descrição
Sistema de Wall adaptado para funcionar com o PvP Framework. Permite que administradores vejam informações dos jogadores através de paredes.

## Funcionalidades
- Visualização de jogadores através de paredes
- Informações em tempo real (vida, ID, distância)
- Sistema de permissões integrado ao framework
- Logs para Discord (opcional)
- Linhas visuais conectando o jogador aos alvos

## Instalação
1. Certifique-se de que o framework está funcionando
2. Coloque este recurso na pasta `resources/`
3. Adicione `ensure ca_wall` ao seu `server.cfg`
4. Reinicie o servidor

## Configuração
Edite o arquivo `config/config.lua`:

```lua
-- Distância máxima para mostrar jogadores
Config.DistanciaWall = 200

-- Permissão necessária (deve corresponder ao grupo no framework)
Config.Permissao = "Admin"

-- Webhook do Discord (opcional)
Config.Webhook = "SEU_WEBHOOK_AQUI"
```

## Uso
- Comando: `/wall`
- Apenas administradores podem usar
- Ativa/desativa a visualização de jogadores

## Integração com Framework
O sistema foi adaptado para:
- Usar o sistema de permissões do framework
- Utilizar as funções Utils do framework
- Funcionar com o sistema de notificações
- Ser compatível com a estrutura do projeto

## Dependências
- PvP Framework (deve estar carregado antes)

## Logs
O sistema envia logs para o Discord quando um admin usa o comando `/wall`, incluindo:
- ID do administrador
- Data e hora
- Informações do sistema

## Performance
- Otimizado para não impactar o desempenho
- Atualizações a cada segundo
- Distância máxima configurável
- Processamento apenas quando ativo 