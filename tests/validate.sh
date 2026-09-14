#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

require_file() {
  test -f "$repo_root/$1" || fail "missing file: $1"
}

require_executable() {
  test -x "$repo_root/$1" || fail "not executable: $1"
}

require_literal() {
  file=$1
  expected=$2
  grep -Fq -- "$expected" "$repo_root/$file" || fail "$file is missing a required contract value"
}

reject_literal() {
  file=$1
  forbidden=$2
  if grep -Fq -- "$forbidden" "$repo_root/$file"; then
    fail "$file contains a machine-specific path"
  fi
}

validate_skill() {
  require_file "SKILL.md"
  require_file "agents/openai.yaml"
  require_file ".gitignore"
  require_executable "tests/validate.sh"

  require_literal ".gitignore" ".idea/"
  require_literal ".gitignore" ".DS_Store"
  require_literal "SKILL.md" "name: auto-impl-brief"
  require_literal "SKILL.md" "## Mode selection"
  require_literal "SKILL.md" '`mode: brief`'
  require_literal "SKILL.md" '`mode: execute`'
  require_literal "SKILL.md" "Inspect → Define → Test first → Implement"
  require_literal "SKILL.md" "three implementation subagents"
  require_literal "SKILL.md" "Do not push"
  require_literal "SKILL.md" "fresh verification evidence"
  require_literal "agents/openai.yaml" 'display_name: "Auto Implementation Brief"'
  require_literal "agents/openai.yaml" 'short_description: "Generate or execute evidence-driven implementation briefs"'
}

validate_template() {
  require_file "templates/implementation-brief.md"

  for field in OBJECTIVE REPOSITORY STARTING_POINT SPECIFICATIONS CONSTRAINTS ACCEPTANCE_CRITERIA MODEL_POLICY GIT_AND_PUBLISH_POLICY EXTERNAL_INPUTS; do
    require_literal "templates/implementation-brief.md" "{{$field}}"
  done

  require_literal "templates/implementation-brief.md" "Inspect → Define → Test first → Implement"
  require_literal "templates/implementation-brief.md" "## Dependency graph"
  require_literal "templates/implementation-brief.md" "## Final report"
  require_literal "templates/implementation-brief.md" "Do not stop after planning, scaffolding, or partial implementation."
  require_literal "templates/implementation-brief.md" "at most three implementation subagents concurrently"
  require_literal "templates/implementation-brief.md" "Without explicit authorization, do not push"
  require_literal "templates/implementation-brief.md" "map evidence to every acceptance criterion"
  reject_literal "templates/implementation-brief.md" "/Users/"
  reject_literal "templates/implementation-brief.md" "C:\\Users\\"
}

validate_docs() {
  require_file "README.md"
  require_file "LICENSE"
  require_file "examples/complete-project-example.md"

  require_literal "README.md" '$auto-impl-brief'
  require_literal "README.md" "mode: brief"
  require_literal "README.md" "mode: execute"
  require_literal "README.md" "sh tests/validate.sh all"
  require_literal "LICENSE" "Apache License"
  require_literal "LICENSE" "Version 2.0, January 2004"

  if grep -Eq '\{\{[A-Z_]+\}\}' "$repo_root/examples/complete-project-example.md"; then
    fail "example contains unresolved template fields"
  fi

  reject_literal "examples/complete-project-example.md" "/Users/"
  reject_literal "examples/complete-project-example.md" "C:\\Users\\"
}

scope=${1:-all}
case "$scope" in
  skill) validate_skill ;;
  template) validate_template ;;
  docs) validate_docs ;;
  all)
    validate_skill
    validate_template
    validate_docs
    ;;
  *) fail "unknown scope: $scope" ;;
esac

printf 'PASS: %s\n' "$scope"
