# Auto Implementation Brief: Design

**Date:** 2026-09-14

**Status:** Approved for implementation

**Repository:** `akarazhev/auto-impl-brief`

## Purpose

`auto-impl-brief` provides a reusable, project-independent contract for giving Codex complex implementation work. It supports two related workflows:

1. producing a self-contained implementation brief that can be handed to a clean Codex session; and
2. executing that brief autonomously in the current repository.

The project must remain independent of any target project, organization, programming language, and repository layout.

## Deliverables

The repository will contain:

- a personal Codex skill named `auto-impl-brief`;
- a portable Markdown template for users who do not have the skill installed;
- examples showing how to specialize the template without coupling the core to those examples;
- validation tests for the skill package and template;
- installation and usage documentation;
- the Apache License 2.0.

## Repository Structure

```text
auto-impl-brief/
├── README.md
├── LICENSE
├── SKILL.md
├── agents/
│   └── openai.yaml
├── templates/
│   └── implementation-brief.md
├── examples/
│   └── complete-project-example.md
├── tests/
│   └── validate.sh
└── docs/
    └── design.md
```

The repository root is also the installable skill directory. A user can clone it directly under the personal Codex skills directory or install it from GitHub.

## Modes

### Brief mode

Invocation example:

```text
$auto-impl-brief mode: brief

Objective: ...
Repository: ...
Constraints: ...
```

The skill inspects the supplied context and produces a complete, copyable assignment for a clean Codex agent. It must resolve reasonable defaults, identify missing material inputs, and preserve unknowns as explicit placeholders rather than inventing project facts.

### Execute mode

Invocation example:

```text
$auto-impl-brief mode: execute

Objective: ...
Acceptance criteria: ...
```

The skill applies the same contract directly. It inspects repository instructions, constructs a dependency graph, executes ready work nodes, verifies integrations, and continues until completion or a precisely documented blocker.

### Mode inference

When no mode is supplied:

- requests such as “prepare”, “write”, or “generate an assignment” select `brief`;
- requests such as “implement”, “fix”, or “complete” select `execute`;
- genuinely ambiguous requests require one concise clarification.

Explicit `mode` always wins.

## Inputs

The reusable contract accepts:

- `OBJECTIVE` — required outcome;
- `REPOSITORY` — target path or repository reference;
- `STARTING_POINT` — optional branch, tag, or commit;
- `SPECIFICATIONS` — source documents and requirements;
- `CONSTRAINTS` — technical, security, cost, and operational limits;
- `ACCEPTANCE_CRITERIA` — observable completion conditions;
- `MODEL_POLICY` — optional orchestration and escalation policy;
- `GIT_AND_PUBLISH_POLICY` — commit, PR, push, and deployment authority;
- `EXTERNAL_INPUTS` — credentials, target systems, profiles, or datasets supplied separately.

Only the objective is universally required. The skill derives repository context when it is already running inside the target repository.

## Execution Contract

Execute mode uses an evidence-producing engineering loop:

```text
Inspect → Define → Test first → Implement → Verify locally →
Review diff → Verify broadly → Record evidence → Integrate
```

For multi-step work, the skill maintains a dependency graph. Each node records its dependencies, status, owner, affected files, verification evidence, commit when applicable, and residual risks. A node becomes ready only after its dependencies are verified.

Independent ready nodes may be delegated to fresh subagents. Concurrent agents must have bounded scopes and non-overlapping file ownership wherever practical. The orchestrator remains responsible for combined-diff review and re-running integrated verification.

## Default Safety Policy

Unless the user explicitly overrides a default, the skill must:

- read applicable `AGENTS.md`, `CLAUDE.md`, and repository instructions first;
- inspect Git status before editing;
- preserve unrelated and untracked user work;
- avoid destructive Git operations;
- avoid push, PR creation, deployment, publication, and other remote mutation;
- use test-driven development for features and defect fixes;
- verify claims with fresh command output before declaring completion;
- limit implementation concurrency to three subagents;
- avoid exposing secrets or copying external private inputs into the repository;
- report unavailable environmental verification rather than fabricating success;
- distinguish genuine external blockers from ordinary engineering failures.

## Model Economy

The template describes roles rather than depending on a single model name:

- a strong reasoning model orchestrates architecture, trust-boundary work, integration, and final review;
- a cost-efficient coding model handles isolated routine implementation and test tasks;
- reasoning effort is escalated only for security-critical work, stubborn failures, or adversarial final review;
- deterministic validation is preferred to redundant model review.

Concrete model names may be supplied by the user or filled from the models available in the active Codex environment. Missing model-selection controls must not prevent execution.

## Error and Blocker Handling

Failed tests and implementation difficulties return the work to inspection and diagnosis. The skill must not weaken assertions, suppress required checks, or misclassify required functionality as optional.

Execution pauses only when progress requires new authority, credentials, unavailable mandatory external state, a destructive out-of-scope action, or a material product decision not resolved by the input. Independent ready work continues when one graph branch is blocked.

## Outputs

Brief mode returns a single self-contained prompt containing the objective, context, constraints, execution contract, acceptance criteria, safety rules, and required final report.

Execute mode returns an evidence-backed completion report containing:

- completed work and commits;
- changed behaviour and architecture;
- verification commands with exact results;
- acceptance-criteria mapping;
- unavailable checks and residual risks;
- final Git status;
- disclosure of any authorized remote action.

## Validation

Automated validation will check:

- required skill metadata and agent configuration;
- the presence and integrity of both modes;
- required Markdown-template placeholders;
- absence of project-specific names, paths, and assumptions in reusable files;
- inclusion of safety, verification, graph, delegation, and completion rules;
- consistency between the skill, template, README, and examples.

Manual scenarios will verify:

1. generating a brief for a new repository;
2. executing a small bounded change;
3. preserving a dirty worktree;
4. handling a missing external input;
5. refusing unauthorized push or deployment;
6. escalating a security-critical task while keeping routine work economical.

## Distribution

The canonical project will be the public GitHub repository:

`https://github.com/akarazhev/auto-impl-brief`

The project will be distributed under the Apache License 2.0.

The repository will contain no credentials, private target data, or generated evidence from private projects. Publishing the initial repository is authorized; later releases and changes remain subject to explicit user instructions.
