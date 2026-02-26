# Category 5 — Automation Integrations (Composio and similar)

## Objective
Leverage broad app automation safely without runaway complexity or context bloat.

## Structure Decision
Do not place massive app automations in core.
Use opt-in presets:
- preset/automation-crm
- preset/automation-project-mgmt
- preset/automation-marketing
- preset/automation-support

## Security Policy
Automation skills default to:
- explicit invocation only
- confirmation gate for high-impact actions
- dry-run first when possible
- second confirmation for destructive operations

## Tool Scope Policy
- Minimum necessary tools only
- No always-on wide MCP surface
- Per-preset dependency isolation

## Execution Standard
Every automation run should follow:
1. Preview/plan
2. Execute
3. Audit output (what changed, where, results)

## Patch Notes
- Keep broad Composio catalog as optional packs
- Promote only proven, stable flows into default presets
