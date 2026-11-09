---
name: limpeza-armazenamento-anything
description: Audita o armazenamento e ajuda a liberar espaço com cuidado no macOS ou Windows. Use quando pedirem para descobrir o que ocupa espaço ou limpar disco, caches, projetos, Docker ou WSL nesses sistemas.
---

# Limpeza de armazenamento: macOS e Windows

Identifique o sistema e a unidade antes de começar. Para macOS, consulte [macOS](references/macos.md) e execute `bash scripts/auditar-macos.sh`. Para Windows nativo, consulte [Windows](references/windows.md) e execute `powershell -NoProfile -File scripts/auditar-windows.ps1` ou `pwsh -NoProfile -File scripts/auditar-windows.ps1`. Resolva os caminhos dos scripts a partir da pasta desta skill. Se estiver no WSL, identifique separadamente o Linux e o Windows hospedeiro; não presuma que caminhos, ferramentas ou espaço livre sejam os mesmos. Em sistemas não suportados, explique a limitação e não execute scripts de outro sistema.

## Fluxo e segurança

1. Audite sem apagar. Os scripts podem demorar, exigem acesso de leitura e fornecem estimativas; informe erros de permissão e caminhos não medidos. Não eleve privilégios automaticamente.
2. Meça o espaço livre na unidade afetada. Liste os maiores achados, separando itens potencialmente regeneráveis, itens que exigem decisão do usuário e dados a preservar. Informe riscos e efeitos, não apenas tamanho. Pastas sobrepostas não devem ser somadas.
3. Antes de qualquer remoção, apresente o caminho e comando exatos, o que será perdido e peça aprovação explícita. Execute somente o aprovado; não use comandos amplos que incluam itens não inspecionados. Para aplicativos, prefira o desinstalador oficial. Nunca remova arquivos de sistema, credenciais, bancos, documentos, projetos ou volumes Docker sem autorização explícita e informada.
4. Meça novamente a mesma unidade após cada etapa e relate o ganho real. Tamanho lógico e espaço liberado podem divergir por arquivos compartilhados, compressão, snapshots, nuvem ou discos virtuais. Se não for possível medir, diga isso.

Caches, builds e dependências podem exigir downloads ou recompilação; confirme que não há processos usando os arquivos e que são realmente dispensáveis. `node_modules` e ambientes virtuais normalmente são recriáveis, mas preserve código e configurações. Não suponha que um repositório Git com remoto tenha backup atualizado: verifique commits e alterações locais. Arquivos de dados de navegador e mídia de aplicativos podem conter conteúdo insubstituível. Nunca considere um nome de pasta, arquivo duplicado ou volume órfão prova suficiente para remoção.

Docker: use `docker system df` antes de sugerir limpeza; imagens sem containers podem ser necessárias depois e o cache será reconstruído. Nunca inclua `--volumes` em limpezas gerais. Volumes, distribuições WSL e discos virtuais podem guardar bancos e projetos; não os exclua ou compacte sem identificar seu conteúdo, entender efeitos e receber aprovação específica. Espaço liberado dentro de uma VM pode não aparecer imediatamente no host.

No relatório, informe espaço antes e depois, ações e riscos, falhas e itens pendentes. Se a tarefa for apenas auditoria, não proponha a execução de exclusões como se já estivessem autorizadas.
