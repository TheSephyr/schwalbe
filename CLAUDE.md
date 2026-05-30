# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Schwalbe** is a football (soccer) manager simulation game built with Godot 4.6 (mobile renderer). The player takes the role of a **trainer** (not manager), selects a German club, negotiates player contracts, simulates matchdays, tracks league standings, manages finances, and develops the squad across multiple seasons. The name means "swallow" in German. The in-game world is set in the 1999/2000 season.

### Design Inspiration

**[`infos/A3_gameplay_features.md`](infos/A3_gameplay_features.md)** is the primary design reference for Schwalbe. It documents the core mechanics of *Anstoss 3* (the 1999 German football manager that Schwalbe is spiritually based on), including:

- Player strength calculation (7-step formula with Frische, Kondition, Talent, Eigenschaften)
- End-of-season upgrade/downgrade system with age and talent modifiers
- Manager career attributes and promotion conditions
- Finance system (tickets, sponsors, merchandise, friendlies)
- Training mechanics (Kondition vs Frische, overtraining thresholds)
- Transfer policy (market value curves, Stammplatzgarantie)
- Team talks and individual player conversation system
- Youth development and stadium expansion
- Tactics (man-marking, offside trap, formation effects on strength)

When designing or extending any game mechanic, consult this file first. Schwalbe should feel like a faithful spiritual successor to Anstoss 3.

## Running the Project

There are no build scripts — run and test via the Godot editor:

```bash
# Open in editor (must have Godot 4.x installed)
godot project.godot

# Run headless (e.g. for CI)
godot --headless --quit
```

The main entry scene is `res://scenes/starting_game.tscn`.

Toggle the debug overlay with **Ctrl+S** at runtime (shows current scene name and a "Simulate Season" button).

## Architecture

### Autoload Singletons

Registered in `project.godot` and accessible globally by name:

| Singleton | File | Purpose |
|-----------|------|---------|
| `Game` | `code/game.gd` | Central state: clubs, season, date, free agents, reporters, referees, celebrities, sponsors, sponsor contract, pending transfers, save/load, AI logic |
| `EventBus` | `code/global/event_bus.gd` | Pub/sub signal hub — UI scenes connect here instead of to each other |
| `GameState` | `code/global/game_state.gd` | Lightweight UI state: `selected_player`, `last_matchday`, `transfer_context`, `transfer_source_club` |
| `Global` | `code/global/global.gd` | Misc utilities |

### Data Flow

```
Game.initial_load()
  → ReadNationFile.loadNationFile()     # parses LandDeut.sav → Dictionary{clubs, reporters, referees, celebrities, sponsors}
  → Game.all_clubs / first_division_clubs[0..17] / reporters / referees / celebrities / sponsors
  → Season(first_division_clubs)        # generates round-robin schedule + assigns dates
	  → Matchday[] (each with a Date)
	  → Match[]
	  → Table (TeamStanding per club)
  → Game.current_date = Date(1, 7, 1999)
  → _generate_free_agents()            # 100 low-ability players from files/firstnames_male.txt + files/lastnames.txt
  → UI scenes subscribe to EventBus signals and render state

On each NEXT press (game._on_next):
  → wages deducted from player_club.money for days elapsed
  → training applied for the week
  → if matchday this week → navigate to match_preview_scene (two-phase flow)
  → else → advance 7 days, autosave

Match preview flow:
  → match_preview_scene shows lineups + attendance + ticket revenue (home games)
  → "Spieltag simulieren" → Game.confirm_matchday_simulation()
  → simulate matchday, advance date, autosave, navigate to matchday_view

Season end:
  → season_end.tscn shown
  → "Neue Saison starten" → Game.start_new_season()
	  → _apply_pending_transfers()     # pre-contract signings join
	  → _ai_renew_contracts()          # AI clubs renew ~85% of expiring contracts
	  → _remove_expired_contracts()    # remaining expired → free agents or retire
	  → _retire_free_agents()          # old free agents age out
	  → _ai_fill_squads()              # AI clubs below 22 players sign free agents by position
```

### Signal-Driven UI

`EventBus` emits three signals that scenes listen to:
- `next` — advance to the next screen/state
- `next_matchday` — simulate and move to next matchday
- `update_ui` — refresh displayed data (e.g. after simulation)

### Scene Navigation

Scenes switch via `get_tree().change_scene_to_file("res://scenes/...")`. `topUi.tscn` (current date + club name) and `bottomUi.tscn` (navigation buttons) are embedded in all league-phase screens.

**Bottom navigation buttons:** Clubs · Matchday · Table · Line-Up · Club · Balance · Kalender · Training · Einzeltraining · Suche · Transfers · Stadion · Ausgaben · Personal · Menü

### Key Data Models

- `code/game_config.gd` — `GameConfig`: single source of truth for all game-wide constants (no autoload, accessible via `class_name`):
  - World: `SEASON_START_YEAR=1999`, `FIRST_DIVISION_SIZE=18`
  - Club finances: `STARTING_CLUB_MONEY`
  - Player contract defaults + generation curve constants
  - Player ability/talent range (1–100 scale)
  - Player condition/freshness (1–100 scale) + training constants
  - Match simulation: `HOME_ADVANTAGE=1.15`, Poisson `MATCH_BASE_LAMBDA`, `MATCH_SCALE`
  - Season points: `POINTS_FOR_WIN=3`, `POINTS_FOR_DRAW=1`
  - Season schedule: Bundesliga-style dates, winter break constants
  - Retirement: `RETIREMENT_MIN_AGE=30`, `RETIREMENT_BASE_CHANCE`, `RETIREMENT_CHANCE_PER_YEAR`, `RETIREMENT_MAX_CHANCE`
  - Transfer market: `PRECONTRACT_WINDOW_DAYS=182`
  - Ticket pricing: `TICKET_PRICE_DEFAULT=25`, `TICKET_PRICE_MIN=5`, `TICKET_PRICE_MAX=150`, `TICKET_PRICE_STEP=5`
  - Generated free agents: `GENERATED_FREE_AGENT_COUNT=100`, `FREE_AGENT_MAX_ABILITY=4`, `FREE_AGENT_MAX_TALENT=4`
  - AI management: `AI_CONTRACT_RENEWAL_CHANCE=0.85`
  - Individual training: `INDIVIDUAL_TRAINING_WEEKS=8` — weeks for a player to fully learn one new skill

- `code/player.gd` — `Player`: name, position (`"1"`–`"10"`), talent/currentAbility (String, 1–100), birthdate, condition, freshness, matches_played; contract: `salary`, `auflauf_praemie`, `tor_praemie`, `market_value`, `contract_end`; `generate_contract()` scales financials from ability/talent via power curve; `POSITION_LABELS` dict maps codes to labels (GK, LI, CB, LB, RB, CDM, LM, RM, CM, ST); `POSITION_CODES` is the reverse mapping (label → code)
  - Appearance: `skin_color: SkinColorTypes.SkinColor`, `hair_color: HairColorTypes.HairColor`, `hair_style: HairStyleTypes.HairStyle`, `beard: BeardTypes.Beard`
  - Positions: `secondary_position_1/2: PositionTypes.Position`
  - Skills/traits (bitmask-parsed arrays): `positive_skills: Array[PlayerSkillTypes.Skill]`, `negative_skills: Array[PlayerSkillTypes.Skill]`, `characteristics: Array[PlayerCharacteristicTypes.Characteristic]`
  - **Goalkeeper skills** (position `"1"` only — different bitmask): `gk_positive_skills: Array[GoalkeeperSkillTypes.Skill]`, `gk_negative_skills: Array[GoalkeeperSkillTypes.Skill]`; outfield `positive_skills`/`negative_skills` remain empty for GKs
  - Character: `character: PlayerCharacterTypes.Character` (bitmask int)
  - Misc: `foot: FootTypes.Foot`, `health: HealthTypes.Health`, `crowd_appeal: CrowdAppealTypes.CrowdAppeal`, `has_stage_name: bool`, `stage_name: String`, `country: int`, `country_2: int`, `nation_player: int`, `captain_retirement: int`, `squad_number: int`
  - **Individual training**: `training_skill: int = 0` (0 = none; otherwise a `PlayerSkillTypes.Skill` or `GoalkeeperSkillTypes.Skill` int value), `training_progress: float = 0.0` (0–1); advanced by `1/INDIVIDUAL_TRAINING_WEEKS` each week by `game._apply_individual_training()`; on completion the skill is appended to the appropriate positive_skills array and both fields reset to 0
  - All fields above are populated by `ReadNationFile` from `LandDeut.sav` using `PlayerFieldIndex` constants
  - **`effective_strength(slot: String) -> int`** — A3-faithful strength used in match simulation: base `currentAbility` ± fitness deviation (±2), ± talent bonus (WONDERKID +20 … TWO_LEFT_FEET −20, halved for ability >75, capped at 80), +10/−10 per positive/negative skill, − position penalty (0 if primary or secondary position matches slot; otherwise `_position_distance / 2` where distance: same group = |Δpos|, cross-group = |Δgroup|×2+1, GK↔outfield = 8)

- `code/club.gd` — `Club`: name, roster (`Player[]`), `currentLineUp: Array[Player]`, `currentLineUpSlots: Array[String]` (parallel array of formation slot labels, e.g. `"CB"`, `"ST"`; populated by `apply_formation()` alongside `currentLineUp`), `money` (set from `BALANCE` field in .sav), `manager`, `trainer`, `stadium`; `total_daily_wages()` = sum(salary)/365; `pay_wages(days)` deducts; `defaultLineUp()` / `apply_formation()`
  - Tactics: `spielstil: int` (default `GameConfig.SPIELSTIL_AUSGEWOGEN`), `pressing: int` (default `GameConfig.PRESSING_MITTEL`)
  - Sponsor contract: `sponsor_name: String`, `sponsor_income: int` (DM/season), `sponsor_duration: int` (years), `sponsor_championship_bonus: int` (DM); set in `sponsor_scene` during preseason; `sponsor_income` credited to `money` when "Saison starten" is pressed in `preseason_scene`
  - Attendance planning: `planned_attendance: int = 0` — player-set average attendance used for ticket revenue projection in `attendance_revenue_scene`; persisted in saves
  - Identity: `abbreviation`, `chant`, `fan_name`, `abbreviation_article: AbbreviationArticleTypes.Article`, `media_city`, `founding_year`, `public_company`, `regional_league: RegionalLeagueTypes.RegionalLeague`
  - Kits: `home_kit_color1/2/shorts_color/socks_color: KitColorTypes.KitColor`, `home_kit_pattern: KitPatternTypes.KitPattern`, `home_kit_socks_striped: bool` (same set for `away_kit_*`); color1+pattern are packed in a single file field: `color = val & 0xF`, `pattern = (val >> 4) & 0xF`; socks: `color = val & 0xF`, `striped = (val & 0x10) != 0`
  - Fans: `fan_attendance: FanAttendanceTypes.FanAttendance`, `fan_type: FanTypeTypes.FanType`, `fan_friendship_with: int`, `arch_rival: int`, `max_fan_attendance: int`, `hooligans: HooliganTypes.Hooligans`
  - Organisation: `board: BoardTypes.Board`, `cup_team: int`, `opposition: OppositionTypes.Opposition`, `amateur_section_of: int`, `pro_section_of: int`, `financial_strength: FinancialStrengthTypes.FinancialStrength`
  - Chairman: `chairman_lastname`, `chairman_firstname`, `chairman_birthday`
  - History: `all_time_goals`, `all_time_goals_against`, `all_time_matches`, `all_time_points`, `titles_championships`, `titles_cups`, `titles_league_cups`, `titles_europa_leagues`, `titles_champions_leagues`, `titles_world_cups`

- `code/stadium.gd` — `Stadium`: name, city, north/south/west/east capacities (main+away+left+right stands, standing+seating summed), `ticket_price` (DM, adjustable in stadium scene); `total()` returns sum of all stands
  - Facilities: `scoreboard: ScoreboardTypes.Scoreboard`, `pitch_heating`, `floodlights`, `running_track`, `heat_lamps` (bitmask), `luxury_boxes`, `seat_cushions`, `heated_seats`, `retractable_pitch` (all bool/int)
  - Location: `home_stand`, `away_stand`, `city_location`, `owned`, `motorway`, `tv_tower`, `mountains`, `castle`, `palace`
  - Per-stand: `main_vip`, `main_condition: StadiumConditionTypes.Condition` (repeated for away/left/right); `roof: int` (bitmask per `RoofCoverTypes.RoofCover`)

- `code/manager.gd` — `Manager`: lastname, firstname, birthdate, `competence: int`; `age(year)` computes from birthdate; `full_name()`

- `code/trainer.gd` — `Trainer`: lastname, firstname, birthdate, `competence: int`, `reputation: TrainerReputationTypes.Reputation`; `age(year)` computes from birthdate; `full_name()`

- `code/reporter.gd` — `Reporter`: broadcaster, lastname, firstname, `attitude: ReporterAttitudeTypes.Attitude`; `full_name()`; stored in `Game.reporters`

- `code/referee.gd` — `Referee`: firstname, lastname, `competence: int`, `strictness: int`, `disliked_club: int`, `characteristics: Array[RefereeCharacteristicTypes.Characteristic]` (bitmask-parsed); `full_name()`; stored in `Game.referees` (both `%SECT%SCHIRI` and `%SECT%ISCHIRI`)

- `code/celebrity.gd` — `Celebrity`: lastname, firstname, `favorite_club: int`; `full_name()`; stored in `Game.celebrities`

- `code/sponsor.gd` — `Sponsor`: `name: String`, `income_per_season: int` (DM; field value × 1000); stored in `Game.sponsors` (40 entries from `%SECT%SPONSOR`). Active contract stored on `player_club` (`sponsor_name`, `sponsor_income`, `sponsor_duration`, `sponsor_championship_bonus`); income credited to `player_club.money` when "Saison starten" is pressed in `preseason_scene`.

- `code/util/date.gd` — `Date` (RefCounted): day/month/year; `add_days(n) → Date`; `days_until(other) → int` (Julian Day Number diff)

- `season/season.gd` — Owns matchday schedule and `Table`; double round-robin; Bundesliga-style dates

- `season/table.gd` / `season/teamStanding.gd` — League standings sorted by points then goal difference

- `match/match.gd` — Simulates goals via Poisson weighted by lineup strength; home advantage 1.15×; `_lineup_strength()` averages `player.effective_strength(slot)` across all 11 starters using `club.currentLineUpSlots` (falls back to `player.position_label()` if slots array is shorter)

- `match/matchday.gd` — Collection of matches for one matchday; holds a `date: Date`

### Transfer Market

Four transfer contexts stored in `GameState.transfer_context`:

| Context | When | Result on accept |
|---------|------|-----------------|
| `"renewal"` | Right-click own player | Update contract in-place |
| `"free"` | Right-click free agent | `Game.sign_player_immediately()` — joins now |
| `"precontract"` | External player, ≤182 days left on contract | `Game.add_pending_transfer()` — joins next season start |
| `"transfer"` | External player, >182 days left — fee accepted first in `transfer_scene` | `Game.sign_player_immediately()` — joins now |

`Game.pending_transfers` is serialized to save files. Applied in `start_new_season()` before contract processing.

### AI Season Transition (start_new_season order)

1. `_apply_pending_transfers()` — pending signings join player club
2. `_ai_renew_contracts(next_year)` — AI clubs renew ~85% of expiring contracts (1–3 yr extension, 0–15% salary bump)
3. `_remove_expired_contracts()` — remaining expired players → free agents or retire
4. `_retire_free_agents()` — elderly free agents age out
5. `_ai_fill_squads()` — AI clubs with <22 players sign best available free agents by position priority (GK×2, CB×3, LB×1, RB×1, LM×1, RM×1, CM×1, ST×2 minimum; fills to max per position until 22)

### Scenes

| Scene | Path | Description |
|-------|------|-------------|
| Starting game | `scenes/starting_game.tscn` | Entry point |
| Main menu | `scenes/main_menu.tscn` | New game / load game |
| Trainer setup | `scenes/manager_setup/manager_setup_scene.tscn` | Enter trainer name + age before new game |
| Team selection | `scenes/team_selection.tscn` | Pick your club → navigates to preseason scene |
| Preseason | `scenes/preseason/preseason_scene.tscn` | Hub before season start; "Kalkulation" → calculation scene; "Saison starten" credits `sponsor_income` to `player_club.money` then navigates to club overview |
| Calculation | `scenes/preseason/calculation_scene.tscn` | Financial planning hub; links to Sponsors and Attendance Revenue sub-scenes |
| Sponsor search | `scenes/preseason/sponsor_scene.tscn` | 3 random sponsors drawn from `Game.sponsors`; accept at base price or negotiate (up to 130% base, +1 year duration, up to 150% championship bonus); result stored on `player_club` |
| Attendance revenue | `scenes/preseason/attendance_revenue_scene.tscn` | Slider to set planned average attendance (1–stadium capacity); shows projected season ticket revenue; persisted as `player_club.planned_attendance` |
| Tactics | `scenes/tactics/tactics_scene.tscn` | Spielstil and pressing selection |
| Club overview | `scenes/club/club.tscn` | Roster list; toggle current vs next-season squad |
| Player profile | `scenes/player/player_scene.tscn` | Player stats + contract |
| Contract negotiation | `scenes/contract/contract_scene.tscn` | Adjust salary/bonuses/years; context-aware (renewal/free/precontract/transfer) |
| Transfer fee | `scenes/transfer/transfer_scene.tscn` | Negotiate fee with source club before contract talks |
| Line-up | `scenes/lineup/lineUp.tscn` | Current formation |
| Match preview | `scenes/match_preview/match_preview_scene.tscn` | Pre-match lineups, attendance, ticket revenue |
| Matchday view | `scenes/matchday_view.tscn` | Results of the last played matchday |
| Table | `scenes/table/table_scene.tscn` | Live league standings |
| Balance | `scenes/balance/balance_scene.tscn` | Club finances |
| Expenditure | `scenes/expenditure/expenditure_scene.tscn` | Season wage + bonus costs (full season vs remaining) |
| Calendar | `scenes/calendar/calendar_scene.tscn` | Monthly calendar; matchdays highlighted |
| Training | `scenes/training/training_scene.tscn` | Weekly training plan (condition vs regen); drag-and-drop per week |
| Individual training | `scenes/individual_training/individual_training_scene.tscn` | Per-player skill training; rows show name · position · skill being learned (green) · progress bar · existing skills (green/red); click row → skill picker overlay; skills already owned are excluded; GK players see `GoalkeeperSkillTypes` skills, outfield see `PlayerSkillTypes` skills |
| Stadium | `scenes/stadium/stadium_scene.tscn` | Stadium schematic + ticket price adjustment |
| Player search | `scenes/player_search/player_search_scene.tscn` | Filter by position/age/talent/ability; "Nur Vereinslose" for free agents; "Vertrag läuft aus" for expiring contracts; right-click to negotiate |
| Settings | `scenes/settings/settings_scene.tscn` | Save/load management, main menu, quit |
| Season end | `scenes/season_end/season_end.tscn` | Final standings; start next season |
| Personnel directory | `scenes/personal/personal_scene.tscn` | Scrollable list of all NPCs (Manager, Trainer, Reporters, Referees, Celebrities); click row → person detail |
| Person detail | `scenes/person/person_scene.tscn` | Shows fields for any NPC type; type dispatched via `GameState.selected_person` (RefCounted) using `is` checks |

### File Reader Infrastructure (`code/filrereader/`)

Note: directory name has a typo (`filrereader`, not `filereader`) — do not rename it.

- `read_nation_file.gd` — `ReadNationFile`: static `loadNationFile()` parses `LandDeut.sav` and returns a `Dictionary` with keys `clubs` (`Array[Club]`), `reporters` (`Array[Reporter]`), `referees` (`Array[Referee]`), `celebrities` (`Array[Celebrity]`), `sponsors` (`Array[Sponsor]`). Line counters are **0-based** and matched against field index enums (no magic numbers). Club post-manager fields are read via a separate `readingClubPost` / `lineCounterClubPost` state that activates after `%ENDSECT%STADION` within a `%SECT%VEREIN` block. `%SECT%SCHIRI` and `%SECT%ISCHIRI` are both parsed into the same referees array. `%SECT%SPONSORP` is a parent wrapper with no own fields — it is silently skipped; individual `%SECT%SPONSOR` entries inside it are parsed normally.
- `field_mappings.gd` — `FieldMappings`: lookup tables (`PackedStringArray` / `Dictionary`) and legacy `SP_*`/`VE_*`/`VP_*`/`TR_*`/`MA_*`/`ST_*`/`RE_*`/`SC_*`/`PR_*` constants. Use field index enums instead of these constants for new code.

**Field index enums** (0-based integers matching each section's line offsets):

| File | Class | Section |
|------|-------|---------|
| `player_field_index.gd` | `PlayerFieldIndex` | `%SECT%SPIELER` |
| `club_field_index.gd` | `ClubFieldIndex` | `%SECT%VEREIN` (two enums: `HeaderField`, `PostField`) |
| `trainer_field_index.gd` | `TrainerFieldIndex` | `%SECT%TRAINER` |
| `manager_field_index.gd` | `ManagerFieldIndex` | `%SECT%MANAGER` |
| `stadium_field_index.gd` | `StadiumFieldIndex` | `%SECT%STADION` |
| `reporter_field_index.gd` | `ReporterFieldIndex` | `%SECT%REPORTER` |
| `referee_field_index.gd` | `RefereeFieldIndex` | `%SECT%SCHIRI` / `%SECT%ISCHIRI` |
| `celebrity_field_index.gd` | `CelebrityFieldIndex` | `%SECT%PROMI` |
| `sponsor_field_index.gd` | `SponsorFieldIndex` | `%SECT%SPONSOR` |

### Type Enums

All lookup tables from `FieldMappings` have corresponding enum classes. Enum values equal the array index (or bitmask bit for `*_BITS` tables). Use these instead of raw integers when working with parsed game data.

**`code/player/` — player-specific:**

| File | Class | Enum | Source table |
|------|-------|------|-------------|
| `player_skill_types.gd` | `PlayerSkillTypes` | `Skill` | `SPIELER_FAEHIGKEITEN` (bitmask); also has `static var LABELS: Dictionary` mapping `Skill` values to German display names |
| `goalkeeper_skill_types.gd` | `GoalkeeperSkillTypes` | `Skill` | `TORWART_FAEHIGKEITEN` (bitmask); also has `static var LABELS: Dictionary` mapping `Skill` values to German display names |
| `characteristic_types.gd` | `PlayerCharacteristicTypes` | `Characteristic` | `EIGENSCHAFTEN` (bitmask) |
| `player_character_types.gd` | `PlayerCharacterTypes` | `Character` | `CHARAKTER` (bitmask) |
| `beard_types.gd` | `BeardTypes` | `Beard` | `BART_BITS` (bitmask) |
| `skin_color_types.gd` | `SkinColorTypes` | `SkinColor` | `HAUTFARBE` |
| `hair_color_types.gd` | `HairColorTypes` | `HairColor` | `HAARFARBE` |
| `hair_style_types.gd` | `HairStyleTypes` | `HairStyle` | `HAAR` |
| `position_types.gd` | `PositionTypes` | `Position` | `POSITION` |
| `foot_types.gd` | `FootTypes` | `Foot` | `FUSS` (1-based; `NONE=0`) |
| `talent_types.gd` | `TalentTypes` | `Talent` | `TALENT` (1-based; `NONE=0`) |
| `health_types.gd` | `HealthTypes` | `Health` | `GESUNDHEIT` |
| `crowd_appeal_types.gd` | `CrowdAppealTypes` | `CrowdAppeal` | `PUBLIKUM` (1-based; `NONE=0`) |
| `abbreviation_article_types.gd` | `AbbreviationArticleTypes` | `Article` | `KUERZEL_ARTIKEL` |

**`code/club/` — club / kit / fans:**

| File | Class | Enum | Source table |
|------|-------|------|-------------|
| `kit_color_types.gd` | `KitColorTypes` | `KitColor` | `TRIKOT_FARBE` |
| `kit_pattern_types.gd` | `KitPatternTypes` | `KitPattern` | `TRIKOT_MUSTER` |
| `fan_attendance_types.gd` | `FanAttendanceTypes` | `FanAttendance` | `FANAUFKOMMEN` |
| `fan_type_types.gd` | `FanTypeTypes` | `FanType` | `ART_DER_FANS` |
| `board_types.gd` | `BoardTypes` | `Board` | `VORSTAND` |
| `opposition_types.gd` | `OppositionTypes` | `Opposition` | `OPPOSITION` |
| `financial_strength_types.gd` | `FinancialStrengthTypes` | `FinancialStrength` | `FINANZKRAFT` |
| `hooligan_types.gd` | `HooliganTypes` | `Hooligans` | `HOOLIGANS` |

**`code/trainer/`:**

| File | Class | Enum | Source table |
|------|-------|------|-------------|
| `trainer_reputation_types.gd` | `TrainerReputationTypes` | `Reputation` | `TRAINER_RUF` |

**`code/referee/`:**

| File | Class | Enum | Source table |
|------|-------|------|-------------|
| `referee_characteristic_types.gd` | `RefereeCharacteristicTypes` | `Characteristic` | `SCHIRI_EIGENSCHAFTEN` (bitmask) |

**`code/reporter/`:**

| File | Class | Enum | Source table |
|------|-------|------|-------------|
| `reporter_attitude_types.gd` | `ReporterAttitudeTypes` | `Attitude` | `BOESE_LIEB` |

**`code/stadium/`:**

| File | Class | Enum | Source table |
|------|-------|------|-------------|
| `scoreboard_types.gd` | `ScoreboardTypes` | `Scoreboard` | `ANZEIGETAFEL` |
| `stand_types.gd` | `StandTypes` | `Stand` | `TRIBUNEN_TYP` |
| `stadium_condition_types.gd` | `StadiumConditionTypes` | `Condition` | `STADION_ZUSTAND` |
| `roof_cover_types.gd` | `RoofCoverTypes` | `RoofCover` | `DACH_BITS` (bitmask) |

**`code/league/`:**

| File | Class | Enum | Source table |
|------|-------|------|-------------|
| `regional_league_types.gd` | `RegionalLeagueTypes` | `RegionalLeague` | `REGIONALLIGA` (values 2/5, not 0-based) |

### Database & Data Files

- `dbfiles/LandDeut.sav` — main game data; custom line-based format with `%SECT%`/`%ENDSECT%` delimiters
  - `%SECT%SPIELER` — players
  - `%SECT%VEREIN` — clubs (header fields + post-manager block)
  - `%SECT%TRAINER` — coaches
  - `%SECT%MANAGER` — managers
  - `%SECT%STADION` — stadiums
  - `%SECT%REPORTER` — TV reporters
  - `%SECT%SCHIRI` / `%SECT%ISCHIRI` — referees
  - `%SECT%PROMI` — celebrities
  - `%SECT%SPONSORP` — parent wrapper for all sponsor entries (no own data fields; silently skipped by reader)
  - `%SECT%SPONSOR` — individual sponsors (40 entries): field 0 = name, field 6 = income in thousands DM
  - `%SECT%LAND` — nation data
- `files/firstnames_male.txt` — male first names for generated free agents (one per line)
- `files/lastnames.txt` — last names for generated free agents (one per line)

### Save / Load

JSON saves in `user://saves/`. Each save includes: clubs (players, lineup, money, stadium, trainer), current date, season state, matchday results, training plan, free agents, pending transfers, sponsor contract (`sponsor_name`, `sponsor_income`). Per-player: `training_skill`, `training_progress`. Autosave runs after each week advance and matchday confirmation.

## Code Conventions

- Programming language is **English** — this applies to identifiers, variables, functions, class names, comments, and **file/directory names**
- Static typing throughout
- GDScript with Godot 4 syntax (`class_name`, typed signals, `@export`, etc.)
- Snake_case for functions, variables, and file names; PascalCase for class names
- gdLinter addon is active — keep code clean to avoid editor warnings
- No automated tests exist; test by running scenes in the editor
- UI text visible to the player is in **German** (game is set in Germany)
