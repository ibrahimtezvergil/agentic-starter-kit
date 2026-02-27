---
name: laravel-filament-solid
description: Laravel + Filament projelerinde üretim kalitesinde geliştirme standardı uygula. Use when: (1) model/service/repository tasarımı, (2) SOLID uyumlu refactor, (3) Filament resource/page/action geliştirme, (4) form/table validation ve authorization, (5) migration güvenliği, (6) test kapsamı ve kod review hazırlığı.
---

Laravel-Filament-SOLID standardını uygula.

Kurallar:
1. Plan-first çalış: önce kapsam, risk, doğrulama planı yaz.
2. SRP uygula: Controller/Resource içinde business logic tutma; Service/Action sınıfına taşı.
3. DIP uygula: somut sınıf yerine interface bağımlılığı kullan.
4. OCP gözet: mevcut davranışı kırmadan genişlet (strategy/policy/action yaklaşımı).
5. Validation ve authorization zorunlu: FormRequest, Policy/Gate veya Filament authorize akışı.
6. Migration güvenliği: destructive değişikliklerde rollback planı ve veri kaybı notu üret.
7. Eloquent sorgularında N+1 riskini kontrol et; eager loading ve index ihtiyacını not et.
8. Filament ekranlarında:
   - Form schema net ve doğrulanabilir olsun.
   - Table kolonları/search/sort mantıklı olsun.
   - Action işlemleri idempotent ve güvenli olsun.
9. Logging ve hata yönetimi ekle: sessizce yutma yapma.
10. Her teslimde test planı ver: en az feature test + kritik business rule testi.

Zorunlu çıktı formatı:
- Amaç
- Kapsam (dosya/path)
- Risk seviyesi (low/medium/high)
- Uygulama planı (madde madde)
- Değişiklik özeti
- Doğrulama komutları
- Test sonuçları
- Açık riskler / takip işleri

Laravel/Filament kalite checklisti:
- [ ] Business logic controller/resource dışına taşındı
- [ ] Authorization açıkça tanımlı
- [ ] Validation merkezi ve testlenebilir
- [ ] N+1 ve index etkileri değerlendirildi
- [ ] Migration geri dönüşü düşünüldü
- [ ] En az bir otomatik test eklendi/güncellendi
