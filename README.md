# Schwalbe

Ein Open-Source Fußball-Manager-Simulationsspiel basierend auf dem Spiel Anstoss 3, entwickelt mit Godot 4.6.

## Über das Spiel

In Schwalbe übernimmst du die Rolle eines Trainers in der deutschen Liga der Saison 1999/2000. Du wählst einen Verein, verhandelst Spielerverträge, simulierst Spieltage, verfolgst die Tabelle, verwaltest die Vereinsfinanzen und entwickelst deinen Kader über mehrere Saisons hinweg.

## Voraussetzungen

- [Godot 4.x](https://godotengine.org/)
- Anstoss 3

## Starten

Projekt im Godot-Editor öffnen:

```bash
godot project.godot
```

Die Einstiegsszene ist `res://scenes/starting_game.tscn`.

## Spielfunktionen

- Trainerwahl und Vereinsauswahl
- Spielertransfers und Vertragsverlängerungen
- Spieltagssimulation mit Poisson-Statistik
- Ligatabelle und Ergebnisübersicht
- Vereinsfinanzen und Gehaltsabrechnung
- Wochentraining und Spielerform
- Stadionverwaltung und Ticketpreise

## Debug

Mit **Strg+S** kann während des Spiels eine Debug-Überlagerung ein- und ausgeblendet werden. Diese zeigt den aktuellen Szenennamen sowie einen Button zum Simulieren der gesamten Saison.

## Offene Fragen

- Woran erkennt man die Ligazugehörigkeit in den Land.sav Dateien?
- Wie werden die Gehälter bei Spielstart generiert?

## Roadmap

Den aktuellen Entwicklungsplan mit offenen Features und Meilensteinen gibt es hier: [infos/ROADMAP.md](infos/ROADMAP.md)

## Discord

https://discord.gg/sZuRPF8SGg