# Operating Model — Cursor + Codex CLI + Claude Code

Bu doküman, full-stack geliştirmede üç aracı çakıştırmadan yönetmek için standart çalışma modelidir.

## 1) Single Source of Truth

Her görevde tek plan dosyası kullan:

`docs/plans/YYYY-MM-DD-<task>.md`

Plan dosyasında zorunlu alanlar:
- Goal
- Scope (izinli path)
- Done criteria
- Risk tier (low/medium/high)
- Validation commands (test/lint/build)

## 2) Tool Role Contract

- **Cursor**: Ana IDE, final insan kontrolü, kritik manuel dokunuş.
- **Codex CLI**: Implementer (kod yazma, refactor, test çalıştırma).
- **Claude Code**: Planner + reviewer + systematic debugger.

Kural: Aynı task aynı anda birden fazla ajana verilmez.

## 3) Branch Policy

Her task ayrı branch:
- `feat/...`
- `fix/...`
- `refactor/...`

Main/master üzerinde ajan tabanlı implementasyon yapılmaz.

## 4) Standard Workflow

1. Claude Code ile plan hazırla
2. Codex CLI ile task’ları uygula
3. Cursor’da diff ve kritik kontrolleri yap
4. Claude Code ile review + risk analizi al
5. Test/lint/build doğrula
6. Commit + PR

## 5) Handoff Format (zorunlu)

Araç geçişinde aşağıyı doldur:
- Ne yapıldı
- Hangi dosyalar değişti
- Ne kaldı
- Test sonucu
- Riskler / notlar

## 6) Cost & Context Hygiene

- Scope dar tut (örn. `app/`, `resources/`, `tests/`)
- `node_modules/`, `vendor/`, `.git/`, `dist/`, `build/`, `storage/logs/` dışarıda
- Uzun/verbose çıktıyı özetleyerek taşı
- İlişkisiz işe geçerken oturum temizliği uygula

## 7) Session Hygiene Policy

### Manual
- Claude Code: `/clear` (görev değişiminde)
- Codex CLI: yeni görev için yeni session ya da `resume` disiplinli kullanım

### Semi-automatic
- Wrapper komut/alias ile her yeni görevde otomatik “plan dosyası + temiz oturum” akışı tetiklenebilir.
- Hook ile task kapanışında “session temizle/yeniden başlat” hatırlatması verilebilir.

Not: Tam otomatik ve her durumda güvenli “self-clear” davranışı, yanlış zamanda bağlam kaybına yol açabileceği için **opt-in** olmalıdır.

## 8) Daily Cadence (öneri)

- Sabah: planlama (Claude)
- Gün içi: implementasyon (Codex + Cursor)
- Akşam: review + PR hazırlığı (Claude)

---

Bu modelin amacı: hız + kalite + düşük maliyet dengesini korumak.
