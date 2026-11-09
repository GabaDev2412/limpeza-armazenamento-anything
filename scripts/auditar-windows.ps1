# Auditoria de armazenamento no Windows. Somente leitura; PowerShell 5.1+.
[CmdletBinding()]
param()

if ($env:OS -ne 'Windows_NT') {
    Write-Error 'Este script requer Windows nativo. No macOS, use auditar-macos.sh.'
    exit 1
}

function Show-Heading([string]$Title) {
    Write-Host "`n== $Title =="
}

# Não acompanha reparse points, evitando ciclos, outros volumes e links para nuvem.
function Get-FolderSize([string]$Path) {
    $result = [ordered]@{ Path = $Path; Bytes = [long]0; Errors = 0; SkippedLinks = 0 }
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    $pending = New-Object 'System.Collections.Generic.Stack[string]'
    $pending.Push($Path)
    while ($pending.Count -gt 0) {
        $current = $pending.Pop()
        try {
            $item = Get-Item -LiteralPath $current -Force -ErrorAction Stop
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                $result.SkippedLinks++
                continue
            }
            if (-not $item.PSIsContainer) {
                $result.Bytes += [long]$item.Length
                continue
            }
            $children = @(Get-ChildItem -LiteralPath $current -Force -ErrorAction Stop)
            foreach ($child in $children) {
                if (($child.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                    $result.SkippedLinks++
                } elseif ($child.PSIsContainer) {
                    $pending.Push($child.FullName)
                } else {
                    $result.Bytes += [long]$child.Length
                }
            }
        } catch {
            $result.Errors++
        }
    }
    [pscustomobject]$result
}

Show-Heading 'Volumes locais (bytes)'
try {
    Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' -ErrorAction Stop |
        Select-Object DeviceID, VolumeName, Size, FreeSpace | Format-Table -AutoSize
} catch { Write-Warning "Não foi possível consultar volumes: $_" }

Show-Heading 'Pastas selecionadas (tamanho lógico aproximado)'
Write-Host 'Pode demorar. Pastas sobrepostas não devem ser somadas; erros indicam resultado incompleto.'
$targets = @(
    (Join-Path $env:USERPROFILE 'Downloads'),
    (Join-Path $env:USERPROFILE 'Documents'),
    (Join-Path $env:USERPROFILE 'Desktop'),
    (Join-Path $env:USERPROFILE 'Videos'),
    (Join-Path $env:USERPROFILE '.npm'),
    (Join-Path $env:USERPROFILE '.nuget\packages'),
    (Join-Path $env:USERPROFILE '.gradle\caches'),
    (Join-Path $env:USERPROFILE '.cache'),
    (Join-Path $env:LOCALAPPDATA 'Temp'),
    (Join-Path $env:LOCALAPPDATA 'npm-cache'),
    (Join-Path $env:LOCALAPPDATA 'pnpm\store'),
    (Join-Path $env:LOCALAPPDATA 'pip\Cache'),
    (Join-Path $env:LOCALAPPDATA 'Google\Chrome\User Data'),
    (Join-Path $env:LOCALAPPDATA 'Microsoft\Edge\User Data'),
    (Join-Path $env:LOCALAPPDATA 'Docker'),
    (Join-Path $env:LOCALAPPDATA 'Packages')
) | Select-Object -Unique
$measurements = foreach ($target in $targets) { Get-FolderSize $target }
$measurements | Sort-Object Bytes -Descending | ForEach-Object {
    '{0,10:N2} GiB | erros: {1} | links ignorados: {2} | {3}' -f ($_.Bytes / 1GB), $_.Errors, $_.SkippedLinks, $_.Path
}

Show-Heading 'Docker (consulta)'
if (Get-Command docker -ErrorAction SilentlyContinue) {
    & docker system df
    if ($LASTEXITCODE -ne 0) { Write-Warning 'Docker indisponível ou daemon parado.' }
} else { Write-Host 'Docker não encontrado.' }

Show-Heading 'WSL (consulta)'
if (Get-Command wsl.exe -ErrorAction SilentlyContinue) {
    & wsl.exe --list --verbose
    if ($LASTEXITCODE -ne 0) { Write-Warning 'Não foi possível listar as distribuições WSL.' }
} else { Write-Host 'WSL não encontrado.' }

Show-Heading 'Fim'
Write-Host 'Nada foi apagado. Examine os resultados e peça autorização antes de cada remoção.'
