# agentic-starter-kit

Yeni bir projeye başlarken Codex / Claude Code (ve benzeri ajanlar) için temel context hijyeni, kurallar ve prompt şablonlarını tek komutla kurar.

## Ne amaçlıyoruz?

Bu projenin amacı, AI destekli yazılım geliştirmeyi **hızlı ama kontrollü** hale getirmek:
- Her projede sıfırdan süreç kurma yükünü kaldırmak
- Agent kullanımını disipline etmek (scope, validation, review)
- Review ve PR kalitesini standartlaştırmak
- Context şişmesi ve maliyet kaçaklarını azaltmak
- Riskli değişikliklerde (özellikle migration gibi) güvenlik kapıları koymak

## Ne yapıyoruz?

Bu repo, pratikte bir "çalışma sistemi" kurar:
- `bootstrap.sh` ile başlangıç dosyalarını projeye yerleştirir
- Scriptlerle task yaşam döngüsünü yönetir (başlat → uygula → review → PR → kapat)
- Yarı otomatik hook akışıyla review tetikleme ve güvenlik kontrolleri sağlar
- Stack presetleriyle (react, react-native, laravel, node-api, python) hızlı konfigürasyon sunar

Özetle: **amaç sadece kod yazdırmak değil, sürdürülebilir ve güvenli bir geliştirme işletim sistemi kurmak.**

## Başlangıç Dokümantasyonu (Mantıksal Akış)

Bu kitin doğru kullanım mantığı: **Plan → Onay → Uygulama → Review → PR → Kapatış**.

### A) Kurulum (bir kez)
```bash
# proje kökünde
git clone https://github.com/ibrahimtezvergil/agentic-starter-kit.git .agentic-starter-kit
.agentic-starter-kit/bootstrap.sh . --tool both
.agentic-starter-kit/scripts/apply-preset.sh react
# seçenekler: react-native | laravel | node-api | python
.agentic-starter-kit/scripts/install-git-hooks.sh
```

### B) Task akışı (her işte)
1. **Önce planı yap** (Claude/Codex veya manuel)
2. Planı onayla
3. Feature branch + plan dosyası başlat:
```bash
.agentic-starter-kit/scripts/start-feature.sh auth-login-timeout-fix feat
```
4. Uygula + user test + commit
5. Review isteği oluştur:
```bash
.agentic-starter-kit/scripts/ready-review.sh auth-login-timeout-fix
```
6. PR paketi oluştur:
```bash
.agentic-starter-kit/scripts/package-pr.sh auth-login-timeout-fix origin/main HEAD
```
7. Task kapat:
```bash
.agentic-starter-kit/scripts/end-task.sh auth-login-timeout-fix
```

> Not: `start-feature.sh` planın yerine geçmez; planı operasyonel olarak branch + task dosyasına bağlar.

Detaylı adım adım sürüm için: `docs/quickstart-10min.md`

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

## Scriptler ve Amaçları

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

| Script | Ne yapar? | Neden var? |
|---|---|---|
| `start-feature.sh` | Branch açar, `new-task.sh` çağırır | Task başlangıcını standartlaştırır |
| `new-task.sh` | Plan dosyası (`docs/plans/...`) üretir | Plansız geliştirmeyi azaltır |
| `end-task.sh` | Verification checklist + guard + kapanış | “Bitti” demeden kalite kontrolü sağlar |
| `ready-review.sh` | Review payload üretir, risk ekler, duplicate SHA’yı engeller | Reviewer’a standart ve tekrar etmeyen input verir |
| `package-pr.sh` | PR paketi şablonu üretir | PR kalitesini ve hızını artırır |
| `context-cost-guard.sh` | Context/maliyet kokularını tespit eder | Oturum şişmesini ve token kaçaklarını azaltır |
| `analyze-risk.sh` | Diff’i low/medium/high sınıflar | Review derinliğini riske göre ayarlar |
| `migration-safety-gate.sh` | Migration/SQL değişikliklerinde onay ister | Veri kaybı/riskli deploy ihtimalini düşürür |
| `apply-preset.sh` | Stack’e uygun `starter.config.yml` uygular | React/Laravel/Python gibi stack’lerde hızlı adaptasyon |
| `install-git-hooks.sh` | post-commit + pre-push hook kurar | Yarı otomatik review/safety akışı sağlar |

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
