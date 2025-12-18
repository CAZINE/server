# FX Movement System

## English

### Overview
FX MOV is a sophisticated movement system for FiveM servers that enhances player movement mechanics, focusing primarily on crouch functionality with extensive customization options.

### Features
- **Advanced Crouch System**
  - Smooth transition animations
  - Customizable transition speed
  - Custom animation sets for crouching and strafing
  - Combat mode compatibility

### Configuration Options
- `DisableCombatMode`: Prevents combat mode while crouching
- `DisableDamageCancels`: Maintains crouch animation even when taking damage
- `DisableRagdoll`: Prevents ragdoll physics while crouching
- `DisableMelee`: Disables melee attacks during crouch
- `DisableFire`: Prevents weapon firing while crouching
- `TransitionSpeed`: Adjustable animation transition speed (default: 0.8)
- Custom animation sets for movement and strafing

### Commands and Controls
- Command: `/FX:Crouch` - Toggle crouch mode
- Default Key: `Left Control` (LCONTROL)

### Exports
- `CrouchState()` - Returns the current crouch state (boolean)

---

## Português

### Visão Geral
FX MOV é um sistema sofisticado de movimentação para servidores FiveM que aprimora as mecânicas de movimento do jogador, com foco principal na funcionalidade de agachamento e amplas opções de personalização.

### Funcionalidades
- **Sistema Avançado de Agachamento**
  - Animações suaves de transição
  - Velocidade de transição personalizável
  - Conjuntos personalizados de animação para agachamento e movimento lateral
  - Compatibilidade com modo de combate

### Opções de Configuração
- `DisableCombatMode`: Desativa o modo de combate durante o agachamento
- `DisableDamageCancels`: Mantém a animação de agachamento mesmo ao receber dano
- `DisableRagdoll`: Impede a física de ragdoll durante o agachamento
- `DisableMelee`: Desativa ataques corpo a corpo durante o agachamento
- `DisableFire`: Impede o disparo de armas durante o agachamento
- `TransitionSpeed`: Velocidade de transição da animação ajustável (padrão: 0.8)
- Conjuntos personalizados de animação para movimento e movimento lateral

### Comandos e Controles
- Comando: `/FX:Crouch` - Alternar modo de agachamento
- Tecla Padrão: `Control Esquerdo` (LCONTROL)

### Exports
- `CrouchState()` - Retorna o estado atual do agachamento (boolean) 
