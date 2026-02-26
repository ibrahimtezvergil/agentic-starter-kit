# Sprint 1 — Workflow Acceleration + Safety Gates

## Scope (Implemented)
1. One-command kickoff (`scripts/start-feature.sh`)
2. PR Packager (`scripts/package-pr.sh`)
3. Cost/Context Guard (`scripts/context-cost-guard.sh`)
4. Auto Risk Analysis (`scripts/analyze-risk.sh`)
5. Migration Safety Gate (`scripts/migration-safety-gate.sh`)

---

## 1) One-command kickoff

### Goal
Start a feature with branch + plan creation in one command.

### What we gain
- Faster, standardized start
- Fewer missed setup steps

### Pros
- Strong consistency
- Better onboarding

### Cons
- Slightly opinionated flow
- Needs occasional branch naming override

---

## 2) PR Packager

### Goal
Generate structured PR package with summary template, changed files, validation slots, and rollback section.

### What we gain
- Better review quality
- Faster PR preparation

### Pros
- Standard PR payload
- Reduces reviewer context switching

### Cons
- Still needs human polish for final wording

---

## 3) Cost/Context Guard

### Goal
Detect context/cost smells early (oversized plans, oversized commits, growing review queue).

### What we gain
- Lower token waste
- Better session hygiene

### Pros
- Lightweight heuristic checks
- Practical prompts for compaction/fresh session

### Cons
- Heuristics are approximate, not exact token accounting

---

## 4) Auto Risk Analysis

### Goal
Classify change risk (low/medium/high) based on diff volume and sensitive paths.

### What we gain
- Risk-aware review depth
- Better triage for critical changes

### Pros
- Fast and automatic
- Included in review request payload

### Cons
- May misclassify edge cases
- Requires tuning over time

---

## 5) Migration Safety Gate

### Goal
Prevent unsafe DB migration/sql changes from passing silently.

### What we gain
- Fewer data-risk incidents
- Explicit rollback/test confirmation behavior

### Pros
- Strong safety for high-impact changes
- Runs as pre-push gate via hook setup

### Cons
- Adds friction when migration changes are frequent
- Interactive confirmation may not fit all CI flows

---

## Notes
- Semi-automatic review trigger remains user-controlled.
- Commit prompt asks whether to start review.
- User can defer and trigger later with `scripts/ready-review.sh <task-slug>`.
