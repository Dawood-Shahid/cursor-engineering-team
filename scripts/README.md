# Run the installer

Two ways to install agents and skills from this repo into `~/.cursor/agents` and `~/.cursor/skills`. Neither copies `templates/` or `AGENTS.md`.

| Script | Behavior |
|--------|----------|
| `install.sh` | **Symlinks** (Mac/Linux). After `git pull`, updates apply without reinstall. |
| `Install-CursorTeam.ps1` | **Copies** files; tracks a manifest and removes stale agents/skills on re-run. |

Run from the repository root after clone or pull. Restart Cursor or refresh Agent context afterward.

Validate the library:

```bash
./scripts/validate-library.sh
```

## Mac and Linux (symlink)

```bash
cd /path/to/cursor-engineering-team
./scripts/install.sh
```

Optional: `jq` improves orphan cleanup when switching from copy to symlink install.

## Windows

PowerShell blocks unsigned scripts until you allow them for the current process. From the repo root:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\Install-CursorTeam.ps1
```

`Set-ExecutionPolicy -Scope Process Bypass` lasts only for that PowerShell window. `.\` means “this folder”; without it PowerShell will not run a script by name.

## Mac and Linux (copy via PowerShell)

```bash
brew install --cask powershell   # Mac
# or: sudo apt-get install -y powershell   # Debian/Ubuntu
cd /path/to/cursor-engineering-team
pwsh ./scripts/Install-CursorTeam.ps1
```

You do not need `Set-ExecutionPolicy` on Mac or Linux for `pwsh`. The script uses `$HOME`, so files land in `~/.cursor` on every platform.
