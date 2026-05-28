## 1. Manager Career & Promotion

- The manager has five personal **attributes** that affect game mechanics:
  - **Verhandlungsgeschick** (negotiation skill) — speeds up contract talks, fewer rounds needed
  - **Motivationsfähigkeit** (motivation) — multiplies morale boosts: `10 × (skill × 0.1)%`
  - **Trainingsgestaltung** (training management) — improves effectiveness of all training
  - **Autorität** (authority) — the higher it is, the less a player training absence costs morale; also affects training performance by ~4%
  - **Fremdsprachenkenntnisse** (foreign languages) — improves negotiation success with foreign players by `0.8 + 0.04 × skill` bonus

- Career mode: manager plays between ages **40 and 67** (normal), or 40–62 (hard).
- **Season end rating** determines contract length change:

| Rating    | Effect            |
|-----------|-------------------|
| > 85 %    | +1 year           |
| > 80 %    | stays (50 %)      |
| > 75 %    | −1 year           |
| > 70 %    | −2 years          |
| > 65 %    | −3 years          |
| < 60 %    | dismissed         |

- **Promotion conditions** (to next division): finishing position, Cup result, European success, youth development, season standing.
- From division 2 onwards the board demands minimum **2 million DM** in transfers per season.
- "Durchgangsstation" strategy: use cheap clubs as a stepping stone — keep costs low, develop young players, sell for profit, then move up.

---

## 2. Finances

### Income Sources
- **Ticket sales**: ticket price × attendance; home games only.
- **Sponsor pool**: 5 % of all sponsor income flows into a pool; payout at the end of each season based on performance.
- **Sponsorenvertrag**: per-season fixed payment; negotiated at start of season.
- **Bandenwerbung** (perimeter advertising): negotiated separately, additional income.
- **Fanartikelhandel** (merchandise): automatic income each season.
- **Freundschaftsspiele** (friendlies): bonus income based on opponent rank:

| Opponent Rank | Income per friendly |
|---------------|---------------------|
| 1             | 100 %               |
| 2             | 90 %                |
| 3             | 82 %                |
| 4             | 74 %                |
| 5             | 67 %                |
| > 7           | 20 %                |

- **Cup bonuses**: progressing through rounds earns significant one-time payments.
- **Turnierteilnahme** (regional leagues): surprisingly good income source even at low level.

### Expenditure
- **Daily wages**: all player contracts draw daily salary.
- **Transfer fees**: direct expense.
- **Ordner** (stewards): 1 % of all expenses; can't be avoided.
- **Infrastruktur** (infrastructure): youth and medical departments draw ongoing monthly cost.

---

## 3. Player Strength System

### Computing a Player's Real Strength ("echte Spielstärke")
Seven-step calculation:

1. Start with **Frische** and **Kondition**: added together, then subtracted from the base; result capped at ±2.
2. If **Talent ≤ 70**: add up to 20 points.
3. If **Talent > 75**: add up to 10 points, but total capped at 80.
4. For each **positive Eigenschaft** (skill/trait): add 10 points.
5. Subtract for each Eigenschaft penalty: the team loses ~30 total points across the lineup.
6. Subtract 1 point per **2 position steps** away from a player's Hauptposition.
7. **Captain bonus**: small additional point bonus for the captain.

> Example: Frische 52, Kondition 60 → ability contribution 10; Talent normal → Stärke 10.

---

## 4. End-of-Season Player Upgrades/Downgrades

- Each season end, player base ability (Stärke) is recalculated from **Einsätze** (appearances).
- A minimum of ~50 appearances across the career provides the best upgrade chances.
- **Age modifiers**:

| Age        | Upgrade chance | Downgrade chance |
|------------|---------------|-----------------|
| < 22       | −10 %         | very low        |
| ≤ 26       | 20 %          | 0 %             |
| ≤ 30       | 5 %           | 10 %            |
| ≤ 34 **   | 5 %           | 35 %            |
| > 36+      | 0 %           | 50 %            |

- **Talent modifiers** on top of age:

| Talent        | Effect                                                   |
|---------------|----------------------------------------------------------|
| Megatalent    | 50 % better upgrade chance (< 25 yrs), 5 % no downgrade |
| Talent        | 25 % better upgrade, 15 % less downgrade chance          |
| Normal begabt | normal chances, max Stärke 10                            |
| Wenig begabt  | 25 % less upgrade, max Stärke 6                          |
| Zwei linke Füße | 50 % less upgrade, max Stärke 6                        |
| Zweibeiner    | 50 % less upgrade, max Stärke 9 (but no position penalty)|

- Short-form (Dauerlauftabelle): players who play every match for a full season achieve best results.
- Players on loan to another continent improve at ~50 % efficiency but are cheaper (no salary cost to you).

---

## 5. Player Properties (Eigenschaften) & Characteristics

- Each Eigenschaft adds **10 points** to effective strength.
- Properties are **fixed** — cannot be trained in during normal play.
- Young players (under 21) can acquire properties at a **training camp** with some probability.
- Notable properties:
  - **Joker**: player scores at 50 % probability when substituted in.
  - **Tennis-Star**: massive fan appeal, but reduces team morale.
  - **Führungsspieler** (leader): boosts morale of nearby players; gives bonus to team morale each week.
  - **Vereinstreu** (loyal): per-season Motivation bonus (+1 per year at same club, up to +4 max at 5+ years).

- "Ähnliche Positionen" (similar positions): ~70 % of the normal strength penalty applies when playing an adjacent position instead of full penalty.

---

## 6. Player Fitness — Kondition & Frische

- **Kondition**: long-term fitness; improves slowly through training; decreases through matches and heavy training.
- **Frische**: short-term freshness; depleted by every match (~10 points) and training; restored by rest.
- A player with Frische **< 70** should not train during a match week.
- Frische **< 40**: player is dangerously tired; risk of injury is high.
- Morale effect: condition training improves a player's Stimmung if they start a season below their best level.

### Training Camp Effects
- **Short camp (3–5 days)**: temporary Frische boost only; disappears quickly.
- **Long camp (7+ days)**: actual Kondition improvement; lasts the season.
- Condition drops during a camp if training is too intense for weak players.

---

## 7. Lineup, Formation & Position Learning

### Formation Selection
- Formations directly affect effective player strength.
- "Too many strikers" (Testmodus): formation with all forwards gives no bonus and weakens defence.
- Offensive at all costs (Testmodus): risky; concedes more.

### Position Learning
- A player can learn a new position if trained there repeatedly.
- **Younger players** learn faster and more permanently.
- Older players: position learning is possible but takes much longer.
- Learning speed: approx. 1 % per week of intensive directed training on that position.

### Position Penalty Table
| Steps away from Hauptposition | Effect on Strength |
|------------------------------|--------------------|
| Stürmer ↔ offensiver Mittelfeldspieler | −1 Stärke point |
| Stürmer ↔ Stürmer (second type) | −1 Stärke point |
| Stürmer ↔ defensiver Mittelfeldspieler | −2 Stärke points |
| (any two positions apart) | −2 Stärke points |

---

## 8. Squad Management (Umgang mit der Mannschaft)

- ANSTOSS 3 models **individual player moods** (Stimmung) as a key mechanic.
- Stimmung is directly affected by results, salary satisfaction, playing time, and training.
- **Morale drops to 100 %** cap on match days — it cannot go higher, but can plummet quickly.

### Morale-Affecting Activities
- **Italienisch Essen** (team dinner): boosts morale for Italian/international players, slight boost overall.
- **Saufabend** (team drinking night): temporary morale boost, but Kondition suffers next day.
- **Zimmerbe­legung** (room assignments at training camp): compatible roommates boost morale; incompatible pairs hurt morale. Rules:
  - Conflicting players: don't put them in the same room.
  - Players who don't get along: separate them (morale drop otherwise).
  - Talkative players together: good combination.
  - Quiet players together: also good.
  - Same nationality: good pairing where possible.
  - At least 2 Muslime players together: culturally appropriate.

### Motivation (per match)
- Motivation can be bought: costs 10,000 DM (1st time), up to 12,500,000 DM (5th time).
- Motivation boost decays; each subsequent use costs exponentially more.

---

## 9. Tactics — Opponent Analysis & Match Settings

### Manndeckung (Man-Marking)
- Assign your best defender to shadow the opponent's best player.
- Works well against Stürmer and offensive players; less effective against midfield.

### Laufwege (Runs)
- A good Laufwege scheme stops the opponent running behind your defence.
- More complex system than previous ANSTOSS games.

### Abseits (Offside Trap)
- Effective only when the entire back line executes it together.
- If any defender is slow, the offside trap fails and concedes a 1v1 with the goalkeeper.

### Key Match Modifiers
- **Yellow cards**: each card reduces the team's effective strength.
- **Red cards** (Platzverweis): severe strength penalty, team plays with 10 men.
- **Protecting weak players**: put weaker players against weaker opponents; avoid mismatches.
- **Offensiver Torwart** (Testmodus): risky; GK participates in attack; high-risk/high-reward.

### Win/Loss Streak Effects
- Win streaks: morale and effective strength increase with each victory.
- Loss streaks: morale collapses; Stimmung drops multiplicatively.
- Match significance bonus: important matches (title deciders) give extra morale.

### Einlaufstärke (Kick-off Strength)
- Player effective strength is also modified at kick-off by current Stimmung (morale).
- Stimmung 100 % → full strength; Stimmung < 60 % → measurable strength reduction.

---

## 10. Training

### Mannschaftstraining (Team Training)
- **Konditionstraining**: pure fitness; improves long-term Kondition.
- **Technik­training**: improves technical ability and Stärke over time.
- Optimal frequency: **3–4 sessions per week** in pre-season; reduce during season.
- **Do not overtrain**: more than 3× per week during season risks Frische collapse.

### Short-Term Training Effects (Kurzfristig)
- Heavy training in the week before a match hurts Frische (−10 points per day of training).
- Frische < 70 before a match → measurable strength reduction.

### Long-Term Training Effects (Langfristig)
- Consistent season-long training adds points to Kondition permanently.
- A **Kondition of 100** absorbs all negative training effects; the player recovers quickly.

### Overtraining (Hohe Dauerbelastung)
- If Frische < 45: player starts losing Stärke permanently.
- This effect stacks; a player trained into the ground loses ability ratings permanently.

### Training Intensity Settings
- Settings 1 and 2: low intensity, high Frische gain.
- Setting 4/5: high intensity; Stärke improvement but Frische loss.
- Recommended: alternate high/low across weeks.

---

## 11. Individual Player Training

- Each player can be given **individual training** separate from team sessions.
- **Skill improvement rates**:
  - On your own (no training): ~1 % per match naturally.
  - Intensive individual training: 1–2 % per week.
  - Training camp: can give up to 3× normal rate for the duration.
- Learning curve is **non-linear**: faster early, slower when approaching ceiling.
- Talent cap: max ability ceiling is set at game start; talent rating determines it.

### Negative Training Effects (Rückschritte)
- Playing against an inferior opponent: −0.5 Stärke for the skill being trained.
- No training at all: −1 Stärke per week for each neglected skill.
- If a skill drops below a threshold, harder to recover.

---

## 12. Trainer Staff

- **Co-Trainer**: supplements training; required for effectiveness.
- **Torwarttrainer** (GK coach): specialist; improves GK ability specifically. Worth hiring if you have a strong keeper.
- **Konditionstrainer**: improves fitness results; specialises in Konditionstraining.
- Having the right trainers (Co-Trainer + Konditionstrainer) is worth ~0.25 extra Stärke points per player per season.

---

## 13. Medical Department

- **Injury risk** scales inversely with Frische: the lower the Frische, the higher the chance.
- Injury risk is highest for:
  - Players with Frische < 30 %.
  - Players over age 30.
  - Players without the "robust" Eigenschaft.
- **Operations**: a player can have an operation to remove an injury, but returns at ~70 % fitness.
- Post-operation: 30 % chance that fitness does not fully return in that season.
- **Medical investment**: higher budget = faster recovery, lower injury rates.

---

## 14. Doping

| Type         | Stat affected | Bonus | Side effect         |
|--------------|---------------|-------|---------------------|
| Regenerator  | Kondition     | +0    | (small recovery)    |
| Anabolika    | Stärke        | +2    | DFB ineligibility risk |
| Kreatin      | Kondition     | +0    | High side-effect risk  |

- Doping has a chance of being caught; caught players are suspended.
- **Players who refuse doping**:
  - Players with no remaining seasons left in contract.
  - Players whose only option is a short-term boost (they know the risk).
  - Stars (Stärke ≥ 12) — they refuse outright.
  - Players with Stärke ≥ 10 and no team relationship — likely to refuse.
- Training camp forces lower-rated players into doping compliance.

---

## 15. Team Talks (Mannschaftsansprachen)

### Pre-Match Talk
- **Taktik** options (each with condition + morale effect):
  - Criticise the opponent lightly (if opponent is strong): −10 pts morale for opponent, +0 pts own.
  - Acknowledge strong opponent: −10 pts morale, −5 pts own if overplayed.
  - Announce aggressive strategy: team gains +2 Motivation; concede morale if opponent is weaker.
  - Underestimate opponent: risky; backfires if opponent wins.
  - Use rivalry: conditional bonus if there is an ongoing history.

### Gegner Options (in pre-match)
- Each option targets specific conditions: home/away position, opponent rank, goal difference.
- Good Taktik talk before an important game: up to +10 % Siegchance (win probability).

### Half-Time Talk
- **Winning comfortably**: praise or stay calm — no drastic changes needed.
- **Losing by 1**: tactical adjustment talk reduces further losses by ~10 %.
- **Losing by 2+**: aggressive intervention; risky but necessary.
- Half-time bonus: if team scores within 5 minutes after the break, morale surges.

---

## 16. Individual Player Talks (Einzelgespräche)

### Under the Week (7 types)
1. **Tell player he is most important**: +5 Motivation pts (if squad rank justifies it).
2. **Praise player**: +3 Motivation pts; best if player has ≥ 10 appearances and played well.
3. **Tell player to keep going**: +3 Motivation pts; player must have Stärke ≥ 11.
4. **Light criticism**: −2 Motivation pts short-term; prevents morale drop long-term.
5. **Sharp criticism**: −3 Motivation pts; player must be underperforming badly.
6. **Suspend from training**: drastic; −4 Motivation pts; can backfire.
7. **Give second chance**: +5 Motivation pts; must be used after a suspension.

### In the Half-Time (4 types)
- **Praise** (score ≥ 4.5 performance): +5 % bonus for rest of game.
- **Praise for team** (top scorer of the half): +3 % across team.
- **Wake-up call**: +5 % for the player addressed.
- **Aufwecken** (stir up): automatic +3 % Stärke for rest of the match.

---

## 17. Transfer Policy

### Squad Composition
- **Squad size**: 17–20 players minimum; Europacup participation requires 22+.
- Over-large squads: players who never play lose morale quickly.
- **Verkauf** (selling): better to sell before contract expires; market value table shows ideal selling window.

### Player Market Value by Age/Contract
- Age < 22 and Talent: low price but high potential.
- Age 22–26: peak value; best selling price.
- Age 26+: value drops each year contract is extended.

### Stammplatzgarantie (Starting Guarantee)
- Player demands starting role based on appearances vs seasons at club.
- Table of minimum appearances before guarantee is triggered:

| Seasons at club | Min. matches demanded |
|---|---|
| 1 | 7 |
| 2 | 9 |
| 3 | 11 |
| 4 | 13 |
| 5+ | 15 |

### Buying Players
- Best strategy: observe players for at least one season before offering.
- Buy players with ≤ 1 year on contract: cheaper fee, but competitor clubs circle.
- Buying from foreign clubs: needs Fremdsprachen skill for better price.

### Illegal Transfers
- Approaching a player under contract without permission: fine from DFB.
- Minimum fine: 500,000 DM; scales up to ~2 million DM.

### Selling for Maximum Profit
- Sell with maximum **remaining contract length** (≥ 3 years left = highest market value).
- Sell before key drop-off years (30, 33, 36).
- Market value multiplier by remaining contract years:

| Remaining years | Value multiplier |
|---|---|
| 6 | × 12 |
| 5 | × 10 |
| 4 | × 8 |
| 3 | × 6 |
| 2 | × 4 |
| 1 | × 2 |

- Sending players to other continents: costs ~1 % development quality but removes salary costs.

---

## 18. Youth & Amateur Players

### Youth Department Investment
- Minimum: **100,000 DM/month** for meaningful youth output.
- Recommended: **150,000 DM/month** for consistent talent production.
- **200,000 DM/month**: chance for Megatalent each season.

### Youth Player Development
- New youth players appear every 1–2 months on average.
- Stats at first scouting: ability 13–18, talent 1–11.
- Development over 4–5 seasons → potential first-team material.

### Youth Player Talent Outcomes
- Probabilities for produced talent (with 200,000 DM investment):

| Talent type | Probability |
|---|---|
| Megatalent | 2 Mio DM: ≤ 15 % |
| Normales Talent | 150,000 DM: ≤ 23 % |
| Zwei linke Füße | 200,000 DM: ≤ 5 % |
| Zweibeiner | 25,000 DM: ≤ 52 % |
| Brot und Butter | normal: highest chance |

### Youth Player Eigenschaften (from training)
Additional skills youth can acquire via youth training:

| Eigenschaft | Training requirement |
|---|---|
| Technik | 52 % talent and medium-rare assignments |
| Schnelligkeit | minimum investment, natural output |
| Flankenläufe | 90 % technical focus |
| Launisch | 30 % chance, unavoidable |
| ... | (positional skills by position type) |

### Amateur Players
- Cheaper than youth investment; lower ceiling.
- Useful as squad fillers for bottom-division teams.

---

## 19. Stadium Development (Stadionausbau)

### When to Expand
- Expand at the start of a new season — never mid-season.
- First expansion priority: build up to match your actual fan attendance first.
- After promotion: immediately expand to attract more fans.

### Cost Structure
- Small kiosks: 25,000 DM annually (maintenance).
- Small stand (25 places): 600,000 DM.
- Medium stand (50 places): 800,000 DM.
- Large stand (150 places): 140,000,000 DM.
- VIP section: 1,000,000 DM.

### Maintenance (Stadionsanierung)
- Required periodically; costs scale with size:

| Games between sanierungen | Annual cost |
|---|---|
| Up to 10 | 27,000 DM |
| Up to 15 | 56,000 DM |
| Up to 20 | 133,000 DM |
| Up to 25 | 327,000 DM |

### Scoreboard (Anzeigetafel)
- Installing a scoreboard allows raising ticket prices.
- Without it: price ceiling is lower; fans expect less from the stadium experience.

### Ticket Pricing
- Sitzplatz (seating): 25 DM default; can increase with better facilities.
- Stehplatz (standing): 40 DM default.
- Higher prices reduce attendance slightly; find the optimal balance per stadium size.

### Platzkarte (Season Tickets)
- Can sell season tickets at start of season at a fixed price; guarantees income.
- Price range: 2,000 – 4,000 DM per season.
- Season ticket holders attend regardless of form.

---

## 20. Private Life

- Each season the manager gets a chance to marry.
- Marriage event: choose from 3 types with different bonuses/events:
  - Heirat + 500,000 – 1,010,000 DM dowry.
  - Chance for bonus resources from wealthy family.
  - Steigerung der Trainingsleistung through companionship.
  - 50,000 DM bonus der Spielertransferleistung.
  - Steigerung einer Karriere um einen weiteren Karrierepunkt.
- After ~13 children the career bonus wears off.
- "Persönliche Erfolge" can unlock hidden events.

---

## 21. Miscellaneous

### Phone Calls
- Managers call each other; can be used to negotiate, probe transfers, or gather information.
- Picking up the phone can reveal opponent intentions.

### Multi-Player Tips
- In human vs human games: formations that counter the opponent's shape matter more than in single-player.
- Scouting human opponents: observe their last 3 games before facing them.

### National Team
- Players called up to the national team gain +5 Motivation on return.
- Player fatigue from international duty must be managed.

### Awards & Honours (Ehrungen)
- End-of-season awards affect morale for the following season.
- Winning the Torjägerkanone, Spieler des Jahres etc.: +10 Motivation for the recipient.
- Team-wide boost if manager receives Manager des Jahres award.

### "Madame Veronique" Easter Egg
- Hidden character who appears during the season and makes predictions.
- Appearance is random; predictions affect minor game events.
