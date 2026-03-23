# Expected skill id (matches "name" in skills ls --json) from an add spec.
_llm_skill_name_from_spec() {
  local spec="$1"
  if [[ "$spec" == *'--skill '* ]]; then
    local rest="${spec#*--skill }"
    echo "${rest%% *}"
  else
    local pkg="${spec%% *}"
    echo "${pkg##*/}"
  fi
}

# One installed skill name per line (global scope).
_llm_global_installed_skill_names() {
  pnpx skills@latest ls -g --json 2>/dev/null | python3 -c "
import json, sys
try:
    for x in json.load(sys.stdin):
        print(x['name'])
except Exception:
    pass
" 2>/dev/null
}

install_llm_skills() {
  local antfu_skill_names=(
    nuxt
    pnpm
    vite
    vitest
    vue
    vue-best-practices
    vue-router-best-practices
    vue-testing-best-practices
    vueuse-functions
    web-design-guidelines
  )

  local mattpocock_skill_names=(
    design-an-interface
    git-guardrails-claude-code
    grill-me
    improve-codebase-architecture
    prd-to-issues
    prd-to-plan
    request-refactor-plan
    setup-pre-commit
    tdd
    ubiquitous-language
    write-a-prd
    write-a-skill
  )

  local jeffallan_skill_names=(
    architecture-designer
    code-documenter
    code-reviewer
    database-optimizer
    debugging-wizard
    devops-engineer
    fullstack-guardian
    javascript-pro
    postgres-pro
    security-reviewer
    typescript-pro
    the-fool
  )

  local specs=(
    'vercel-labs/skills --skill find-skills'
    https://github.com/anthropics/skills --skill skill-creator
    'vercel-labs/agent-browser'
    'https://github.com/supabase/agent-skills --skill supabase-postgres-best-practices'

    "https://github.com/antfu/skills --skill ${(j: :)antfu_skill_names}"
    "https://github.com/mattpocock/skills --skill ${(j: :)mattpocock_skill_names}"
    "https://github.com/jeffallan/claude-skills --skill ${(j: :)jeffallan_skill_names}"
  )

  echo "Loading global installed skills…"
  echo
  local installed_names
  installed_names=$(_llm_global_installed_skill_names)

  echo "Attempting to install ${#specs[@]} skills…"
  echo

  local spec name
  local -a add_args
  local skipped=0 added=0
  for spec in "${specs[@]}"; do
    [[ -z "$spec" ]] && continue
    name=$(_llm_skill_name_from_spec "$spec")
    if printf '%s\n' "$installed_names" | grep -qxF "$name"; then
      echo "↓ [$name] skipped, already installed"
      (( skipped++ ))
      continue
    fi

    echo "[$name] installing…"

    add_args=(pnpx skills@latest add -g ${(z)spec})
    if "${add_args[@]}"; then
      echo "✅ [$name] installed"
      (( added++ ))
    else
      echo "❌ [$name] installation failed" >&2
    fi
  done

  echo
  echo "Finished (installed: $added, skipped: $skipped)"
}

update_llm_skills() {
  pnpx skills@latest update -g
}
