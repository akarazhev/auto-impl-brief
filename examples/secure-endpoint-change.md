# Example: Secure Endpoint Change

This fictional scenario demonstrates `brief` mode for a bounded security change. The repository and task are fictional.

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

Expected result: an implementation brief that conforms to `protocol/implementation-brief.md`, resolves every supplied field, and requires no unstated context.
