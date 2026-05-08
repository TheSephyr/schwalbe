# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Schwalbe** is a football (soccer) manager simulation game built with Godot 4.6 (mobile renderer). Players select a German club, view lineups, simulate matchdays, and track league standings. The name means "swallow" in German.

## Running the Project

There are no build scripts — run and test via the Godot editor:

```bash
# Open in editor (must have Godot 4.x installed)
godot project.godot

# Run headless (e.g. for CI)
godot --headless --quit
```

The main entry scene is `res://scenes/starting_game.tscn`.

Toggle the debug overlay with **Ctrl+S** at runtime (shows current scene name).

## Architecture

### Autoload Singletons

Registered in `project.godot` and accessible globally by name:

| Singleton | File | Purpose |
|-----------|------|---------|
| `Game` | `code/game.gd` | Central state: all clubs, current season, week counter, game initialization |
| `EventBus` | `code/global/event_bus.gd` | Pub/sub signal hub — UI scenes connect here instead of to each other |
| `GameState` | `code/global/game_state.gd` | Lightweight UI state (e.g. currently selected player) |
| `Global` | `code/global/global.gd` | Misc utilities |

### Data Flow

```
Game.initial_load()
  → ReadNationFile.loadNationFile()     # parses LandDeutAllNeu.sav
  → Game.all_clubs / first_division_clubs[0..17]
  → Season(first_division_clubs)        # generates round-robin schedule
	  → Matchday[] → Match[]
	  → Table (TeamStanding per club)
  → UI scenes subscribe to EventBus signals and render state
```

### Signal-Driven UI

`EventBus` emits three signals that scenes listen to:
- `next` — advance to the next screen/state
- `next_matchday` — simulate and move to next matchday
- `update_ui` — refresh displayed data (e.g. after simulation)

Scene controllers call `EventBus.connect(...)` and react; they never communicate directly with each other.

### Scene Navigation

Scenes switch via `get_tree().change_scene_to_file("res://scenes/...")`. The UI shell (`completeUi.tscn`) contains `topUi.tscn` (week + club name) and `bottomUi.tscn` (navigation buttons) and is embedded in league-phase screens.

### Key Data Models

- `code/player.gd` — Player: name, position, talent, ability, birthdate, match history
- `code/club.gd` — Club: name, roster (`Player[]`), current lineup, money
- `season/season.gd` — Owns the matchday schedule and `Table`; uses rotation algorithm for round-robin
- `season/table.gd` / `season/teamStanding.gd` — League standings sorted by points then goal difference
- `match/match.gd` — Single match: simulates goals (random 0–3 per side), updates player match counts
- `match/matchday.gd` — Collection of matches for one week

### Database Format

Game data lives in `dbfiles/LandDeutAllNeu.sav` — a custom line-based format with section markers:
- `%SECT%SPIELER` — players (lastname @ line 1, firstname @ line 2, position @ line 9, talent @ line 19)
- `%SECT%VEREIN` — clubs
- `%SECT%TRAINER` — coaches (skipped)
- `%SECT%STADION` — stadiums (skipped)

Parsing logic is in `code/read_nation_file.gd`.

## Code Conventions

- Static Typing
- GDScript with Godot 4 syntax (`class_name`, typed signals, `@export`, etc.)
- Snake_case for functions and variables; PascalCase for class names
- gdLinter addon is active — keep code clean to avoid editor warnings
- No automated tests exist; test by running scenes in the editor
