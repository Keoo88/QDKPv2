<p align="center">
  <img src="https://github.com/user-attachments/assets/ad7e5dc6-9556-4e4e-afb5-08c8acc5e5fd" alt="QDKPv2" width="90"><br><br>
  <img src="https://img.shields.io/badge/QDKPv2-2.6.7-ff8800?style=for-the-badge&logo=appveyor">
  <img src="https://img.shields.io/badge/WotLK-3.3.5a-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/status-stable-brightgreen?style=for-the-badge">
</p>

<h1 align="center">QDKPv2 — WotLK 3.3.5a (Community Build)</h1>

<p align="center">
  <b>Complete in-game DKP management system for World of Warcraft 3.3.5a (WotLK).</b><br>
  <i>Modified QDKPv2 2.6.7 for 3.3.5a, with additional bid, backup and loot improvements.</i>
</p>

<p align="center">
  <a href="#english">English</a> ·
  <a href="#russian">Русский</a>
</p>

---

<a name="english"></a>
## English

<p align="center">
  <a href="#whats-new">What's New</a> ·
  <a href="#base-changes">3.3.5a Changes</a> ·
  <a href="#slash-commands">Slash Commands</a> ·
  <a href="#installation">Installation</a> ·
  <a href="#credits">Credits</a>
</p>

### About

**QDKPv2** (Quick DKP V2) is a complete system for managing DKP (Dragon Kill
Points) directly in-game: bidding, loot tracking, boss awards, standby
modifiers, alts, logs, and full guild-note synchronization. This repository is
a **backport of QDKPv2 2.6.7 to the WoW 3.3.5a (WotLK) client**, with a set of
additional community improvements on top.

<p align="center">
  <img src="https://github.com/user-attachments/assets/60874cbd-a23f-4ffa-a152-c439201cffef" alt="Quick DKP V2 panel" width="360">
</p>

<a name="whats-new"></a>
### What's New in This Build

Quality-of-life and fairness features added on top of the 3.3.5a port:

#### Bidding

- **Minimum bid increment** — a new bid must beat the current top bid by at
  least `QDKP2_BidM_MinIncrement` DKP. Set to `0` to disable.
- **Anti-snipe** — if a bid arrives during the 3-2-1 countdown, the countdown
  restarts instead of just being cancelled (`QDKP2_BidM_AntiSnipe` ticks). Set
  to `0` for the old behavior.
- **QuickBid** — `ALT`+click an item in your bags instantly starts a bid on it
  (officers only). Toggle with `QDKP2_QuickBid_Enabled`.

<p align="center">
  <img src="https://github.com/user-attachments/assets/98601e35-d6b0-4810-9ce3-4f490b05a3b1" alt="Bid Manager" width="760">
</p>

#### Backups

- **Rotating backups** — instead of a single overwrite, the addon keeps a
  rotation of the last `QDKP2_BACKUP_MAX` snapshots (default 5, newest first).
- **Restore any snapshot** — restore the newest or any older backup by index.
- **List backups** — print all stored snapshots with their dates.

#### Data & Loot

- **Integrity check** — verifies internal consistency of DKP data
  (`net == total − spent`) for every main and reports mismatches.
- **Locale-independent item type matching** — badges/shards filtering now works
  correctly on non-English clients (enUS + ruRU fallbacks for Money / Trade
  Goods / Enchanting).
- **Multi-loot quantity parsing** — correctly reads stacked loot messages
  (e.g. "xN" suffix) when logging looted items.

#### Interface

- **Right-click minimap button** → opens the **Bid Manager** roster directly
  (officers only); left-click still toggles the main window.

<p align="center">
  <img src="https://github.com/user-attachments/assets/2b9b563d-6f85-4a07-9b48-fe865422d74a" alt="Guild roster" width="620"><br>
  <img src="https://github.com/user-attachments/assets/f4120851-92a2-45a8-9dfd-dfb391603fa4" alt="Raid log" width="760">
</p>

<a name="base-changes"></a>
### 3.3.5a Base Changes

Inherited from the QDKPv2 2.6.7 WotLK port:

- Implemented heroic boss detection (`DKP_10N` / `DKP_10H` / `DKP_25N` / `DKP_25H`).
- Auto-distribute loot when charging a raid member for an item (loot window must be open).
- Auto-distribute loot when a raid member wins a no-DKP roll (loot window must be open).
- Fixed "The Ruby Sanctum" zone name (boss-award now works in RS).
- Correctly parse "Halion the Twilight Destroyer" (boss-award now works for Halion).
- LibBabble (translations) updated to the latest 3.3.5 release.
- LibBabble: corrected Russian localizations for GSB, BPC and BQL to match the latest stable DBM for 3.3.5a.
- Fixed Russian localization of Halion the Twilight Destroyer.
- Possible fix for incorrect alt links when a bugged character with an empty name is in the guild.
- Accept bids in "5k" format.
- Accept bids in "10 os" format.
- Fixed incorrect (often negative) DKP for characters who left and rejoined the guild.
- Better localization support; Russian localization added.
- Quick-modify DKP amount can be correctly set via `Options.ini`.
- DKP modifiers for standby players.
- Correctly preload DBM/BigWigs if installed.
- Fixed whispers to alts.
- "Modify Guild Info" permission no longer required.

<a name="slash-commands"></a>
### Slash Commands

Type `/qdkp` for the full command list. Commands added in this build:

| Command | Description |
| --- | --- |
| `/qdkp backup` | Make a new backup snapshot |
| `/qdkp backup list` | List all stored snapshots with dates |
| `/qdkp restore` | Restore the newest snapshot |
| `/qdkp restore <n>` | Restore snapshot number `<n>` (1 = newest) |
| `/qdkp integrity` | Run the DKP data integrity check |

<a name="installation"></a>
### Installation

1. Download the latest release (or clone this repository).
2. Extract the archive.
3. Move the **QDKP_V2** and **QDKP2_GUI** folders into:
   ```
   \Interface\AddOns\
   ```
4. Enable both on the character-select AddOns screen and launch the game. Type `/qdkp` to get started.

### Compatibility

- Built and tested on **WoW 3.3.5a (WotLK)**, Interface `30300`.
- `Options.ini` is **not** compatible with the original QDKP2 addon.
- Optional dependencies: AtlasLoot, DBM-Core, BigWigs.

<a name="credits"></a>
### Credits

- Original addon: **QDKPv2** — Quick DKP V2, a complete in-game DKP management system.
- Modified by: **Keoo**

---

<a name="russian"></a>
## Русский

<p align="center">
  <a href="#что-нового">Что нового</a> ·
  <a href="#изменения-335a">Изменения 3.3.5a</a> ·
  <a href="#команды">Команды</a> ·
  <a href="#установка">Установка</a> ·
  <a href="#благодарности">Благодарности</a>
</p>

### Об аддоне

**QDKPv2** (Quick DKP V2) — полноценная система управления DKP (Dragon Kill
Points) прямо в игре: ставки, учёт лута, начисления за боссов, модификаторы для
запасных, твинки, логи и полная синхронизация через заметки гильдии. Этот
репозиторий — **бэкпорт QDKPv2 2.6.7 под клиент WoW 3.3.5a (WotLK)** с набором
дополнительных доработок сообщества.

<p align="center">
  <img src="https://github.com/user-attachments/assets/60874cbd-a23f-4ffa-a152-c439201cffef" alt="Панель Quick DKP V2" width="360"><br>
  <img src="https://github.com/user-attachments/assets/98601e35-d6b0-4810-9ce3-4f490b05a3b1" alt="Bid Manager" width="760">
</p>

<a name="что-нового"></a>
### Что нового в этой сборке

Доработки для удобства и честности торгов поверх порта 3.3.5a:

#### Ставки

- **Минимальный шаг ставки** — новая ставка должна превышать текущую
  максимальную минимум на `QDKP2_BidM_MinIncrement` DKP. `0` — отключено.
- **Анти-снайп** — если ставка приходит во время отсчёта 3-2-1, отсчёт
  перезапускается, а не отменяется (`QDKP2_BidM_AntiSnipe` тиков). `0` —
  старое поведение.
- **QuickBid** — `ALT`+клик по предмету в сумках мгновенно начинает торги по
  нему (только офицеры). Переключается через `QDKP2_QuickBid_Enabled`.

#### Резервные копии

- **Ротация бэкапов** — вместо перезаписи одной копии аддон хранит последние
  `QDKP2_BACKUP_MAX` снимков (по умолчанию 5, новые сверху).
- **Восстановление любого снимка** — восстановить самый свежий или любой более
  старый бэкап по номеру.
- **Список бэкапов** — вывод всех сохранённых снимков с датами.

#### Данные и лут

- **Проверка целостности** — проверяет корректность данных DKP
  (`net == total − spent`) у всех мейнов и сообщает о расхождениях.
- **Определение типа предмета без привязки к языку** — фильтрация значков/шардов
  теперь работает и на неанглийских клиентах (enUS + ruRU для «Деньги» /
  «Хозяйственные товары» / «Наложение чар»).
- **Разбор количества лута** — корректно читает сообщения о стаках предметов
  (суффикс «xN») при логировании лута.

#### Интерфейс

- **Правый клик по кнопке на миникарте** → открывает ростер **Bid Manager**
  напрямую (только офицеры); левый клик по-прежнему открывает главное окно.

<a name="изменения-335a"></a>
### Базовые изменения 3.3.5a

Унаследовано от порта QDKPv2 2.6.7 под WotLK:

- Определение героических боссов (`DKP_10N` / `DKP_10H` / `DKP_25N` / `DKP_25H`).
- Автораздача лута при списании DKP с рейдера за предмет (окно лута должно быть открыто).
- Автораздача лута при выигрыше ролла без DKP (окно лута должно быть открыто).
- Исправлено название зоны «The Ruby Sanctum» (начисление за босса теперь работает в RS).
- Корректный разбор имени «Halion the Twilight Destroyer» (начисление за Халиона теперь работает).
- LibBabble (переводы) обновлён до последнего релиза 3.3.5.
- LibBabble: исправлены русские локализации GSB, BPC и BQL по последнему стабильному DBM для 3.3.5a.
- Исправлена русская локализация Halion the Twilight Destroyer.
- Возможное исправление некорректных ссылок на твинков, если в гильдии есть баганый персонаж с пустым именем.
- Приём ставок в формате «5k».
- Приём ставок в формате «10 os».
- Исправлен некорректный (часто отрицательный) DKP у персонажей, покинувших и вернувшихся в гильдию.
- Улучшенная поддержка локализаций; добавлена русская локализация.
- Быстрое изменение размера DKP корректно задаётся через `Options.ini`.
- Модификаторы DKP для запасных игроков.
- Корректная предзагрузка DBM/BigWigs, если установлены.
- Исправлены шёпоты твинкам.
- Право «Изменять информацию о гильдии» больше не требуется.

<a name="команды"></a>
### Команды (Slash Commands)

Введите `/qdkp` для полного списка команд. Команды, добавленные в этой сборке:

| Команда | Описание |
| --- | --- |
| `/qdkp backup` | Создать новый снимок-бэкап |
| `/qdkp backup list` | Показать все снимки с датами |
| `/qdkp restore` | Восстановить самый свежий снимок |
| `/qdkp restore <n>` | Восстановить снимок номер `<n>` (1 = самый новый) |
| `/qdkp integrity` | Запустить проверку целостности данных DKP |

<a name="установка"></a>
### Установка

1. Скачайте последний релиз (или клонируйте репозиторий).
2. Распакуйте архив.
3. Переместите папки **QDKP_V2** и **QDKP2_GUI** в:
   ```
   \Interface\AddOns\
   ```
4. Включите оба аддона на экране выбора персонажа и запустите игру. Введите `/qdkp`, чтобы начать.

### Совместимость

- Собрано и протестировано на **WoW 3.3.5a (WotLK)**, Interface `30300`.
- `Options.ini` **не** совместим с оригинальным аддоном QDKP2.
- Необязательные зависимости: AtlasLoot, DBM-Core, BigWigs.

<a name="благодарности"></a>
### Благодарности

- Оригинальный аддон: **QDKPv2** — Quick DKP V2, полная система управления DKP в игре.
- Модификация: **Keoo**
