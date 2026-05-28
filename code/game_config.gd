class_name GameConfig

# --- World ---
const SEASON_START_YEAR: int = 1999
const FIRST_DIVISION_SIZE: int = 18

# --- Club finances ---
const STARTING_CLUB_MONEY: int = 5_000_000

# --- Player contract defaults ---
const DEFAULT_SALARY: int = 500_000
const DEFAULT_APPEARANCE_BONUS: int = 10_000
const DEFAULT_GOAL_BONUS: int = 0
const DEFAULT_MARKET_VALUE: int = 5_000_000
const DEFAULT_CONTRACT_END: String = "30.06.2003"

# --- Contract generation (ability/talent-scaled, with random spread) ---
const CONTRACT_ABILITY_WEIGHT: float = 0.7
const CONTRACT_TALENT_WEIGHT: float = 0.3
const CONTRACT_CURVE_POWER: float = 1.8
const CONTRACT_RAND_SPREAD: float = 0.3
const CONTRACT_MIN_SALARY: int = 60_000
const CONTRACT_MAX_SALARY: int = 8_000_000
const CONTRACT_MIN_APPEARANCE_BONUS: int = 2_000
const CONTRACT_MAX_APPEARANCE_BONUS: int = 150_000
const CONTRACT_MIN_MARKET_VALUE: int = 50_000
const CONTRACT_MAX_MARKET_VALUE: int = 25_000_000

# --- Player ability range (1–100 scale from the .sav file) ---
const MIN_ABILITY: int = 1
const MAX_ABILITY: int = 100
const MIN_TALENT: int = 1
const MAX_TALENT: int = 100

# --- Player condition & freshness (1–100 scale) ---
const MIN_CONDITION: int = 1
const MAX_CONDITION: int = 100
const DEFAULT_CONDITION_MIN: int = 40
const DEFAULT_CONDITION_MAX: int = 60
const MATCH_CONDITION_LOSS: int = 10
const MIN_FRESHNESS: int = 1
const MAX_FRESHNESS: int = 100
const DEFAULT_FRESHNESS_MIN: int = 40
const DEFAULT_FRESHNESS_MAX: int = 60
const MATCH_FRESHNESS_LOSS: int = 8
const TRAINING_TYPE_NONE: int = 0
const TRAINING_TYPE_CONDITION: int = 1
const TRAINING_TYPE_REGEN: int = 2
const TRAINING_CONDITION_GAIN: int = 8
const TRAINING_CONDITION_FRESHNESS_LOSS: int = 4
const TRAINING_REGEN_FRESHNESS_GAIN: int = 8
const TRAINING_REGEN_CONDITION_LOSS: int = 4
const INDIVIDUAL_TRAINING_WEEKS: int = 8

# --- Match simulation (Poisson model) ---
const HOME_ADVANTAGE: float = 1.15
const MATCH_BASE_LAMBDA: float = 0.1
const MATCH_SCALE: float = 3.0

# --- Season points ---
const POINTS_FOR_WIN: int = 3
const POINTS_FOR_DRAW: int = 1

# --- Season schedule (Bundesliga-style) ---
const SEASON_FIRST_MD_DAY: int = 7
const SEASON_FIRST_MD_MONTH: int = 8
const MATCHDAY_INTERVAL_DAYS: int = 8
const WINTER_BREAK_AFTER_MD: int = 17
const WINTER_BREAK_DAYS: int = 38

# --- Ticket pricing ---
const TICKET_PRICE_DEFAULT: int = 25
const TICKET_PRICE_MIN: int = 5
const TICKET_PRICE_MAX: int = 150
const TICKET_PRICE_STEP: int = 5

# --- Transfer market ---
const PRECONTRACT_WINDOW_DAYS: int = 182
const TRANSFER_NEGOTIATION_DAYS: int = 14
const AI_NEGOTIATION_OFFER_CHANCE: float = 0.35

# --- Generated free agents (new game) ---
const GENERATED_FREE_AGENT_COUNT: int = 100
const FREE_AGENT_MAX_ABILITY: int = 4
const FREE_AGENT_MAX_TALENT: int = 4

# --- AI contract management ---
const AI_CONTRACT_RENEWAL_CHANCE: float = 0.85

# --- Player retirement (triggered when contract expires) ---
const RETIREMENT_MIN_AGE: int = 30
const RETIREMENT_BASE_CHANCE: float = 0.05
const RETIREMENT_CHANCE_PER_YEAR: float = 0.10
const RETIREMENT_MAX_CHANCE: float = 0.95

# --- Taktik ---
const SPIELSTIL_DEFENSIV: int = 0
const SPIELSTIL_AUSGEWOGEN: int = 1
const SPIELSTIL_OFFENSIV: int = 2

const PRESSING_TIEF: int = 0
const PRESSING_MITTEL: int = 1
const PRESSING_HOCH: int = 2

# --- Display ---
const MILLIONS_THRESHOLD: int = 1_000_000
