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

# --- Player ability range (1–100 scale from the .sav file) ---
const MIN_ABILITY: int = 1
const MAX_ABILITY: int = 100
const MIN_TALENT: int = 1
const MAX_TALENT: int = 100

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

# --- Display ---
const MILLIONS_THRESHOLD: int = 1_000_000
