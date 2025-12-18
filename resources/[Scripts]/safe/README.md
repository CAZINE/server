# Sistema de Safe Zone

Sistema completo de Safe Zones para FiveM com visualização 3D e funcionalidades administrativas.

## Características

- ✅ Círculos de 100m de raio nas coordenadas especificadas
- ✅ Visualização 3D com cilindros brancos e opacidade (apenas no jogo)
- ✅ Blips no mapa desativados por padrão (podem ser ativados via comando)
- ✅ Sistema de notificações ao entrar/sair das zonas
- ✅ Comandos administrativos para gerenciar zonas
- ✅ Integração com sistema de permissões do framework
- ✅ Exports para outros resources

## Coordenadas Configuradas

1. **Aeroporto**: `{x = 1476.818, y = -6554.745, z = 13.447}`
2. **Paleto Bay**: `{x = 1368.329, y = -584.030, z = 74.380}`
3. **Sandy Shores**: `{x = -1645.916, y = -1001.173, z = 13.017}`
4. **Zona Norte**: `{x = 1290.530, y = 3066.014, z = 40.534}`

## Comandos

### Para Jogadores
- `/safezone` - Verificar se está em uma safe zone
- `/togglesafezones` - Alternar blips das zonas no mapa (admin)

### Para Administradores
- `/safezonelist` - Listar jogadores em safe zones
- `/tpsafezone <número>` - Teleportar para uma safe zone
- `/addsafezone <nome> <x> <y> <z> [raio] [altura]` - Adicionar nova zona
- `/removesafezone <número>` - Remover zona existente

## Configuração

### Config.lua
```lua
Config.SafeZones = {
    {
        name = "Nome da Zona",
        coords = vector3(x, y, z),
        radius = 100.0,        -- Raio em metros
        height = 200.0,        -- Altura do cilindro
        color = {r = 255, g = 255, b = 255, a = 50}, -- Cor e opacidade
        heading = 450.0
    }
}
```

### Configurações Gerais
- `Config.DrawDistance` - Distância máxima para desenhar (500m)
- `Config.UpdateInterval` - Intervalo de atualização (100ms)
- `Config.ShowBlips` - Mostrar blips no mapa (false - desativado por padrão)
- `Config.BlipSprite` - Sprite do blip (1 = círculo)
- `Config.BlipColor` - Cor do blip (0 = branco)

## Exports

### Cliente
```lua
-- Verificar se jogador está em safe zone
local inSafeZone, zone = exports['safe']:IsPlayerInSafeZone()

-- Obter zona atual
local currentZone = exports['safe']:GetCurrentSafeZone()

-- Verificar status
local isInZone = exports['safe']:IsInSafeZone()
```

### Servidor
```lua
-- Verificar se jogador está em safe zone
local inSafeZone, zone = exports['safe']:IsPlayerInSafeZone(playerId)

-- Obter lista de jogadores em safe zones
local players = exports['safe']:GetPlayersInSafeZone()
```

## Eventos

### Cliente
- `safe:enteredZone` - Disparado ao entrar na zona
- `safe:leftZone` - Disparado ao sair da zona
- `safe:playerEnteredZone` - Outro jogador entrou na zona
- `safe:playerLeftZone` - Outro jogador saiu da zona

### Servidor
- `safe:requestSafeZoneStatus` - Solicitar status da zona
- `safe:requestPlayersInSafeZone` - Solicitar lista de jogadores

## Instalação

1. Coloque a pasta `safe` em `resources/[Scripts]/`
2. Adicione `ensure safe` no `server.cfg`
3. Reinicie o servidor

## Dependências

- FiveM
- Framework PvP (opcional, para sistema de permissões)
- Resource `notify` (opcional, para notificações)

## Notas

- O sistema é otimizado para performance com verificação a cada 500ms
- As zonas são desenhadas apenas quando o jogador está próximo (500m)
- Compatível com sistemas de permissões existentes
- Não gera arquivos de cache conforme preferência do usuário
