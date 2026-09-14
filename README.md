# auto-impl-brief

`auto-impl-brief` is a reusable Codex skill and portable prompt for evidence-driven software implementation. It can prepare a self-contained assignment for a clean Codex session or apply the same engineering contract directly in a target repository.

## Choose a workflow

- **Brief mode** creates a standalone assignment you can inspect, edit, and hand to another Codex session.
- **Execute mode** applies the workflow in the current session and continues through implementation and verification.
- **Portable template** lets you use [`templates/implementation-brief.md`](templates/implementation-brief.md) without installing the skill.

## Install as a personal Codex skill

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
git clone https://github.com/akarazhev/auto-impl-brief.git \
  "${CODEX_HOME:-$HOME/.codex}/skills/auto-impl-brief"
```

If you already have a clone, you may link that repository into the same skills directory. Check that the destination does not exist first; never overwrite an existing skill path automatically. Restart Codex if the new skill is not discovered in the current session.

## Use

Generate a handoff for a clean Codex session:

```text
$auto-impl-brief mode: brief

OBJECTIVE:
Add structured audit logging to administrative operations.

CONSTRAINTS:
Preserve the current public API and use existing dependencies.

ACCEPTANCE_CRITERIA:
Tests cover authorized, unauthorized, successful, and failed operations.
```

Execute a formal workflow directly:

```text
$auto-impl-brief mode: execute

OBJECTIVE:
Implement the approved specification in docs/design.md and verify every acceptance criterion.

GIT_AND_PUBLISH_POLICY:
Local commits are allowed. Do not push or create a pull request.
```

If `mode` is omitted, the skill infers `brief` for requests to prepare an assignment and `execute` for requests to perform a formal implementation workflow. It asks one concise question only when the intent remains ambiguous.

## Inputs

The public input contract contains:

- `OBJECTIVE` — the required outcome;
- `REPOSITORY` — a target path or repository reference;
- `STARTING_POINT` — a branch, tag, or commit;
- `SPECIFICATIONS` — governing requirements and documents;
- `CONSTRAINTS` — technical, security, cost, and operational limits;
- `ACCEPTANCE_CRITERIA` — observable completion conditions;
- `MODEL_POLICY` — model roles and escalation guidance;
- `GIT_AND_PUBLISH_POLICY` — allowed commits and remote actions;
- `EXTERNAL_INPUTS` — credentials, systems, profiles, or datasets supplied separately.

Only `OBJECTIVE` is universally required. When Codex is already operating in the target repository, it can derive repository facts by inspection. Unknown credentials, paths, permissions, checks, and external state are never invented.

## Safety defaults

The skill reads applicable repository instructions and Git status before editing. It preserves unrelated tracked and untracked work, avoids destructive Git actions, tests changes before completion claims, and limits implementation work to three concurrent subagents.

The default policy allows no unauthorized remote mutation. Pushes, pull requests, deployments, publications, messages, and other remote changes require explicit user authorization.

Unavailable optional tools and external systems are reported as unavailable; they are not represented as successful checks. Ordinary engineering failures return the work to diagnosis instead of being mislabeled as blockers.

## Model economy

The workflow assigns strong reasoning to architecture, security boundaries, integration, difficult diagnosis, and final adversarial review. Isolated routine implementation and tests use a cost-efficient coding model when model selection is available. Deterministic tools and tests take precedence over redundant model reviews.

## Validate

The repository has no runtime dependencies. Run all structural and contract checks with:

```bash
sh tests/validate.sh all
```

Maintainers should also run the official Codex skill validator from the installed `skill-creator` package.

## Contributing

Keep the reusable files project-neutral. Add a failing validation or reproducible scenario before changing behaviour, make the smallest implementation change, and run every validation scope before opening a pull request.

## License

Licensed under [Apache-2.0](LICENSE).
