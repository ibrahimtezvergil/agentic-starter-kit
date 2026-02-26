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

## Kullanım

```bash
./bootstrap.sh /path/to/project --tool both
```

## Yarı otomatik task/session akışı

Bu repoda iki yardımcı script vardır:

```bash
scripts/new-task.sh <task-slug>
scripts/end-task.sh <task-slug>
```

- `new-task.sh`: plan dosyası oluşturur, fresh session hygiene hatırlatır
- `end-task.sh`: verification checklist ve session clear hatırlatması verir

Seçenekler:

- `--tool codex`
- `--tool claude`
- `--tool both` (varsayılan)
- `--force` (mevcut dosyaların üstüne yazar)

## Örnek

```bash
./bootstrap.sh ~/projects/laravel/crm-app --tool both
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

## Not

Bu repo sadece başlangıç seti sağlar. Proje özelinde allowlist path, test komutları, branch kuralları gibi ayarları sonradan güncellemen önerilir.
