# Sistema de Armas - ZTK PVP

## Funcionalidades

### Botão "Desequipar Todas" 
- **Localização**: Header do painel de armas
- **Funcionalidade**: Desequipa todas as armas do jogador com lógica real
- **Visual**: Botão vermelho com ícone de arma e efeito hover

### Sistema de Reequipamento Automático
- **Funcionalidade**: Quando o jogador morre, renasce com a mesma arma que estava equipada
- **Monitoramento**: Detecta automaticamente morte e respawn do jogador
- **Sincronização**: Salva a última arma tanto no cliente quanto no servidor
- **Persistência**: Mantém a arma mesmo após reconexão

### Como Funciona

#### Botão Desequipar Todas
1. **Interface**: O botão está localizado no canto superior direito do painel
2. **Clique**: Ao clicar, o botão mostra um estado de loading ("DESEQUIPANDO...")
3. **Lógica**: 
   - Força o desequipamento da arma atual
   - Usa a função `ForceUnequipAllWeapons()` do framework se disponível
   - Método alternativo nativo se o framework não estiver disponível
   - Remove todas as armas e força o desequipamento múltiplas vezes
4. **Feedback**: Notifica o jogador sobre o sucesso da operação
5. **HUD**: Atualiza os slots do HUD se disponível

#### Sistema de Reequipamento
1. **Monitoramento**: Thread que verifica se o jogador morreu
2. **Salvamento**: Salva automaticamente a arma equipada antes da morte
3. **Detecção**: Aguarda o respawn do jogador
4. **Reequipamento**: Reequipa automaticamente a última arma após renascer
5. **Sincronização**: Mantém sincronizado entre cliente e servidor

### Comandos de Teste

- `/testunequipall` - Testa a funcionalidade de desequipar todas as armas
- `/testreequip` - Testa o reequipamento da última arma
- `/openWeaponMenu` - Abre o painel de armas (F2)

### Estrutura de Arquivos

```
[Scripts]/weapon/
├── web-side/
│   ├── index.html (Interface com botão)
│   ├── styles/styles.css (Estilos do botão)
│   └── scripts/main.js (Lógica do botão)
├── client/
│   └── client.lua (Callback NUI, lógica de desequipamento e reequipamento)
├── server/
│   └── server.lua (Eventos de auditoria e sincronização)
└── fxmanifest.lua
```

### Logs e Debug

O sistema inclui logs detalhados para debug:
- `[WEAPON][CLIENT]` - Logs do lado cliente
- `[DEBUG][WEAPON]` - Logs de debug do servidor
- `[AUDIT][WEAPON]` - Logs de auditoria

### Integração com Framework

O sistema se integra com o framework PvP existente:
- Usa `ForceUnequipAllWeapons()` se disponível
- Atualiza `UpdateHUDWeaponSlots()` se disponível
- Compatível com o sistema de notificações existente

### Funcionalidades Avançadas

#### Monitoramento de Arma
- **Thread dedicada**: Monitora mudanças de arma em tempo real
- **Salvamento automático**: Salva a arma sempre que o jogador troca
- **Sincronização**: Mantém sincronizado entre cliente e servidor

#### Sistema de Respawn
- **Detecção de morte**: Detecta quando o jogador morre
- **Aguardar respawn**: Aguarda o respawn completo antes de reequipar
- **Verificação de arma**: Confirma se o jogador ainda tem a arma salva
- **Reequipamento seguro**: Reequipa apenas se a arma ainda estiver disponível

#### Limpeza de Dados
- **Desconexão**: Limpa dados quando o jogador desconecta
- **Reconexão**: Sincroniza dados quando o jogador reconecta
- **Memória**: Gerencia memória de forma eficiente 