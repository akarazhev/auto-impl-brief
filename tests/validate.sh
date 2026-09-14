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

reject_pattern_ci() {
  file=$1
  pattern=$2
  if grep -Eiq -- "$pattern" "$repo_root/$file"; then
    fail "$file contains retired product language"
  fi
}

validate_branding() {
  for file in README.md SKILL.md agents/openai.yaml protocol/implementation-brief.md examples/secure-endpoint-change.md docs/design.md docs/superpowers/plans/2026-09-14-auto-impl-brief.md; do
    require_file "$file"
    reject_pattern_ci "$file" 'portable|reusable|clean[[:space:]]+codex|handoff|evidence-driven[[:space:]]+software[[:space:]]+implementation|templates/implementation-brief|examples/complete-project-example|validate_template'
  done

  require_literal "README.md" '`auto-impl-brief` is a controlled implementation orchestration framework for Codex.'
  require_literal "docs/design.md" '`auto-impl-brief` is a controlled implementation orchestration framework for Codex.'
  require_literal "agents/openai.yaml" 'short_description: "Plan and run controlled software implementations"'
  require_literal "protocol/implementation-brief.md" "# Auto Implementation Protocol"
  test ! -e "$repo_root/templates" || fail "obsolete templates directory exists"
  test ! -e "$repo_root/examples/complete-project-example.md" || fail "obsolete example path exists"
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
  require_literal "agents/openai.yaml" 'short_description: "Plan and run controlled software implementations"'
}

validate_protocol() {
  require_file "protocol/implementation-brief.md"

  for field in OBJECTIVE REPOSITORY STARTING_POINT SPECIFICATIONS CONSTRAINTS ACCEPTANCE_CRITERIA MODEL_POLICY GIT_AND_PUBLISH_POLICY EXTERNAL_INPUTS; do
    require_literal "protocol/implementation-brief.md" "{{$field}}"
  done

  require_literal "protocol/implementation-brief.md" "Inspect → Define → Test first → Implement"
  require_literal "protocol/implementation-brief.md" "## Dependency graph"
  require_literal "protocol/implementation-brief.md" "## Final report"
  require_literal "protocol/implementation-brief.md" "Do not stop after planning, scaffolding, or partial implementation."
  require_literal "protocol/implementation-brief.md" "at most three implementation subagents concurrently"
  require_literal "protocol/implementation-brief.md" "Without explicit authorization, do not push"
  require_literal "protocol/implementation-brief.md" "map evidence to every acceptance criterion"
  reject_literal "protocol/implementation-brief.md" "/Users/"
  reject_literal "protocol/implementation-brief.md" "C:\\Users\\"
}

validate_docs() {
  require_file "README.md"
  require_literal "README.md" "git clone https://github.com/akarazhev/auto-impl-brief.git"
  require_literal "README.md" "protocol/implementation-brief.md"
  require_literal "README.md" "Apache-2.0"
  require_file "LICENSE"
  require_file "examples/secure-endpoint-change.md"

  require_literal "README.md" '$auto-impl-brief'
  require_literal "README.md" "mode: brief"
  require_literal "README.md" "mode: execute"
  require_literal "README.md" "sh tests/validate.sh all"
  require_literal "LICENSE" "Apache License"
  require_literal "LICENSE" "Version 2.0, January 2004"

  if grep -Eq '\{\{[A-Z_]+\}\}' "$repo_root/examples/secure-endpoint-change.md"; then
    fail "example contains unresolved protocol fields"
  fi

  require_literal "examples/secure-endpoint-change.md" "The repository and task are fictional."
  require_literal "examples/secure-endpoint-change.md" "/workspace/sample-service"
  require_literal "examples/secure-endpoint-change.md" "Do not push, create a pull request, deploy, or publish"
  reject_literal "examples/secure-endpoint-change.md" "/Users/"
  reject_literal "examples/secure-endpoint-change.md" "C:\\Users\\"
}

validate_consistency() {
  for field in OBJECTIVE REPOSITORY STARTING_POINT SPECIFICATIONS CONSTRAINTS ACCEPTANCE_CRITERIA MODEL_POLICY GIT_AND_PUBLISH_POLICY EXTERNAL_INPUTS; do
    require_literal "SKILL.md" "$field"
    require_literal "protocol/implementation-brief.md" "{{$field}}"
  done

  require_literal "SKILL.md" "Do not push"
  require_literal "protocol/implementation-brief.md" "do not push"
  require_literal "README.md" "no unauthorized remote"
}

scope=${1:-all}
case "$scope" in
  skill) validate_skill ;;
  protocol) validate_protocol ;;
  docs) validate_docs ;;
  branding) validate_branding ;;
  consistency) validate_consistency ;;
  all)
    validate_skill
    validate_protocol
    validate_docs
    validate_branding
    validate_consistency
    ;;
  *) fail "unknown scope: $scope" ;;
esac

printf 'PASS: %s\n' "$scope"
