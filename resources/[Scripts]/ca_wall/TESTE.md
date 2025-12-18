# Teste do Sistema Wall

## Como testar:

1. **Iniciar o servidor:**
   ```
   ensure framework
   ensure ca_wall
   ```

2. **Verificar se carregou sem erros:**
   - Procurar por: `[Wall System] Sistema de Wall inicializado!`
   - Procurar por: `[Wall System] Cliente inicializado!`

3. **Testar permissões:**
   - Use o comando: `/testwall`
   - Deve mostrar seu grupo e se tem permissão

4. **Testar o wall:**
   - Use o comando: `/wall`
   - Se tiver permissão, deve ativar/desativar a visualização
   - Se não tiver permissão, deve mostrar mensagem de erro

5. **Verificar logs:**
   - Se configurado o webhook, deve enviar log para Discord
   - Verificar console do servidor para mensagens de debug

## Possíveis problemas:

1. **Erro de permissão:**
   - Verificar se o jogador tem grupo "admin"
   - Verificar se a permissão "wall" está configurada

2. **Erro de dependência:**
   - Verificar se o framework está carregado antes do ca_wall
   - Verificar se o oxmysql está funcionando

3. **Erro de notificação:**
   - Verificar se o sistema de notificações do framework está funcionando

## Comandos úteis:

- `/wall` - Ativar/desativar wall
- `/testwall` - Testar permissões
- `/zones` - Ver zonas disponíveis (framework)
- `/zoneinfo` - Informações da zona atual (framework) 