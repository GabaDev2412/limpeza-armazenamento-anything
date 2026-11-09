# Windows

Execute o script de auditoria em PowerShell 5.1 ou PowerShell 7 no Windows, sem administrador. Ele mede volumes locais e uma seleção de pastas do usuário, ignora junctions e links simbólicos durante a varredura e informa erros. Tamanhos são estimativas lógicas; pastas sobrepostas não devem ser somadas. Perfis de nuvem, pontos de montagem, arquivos protegidos e permissões podem limitar os resultados. A auditoria pode ser lenta; não faça download de arquivos sob demanda deliberadamente.

- Meça a unidade do alvo, por exemplo com `Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object DeviceID,Size,FreeSpace`. Outros discos precisam ser medidos separadamente.
- `%TEMP%`, caches e dependências podem estar em uso ou conter dados temporários necessários. Feche o aplicativo correspondente, examine o conteúdo e obtenha aprovação antes de excluir itens específicos. Não apague a pasta Temp inteira indiscriminadamente.
- Apps: use Configurações > Aplicativos ou o desinstalador do fornecedor. Não exclua `Windows`, `Program Files`, `ProgramData` ou pastas de perfil de aplicativo em massa.
- Downloads, Documentos, Área de Trabalho, OneDrive e mídias podem ser os únicos exemplares. Arquivos do OneDrive podem estar somente na nuvem ou sincronizando; use as opções oficiais após verificar a sincronização e o impacto.
- Navegadores: perfis, IndexedDB, Service Worker e outros dados de sites podem guardar sessões, rascunhos e dados offline. Prefira controles do próprio navegador e explique o que será perdido; não trate pastas como cache descartável sem investigar.
- Docker Desktop/WSL: `docker system df` e `wsl --list --verbose` são consultas. `ext4.vhdx` e outros VHDX podem conter projetos e bancos. Não remova, desregistre, redefina ou compacte distribuições ou discos como limpeza genérica. A compactação exige avaliação específica, backup adequado e instruções compatíveis com o ambiente.
- Instalações de ferramentas, SDKs e versões antigas podem ser necessárias para projetos. Examine antes de sugerir remoção. Nunca execute comandos de limpeza de volumes Docker.
