# Schwalbe

Ein Open-Source Fußball-Manager-Simulationsspiel basierend auf dem Spiel Anstoss, entwickelt mit Godot 4.6.

## Über das Spiel

In Schwalbe übernimmst du die Rolle eines Trainers in der deutschen Liga der Saison 1999/2000. Du wählst einen Verein, verhandelst Spielerverträge, simulierst Spieltage, verfolgst die Tabelle, verwaltest die Vereinsfinanzen und entwickelst deinen Kader über mehrere Saisons hinweg.

## Voraussetzungen

- [Godot 4.x](https://godotengine.org/)
- nation.sav-File eines Landes von Anstoss 3 (muss in UTF-8 umkonvertiert werden) unter dbfiles/LandDeut.sav

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

## Discord

https://discord.gg/sZuRPF8SGg