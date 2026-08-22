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

  pnpx skills@latest add -g -y vercel-labs/skills --skill find-skills
  pnpx skills@latest add -g -y vercel-labs/agent-browser
  pnpx skills@latest add -g -y https://github.com/anthropics/skills --skill skill-creator
  pnpx skills@latest add -g -y https://github.com/antfu/skills --skill "${antfu_skill_names[@]}"
  pnpx skills@latest add -g -y https://github.com/mattpocock/skills --skill "${mattpocock_skill_names[@]}"
  pnpx skills@latest add -g -y https://github.com/jeffallan/claude-skills --skill "${jeffallan_skill_names[@]}"
}

update_llm_skills() {
  pnpx skills@latest update -g
}
