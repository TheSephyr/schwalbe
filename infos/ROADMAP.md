# Schwalbe — Entwicklungs-Roadmap (KI - generiert)

Basierend auf dem aktuellen Stand des Projekts und dem A3-Designreferenz-Dokument (`A3_gameplay_features.md`).

Status: ✅ Fertig · 🔧 Teilweise · ⬜ Nicht begonnen

---

## Was bereits funktioniert

| Bereich | Status | Anmerkungen |
|---------|--------|-------------|
| Vereins- & Spielerdaten laden (LandDeut.sav) | ✅ | Vollständige Feldindex-Abdeckung |
| Saisonplan (Doppelrunde, Bundesliga-Termine) | ✅ | |
| Spielsimulation (Poisson, Heimvorteil) | ✅ | |
| Spielstärke-Formel (`effective_strength`) | ✅ | 7-stufig, A3-getreu |
| Formation / Aufstellungszuweisung | ✅ | Slot-basiert, Positionsstrafe |
| Vertragssystem (Verlängerung / Vereinslos / Vorvertrag / Transfer) | ✅ | 4 Kontexte |
| Sponsorenverhandlung & -vertrag | ✅ | Gespeichert am Verein |
| Transfermarkt (Suche, Ablöse, KI-Gebote) | ✅ | |
| Einzeltraining (Fähigkeit lernen, Fortschrittsanzeige) | ✅ | |
| Mannschaftstraining (Kondition vs. Regeneration, Wochenplan) | ✅ | |
| Finanzen (Bilanz, Ausgaben) | ✅ | |
| Stadion-Datenmodell + Ticketpreis | ✅ | |
| Tabelle, Spieltagsansicht, Kalender | ✅ | |
| Personalverzeichnis (Reporter, Schiedsrichter usw.) | ✅ | |
| Speichern / Laden (JSON, Autosave) | ✅ | |
| Co-Trainer-Einstellung (Vorsaison) | ✅ | |
| Zuschauereinnahmenplanung | ✅ | |
| KI-Saisonübergang (Verlängerungen, Kader auffüllen, Rücktritte) | ✅ | |

---

## Meilenstein 1 — Vollständiger Spielablauf

Diese Lücken lassen das Spiel selbst innerhalb einer einzigen Saison unfertig wirken.

### 1.1 Spielermoral (Stimmung)
- `morale: int` (0–100) zu `Player` hinzufügen; in Spielständen speichern.
- Stimmung sinkt nach Niederlagen, steigt nach Siegen; auf Spieltagen bei 100 gedeckelt.
- Stimmung unter 60 reduziert `effective_strength` beim Anpfiff.
- Sieges-/Niederlagenserie: jedes aufeinanderfolgende Ergebnis verschiebt die Stimmung um ±5.
- A3-Referenz: §8, §9 (Einlaufstärke).

### 1.2 Saisonabschluss: Spielerstärke-Auf-/Abwertungen
- `player_update_scene` existiert, aber die vollständige A3-Tabelle Alter × Talent ist nicht eingebunden.
- Tabelle aus §4 implementieren: Altersgruppen (< 22, ≤ 26, ≤ 30, ≤ 34, > 36) × Talentmodifikatoren (Megatalent, Talent, Normal, Wenig begabt, Zwei linke Füße).
- `matches_played` pro Saison tracken; am Saisonstart zurücksetzen.
- A3-Referenz: §4.

### 1.3 Verletzungen
- `HealthTypes` wird aus der Datendatei gelesen, aber nie in der Simulation verwendet.
- Frische < 40 → Verletzungsrisiko pro Spiel (abhängig von Alter, fehlendem „Robust"-Merkmal).
- Verletzter Spieler: N Wochen nicht aufstellbar; Gesundheitsstatus auf der Spielerkarte anzeigen.
- A3-Referenz: §13.

### 1.4 Übertraining-Regel
- Frische < 45 nach einer Trainingswoche → dauerhafter Stärkepunktverlust.
- Das Mannschaftstraining berechnet Kondition/Frische-Änderungen, erzwingt aber diese Grenze nicht.
- A3-Referenz: §10.

### 1.5 Tiefere Spielsimulation
- **Karten**: zufällige Gelb-/Rotkartenwahrscheinlichkeit pro Spiel; Rote Karte = Team spielt mit 10 Mann (−1 Slot-Stärke).
- **Einwechslungen**: 3 Auswechslungen im Spielvorschau-Bildschirm erlauben; Einwechslung ersetzt den Stärkebeitrag eines Slots.
- Beide wirken sich auf Stimmung und die Stärkekalkulation aus.
- A3-Referenz: §9.

---

## Meilenstein 2 — Finanztiefe

Schwalbe hat derzeit Sponsoren und Ticketverkäufe. Drei wichtige Einnahmequellen fehlen.

### 2.1 Fanartikelhandel
- Automatische Pauschaleinnahme zu Saisonbeginn, skaliert nach Liga und Zuschauerzahl.
- Einfache Formel: `fan_attendance × merchandise_rate` (Konstante in `GameConfig` definieren).
- A3-Referenz: §2.

### 2.2 Bandenwerbung
- Ein separater, verhandelbarer Vertrag neben dem Hauptsponsor.
- Vorsaison-Szene: eine zweite Verhandlungskarte für Bandenwerbung neben dem Sponsor hinzufügen.
- A3-Referenz: §2.

### 2.3 Freundschaftsspiele
- Zwischen Saisonende und Saisonstart: 1–3 Freundschaftsspiele anbieten.
- Einnahmen skalieren nach Gegnerrang (Tabelle §2).
- Beeinflusst Kondition/Frische und Stimmung; leichte Spielsimulation (keine Tabellenpunkte).

### 2.4 Infrastrukturkosten
- Jugendabteilung und medizinische Abteilung verursachen monatliche DM-Kosten.
- `youth_budget: int` und `medical_budget: int` zu `Club` hinzufügen; in `pay_wages` abziehen.
- A3-Referenz: §2, §13, §18.

### 2.5 Dauerkarten (Platzkarten)
- Vor der Saison zu einem Festpreis verkaufen (2.000–4.000 DM/Saison).
- Dauerkarteninhaber erscheinen unabhängig von der Formkurve bei jedem Heimspiel.
- In der Zuschauereinnahmen-Szene oder einer eigenen Vorsaison-Unterszene integrieren.
- A3-Referenz: §19.

### 2.6 Stadionausbau
- `Stadium` hat bereits Stand-Kapazitäten; Ausbau-UI mit DM-Kosten erstellen.
- Kostentabelle aus §19 (Kleintribüne 600k, Mitteltribüne 800k, Großtribüne 140M).
- Ausbau tritt erst zum nächsten Saisonstart in Kraft.
- A3-Referenz: §19.

---

## Meilenstein 3 — Kaderführung & Moraltiefe

### 3.1 Mannschaftsansprachen
- **Vorspielbesprechung**: Auswahl aus 3–4 Tonoptionen; Moralmodifikator für alle Spieler vor dem Anpfiff.
- **Halbzeitansprache** (Halbzeitbildschirm hinzufügen): Äste für Führung / Rückstand; bis zu ±10 % Siegchance anpassbar.
- A3-Referenz: §15.

### 3.2 Einzelgespräche
- Neue Szene, erreichbar über das Spielerprofil.
- 7 wöchentliche Interaktionsarten (loben, kritisieren, sperren, zweite Chance usw.) aus §16.
- Jede Interaktion passt die `morale` des Spielers an und hat eine Abklingzeit.
- A3-Referenz: §16.

### 3.3 Stammplatzgarantie
- Nach N Saisons im Verein fordert ein Spieler eine Mindestanzahl an Einsätzen.
- Verletzung löst Stimmungsabfall und potenziellen Transferwunsch aus.
- Vereinszugehörigkeit am Vertrag oder als separates `Player`-Feld tracken.
- A3-Referenz: §17.

### 3.4 Moralstrafe für Bankspieler
- Spieler mit 0 Einsätzen in einer Saison verlieren wöchentlich Stimmung.
- Kader > 22 Spieler lösen dies für Dauerreservisten aus.
- A3-Referenz: §17.

---

## Meilenstein 4 — Trainerlaufbahn

### 4.1 Trainer-Karriereattribute
- Trainer speichert derzeit nur Name, Alter und Kompetenz.
- Die 5 A3-Karriereattribute zu `Manager` hinzufügen: `verhandlungsgeschick`, `motivationsfaehigkeit`, `trainingsgestaltung`, `autoritaet`, `fremdsprachenkenntnisse`.
- Einbinden: Verhandlung reduziert benötigte Gesprächsrunden; Autorität senkt Moralkosten bei Trainingsabwesenheit; Fremdsprachenkenntnisse verbessern Ausländer-Transferpreise.
- Trainer-Setup-Szene: Startpunkte verteilen lassen.
- A3-Referenz: §1.

### 4.2 Saisonabschlussbewertung & Entlassung
- Nach jeder Saison eine Bewertung (0–100) berechnen: Tabellenplatz vs. Erwartung, Spielerentwicklung, Finanzzustand.
- A3-Vertragsvertragstabelle anwenden (§1): Bewertung > 85 → +1 Jahr, < 60 → Entlassung → Game Over.
- Bewertung auf dem Saisonabschluss-Bildschirm anzeigen.
- A3-Referenz: §1.

### 4.3 Auf- und Abstieg (Mehrlige-Karriere)
- Derzeit nur eine Liga.
- Zweite Liga hinzufügen (18 KI-Vereine aus LandDeut.sav).
- Letzte 3 der 1. Liga steigen ab; erste 3 der 2. Liga steigen auf.
- Trainerlaufbahn: in der 2. Liga beginnen, nach oben arbeiten.
- A3-Referenz: §1.

---

## Meilenstein 5 — Trainingstiefe

### 5.1 Positionslernen
- Einzeltraining lehrt derzeit Fähigkeiten (PlayerSkillTypes).
- Separaten „Positionstraining"-Slot hinzufügen: Spieler einer Zweitposition zuweisen.
- Fortschritt ~1 %/Woche; bei Abschluss zu `secondary_position_1` oder `secondary_position_2` hinzufügen.
- A3-Referenz: §7.

### 5.2 Trainingslager
- Kurzes Lager (3–5 Tage): nur temporärer Frische-Boost.
- Langes Lager (7+ Tage): tatsächliche Konditionsverbesserung.
- Zimmerbelegungs-Minispiel beeinflusst Stimmung (kompatible/inkompatible Paare aus §8).
- A3-Referenz: §6, §8.

### 5.3 Trainingsintensitätsstufen
- Training ist derzeit binär (Kondition vs. Regeneration).
- 5 Intensitätsstufen hinzufügen (1 = Erholung, 5 = Maximum); höher = mehr Stärkegewinn, mehr Frischeverlust.
- A3-Referenz: §10.

---

## Meilenstein 6 — Jugend & Langzeitentwicklung

### 6.1 Jugendabteilung
- `youth_budget` (aus M2.4) schaltet monatlichen Jugendspielerzulauf frei.
- Neue Jugendspieler erscheinen mit Stärke 13–18 und Talent 1–11; werden einem Jugendkader hinzugefügt.
- 150.000 DM/Monat: normale Talentproduktion. 200.000 DM: Chance auf Megatalent.
- A3-Referenz: §18.

### 6.2 Aufstieg in den Profikader
- Jugendspieler können nach 1–2 Saisons in den Profikader befördert werden.
- Eigene Jugendkaderszene (Liste + Befördern-Button).

---

## Meilenstein 7 — Politur & Atmosphäre

Niedrigere Priorität, vertieft aber die A3-Atmosphäre spürbar.

### 7.1 Nationalmannschaftsberufungen
- Etwa 3–5 Spieler pro Saison werden zwischen Spieltagen nominiert.
- Spieler kehrt mit +5 Stimmung zurück; verpasst ggf. 1 Ligaspieltag.
- A3-Referenz: §21.

### 7.2 Saisonabschlussehrungen
- Torjägerkanone, Spieler des Jahres, Trainer des Jahres.
- Gewinner erhält +10 Stimmung für die nächste Saison; Trainer-des-Jahres-Award gibt teamweiten kleinen Bonus.
- A3-Referenz: §21.

### 7.3 Pokalwettbewerb (DFB-Pokal-Stil)
- K.-o.-Runde parallel zur Liga.
- Weiterkommen bringt einmalige DM-Prämien (§2).
- Auslosung im Kalender anzeigen.

### 7.4 Doping
- Optionale Risiko/Belohnungs-Mechanik: Anabolika (+2 Stärke), Kreatin (Konditionsboost), Regenerator.
- Erwischter Spieler → N Wochen gesperrt; DFB-Geldstrafe.
- A3-Referenz: §14.

### 7.5 Privatleben-Events
- Zufällige Saisonereignisse: Heiratsangebot mit DM-Mitgift oder Karrierepunktbonus.
- Rein atmosphärisch; geringer Implementierungsaufwand sobald ein Eventsystem existiert.
- A3-Referenz: §20.

---

## Technische Schulden & Infrastruktur

Keine A3-Features, aber nötig für die weitere Entwicklung.

- **Automatisierte Tests**: keine Tests vorhanden; mindestens einen Headless-Smoke-Test einführen, der eine vollständige Saison ohne Absturz durchläuft.
- **`game.gd`-Größe**: der Singleton übernimmt zu viel; KI-Logik (`_ai_*`-Methoden) in eine eigene `AIManager`-Klasse auslagern.
- **EventBus-Nutzung**: einige Szenen navigieren direkt über `change_scene_to_file` statt Signale zu senden; auf EventBus vereinheitlichen.
- **Null-Sicherheits-Audit**: `@onready`-Pfade schlagen lautlos zur Laufzeit fehl (vgl. Transfer-Markt-Bug); `assert`-Guards oder `%EindeutigeNamen` verwenden.
