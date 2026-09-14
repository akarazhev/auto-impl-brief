# Auto Implementation Brief: Design

**Date:** 2026-09-14

**Status:** Implemented

**Repository:** `akarazhev/auto-impl-brief`

## Purpose

`auto-impl-brief` is a controlled implementation orchestration framework for Codex. It prepares complete implementation briefs and runs structured repository changes under explicit verification and authority controls.

The framework remains independent of any target project, organization, programming language, and repository layout. Target repositories provide objectives and context; they do not define the framework itself.

## Product Model

The framework has two operating modes backed by one implementation protocol:

1. `brief` compiles supplied facts and safe defaults into a complete implementation brief for a Codex session.
2. `execute` performs an implementation run in the current repository and reports verified results.

The shared protocol governs inspection, dependency-aware planning, engineering loops, bounded delegation, verification gates, blocker handling, and authority boundaries.

## Deliverables

The repository contains:

- the installable Codex skill `auto-impl-brief`;
- the canonical implementation protocol;
- a complete fictional invocation that demonstrates `brief` mode;
- dependency-free structural, contract, branding, and consistency validation;
- installation, operation, and development documentation;
- the Apache License 2.0.

## Repository Structure

```text
auto-impl-brief/
├── README.md
├── LICENSE
├── SKILL.md
├── agents/
│   └── openai.yaml
├── protocol/
│   └── implementation-brief.md
├── examples/
│   └── secure-endpoint-change.md
├── tests/
│   └── validate.sh
└── docs/
    ├── design.md
    └── superpowers/
        ├── plans/
        └── specs/
```

The repository root is the installable skill directory. GitHub is the canonical distribution source, and an existing clone may also be linked into the personal Codex skills directory.

## Modes

### Brief mode

Invocation example:

```text
$auto-impl-brief mode: brief

OBJECTIVE: ...
REPOSITORY: ...
CONSTRAINTS: ...
```

The skill reads `protocol/implementation-brief.md`, resolves every public field from supplied facts, inspected repository context, or explicit safe defaults, and returns a complete implementation brief. Unknown material inputs remain explicit instead of being invented. The brief is not executed unless the user separately requests execution.

### Execute mode

Invocation example:

```text
$auto-impl-brief mode: execute

OBJECTIVE: ...
ACCEPTANCE_CRITERIA: ...
```

The skill applies the implementation protocol directly. It inspects repository instructions and Git state, constructs a dependency graph for multi-step work, executes ready nodes, verifies integrations, and continues until completion or a precisely documented blocker.

### Mode inference

When no mode is supplied:

- requests to prepare, write, or generate an implementation brief select `brief`;
- requests to implement, fix, build, or complete work select `execute`;
- genuinely ambiguous requests require one concise clarification.

An explicit `mode` always wins.

## Inputs

The public protocol fields are:

- `OBJECTIVE` — required outcome;
- `REPOSITORY` — target path or repository reference;
- `STARTING_POINT` — branch, tag, or commit when relevant;
- `SPECIFICATIONS` — source documents and requirements;
- `CONSTRAINTS` — technical, security, cost, and operational limits;
- `ACCEPTANCE_CRITERIA` — observable completion conditions;
- `MODEL_POLICY` — optional orchestration and escalation policy;
- `GIT_AND_PUBLISH_POLICY` — commit, pull-request, push, and deployment authority;
- `EXTERNAL_INPUTS` — credentials, target systems, profiles, or datasets supplied separately.

Only `OBJECTIVE` is universally required. Repository facts are derived when Codex is already operating in the target repository. Missing paths, credentials, permissions, test results, and external state are never invented.

## Implementation Protocol

Every implementation node uses:

```text
Inspect → Define → Test first → Implement → Verify locally →
Review diff → Verify broadly → Record evidence → Integrate
```

For multi-step work, each dependency-graph node records its dependencies, readiness, owner, affected files, acceptance checks, status, verification evidence, commit when applicable, blockers, and residual risks. A node becomes ready only after every dependency is verified.

Independent ready nodes may be delegated when useful. Delegated scopes must be bounded and must avoid overlapping file ownership or shared integration contracts. The root agent remains accountable for architectural consistency, combined-diff review, integrated verification, and completion claims.

## Verification Gates

Focused checks run for each implementation node. The union of affected checks runs after integration, and broad repository verification runs at phase and completion gates. A final report maps fresh evidence to every acceptance criterion and identifies any unavailable environment-dependent checks.

A failing test returns the run to inspection and diagnosis. Assertions, required checks, and required behaviour cannot be weakened merely to obtain a pass.

## Authority Boundaries

Unless the user explicitly authorizes an action, the framework must:

- read applicable repository instructions and inspect Git status before editing;
- preserve unrelated tracked and untracked work;
- avoid destructive Git and filesystem operations;
- avoid pushes, pull requests, deployments, publications, messages, and other remote mutations;
- prevent credentials and private external inputs from entering tracked files;
- report unavailable environmental verification accurately;
- distinguish external blockers from ordinary engineering failures.

Execution pauses only when further progress requires new authority, credentials, unavailable mandatory external state, a destructive out-of-scope action, or a material product decision not resolved by supplied requirements. Independent ready work continues when one graph branch is blocked.

## Model Economy

Model policy is role-based and optional:

- strong reasoning is appropriate for architecture, security boundaries, integration, difficult diagnosis, and final adversarial review;
- cost-efficient coding is appropriate for isolated routine implementation and tests;
- reasoning effort escalates only when evidence justifies it;
- deterministic tools and tests take precedence over redundant model review.

Concrete model names may be supplied by the user or selected from the active Codex environment. Missing model-selection controls do not prevent execution.

## Outputs

Brief mode returns one complete implementation brief containing the objective, context, constraints, protocol, acceptance criteria, authority boundaries, and required final report.

Execute mode returns an evidence-backed completion report containing:

- completed work units and commits;
- changed behaviour and architecture;
- exact verification commands and results;
- acceptance-criteria mapping;
- unavailable checks and residual risks;
- authorized external actions;
- final Git status.

## Validation

`tests/validate.sh` exposes these scopes:

- `skill` checks the skill entry point and Codex metadata;
- `protocol` checks public fields and execution guarantees;
- `docs` checks installation, license, and the fictional example;
- `branding` rejects retired positioning and obsolete paths;
- `consistency` checks cross-file invariants;
- `all` runs every scope.

Manual scenarios cover preparing an implementation brief, performing a bounded implementation run, preserving a dirty worktree, handling a missing external input, refusing an unauthorized remote action, and applying role-based model economy to security-critical and routine work.

## Distribution

The canonical public repository is `https://github.com/akarazhev/auto-impl-brief`.

The project is distributed under Apache-2.0. The repository contains no credentials, private target data, or generated evidence from private projects. Publication remains subject to explicit user authorization.
