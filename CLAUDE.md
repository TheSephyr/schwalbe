# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Schwalbe** is a football (soccer) manager simulation game built with Godot 4.6 (mobile renderer). The player takes the role of a **trainer** (not manager), selects a German club, negotiates player contracts, simulates matchdays, tracks league standings, manages finances, and develops the squad across multiple seasons. The name means "swallow" in German. The in-game world is set in the 1999/2000 season.

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
| `Game` | `code/game.gd` | Central state: clubs, season, date, free agents, pending transfers, save/load, AI logic |
| `EventBus` | `code/global/event_bus.gd` | Pub/sub signal hub — UI scenes connect here instead of to each other |
| `GameState` | `code/global/game_state.gd` | Lightweight UI state: `selected_player`, `last_matchday`, `transfer_context`, `transfer_source_club` |
| `Global` | `code/global/global.gd` | Misc utilities |

### Data Flow

```
Game.initial_load()
  → ReadNationFile.loadNationFile()     # parses LandDeut.sav
  → Game.all_clubs / first_division_clubs[0..17]
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

**Bottom navigation buttons:** Clubs · Matchday · Table · Line-Up · Club · Balance · Kalender · Training · Suche · Stadion · Ausgaben · Menü

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

- `code/player.gd` — `Player`: name, position (`"1"`–`"10"`), talent/currentAbility (String, 1–100), birthdate, condition, freshness, matches_played; contract: `salary`, `auflauf_praemie`, `tor_praemie`, `market_value`, `contract_end`; `generate_contract()` scales financials from ability/talent via power curve; `POSITION_LABELS` dict maps codes to labels (GK, LI, CB, LB, RB, CDM, LM, RM, CM, ST)

- `code/club.gd` — `Club`: name, roster (`Player[]`), lineup, `money`, `manager`, `trainer`, `stadium`; `total_daily_wages()` = sum(salary)/365; `pay_wages(days)` deducts; `defaultLineUp()` / `apply_formation()`

- `code/stadium.gd` — `Stadium`: name, city, north/south/west/east capacities (from .sav), `ticket_price` (DM, adjustable in stadium scene); `total()` returns sum of all stands

- `code/manager.gd` / `code/trainer.gd` — Simple data classes: lastname, firstname, birthdate

- `code/util/date.gd` — `Date` (RefCounted): day/month/year; `add_days(n) → Date`; `days_until(other) → int` (Julian Day Number diff)

- `season/season.gd` — Owns matchday schedule and `Table`; double round-robin; Bundesliga-style dates

- `season/table.gd` / `season/teamStanding.gd` — League standings sorted by points then goal difference

- `match/match.gd` — Simulates goals via Poisson weighted by lineup ability; home advantage 1.15×

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
| Team selection | `scenes/team_selection.tscn` | Pick your club |
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
| Stadium | `scenes/stadium/stadium_scene.tscn` | Stadium schematic + ticket price adjustment |
| Player search | `scenes/player_search/player_search_scene.tscn` | Filter by position/age/talent/ability; "Nur Vereinslose" for free agents; "Vertrag läuft aus" for expiring contracts; right-click to negotiate |
| Settings | `scenes/settings/settings_scene.tscn` | Save/load management, main menu, quit |
| Season end | `scenes/season_end/season_end.tscn` | Final standings; start next season |

### Database & Data Files

- `dbfiles/LandDeut.sav` — main game data (clubs, players, stadiums); custom line-based format
  - `%SECT%SPIELER` — players
  - `%SECT%VEREIN` — clubs
  - `%SECT%TRAINER` — coaches (parsed but not used)
  - `%SECT%STADION` — stadiums (N/S/W/E stand capacities parsed)
- `files/firstnames_male.txt` — male first names for generated free agents (one per line)
- `files/lastnames.txt` — last names for generated free agents (one per line)

### Save / Load

JSON saves in `user://saves/`. Each save includes: clubs (players, lineup, money, stadium, trainer), current date, season state, matchday results, training plan, free agents, pending transfers. Autosave runs after each week advance and matchday confirmation.

## Code Conventions

- Programming language (identifiers, variables, functions, class names, comments) is **English**
- Static typing throughout
- GDScript with Godot 4 syntax (`class_name`, typed signals, `@export`, etc.)
- Snake_case for functions and variables; PascalCase for class names
- gdLinter addon is active — keep code clean to avoid editor warnings
- No automated tests exist; test by running scenes in the editor
- UI text visible to the player is in **German** (game is set in Germany)
