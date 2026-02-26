# Category 1 — Core Engineering Workflow

## Objective
Create a reliable end-to-end engineering flow from idea to merge:

`brainstorming -> writing-plans -> subagent-driven-development -> finishing-a-development-branch`

## Canonical Core Skills
- brainstorming
- writing-plans
- subagent-driven-development
- executing-plans (alternative mode)
- test-driven-development
- using-git-worktrees
- finishing-a-development-branch

## Keep / Adapt / Optional

### Keep
- brainstorming
- writing-plans
- test-driven-development
- using-git-worktrees
- finishing-a-development-branch

### Adapt
- subagent-driven-development: risk-based review depth
- executing-plans: smaller default batch size, strict blocker handling

### Optional
- dispatching-parallel-agents (only for truly parallelizable tasks)

## Operating Modes

### Light (small changes)
- mini brainstorming
- writing-plans (light)
- executing-plans (batch=2)
- finishing-a-development-branch

### Standard (default)
- brainstorming
- writing-plans
- subagent-driven-development (risk-based reviews)
- finishing-a-development-branch

### Strict (critical domains)
- full brainstorming
- full writing-plans
- subagent-driven-development (spec + quality + final review)
- finishing-a-development-branch

## Patch Notes
- Add micro-task bypass in brainstorming for tiny edits
- Add risk tier in plan header (low/medium/high)
- Apply review depth by risk tier in execution
- Keep TDD mandatory; allow explicit human-approved exceptions for non-code tasks
