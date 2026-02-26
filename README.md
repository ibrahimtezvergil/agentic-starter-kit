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

## Kullanım

```bash
./bootstrap.sh /path/to/project --tool both
```

Seçenekler:

- `--tool codex`
- `--tool claude`
- `--tool both` (varsayılan)
- `--force` (mevcut dosyaların üstüne yazar)

## Örnek

```bash
./bootstrap.sh ~/projects/laravel/crm-app --tool both
```

## Claude Skills kullanımı

Bootstrap sonrası projede iki örnek skill gelir:

- `/bugfix-safe [issue|hata tanımı]`
- `/review-pr-risk [branch veya PR no]`

Claude Code'da `/skills` ile görebilir, doğrudan slash komutla çağırabilirsin.

## Not

Bu repo sadece başlangıç seti sağlar. Proje özelinde allowlist path, test komutları, branch kuralları gibi ayarları sonradan güncellemen önerilir.
