# Quickstart (10 Minutes)

## 1) Bootstrap
```bash
./bootstrap.sh /path/to/project --tool both
cd /path/to/project
```

## 2) Apply stack preset
```bash
scripts/apply-preset.sh react
# or: laravel | node-api | python
```

## 3) Install git hooks
```bash
scripts/install-git-hooks.sh
```

## 4) Start a feature
```bash
scripts/start-feature.sh auth-login-timeout-fix feat
```

## 5) Implement + user test + commit
```bash
git add .
git commit -m "fix: handle login timeout gracefully"
```

After commit, post-commit asks if review should start.

## 6) Generate review payload manually (if skipped)
```bash
scripts/ready-review.sh auth-login-timeout-fix
```

## 7) Package PR
```bash
scripts/package-pr.sh auth-login-timeout-fix origin/main HEAD
```

## 8) Close task
```bash
scripts/end-task.sh auth-login-timeout-fix
```

---

## Non-interactive examples

```bash
scripts/start-feature.sh auth-login-timeout-fix feat --yes
scripts/ready-review.sh auth-login-timeout-fix --yes
scripts/migration-safety-gate.sh HEAD~1 HEAD --yes
```
