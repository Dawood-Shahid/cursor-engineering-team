#!/usr/bin/env bash
# Symlink agents and skills from this repo into ~/.cursor so git pull updates apply without reinstall.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CURSOR_HOME="${CURSOR_HOME:-$HOME/.cursor}"
AGENT_TARGET="$CURSOR_HOME/agents"
SKILL_TARGET="$CURSOR_HOME/skills"
MANIFEST="$CURSOR_HOME/cursor-engineering-team.manifest.json"

AGENT_SOURCE="$REPO_ROOT/agents"
SKILL_SOURCE="$REPO_ROOT/skills"

if [[ ! -d "$AGENT_SOURCE" ]]; then
  echo "Agents source not found: $AGENT_SOURCE" >&2
  exit 1
fi
if [[ ! -d "$SKILL_SOURCE" ]]; then
  echo "Skills source not found: $SKILL_SOURCE" >&2
  exit 1
fi

mkdir -p "$AGENT_TARGET" "$SKILL_TARGET"

installed_agents=()
installed_skills=()

link_file() {
  local src="$1"
  local dest="$2"
  if [[ -e "$dest" || -L "$dest" ]]; then
    rm -f "$dest"
  fi
  ln -s "$src" "$dest"
}

for f in "$AGENT_SOURCE"/*.md; do
  [[ -f "$f" ]] || continue
  name="$(basename "$f")"
  link_file "$f" "$AGENT_TARGET/$name"
  installed_agents+=("$name")
  echo "Linked agent: $name"
done

for dir in "$SKILL_SOURCE"/*/; do
  [[ -d "$dir" ]] || continue
  name="$(basename "$dir")"
  dest="$SKILL_TARGET/$name"
  if [[ -L "$dest" || -d "$dest" ]]; then
    rm -rf "$dest"
  fi
  ln -s "$dir" "$dest"
  installed_skills+=("$name")
  echo "Linked skill: $name"
done

# Orphan cleanup from previous copy-based install manifest
if [[ -f "$MANIFEST" ]] && command -v jq >/dev/null 2>&1; then
  while IFS= read -r stale; do
    [[ -z "$stale" ]] && continue
    if [[ " ${installed_agents[*]} " != *" $stale "* ]]; then
      rm -f "$AGENT_TARGET/$stale"
      echo "Removed stale agent: $stale"
    fi
  done < <(jq -r '.agents[]?' "$MANIFEST" 2>/dev/null || true)

  while IFS= read -r stale; do
    [[ -z "$stale" ]] && continue
    if [[ " ${installed_skills[*]} " != *" $stale "* ]]; then
      rm -rf "$SKILL_TARGET/$stale"
      echo "Removed stale skill: $stale"
    fi
  done < <(jq -r '.skills[]?' "$MANIFEST" 2>/dev/null || true)
fi

installed_at="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
if command -v jq >/dev/null 2>&1; then
  agents_json=$(printf '%s\n' "${installed_agents[@]}" | jq -R . | jq -s .)
  skills_json=$(printf '%s\n' "${installed_skills[@]}" | jq -R . | jq -s .)
  jq -n \
    --arg installedAt "$installed_at" \
    --arg source "$REPO_ROOT" \
    --argjson agents "$agents_json" \
    --argjson skills "$skills_json" \
    '{installedAt: $installedAt, source: $source, mode: "symlink", agents: $agents, skills: $skills}' \
    > "$MANIFEST"
else
  agents_csv=$(IFS=,; echo "${installed_agents[*]}")
  skills_csv=$(IFS=,; echo "${installed_skills[*]}")
  cat > "$MANIFEST" <<EOF
{"installedAt":"$installed_at","source":"$REPO_ROOT","mode":"symlink","agentsNote":"$agents_csv","skillsNote":"$skills_csv"}
EOF
fi

echo ""
echo "Symlink install complete."
echo "Agents: $AGENT_TARGET"
echo "Skills: $SKILL_TARGET"
echo "Pull this repo to update linked content; restart Cursor if agents/skills do not refresh."
