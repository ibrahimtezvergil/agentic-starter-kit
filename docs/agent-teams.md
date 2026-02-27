# Agent Teams (Starter Kit)

This starter kit includes a basic 3-role Claude agent team template:

- `.claude/agents/planner.md`
- `.claude/agents/implementer.md`
- `.claude/agents/reviewer.md`

## Recommended flow
1. Planner creates plan
2. Human approves plan
3. Implementer applies changes + validation
4. Reviewer performs risk-first review
5. Human decides merge

## Notes
- Keep this team for medium/high-risk tasks.
- For small fixes, single-agent mode is usually faster.
- Use `starter.config.yml` and existing scripts for consistency.
