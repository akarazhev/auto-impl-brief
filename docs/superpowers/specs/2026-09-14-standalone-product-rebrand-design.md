# Standalone Product Rebrand Design

**Date:** 2026-09-14

**Status:** Approved for implementation planning

## Objective

Present `auto-impl-brief` as a new, standalone Codex execution framework. Every current user-facing surface must describe the product in its own terms rather than as a derivative prompt, transferable wrapper, or adaptation of another project.

The canonical positioning is:

> `auto-impl-brief` is a controlled implementation orchestration framework for Codex.

## Product Model

The framework converts an objective, constraints, acceptance criteria, and authority boundaries into one of two outcomes:

- `brief` compiles a complete implementation brief for a Codex session;
- `execute` runs the implementation workflow directly and reports verified results.

Both modes use the same implementation protocol. The protocol defines repository inspection, dependency-aware planning, engineering loops, bounded delegation, verification gates, blocker handling, and remote-action authority.

## Canonical Vocabulary

Current project language will use:

- **execution framework** for the project as a whole;
- **implementation protocol** for the governing workflow contract;
- **implementation brief** for the output of `brief` mode;
- **implementation run** for work performed by `execute` mode;
- **verification gates** for evidence required before integration or completion;
- **authority boundaries** for destructive and remote actions.

Descriptions must lead with the product's purpose and capabilities. They must not frame the project as a repackaging, transport format, compatibility layer, or continuation of another codebase.

## Repository Structure

Rename the protocol source and example to reflect the standalone product model:

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

`protocol/implementation-brief.md` is the canonical implementation protocol used by `brief` mode. It remains directly readable for operators, but documentation must describe it as part of the framework rather than as an alternate no-install product.

## Public Interface Changes

The following current interfaces change:

- the protocol validation scope is named `protocol`;
- the validator function is named `validate_protocol`;
- README commands use `sh tests/validate.sh protocol` and `sh tests/validate.sh all`;
- `SKILL.md` reads `protocol/implementation-brief.md` in `brief` mode;
- the neutral example is `examples/secure-endpoint-change.md`;
- Codex UI metadata describes controlled implementation planning and execution.

The repository is at an initial stage, so these path and validation-scope changes are accepted without a compatibility alias. Tests must ensure that obsolete paths and scopes are absent.

## File-Level Changes

### README

Open with the canonical positioning and immediately explain the two modes. Organize the document around installation, operation, inputs, protocol guarantees, safety, verification, and development. Remove language that presents a Markdown file as a separate distribution strategy.

### Skill

Change frontmatter description to triggering conditions only:

> Use when a user wants Codex to prepare or run a structured implementation workflow for a complex repository task.

The overview identifies the framework and its two modes. Detailed behaviour remains unchanged except for the canonical protocol path and terminology.

### Agent metadata

Use:

- display name: `Auto Implementation Brief`;
- short description: `Plan and run controlled software implementations`.

### Protocol

Retain the implementation behaviour and input fields. Introduce the document as the framework's execution protocol and use framework vocabulary consistently.

### Example

Present the fictional secure-endpoint task as a complete framework invocation. Do not describe it as an adaptation of another artifact.

### Design and plan documents

Revise current documentation so it reads as the design and implementation history of this standalone project. Preserve technical decisions and verification evidence while aligning product terminology and current paths.

## Validation Strategy

Follow a RED→GREEN sequence:

1. Add a `branding` validation scope before changing product copy.
2. Confirm that the scope fails against the existing wording and paths.
3. Rename protocol and example files with Git-aware moves.
4. Rewrite active product surfaces and documentation.
5. Update structural and consistency checks for the new paths and scope.
6. Confirm `skill`, `protocol`, `docs`, `branding`, `consistency`, and `all` scopes pass.
7. Run the official Codex skill validator.
8. Verify the installed symlink resolves to the updated skill.

The branding scope will scan current user-facing files for compatibility-era positioning, machine-specific paths, and obsolete file locations. The validation script itself may contain rejection patterns and is therefore excluded from its own branding scan.

## Git and Publication

Implement the change on a feature branch and integrate only after full verification. Do not rewrite published Git history; earlier commit messages remain historical records.

After local integration and explicit verification:

- push the new commits to public `main`;
- update the GitHub repository description to `Controlled implementation orchestration for Codex.`;
- confirm local `main` and `origin/main` resolve to the same commit.

No release tag or compatibility branch is required for this initial-stage change.

## Non-Goals

- changing the core engineering loop or safety guarantees;
- adding runtime dependencies;
- adding another model provider or execution backend;
- rewriting published history;
- modifying any target repository;
- changing the repository or skill name.

## Acceptance Criteria

- Current public files consistently present `auto-impl-brief` as a standalone execution framework.
- The canonical introductory sentence appears in README and design documentation.
- `brief` and `execute` retain their existing behaviour.
- The canonical protocol lives at `protocol/implementation-brief.md`.
- The example lives at `examples/secure-endpoint-change.md`.
- Validation exposes `protocol` and `branding` scopes and no obsolete scope.
- Codex metadata uses the approved short description.
- All validation scopes and the official skill validator pass.
- GitHub displays the approved repository description.
- Published history is preserved and no unrelated project is modified.
