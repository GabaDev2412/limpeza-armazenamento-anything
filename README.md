# Limpeza de armazenamento: macOS e Windows

Skill para agentes de código que ajuda a identificar o que ocupa espaço e planejar uma limpeza cuidadosa. Inclui scripts de auditoria **somente de leitura** para macOS e Windows. Nenhum script apaga arquivos.

A skill orienta o agente a medir, categorizar, explicar riscos, pedir confirmação para cada remoção e medir o resultado real. Docker, WSL, dados de aplicativos, projetos e arquivos pessoais exigem atenção especial.

## Instalação

Clone este repositório para a pasta de skills do seu agente, com Git instalado. Exemplos:

```bash
# Codex (macOS)
git clone https://github.com/GabaDev2412/limpeza-armazenamento-anything.git ~/.codex/skills/limpeza-armazenamento-anything
# Claude Code (macOS)
git clone https://github.com/GabaDev2412/limpeza-armazenamento-anything.git ~/.claude/skills/limpeza-armazenamento-anything
```

No Windows, em PowerShell:

```powershell
# Codex
git clone https://github.com/GabaDev2412/limpeza-armazenamento-anything.git "$HOME\.codex\skills\limpeza-armazenamento-anything"
# Claude Code
git clone https://github.com/GabaDev2412/limpeza-armazenamento-anything.git "$HOME\.claude\skills\limpeza-armazenamento-anything"
```

Reinicie o agente se necessário e peça, por exemplo, “o que está ocupando meu disco?” ou “me ajude a liberar espaço”.

## Auditoria independente

Execute na raiz do repositório:

```bash
# macOS
bash scripts/auditar-macos.sh
```

```powershell
# Windows PowerShell 5.1 ou PowerShell 7, no Windows
powershell -NoProfile -File .\scripts\auditar-windows.ps1
# Alternativa com PowerShell 7:
pwsh -NoProfile -File .\scripts\auditar-windows.ps1
```

No Windows, se a política de execução impedir scripts, consulte a política da sua organização antes de alterá-la. Nenhum privilégio de administrador é necessário, mas algumas pastas protegidas podem não ser medidas. Em ambos os sistemas a varredura pode demorar e os tamanhos são aproximados; pastas sobrepostas não devem ser somadas. O WSL é identificado no Windows, mas a auditoria não vasculha suas distribuições.

## Estrutura

- `SKILL.md`: fluxo e regras comuns da skill.
- `references/`: orientações específicas de cada sistema.
- `scripts/`: auditorias por plataforma, somente leitura.

O suporte é para macOS e Windows nativo; Linux e WSL como ambiente de execução não são suportados pelos scripts. O script de macOS foi adaptado do projeto [limpeza-disco-mac](https://github.com/nerigleston/limpeza-disco-mac).
