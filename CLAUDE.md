# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Schwalbe** is a football (soccer) manager simulation game built with Godot 4.6 (mobile renderer). Players select a German club, view lineups, simulate matchdays, track league standings, and manage club finances. The name means "swallow" in German. The in-game world is set in the 1999/2000 season.

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
| `Game` | `code/game.gd` | Central state: all clubs, current season, current date, game initialization, save/load |
| `EventBus` | `code/global/event_bus.gd` | Pub/sub signal hub — UI scenes connect here instead of to each other |
| `GameState` | `code/global/game_state.gd` | Lightweight UI state (e.g. currently selected player, last matchday) |
| `Global` | `code/global/global.gd` | Misc utilities |

### Data Flow

```
Game.initial_load()
  → ReadNationFile.loadNationFile()     # parses LandDeutAllNeu.sav
  → Game.all_clubs / first_division_clubs[0..17]
  → Season(first_division_clubs)        # generates round-robin schedule + assigns dates
	  → Matchday[] (each with a Date)
	  → Match[]
	  → Table (TeamStanding per club)
  → Game.current_date = Date(1, 7, 1999)
  → UI scenes subscribe to EventBus signals and render state

On each NEXT press (game._on_next):
  → wages deducted from player_club.money for days elapsed
  → current matchday simulated (ability-weighted Poisson model)
  → current_date advances to matchday date
  → if season finished → season_end scene; else → matchday_view scene
```

### Signal-Driven UI

`EventBus` emits three signals that scenes listen to:
- `next` — advance to the next screen/state
- `next_matchday` — simulate and move to next matchday
- `update_ui` — refresh displayed data (e.g. after simulation)

Scene controllers call `EventBus.connect(...)` and react; they never communicate directly with each other.

### Scene Navigation

Scenes switch via `get_tree().change_scene_to_file("res://scenes/...")`. The UI shell (`completeUi.tscn`) contains `topUi.tscn` (current date + club name) and `bottomUi.tscn` (navigation buttons) and is embedded in league-phase screens.

**Bottom navigation buttons:** Clubs · Matchday · Table · Line-Up · Club · Balance · Kalender

### Key Data Models

- `code/game_config.gd` — `GameConfig`: single source of truth for all game-wide constants. Sections: World (`SEASON_START_YEAR=1999`, `FIRST_DIVISION_SIZE=18`), Club finances (`STARTING_CLUB_MONEY`), Player contract defaults (`DEFAULT_SALARY`, `DEFAULT_APPEARANCE_BONUS`, `DEFAULT_GOAL_BONUS`, `DEFAULT_MARKET_VALUE`, `DEFAULT_CONTRACT_END`), Player ability range (`MIN/MAX_ABILITY`, `MIN/MAX_TALENT` — 1–100 scale), Match simulation (`HOME_ADVANTAGE`, `MATCH_BASE_LAMBDA`, `MATCH_SCALE`), Season points (`POINTS_FOR_WIN=3`, `POINTS_FOR_DRAW=1`), Season schedule (`SEASON_FIRST_MD_DAY/MONTH`, `MATCHDAY_INTERVAL_DAYS`, `WINTER_BREAK_AFTER_MD`, `WINTER_BREAK_DAYS`), Display (`MILLIONS_THRESHOLD`). No autoload needed — accessible globally via `class_name`.
- `code/player.gd` — Player: name, position, talent, ability, birthdate, match history; contract fields: `salary`, `auflauf_praemie`, `tor_praemie`, `market_value`, `contract_end`
- `code/club.gd` — Club: name, roster (`Player[]`), current lineup, `money` (starts at `GameConfig.STARTING_CLUB_MONEY`); `total_daily_wages()` sums roster salaries / 365; `pay_wages(days)` deducts from money
- `code/util/date.gd` — `Date` (RefCounted): `day`, `month`, `year`; `_to_string()` → `"DD.MM.YYYY"`; `add_days(n) → Date`; `days_until(other) → int` (Julian Day Number diff); `_days_in_month(m, y)` (static, leap-year aware)
- `season/season.gd` — Owns the matchday schedule and `Table`; double round-robin; assigns Bundesliga-style calendar dates (MD1 = Aug 7 1999, winter break after MD17, MD34 = May 27 2000)
- `season/table.gd` / `season/teamStanding.gd` — League standings sorted by points then goal difference
- `match/match.gd` — Single match: simulates goals using **Poisson distribution** weighted by each lineup's average `currentAbility`; home team gets 1.15× strength bonus; `BASE_LAMBDA=0.1`, `SCALE=3.0` → equal teams average ~1.6 goals each
- `match/matchday.gd` — Collection of matches for one matchday; holds a `date: Date`

### Scenes

| Scene | Path | Description |
|-------|------|-------------|
| Starting game | `scenes/starting_game.tscn` | Entry point |
| Main menu | `scenes/main_menu.tscn` | New game / load game |
| Team selection | `scenes/team_selection.tscn` | Pick your club |
| Club overview | `scenes/club/club.tscn` | Full roster list |
| Player profile | `scenes/player/player_scene.tscn` | Player stats + contract (Vertrag) |
| Line-up | `scenes/lineup/lineUp.tscn` | Current formation |
| Matchday view | `scenes/matchday_view.tscn` | Results of the last played matchday |
| Table | `scenes/table/table_scene.tscn` | Live league standings |
| Balance | `scenes/balance/balance_scene.tscn` | Club finances (Anlagen / Vermögen / Rechtsform) |
| Calendar | `scenes/calendar/calendar_scene.tscn` | Monthly calendar; matchdays highlighted; < > to navigate months |
| Season end | `scenes/season_end/season_end.tscn` | Final standings, champion, player club result |

### Database Format

Game data lives in `dbfiles/LandDeutAllNeu.sav` — a custom line-based format with section markers:
- `%SECT%SPIELER` — players (lastname @ line 1, firstname @ line 2, position @ line 9, talent @ line 19, ability @ line 7, birthdate @ line 22)
- `%SECT%VEREIN` — clubs
- `%SECT%TRAINER` — coaches (skipped)
- `%SECT%STADION` — stadiums (skipped)

Parsing logic is in `code/read_nation_file.gd`.

## Code Conventions

- Programming language (identifiers, variables, functions, class names, comments) is **English**
- Static typing throughout
- GDScript with Godot 4 syntax (`class_name`, typed signals, `@export`, etc.)
- Snake_case for functions and variables; PascalCase for class names
- gdLinter addon is active — keep code clean to avoid editor warnings
- No automated tests exist; test by running scenes in the editor
- UI text visible to the player is in **German** (game is set in Germany)
