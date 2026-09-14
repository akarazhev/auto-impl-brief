# Standalone Product Language Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Present `auto-impl-brief` consistently as a standalone Codex implementation orchestration framework and move its canonical workflow contract to `protocol/`.

**Architecture:** Preserve the `brief` and `execute` behaviours while changing the product model exposed by README, skill metadata, protocol, example, validation, and design documentation. A new branding gate fails on compatibility-oriented language and obsolete paths. The initial-stage repository accepts the path and validation-scope changes without aliases.

**Tech Stack:** Markdown, YAML, POSIX shell, Git, GitHub CLI, Codex skills.

## Global Constraints

- Use the canonical positioning: “`auto-impl-brief` is a controlled implementation orchestration framework for Codex.”
- Use `implementation protocol`, `implementation brief`, `implementation run`, `verification gates`, and `authority boundaries` as canonical terms.
- Preserve the semantics and inputs of `brief` and `execute` modes.
- Rename the canonical contract to `protocol/implementation-brief.md`.
- Rename the example to `examples/secure-endpoint-change.md`.
- Replace the validation scope and function named for the former artifact type with `protocol` and `validate_protocol`.
- Do not add compatibility aliases; the project is still at its initial stage.
- Do not add runtime dependencies.
- Do not rewrite published Git history.
- Keep local editor metadata ignored and untouched.
- Do not modify any target repository.
- Update GitHub description only after local verification passes.

---

## File Map

- `README.md`: product identity, modes, installation, inputs, guarantees, validation, and development guidance.
- `SKILL.md`: concise discovery trigger, mode routing, and execution rules.
- `agents/openai.yaml`: UI-facing standalone product description.
- `protocol/implementation-brief.md`: canonical implementation protocol.
- `examples/secure-endpoint-change.md`: complete fictional framework invocation.
- `tests/validate.sh`: structure, protocol, branding, consistency, and aggregate validation scopes.
- `docs/design.md`: current architecture and product model.
- `docs/superpowers/plans/2026-09-14-auto-impl-brief.md`: initial implementation plan updated to current names and terminology.
- `docs/superpowers/specs/2026-09-14-standalone-product-rebrand-design.md`: approved design for this change.

## Task 1: Product Surfaces and Protocol Structure

**Files:**

- Modify: `tests/validate.sh`
- Modify: `README.md`
- Modify: `SKILL.md`
- Modify: `agents/openai.yaml`
- Rename: `templates/implementation-brief.md` → `protocol/implementation-brief.md`
- Rename: `examples/complete-project-example.md` → `examples/secure-endpoint-change.md`

**Interfaces:**

- Consumes: the mode and input contracts already implemented by `SKILL.md`.
- Produces: `brief`, `execute`, `protocol`, `branding`, `consistency`, and `all` validation interfaces using the new product model.

- [ ] **Step 1: Add the failing branding check**

Add a case-insensitive rejection helper to `tests/validate.sh`:

```sh
reject_pattern_ci() {
  file=$1
  pattern=$2
  if grep -Eiq -- "$pattern" "$repo_root/$file"; then
    fail "$file contains retired product language"
  fi
}
```

Add the initial check against current product surfaces:

```sh
validate_branding() {
  for file in README.md SKILL.md agents/openai.yaml templates/implementation-brief.md examples/complete-project-example.md; do
    require_file "$file"
    reject_pattern_ci "$file" 'portable|reusable|clean[[:space:]]+codex|handoff|evidence-driven[[:space:]]+software[[:space:]]+implementation'
  done
}
```

Add `branding) validate_branding ;;` to the scope case and call `validate_branding` from `all)`.

- [ ] **Step 2: Run the branding scope and observe RED**

Run: `sh tests/validate.sh branding`

Expected: exit 1 with `FAIL: README.md contains retired product language`.

- [ ] **Step 3: Rename the protocol and example with Git-aware moves**

Run:

```bash
mkdir -p protocol
git mv templates/implementation-brief.md protocol/implementation-brief.md
git mv examples/complete-project-example.md examples/secure-endpoint-change.md
```

Remove the empty `templates/` directory only if Git leaves it present and empty.

- [ ] **Step 4: Rewrite README product positioning**

Make the opening exactly:

```markdown
# auto-impl-brief

`auto-impl-brief` is a controlled implementation orchestration framework for Codex. It turns objectives and constraints into verified implementation briefs or autonomous implementation runs.
```

Rename “Choose a workflow” to “Modes” and define the product as follows:

```markdown
- **Brief mode** compiles the supplied objective, constraints, and acceptance criteria into a complete implementation brief.
- **Execute mode** runs the implementation protocol in the current repository and continues through verification.
- **Implementation protocol** defines the shared engineering loop, dependency graph, delegation rules, verification gates, and authority boundaries in [`protocol/implementation-brief.md`](protocol/implementation-brief.md).
```

Change the first brief-mode usage sentence to `Compile an implementation brief:`. Describe `protocol/implementation-brief.md` as the canonical protocol, not as an alternate distribution format. In Contributing, require current framework terminology and `sh tests/validate.sh all`.

- [ ] **Step 5: Rewrite skill discovery and routing language**

Set the frontmatter description exactly to:

```yaml
description: Use when a user wants Codex to prepare or run a structured implementation workflow for a complex repository task.
```

Set the first body paragraph to:

```markdown
`auto-impl-brief` is a controlled implementation orchestration framework for Codex. It compiles an implementation brief or performs an implementation run while preserving user authority over destructive and remote actions.
```

In mode selection use:

```markdown
- `mode: brief` compiles a complete implementation brief for a Codex session.
- `mode: execute` performs an implementation run in the current session.
```

In brief mode, read `protocol/implementation-brief.md`. Refer to its output as `the implementation brief` and retain all existing safety and completeness requirements.

- [ ] **Step 6: Update Codex UI metadata**

Keep the existing display name and set the short description exactly:

```yaml
interface:
  display_name: "Auto Implementation Brief"
  short_description: "Plan and run controlled software implementations"
```

- [ ] **Step 7: Align the protocol and example**

Change the protocol title and introduction to:

```markdown
# Auto Implementation Protocol

## Mission

Run a controlled software implementation from initial inspection through implementation, verification, integration, and final reporting. Do not stop after planning, scaffolding, or partial implementation.
```

Preserve every public input field and all execution, delegation, safety, blocking, and final-report rules.

Change the example introduction to:

```markdown
# Example: Secure Endpoint Change

This fictional scenario demonstrates `brief` mode for a bounded security change.
```

Change its final sentence to:

```markdown
Expected result: an implementation brief that conforms to `protocol/implementation-brief.md`, resolves every supplied field, and requires no unstated context.
```

- [ ] **Step 8: Update the validator to the new interfaces**

Apply these structural changes throughout `tests/validate.sh`:

```text
validate_template                         → validate_protocol
templates/implementation-brief.md         → protocol/implementation-brief.md
examples/complete-project-example.md      → examples/secure-endpoint-change.md
template) validate_template               → protocol) validate_protocol
```

Update `validate_branding()` to scan the renamed paths. Require the canonical README positioning, the new UI description, and the `# Auto Implementation Protocol` title. Reject the obsolete directory and example path:

```sh
test ! -e "$repo_root/templates" || fail "obsolete templates directory exists"
test ! -e "$repo_root/examples/complete-project-example.md" || fail "obsolete example path exists"
```

- [ ] **Step 9: Run focused GREEN verification**

Run:

```bash
sh -n tests/validate.sh
sh tests/validate.sh skill
sh tests/validate.sh protocol
sh tests/validate.sh docs
sh tests/validate.sh branding
sh tests/validate.sh consistency
sh tests/validate.sh all
git diff --check
```

Expected: every validation scope prints `PASS` and diff check exits 0 without output.

- [ ] **Step 10: Inspect and commit Task 1**

Run:

```bash
git status --short
git add README.md SKILL.md agents/openai.yaml protocol/implementation-brief.md examples/secure-endpoint-change.md tests/validate.sh
git add -u
git diff --cached --check
git diff --cached --stat
git commit -m "refactor: establish standalone product language"
```

Expected: one commit containing only the current product surfaces, path moves, and validation changes.

## Task 2: Design and Implementation Documentation

**Files:**

- Modify: `docs/design.md`
- Modify: `docs/superpowers/plans/2026-09-14-auto-impl-brief.md`
- Modify: `docs/superpowers/specs/2026-09-14-standalone-product-rebrand-design.md` only if current terminology or paths have drifted from the implementation.
- Modify: `tests/validate.sh`

**Interfaces:**

- Consumes: canonical vocabulary and paths established in Task 1.
- Produces: documentation consistent with the current standalone framework and covered by `branding` validation.

- [ ] **Step 1: Extend the branding test to design documentation**

Add `docs/design.md` and `docs/superpowers/plans/2026-09-14-auto-impl-brief.md` to the files scanned by `validate_branding()`.

- [ ] **Step 2: Run the extended test and observe RED**

Run: `sh tests/validate.sh branding`

Expected: exit 1 because at least one design document still contains retired terminology or an obsolete path.

- [ ] **Step 3: Rewrite the current design document**

Open `docs/design.md` with the canonical positioning. Describe the repository as an installable Codex execution framework with a canonical implementation protocol. Update the structure tree, modes, outputs, validation names, and every path to the Task 1 interfaces.

Preserve these technical decisions:

- only `OBJECTIVE` is universally required;
- both modes share the same protocol and safety defaults;
- execute mode uses dependency-aware work and verification gates;
- model selection is role-based and optional;
- Apache-2.0 remains the license;
- GitHub remains the canonical distribution repository.

- [ ] **Step 4: Align the initial implementation plan**

Update `docs/superpowers/plans/2026-09-14-auto-impl-brief.md` mechanically and editorially:

```text
templates/implementation-brief.md         → protocol/implementation-brief.md
validate_template                         → validate_protocol
template validation scope                 → protocol validation scope
Portable Implementation-Brief Template    → Implementation Protocol
portable contract                         → implementation protocol
portable Markdown template                → implementation protocol
reusable Codex skill                       → Codex execution framework
clean Codex session                        → Codex session
handoff                                    → implementation brief
```

Update embedded README, SKILL, validator, example, commands, file map, acceptance mapping, and expected commit messages so the document describes the current framework consistently. Do not change the original engineering decisions or acceptance coverage.

- [ ] **Step 5: Verify documentation vocabulary and paths**

Run:

```bash
sh tests/validate.sh branding
rg -ni 'portable|reusable|clean[[:space:]]+codex|handoff|evidence-driven[[:space:]]+software[[:space:]]+implementation|templates/implementation-brief|validate_template' README.md SKILL.md agents protocol examples docs/design.md docs/superpowers/plans/2026-09-14-auto-impl-brief.md
git diff --check
```

Expected: branding prints `PASS`; `rg` produces no matches; diff check exits 0 without output.

- [ ] **Step 6: Run all local validation and commit Task 2**

Run:

```bash
sh tests/validate.sh all
git add docs/design.md docs/superpowers/plans/2026-09-14-auto-impl-brief.md tests/validate.sh
git diff --cached --check
git diff --cached --stat
git commit -m "docs: align framework design and terminology"
```

If the approved specification required a terminology-only correction, stage it explicitly and include it in this documentation commit.

## Task 3: Skill Validation and Public Metadata

**Files:**

- Modify: tracked files only if final verification exposes a demonstrated inconsistency.
- External metadata: GitHub repository description.

**Interfaces:**

- Consumes: the complete framework package from Tasks 1 and 2.
- Produces: a validated installed skill and public repository whose metadata matches the canonical positioning.

- [ ] **Step 1: Run the complete local verification gate**

Run:

```bash
sh -n tests/validate.sh
sh tests/validate.sh skill
sh tests/validate.sh protocol
sh tests/validate.sh docs
sh tests/validate.sh branding
sh tests/validate.sh consistency
sh tests/validate.sh all
git diff --check
```

Expected: all scopes print `PASS`; shell syntax and diff checks exit 0.

- [ ] **Step 2: Run the official Codex skill validator**

Resolve the installed `skill-creator` directory and run:

```bash
uv --cache-dir /tmp/auto-impl-brief-uv-cache run --with pyyaml python "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-creator/scripts/quick_validate.py" .
```

Expected: `Skill is valid!`.

- [ ] **Step 3: Verify installed skill resolution**

Run:

```bash
test -f "${CODEX_HOME:-$HOME/.codex}/skills/auto-impl-brief/SKILL.md"
test -f "${CODEX_HOME:-$HOME/.codex}/skills/auto-impl-brief/protocol/implementation-brief.md"
test ! -e "${CODEX_HOME:-$HOME/.codex}/skills/auto-impl-brief/templates"
```

Expected: all commands exit 0.

- [ ] **Step 4: Review the final diff and Git state**

Run:

```bash
git status --short --branch
git diff origin/main...HEAD --check
git diff origin/main...HEAD --stat
git log --oneline --decorate origin/main..HEAD
```

Expected: only approved product-language, structure, tests, design, and plan changes are present.

- [ ] **Step 5: Integrate and publish the approved commits**

After the finishing-branch verification gate, fast-forward the feature branch into local `main` and run the full validator again. Push `main` without force.

Run:

```bash
git push origin main
gh repo edit akarazhev/auto-impl-brief --description "Controlled implementation orchestration for Codex."
```

- [ ] **Step 6: Verify public state**

Run:

```bash
git ls-remote origin refs/heads/main
gh repo view akarazhev/auto-impl-brief --json url,visibility,description,defaultBranchRef
git status --short --branch
```

Expected:

- local and remote `main` resolve to the same commit;
- visibility is `PUBLIC`;
- description is `Controlled implementation orchestration for Codex.`;
- the local worktree is clean;
- published history was not rewritten.

## Acceptance Mapping

- Standalone product positioning: Tasks 1 and 2.
- Canonical `protocol/` structure: Task 1.
- Preserved `brief` and `execute` behaviour: Tasks 1 and 3.
- Product-language regression gate: Tasks 1 and 2.
- Current design and implementation documentation: Task 2.
- Valid installed Codex skill: Task 3.
- Public GitHub description and synchronized history: Task 3.
