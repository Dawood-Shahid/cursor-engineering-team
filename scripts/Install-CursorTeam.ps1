param(
    [string]$Source = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Stop"

$CursorHome = Join-Path $HOME ".cursor"
$AgentTarget = Join-Path $CursorHome "agents"
$SkillTarget = Join-Path $CursorHome "skills"
$ManifestPath = Join-Path $CursorHome "cursor-engineering-team.manifest.json"

$AgentSource = Join-Path $Source "agents"
$SkillSource = Join-Path $Source "skills"

if (!(Test-Path $AgentSource)) {
    throw "Agents source folder not found: $AgentSource"
}

if (!(Test-Path $SkillSource)) {
    throw "Skills source folder not found: $SkillSource"
}

New-Item -ItemType Directory -Force -Path $AgentTarget | Out-Null
New-Item -ItemType Directory -Force -Path $SkillTarget | Out-Null

$installedAgents = @()
$installedSkills = @()

# Copy agent definitions
Get-ChildItem $AgentSource -File -Filter "*.md" | ForEach-Object {
    Copy-Item $_.FullName -Destination $AgentTarget -Force
    $installedAgents += $_.Name
    Write-Host "Installed agent: $($_.Name)"
}

# Copy skill folder contents (avoid nested skill/skill/SKILL.md on re-run)
Get-ChildItem $SkillSource -Directory | ForEach-Object {
    $skillName = $_.Name
    $destination = Join-Path $SkillTarget $skillName
    $installedSkills += $skillName

    New-Item -ItemType Directory -Force -Path $destination | Out-Null

    Get-ChildItem $_.FullName -Force | ForEach-Object {
        $targetPath = Join-Path $destination $_.Name
        if ($_.PSIsContainer) {
            if (Test-Path $targetPath) {
                Remove-Item $targetPath -Recurse -Force
            }
            Copy-Item $_.FullName -Destination $targetPath -Recurse -Force
        } else {
            Copy-Item $_.FullName -Destination $targetPath -Force
        }
    }

    Write-Host "Installed skill: $skillName"
}

# Remove agents no longer in the library
if (Test-Path $ManifestPath) {
    try {
        $previous = Get-Content $ManifestPath -Raw | ConvertFrom-Json
        foreach ($staleAgent in $previous.agents) {
            if ($staleAgent -notin $installedAgents) {
                $stalePath = Join-Path $AgentTarget $staleAgent
                if (Test-Path $stalePath) {
                    Remove-Item $stalePath -Force
                    Write-Host "Removed stale agent: $staleAgent"
                }
            }
        }
        foreach ($staleSkill in $previous.skills) {
            if ($staleSkill -notin $installedSkills) {
                $stalePath = Join-Path $SkillTarget $staleSkill
                if (Test-Path $stalePath) {
                    Remove-Item $stalePath -Recurse -Force
                    Write-Host "Removed stale skill: $staleSkill"
                }
            }
        }
    } catch {
        Write-Warning "Could not read manifest for orphan cleanup: $_"
    }
}

$manifest = @{
    installedAt = (Get-Date).ToUniversalTime().ToString("o")
    source      = (Resolve-Path $Source).Path
    agents      = $installedAgents
    skills      = $installedSkills
}
$manifest | ConvertTo-Json -Depth 4 | Set-Content -Path $ManifestPath -Encoding utf8

Write-Host ""
Write-Host "Cursor team configuration installed."
Write-Host "Agents: $AgentTarget"
Write-Host "Skills: $SkillTarget"
Write-Host "Manifest: $ManifestPath"
Write-Host "Restart Cursor or refresh its Agent context if needed."
