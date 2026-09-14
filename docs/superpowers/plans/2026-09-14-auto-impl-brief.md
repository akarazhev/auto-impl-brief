# Auto Implementation Brief Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build and publish a reusable Codex skill with `brief` and `execute` modes, together with a portable Markdown implementation-brief template.

**Architecture:** The repository root is an installable Codex skill. `SKILL.md` defines mode selection and execution behaviour, while `templates/implementation-brief.md` is the canonical portable contract used by brief mode. A dependency-free POSIX shell validator checks package structure and cross-file invariants; documentation and a neutral example make the project usable without the skill.

**Tech Stack:** Markdown, YAML, POSIX shell, Git, Codex skills.

## Global Constraints

- The package name and skill name are exactly `auto-impl-brief`.
- Support both explicit modes: `brief` and `execute`.
- Infer `brief` for requests to prepare or generate an assignment and `execute` for requests to implement or complete work; ask one concise question only when the intent remains ambiguous.
- Remain independent of every target project, organization, programming language, and repository layout.
- Treat only `OBJECTIVE` as universally required; derive repository context when already inside the target repository.
- Read applicable repository instructions and Git status before editing in execute mode.
- Preserve unrelated and untracked work and avoid destructive Git operations.
- Do not push, create pull requests, deploy, publish, or otherwise mutate remote state without explicit authorization.
- Use test-driven implementation and fresh verification evidence before completion claims.
- Limit concurrent implementation subagents to three and re-verify their combined work at the root.
- Prefer deterministic validation and cost-efficient models for routine isolated tasks; escalate reasoning only for security-critical work, stubborn failures, integration, or adversarial final review.
- Never invent unavailable project facts, successful checks, credentials, or external state.
- Distribute the project under Apache License 2.0.

---

## File Map

- `SKILL.md`: installable skill metadata, mode inference, brief generation, execute workflow, safety defaults, and output contracts.
- `agents/openai.yaml`: Codex-facing display metadata.
- `.gitignore`: excludes local IDE and operating-system metadata without deleting user files.
- `templates/implementation-brief.md`: canonical project-neutral prompt with user-replaceable fields and autonomous execution rules.
- `tests/validate.sh`: dependency-free structural and semantic validation with `skill`, `template`, `docs`, and `all` scopes.
- `examples/complete-project-example.md`: fully resolved neutral example with no unresolved template fields.
- `README.md`: installation, invocation, inputs, safety defaults, validation, and contribution instructions.
- `LICENSE`: canonical Apache License 2.0 text.
- `docs/design.md`: approved design; modify only if implementation discovers a genuine contradiction.

## Task 1: Skill Contract and Package Metadata

**Files:**

- Create: `tests/validate.sh`
- Create: `SKILL.md`
- Create: `agents/openai.yaml`
- Create: `.gitignore`

**Interfaces:**

- Consumes: the approved behavioural contract in `docs/design.md`.
- Produces: the `$auto-impl-brief` entry point and `sh tests/validate.sh skill` validation interface.

- [ ] **Step 1: Add the failing skill-package validator**

Create `tests/validate.sh`, mark it executable, and use this exact dependency-free harness:

```sh
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
  text=$2
  grep -Fq -- "$text" "$repo_root/$file" || fail "$file is missing: $text"
}

reject_literal() {
  file=$1
  text=$2
  if grep -Fq -- "$text" "$repo_root/$file"; then
    fail "$file contains forbidden text: $text"
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
  require_literal "templates/implementation-brief.md" "Dependency graph"
  require_literal "templates/implementation-brief.md" "Final report"
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
```

- [ ] **Step 2: Run the validator and confirm the intended failure**

Run:

```bash
chmod +x tests/validate.sh
sh tests/validate.sh skill
```

Expected: exit 1 with `FAIL: missing file: SKILL.md`.

- [ ] **Step 3: Add safe local-file exclusions**

Create `.gitignore` exactly as follows. Do not delete an existing `.idea/` directory; ignore it in Git only.

```gitignore
.DS_Store
.idea/
```

- [ ] **Step 4: Add the skill metadata**

Create `agents/openai.yaml` exactly as follows:

```yaml
interface:
  display_name: "Auto Implementation Brief"
  short_description: "Generate or execute evidence-driven implementation briefs"
```

- [ ] **Step 5: Add the core skill instructions**

Create `SKILL.md` with YAML front matter and these required sections and rules:

```markdown
---
name: auto-impl-brief
description: Generate a self-contained implementation assignment for a clean Codex session, or execute a complex repository task autonomously using an evidence-driven engineering loop, dependency graph, bounded subagents, and explicit safety constraints. Use when a user asks for an implementation brief, autonomous implementation, systematic completion of a specification, or reusable execution instructions.
---

# Auto Implementation Brief

Turn a goal into a complete execution contract or apply that contract directly. Remain project-neutral and preserve user authority over remote and destructive actions.

## Mode selection

Use an explicit mode when supplied:

- `mode: brief` produces one self-contained prompt for a clean Codex session.
- `mode: execute` performs the work in the current session.

Without an explicit mode, infer `brief` from requests to prepare, write, or generate an assignment. Infer `execute` from requests to implement, fix, build, or complete work. If both remain plausible, ask one concise question and do not alter files before the answer.

## Normalize the request

Collect the following fields from the request and available repository context:

- `OBJECTIVE` — required outcome;
- `REPOSITORY` — target path or repository reference;
- `STARTING_POINT` — branch, tag, or commit when relevant;
- `SPECIFICATIONS` — governing documents and requirements;
- `CONSTRAINTS` — technical, security, cost, and operational limits;
- `ACCEPTANCE_CRITERIA` — observable completion conditions;
- `MODEL_POLICY` — optional orchestration and escalation policy;
- `GIT_AND_PUBLISH_POLICY` — allowed commits and remote actions;
- `EXTERNAL_INPUTS` — separately supplied credentials, systems, profiles, or datasets.

Only `OBJECTIVE` is universally required. Derive repository facts when already inside the target repository. Make safe, reversible assumptions when they do not change scope. Never invent missing paths, credentials, test results, external state, or authorization.

## Brief mode

Read `templates/implementation-brief.md` completely. Replace every template field with supplied facts, derived repository facts, an explicit safe default, or `Not supplied — resolve before the dependent step`. Remove instructional comments and return one copyable prompt.

The generated brief must be self-contained. It must not rely on this skill, prior conversation, or unstated project knowledge. Preserve material user constraints verbatim. Make acceptance criteria observable and distinguish required checks from environment-dependent checks.

Do not execute the generated assignment unless the user separately asks to do so.

## Execute mode

### Inspect first

Read applicable `AGENTS.md`, `CLAUDE.md`, repository documentation, referenced specifications, and current Git status before editing. Establish a fresh test baseline. Preserve unrelated tracked and untracked work.

### Build the dependency graph

For multi-step work, create bounded nodes with an ID, outcome, dependencies, owned files, acceptance checks, status, evidence, commit when applicable, and residual risks. A node is ready only after every dependency is verified.

Keep graph state in the conversation or an existing project-approved tracking location. Do not add process artifacts to the target repository unless requested or required by its instructions.

### Use the engineering loop

For every implementation node use:

`Inspect → Define → Test first → Implement → Verify locally → Review diff → Verify broadly → Record evidence → Integrate`

On failure, return to inspection and diagnosis. Do not weaken assertions, suppress required failures, remove required checks, or relabel required behaviour as optional to obtain a passing result.

### Delegate bounded work

Use applicable planning, testing, debugging, review, and verification skills when available. Delegate independent ready nodes when useful, with no more than three implementation subagents running concurrently. Give each subagent exact dependencies, file ownership, acceptance criteria, verification commands, and prohibited actions.

Do not delegate overlapping shared schemas, migrations, integration contracts, or the same files concurrently. Re-run the union of affected tests and review the combined diff after integration. The root agent remains accountable for all completion claims.

### Apply model economy

Use the strongest available reasoning capability for architecture, security boundaries, integration, difficult diagnosis, and final adversarial review. Use a cost-efficient coding model for isolated routine implementation and tests. Escalate reasoning only when evidence shows it is needed. Prefer deterministic tools and tests over redundant model review.

If model selection is unavailable, continue with the configured model and preserve the same escalation discipline through review depth and reasoning effort.

### Protect the repository and external systems

Do not push, create a pull request, deploy, publish, send messages, or mutate other remote state without explicit authorization. Do not perform destructive Git or filesystem operations unless they are clearly requested and their exact targets are verified.

Inspect staged content before every commit. Never commit credentials, private external inputs, generated sensitive evidence, or unrelated user files. Treat tool absence honestly and continue independent graph branches where possible.

### Verify completion

Use focused tests per node and broad integration verification at phase gates. Before declaring success, gather fresh verification evidence, inspect the final diff, map results to every acceptance criterion, and report final Git status.

A genuine blocker requires new authority, credentials, unavailable mandatory external state, a destructive out-of-scope action, or a material unresolved product decision. Engineering difficulty or a failing test is not itself a blocker.

## Output contracts

Brief mode returns only the self-contained assignment, preceded by a one-sentence usage note when helpful.

Execute mode leads with the outcome and reports changed behaviour, important files, exact verification results, acceptance coverage, unavailable checks, residual risks, commits, remote actions, and final Git status. Never claim checks that were not run.
```

- [ ] **Step 6: Run the focused validation**

Run: `sh tests/validate.sh skill`

Expected: `PASS: skill`.

- [ ] **Step 7: Inspect and commit Task 1**

Run:

```bash
git diff --check
git status --short
git add .gitignore SKILL.md agents/openai.yaml tests/validate.sh
git diff --cached --check
git commit -m "feat: add auto implementation skill"
```

Expected: one commit containing only the skill contract, metadata, and validator.

## Task 2: Portable Implementation-Brief Template

**Files:**

- Create: `templates/implementation-brief.md`
- Modify: `tests/validate.sh`

**Interfaces:**

- Consumes: normalized fields and brief-mode rules from `SKILL.md`.
- Produces: a standalone prompt that remains usable without installing the skill.

- [ ] **Step 1: Confirm the template scope fails before implementation**

Run: `sh tests/validate.sh template`

Expected: exit 1 with `FAIL: missing file: templates/implementation-brief.md`.

- [ ] **Step 2: Add the canonical template**

Create `templates/implementation-brief.md`. It must contain the following exact structure and rules; retain the double-braced fields because they are the public template interface:

```markdown
# Autonomous Implementation Assignment

## Mission

You are responsible for completing this task from inspection through implementation, verification, integration, and final reporting. Do not stop after planning, scaffolding, or partial implementation.

## Inputs

- Objective: {{OBJECTIVE}}
- Repository: {{REPOSITORY}}
- Starting point: {{STARTING_POINT}}
- Specifications: {{SPECIFICATIONS}}
- Constraints: {{CONSTRAINTS}}
- Acceptance criteria: {{ACCEPTANCE_CRITERIA}}
- Model policy: {{MODEL_POLICY}}
- Git and publication policy: {{GIT_AND_PUBLISH_POLICY}}
- External inputs: {{EXTERNAL_INPUTS}}

Treat explicitly supplied values as authoritative. Resolve repository facts by inspection. Do not invent missing paths, credentials, permissions, test results, or external state.

## Initial inspection

Before editing:

1. Read every applicable `AGENTS.md`, `CLAUDE.md`, and repository instruction.
2. Inspect Git status and recent relevant history.
3. Read the supplied specifications completely.
4. Map the files, architecture, tests, build commands, and current behaviour relevant to the objective.
5. Run an appropriate baseline without altering or hiding pre-existing failures.

Preserve unrelated tracked and untracked user work.

## Dependency graph

For multi-step work, maintain a dependency graph whose nodes record:

- node ID and outcome;
- dependencies and readiness;
- owned files and assigned agent;
- acceptance checks and current status;
- verification evidence and commit when applicable;
- blockers and residual risks.

Execute only ready nodes. After integration, update the graph and select the next ready work. Continue independent branches when another branch is externally blocked.

## Engineering loop

For every implementation node use:

`Inspect → Define → Test first → Implement → Verify locally → Review diff → Verify broadly → Record evidence → Integrate`

When verification fails, inspect and diagnose before changing code. Do not weaken tests, suppress required failures, remove required checks, or redefine required behaviour merely to obtain a pass.

## Subagents and integration

Use applicable planning, testing, debugging, review, and verification skills. Delegate independent bounded nodes when useful, with at most three implementation subagents concurrently.

Every delegated node must specify dependencies, exact scope, file ownership, acceptance criteria, required verification, expected response, and prohibited actions. Avoid concurrent ownership of shared schemas, migrations, integration contracts, or overlapping files.

The root agent owns architectural consistency and completion. Review every returned diff and re-run the combined affected tests after integration.

## Quality and model economy

Apply this supplied policy: {{MODEL_POLICY}}

When the policy does not select concrete models, use the strongest available reasoning capability for architecture, security boundaries, integration, difficult diagnosis, and final adversarial review. Use a cost-efficient coding model for isolated routine work. Escalate reasoning only where evidence justifies it. Prefer deterministic tools and tests over redundant model review.

## Safety and authority

Apply this Git and publication policy: {{GIT_AND_PUBLISH_POLICY}}

Without explicit authorization, do not push, create pull requests, deploy, publish, send messages, or mutate remote systems. Do not perform destructive Git or filesystem actions unless clearly requested and exact targets are verified.

Inspect every staged diff before committing. Do not commit credentials, private external inputs, sensitive generated evidence, build artifacts, or unrelated user files.

## Verification

Use test-driven development for features and defect fixes. Run focused tests for each node, the union of affected tests after integration, and broad repository verification at phase gates. Run environment-dependent smoke tests only when their prerequisites are available and record unavailable checks accurately.

Before claiming completion:

1. inspect the final combined diff;
2. run fresh broad verification;
3. map evidence to every acceptance criterion;
4. verify documentation against actual behaviour;
5. inspect staged content and final Git status;
6. perform an adversarial review of security and trust boundaries when relevant.

## Blocking policy

Do not stop for ordinary complexity, implementation failures, or missing optional tools. Diagnose failures and continue ready work.

Stop only when progress requires new authority, credentials, unavailable mandatory external state, a destructive out-of-scope action, or a material product decision unresolved by the supplied specification. Report the exact blocked dependency and complete all independent work first.

## Completion standard

The assignment is complete only when all supplied acceptance criteria are implemented and backed by fresh evidence, documentation matches behaviour, relevant integrations pass, and no required work remains.

## Final report

Lead with the outcome and include:

1. completed graph nodes or work units;
2. important behavioural and architectural changes;
3. changed files and logical commits;
4. exact verification commands and results;
5. acceptance-criteria mapping;
6. environment-dependent checks that could not run;
7. residual risks and recommended follow-up;
8. external or remote actions performed under explicit authority;
9. final Git status;
10. confirmation that unrelated work and private inputs were preserved.
```

- [ ] **Step 3: Tighten the validator for accidental template drift**

In `validate_template()`, after the existing final-report assertion, add:

```sh
  require_literal "templates/implementation-brief.md" "Do not stop after planning, scaffolding, or partial implementation."
  require_literal "templates/implementation-brief.md" "at most three implementation subagents concurrently"
  require_literal "templates/implementation-brief.md" "Without explicit authorization, do not push"
  require_literal "templates/implementation-brief.md" "map evidence to every acceptance criterion"
```

- [ ] **Step 4: Run the focused validation**

Run: `sh tests/validate.sh template`

Expected: `PASS: template`.

- [ ] **Step 5: Inspect and commit Task 2**

Run:

```bash
git diff --check
git add templates/implementation-brief.md tests/validate.sh
git diff --cached --check
git commit -m "feat: add portable implementation brief"
```

Expected: one commit containing the canonical prompt and its semantic checks.

## Task 3: Neutral Worked Example

**Files:**

- Create: `examples/complete-project-example.md`
- Modify: `tests/validate.sh`

**Interfaces:**

- Consumes: every input field from `templates/implementation-brief.md`.
- Produces: a copyable neutral example with no unresolved double-braced fields.

- [ ] **Step 1: Confirm the documentation scope fails before implementation**

Run: `sh tests/validate.sh docs`

Expected: exit 1; the first missing documentation file may be `README.md`, `LICENSE`, or `examples/complete-project-example.md` depending on validator order.

- [ ] **Step 2: Add a fully resolved example**

Create `examples/complete-project-example.md` using a fictional repository `/workspace/sample-service`. The example must request a rate-limited health endpoint, require tests and documentation, prohibit remote mutation, and use this complete input block:

````markdown
# Example: Complete a Bounded Repository Change

This example shows how to specialize the portable template. The repository and task are fictional.

```text
mode: brief

OBJECTIVE:
Add an authenticated, rate-limited `/health/details` endpoint that reports dependency status without exposing credentials or internal connection strings.

REPOSITORY:
/workspace/sample-service

STARTING_POINT:
Current checked-out branch and commit. Inspect and record both before editing.

SPECIFICATIONS:
- Read all repository instructions.
- Follow the existing HTTP routing and authentication architecture.
- Preserve the existing public `/health` response.

CONSTRAINTS:
- Use existing runtime dependencies unless a new dependency is demonstrably necessary.
- Never include secrets, raw exception messages, or connection strings in responses or logs.
- Preserve unrelated tracked and untracked work.

ACCEPTANCE_CRITERIA:
- Anonymous requests receive the existing unauthorized response.
- Authorized requests receive deterministic JSON with an overall state and bounded per-dependency states.
- Rate limiting uses the repository's existing mechanism.
- Unit and integration tests cover authorization, redaction, healthy dependencies, and degraded dependencies.
- Operator documentation describes the endpoint and response without publishing credentials.

MODEL_POLICY:
Use a strong reasoning model for architecture, security boundaries, integration, and final adversarial review. Use a cost-efficient coding model for isolated tests and routine implementation. Escalate only when evidence justifies it.

GIT_AND_PUBLISH_POLICY:
Local logical commits are allowed after staged-diff review. Do not push, create a pull request, deploy, or publish without separate explicit authorization.

EXTERNAL_INPUTS:
No credentials are required. Use test doubles for dependency checks. Report any real integration environment as unavailable rather than inventing results.
```

Expected brief-mode result: one self-contained assignment based on `templates/implementation-brief.md`, with every field above resolved and no dependency on prior conversation.
````

Use four backticks for the outer code fence when authoring this file so the nested `text` fence renders correctly.

- [ ] **Step 3: Add example-specific assertions**

Append these checks to `validate_docs()` after the unresolved-field check:

```sh
  require_literal "examples/complete-project-example.md" "The repository and task are fictional."
  require_literal "examples/complete-project-example.md" "/workspace/sample-service"
  require_literal "examples/complete-project-example.md" "Do not push, create a pull request, deploy, or publish"
```

- [ ] **Step 4: Run a temporary focused example check**

Because `README.md` and `LICENSE` intentionally arrive in Task 4, run:

```bash
test -f examples/complete-project-example.md
! grep -Eq '\{\{[A-Z_]+\}\}' examples/complete-project-example.md
grep -Fq '/workspace/sample-service' examples/complete-project-example.md
```

Expected: exit 0 with no output.

- [ ] **Step 5: Inspect and commit Task 3**

Run:

```bash
git diff --check
git add examples/complete-project-example.md tests/validate.sh
git diff --cached --check
git commit -m "docs: add neutral implementation example"
```

Expected: one commit containing only the neutral example and its assertions.

## Task 4: Public Documentation and License

**Files:**

- Create: `README.md`
- Create: `LICENSE`
- Modify: `tests/validate.sh`

**Interfaces:**

- Consumes: invocation and input contracts from `SKILL.md` and `templates/implementation-brief.md`.
- Produces: installation and operation guidance for both skill and no-install workflows.

- [ ] **Step 1: Add README-specific validation before the file exists**

In `validate_docs()`, add these assertions immediately after `require_file "README.md"`:

```sh
  require_literal "README.md" "git clone https://github.com/akarazhev/auto-impl-brief.git"
  require_literal "README.md" "templates/implementation-brief.md"
  require_literal "README.md" "Apache-2.0"
```

Run: `sh tests/validate.sh docs`

Expected: exit 1 because `README.md` or `LICENSE` is missing.

- [ ] **Step 2: Write the README**

Create `README.md` with these sections in order:

1. title and one-paragraph purpose;
2. “Choose a workflow” comparing `mode: brief`, `mode: execute`, and direct use of `templates/implementation-brief.md`;
3. “Install as a personal Codex skill” with the commands below;
4. “Use” with complete brief- and execute-mode invocations;
5. “Inputs” defining all nine public fields and stating that only `OBJECTIVE` is universally required;
6. “Safety defaults” covering dirty-worktree preservation, no destructive Git, no unauthorized remote mutation, evidence-backed completion, and bounded subagents;
7. “Model economy” describing role-based escalation without requiring specific model names;
8. “Validate” containing `sh tests/validate.sh all`;
9. “License” identifying Apache-2.0.

Use these exact installation commands:

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
git clone https://github.com/akarazhev/auto-impl-brief.git \
  "${CODEX_HOME:-$HOME/.codex}/skills/auto-impl-brief"
```

State that users with an existing clone may instead link that repository into the same skills directory, but must not overwrite an existing path automatically. In “Safety defaults”, include the exact sentence: `The default policy allows no unauthorized remote mutation.`

- [ ] **Step 3: Add the canonical Apache License 2.0**

Create `LICENSE` using the unmodified canonical text from `https://www.apache.org/licenses/LICENSE-2.0.txt`. Verify that it begins with:

```text
                                 Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/
```

Verify that it contains `END OF TERMS AND CONDITIONS` and retains the canonical `APPENDIX: How to apply the Apache License to your work` section. Do not add a project-specific copyright line to the license body.

- [ ] **Step 4: Run documentation validation**

Run: `sh tests/validate.sh docs`

Expected: `PASS: docs`.

- [ ] **Step 5: Check public files for local-path leakage**

Run:

```bash
if rg -n '/Users/|C:\\Users\\|Developer/' README.md SKILL.md templates examples docs/design.md; then
  exit 1
fi
```

Expected: exit 0 with no matches.

- [ ] **Step 6: Inspect and commit Task 4**

Run:

```bash
git diff --check
git add README.md LICENSE tests/validate.sh
git diff --cached --check
git commit -m "docs: document installation and usage"
```

Expected: one commit containing README, license, and documentation assertions.

## Task 5: Cross-File Consistency and Installation Verification

**Files:**

- Modify: `tests/validate.sh`
- Modify: `README.md` only if verification exposes an incorrect command.
- Modify: `SKILL.md` or `templates/implementation-brief.md` only if cross-file verification exposes a specification inconsistency.

**Interfaces:**

- Consumes: all repository deliverables.
- Produces: one reproducible full validation command and a locally discoverable personal skill.

- [ ] **Step 1: Add cross-file consistency checks**

Add this function before the `scope` assignment in `tests/validate.sh`:

```sh
validate_consistency() {
  for field in OBJECTIVE REPOSITORY STARTING_POINT SPECIFICATIONS CONSTRAINTS ACCEPTANCE_CRITERIA MODEL_POLICY GIT_AND_PUBLISH_POLICY EXTERNAL_INPUTS; do
    require_literal "SKILL.md" "$field"
    require_literal "templates/implementation-brief.md" "{{$field}}"
  done
  require_literal "SKILL.md" "Do not push"
  require_literal "templates/implementation-brief.md" "do not push"
  require_literal "README.md" "no unauthorized remote"
}
```

Update the `all)` branch to call `validate_consistency` after `validate_docs`. Add a `consistency)` branch that calls only `validate_consistency`.

- [ ] **Step 2: Run the consistency scope and fix only demonstrated mismatches**

Run: `sh tests/validate.sh consistency`

Expected: `PASS: consistency`. If an exact case-sensitive wording assertion fails, make the smallest wording change that preserves the approved design, then rerun.

- [ ] **Step 3: Run syntax and full validation**

Run:

```bash
sh -n tests/validate.sh
sh tests/validate.sh skill
sh tests/validate.sh template
sh tests/validate.sh docs
sh tests/validate.sh consistency
sh tests/validate.sh all
git diff --check
```

Expected: every validation scope prints `PASS`, shell syntax exits 0, and the diff check has no output.

- [ ] **Step 4: Review the package as an adversarial clean user**

From a clean shell at the repository root, verify all of the following without relying on conversation history:

```bash
test -f SKILL.md
test -f agents/openai.yaml
test -f templates/implementation-brief.md
```

Then manually confirm:

- brief mode directs the agent to return a standalone assignment and not execute it;
- execute mode directs the agent to inspect, build a graph, test first, implement, and verify;
- missing permissions cannot be inferred;
- a dirty worktree is preserved;
- absent optional tools do not become fabricated successes;
- ordinary test failures do not become blockers;
- the neutral example contains no unresolved double-braced fields.

- [ ] **Step 5: Install the local repository as the personal skill**

Resolve the personal skills root as `${CODEX_HOME:-$HOME/.codex}/skills`. Check whether `auto-impl-brief` already exists. If it exists, stop this installation step and report the collision without overwriting it. Otherwise create a symbolic link from the absolute repository root to `<skills-root>/auto-impl-brief`.

Verify:

```bash
test -f "${CODEX_HOME:-$HOME/.codex}/skills/auto-impl-brief/SKILL.md"
test -f "${CODEX_HOME:-$HOME/.codex}/skills/auto-impl-brief/agents/openai.yaml"
```

Expected: both commands exit 0. Restart Codex when required for skill discovery.

- [ ] **Step 6: Commit verification hardening**

If Task 5 changed tracked files, run:

```bash
git diff --check
git add tests/validate.sh README.md SKILL.md templates/implementation-brief.md
git diff --cached --check
git commit -m "test: verify skill package consistency"
```

Do not create an empty commit when no tracked files changed.

- [ ] **Step 7: Verify Git state and publish authorized commits**

Run:

```bash
git status --short --branch
git log --oneline --decorate -6
git push origin main
git status --short --branch
```

Expected: `main` is synchronized with `origin/main`, the worktree is clean, and only the intended public files appear in history.

## Acceptance Mapping

- Installable personal skill: Tasks 1 and 5.
- Portable Markdown template: Task 2.
- Explicit and inferred `brief`/`execute` modes: Task 1.
- Project-neutral specialization example: Task 3.
- Safe Git, external-action, evidence, graph, delegation, and model-economy rules: Tasks 1 and 2.
- Apache-2.0 public distribution and user documentation: Task 4.
- Structural, semantic, consistency, and leakage checks: Tasks 1 through 5.
- Public GitHub delivery: Task 5.
