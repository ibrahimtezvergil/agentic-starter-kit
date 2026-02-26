# Category 2 — Debug + Verification

## Objective
Eliminate guesswork and enforce evidence-based completion.

## Canonical Core Skills
- systematic-debugging
- verification-before-completion
- test-driven-development (integration)

## Mandatory Flow
`systematic-debugging -> (TDD where applicable) -> verification-before-completion`

## Debug Policy
- No fixes before root-cause investigation
- No bundled multi-fix attempts without evidence
- After 3 failed fix attempts: stop and trigger architecture checkpoint

## Verification Policy
Before any success claim ("fixed", "done", "passing"):
1. Run fresh verification commands
2. Read full output and exit codes
3. Match claim to evidence
4. Then report status

## Risk-Tier Execution
- Low: focused root cause + regression test + verify
- Medium: full 4-phase debugging + relevant suite + verify
- High: full debugging + expanded verification + final review + verify gate

## Patch Notes
- Add architecture-stop rule after repeated failed attempts
- Add explicit pre-commit/pre-PR verification checklist
- Keep evidence-before-assertion as non-negotiable gate
