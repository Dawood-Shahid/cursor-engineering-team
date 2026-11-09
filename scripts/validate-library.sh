#!/usr/bin/env bash
# Validate agents, skills, and rule templates in this repo.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
errors=0

fail() {
  echo "ERROR: $*" >&2
  errors=$((errors + 1))
}

check_frontmatter() {
  local file="$1"
  local require_name="${2:-false}"
  if ! head -n 1 "$file" | grep -q '^---$'; then
    fail "$file: missing YAML frontmatter"
    return
  fi
  if ! grep -q '^description:' "$file"; then
    fail "$file: missing description in frontmatter"
  fi
  if [[ "$require_name" == "true" ]] && ! grep -q '^name:' "$file"; then
    fail "$file: missing name in frontmatter"
  fi
  local name_line
  name_line=$(grep -m1 '^name:' "$file" | sed 's/^name:\s*//;s/^>//;s/["'\'']//g' | tr -d ' ')
  if [[ -n "$name_line" && "$name_line" =~ [^a-z0-9-] ]]; then
    fail "$file: name must be lowercase letters, numbers, hyphens only (got: $name_line)"
  fi
  local desc_bytes
  desc_bytes=$(awk '/^description:/{f=1; sub(/^description:\s*/,""); print; next} f&&/^[^ ]/{exit} f{print}' "$file" | wc -c)
  if [[ "$desc_bytes" -gt 1024 ]]; then
    fail "$file: description may exceed 1024 chars (approx $desc_bytes bytes)"
  fi
}

for agent in "$REPO_ROOT"/agents/*.md; do
  [[ -f "$agent" ]] || continue
  check_frontmatter "$agent" true
done

for skill in "$REPO_ROOT"/skills/*/SKILL.md; do
  [[ -f "$skill" ]] || continue
  check_frontmatter "$skill" true
  lines=$(wc -l < "$skill")
  if [[ "$lines" -gt 500 ]]; then
    fail "$skill: $lines lines (max 500 recommended)"
  fi
done

for rule in "$REPO_ROOT"/templates/*.mdc; do
  [[ -f "$rule" ]] || continue
  if ! head -n 1 "$rule" | grep -q '^---$'; then
    fail "$rule: missing frontmatter"
  fi
  if ! grep -q '^description:' "$rule"; then
    fail "$rule: missing description"
  fi
  lines=$(wc -l < "$rule")
  if [[ "$lines" -gt 500 ]]; then
    fail "$rule: $lines lines (max 500)"
  fi
done

if [[ "$errors" -gt 0 ]]; then
  echo "Validation failed with $errors error(s)." >&2
  exit 1
fi

echo "Validation passed."
