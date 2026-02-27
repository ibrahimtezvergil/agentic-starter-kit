# agentic-starter-kit

Yeni bir projeye başlarken Codex / Claude Code (ve benzeri ajanlar) için temel context hijyeni, kurallar ve prompt şablonlarını tek komutla kurar.

## Ne kurar?

- `.agentignore`
- `AGENTS.md` (context hygiene + çalışma kuralları)
- `CLAUDE.md` (Claude Code için)
- `.codex/config.toml` (Codex için)
- `docs/ai/prompt-template.txt`
- `.claude/skills/bugfix-safe/SKILL.md`
- `.claude/skills/review-pr-risk/SKILL.md`
- `.claude-plugin/*` plugin-ready scaffold (commands/hooks/skills + plugin.json)
- `starter.config.yml` (eşikler / default branch / validasyon komutları)

## Kullanım

```bash
./bootstrap.sh /path/to/project --tool both
```

## Yarı otomatik task/session akışı

Bu repoda yardımcı script'ler vardır:

```bash
scripts/start-feature.sh <task-slug> [branch-prefix] [--yes|--ci]
scripts/new-task.sh <task-slug> [--yes|--ci]
scripts/end-task.sh <task-slug> [--yes|--ci]
scripts/ready-review.sh <task-slug> [--yes|--ci]
scripts/package-pr.sh <task-slug> [base-ref] [head-ref]
scripts/context-cost-guard.sh [plan-file]
scripts/analyze-risk.sh [base-ref] [head-ref]
scripts/migration-safety-gate.sh [base-ref] [head-ref]
scripts/apply-preset.sh <react|react-native|laravel|node-api|python>
scripts/install-git-hooks.sh
```

- `start-feature.sh`: branch açar + plan bootstrap eder (one-command kickoff)
- `new-task.sh`: plan dosyası oluşturur, fresh session hygiene hatırlatır
- `end-task.sh`: verification checklist + context/cost guard + migration safety prompt
- `ready-review.sh`: review payload dosyası üretir (`docs/review-queue/`), auto risk ekler, aynı SHA için duplicate review üretimini engeller
- `package-pr.sh`: PR package şablonu üretir (`docs/pr-packages/`)
- `context-cost-guard.sh`: context/cost kokularını kontrol eder
- `analyze-risk.sh`: diff için low/medium/high risk sınıfı üretir
- `migration-safety-gate.sh`: migration/sql değişikliklerinde onay kapısı
- `apply-preset.sh`: stack presetini `starter.config.yml` üzerine uygular
- `install-git-hooks.sh`: post-commit review prompt + pre-push migration gate kurar

Seçenekler:

- `--tool codex`
- `--tool claude`
- `--tool both` (varsayılan)
- `--force` (mevcut dosyaların üstüne yazar)

## Örnek

```bash
./bootstrap.sh ~/projects/laravel/crm-app --tool both
scripts/install-git-hooks.sh
```

## Plugin-ready yapı

Bootstrap, proje içine `.claude-plugin/` altında başlangıç scaffold'u da kopyalar:
- `.claude-plugin/plugin.json`
- `.claude-plugin/commands/feature-dev.md`
- `.claude-plugin/hooks/README.md`
- `.claude-plugin/skills/README.md`

Bu yapı ile skill + command + hook birleşik plugin düzenine hızlı geçiş yapabilirsin.

## Claude Skills kullanımı

Bootstrap sonrası projede iki örnek skill gelir:

- `/bugfix-safe [issue|hata tanımı]`
- `/review-pr-risk [branch veya PR no]`

Claude Code'da `/skills` ile görebilir, doğrudan slash komutla çağırabilirsin.

## CI

Script doğrulamaları için GitHub Actions eklidir:
- `.github/workflows/scripts-check.yml` (`bash -n` + `shellcheck`)

## Hızlı başlangıç demosu
- `docs/quickstart-10min.md`

## Not

Bu repo sadece başlangıç seti sağlar. Proje özelinde allowlist path, test komutları, branch kuralları gibi ayarları `starter.config.yml` üzerinden güncellemen önerilir.
