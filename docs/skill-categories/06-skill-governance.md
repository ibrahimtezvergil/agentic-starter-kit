# Category 6 — Skill Governance

## Objective
Create a scalable, testable, and maintainable skill ecosystem.

## Naming Standard
`<domain>-<action>-<mode>`
Examples:
- code-review-risk
- docs-release-notes
- automation-jira-sync

## Invocation Contract
Each skill must explicitly define:
- explicit vs implicit invocation
- who can invoke (user/model)
- trigger conditions and non-trigger conditions

## Quality Gates (pre-merge)
- frontmatter/schema validation
- trigger behavior tests
- output format tests
- dependency checks
- destructive-action safety checks

## Versioning
Use semantic versioning:
- MAJOR: breaking behavior
- MINOR: additive capability
- PATCH: fixes
Require changelog updates.

## Deprecation Policy
- Mark deprecated with replacement path
- Provide migration guidance and grace period
- No silent removals

## Repository Topology
- skills/core/
- skills/support/
- skills/presets/automation/
- tests/skills/
- docs/governance/

## Operational Metrics
Track periodically:
- invocation frequency
- false trigger rate
- task completion success rate
- token/cost per task
- automation failure rate

## Patch Notes
- Governance is mandatory from first release
- Avoid ad-hoc skill growth without tests and lifecycle rules
