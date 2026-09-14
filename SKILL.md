---
name: auto-impl-brief
description: Generate a self-contained implementation assignment for a clean Codex session, or execute a complex repository task autonomously using an evidence-driven engineering loop, dependency graph, bounded subagents, and explicit safety constraints. Use when a user asks for a reusable implementation handoff or a formal autonomous implementation workflow. Do not use for ordinary coding requests that do not need this structured contract.
---

# Auto Implementation Brief

Turn a goal into a complete execution contract or apply that contract directly. Remain project-neutral and preserve user authority over remote and destructive actions.

## Mode selection

Use an explicit mode when supplied:

- `mode: brief` produces one self-contained prompt for a clean Codex session.
- `mode: execute` performs the work in the current session.

Without an explicit mode, infer `brief` from requests to prepare, write, or generate an assignment. Infer `execute` from requests to implement, fix, build, or complete work using this formal workflow. If both remain plausible, ask one concise question and do not alter files before the answer.

## Normalize the request

Collect these fields from the request and available repository context:

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
