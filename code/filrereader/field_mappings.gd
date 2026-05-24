class_name FieldMappings
extends RefCounted

# ---------------------------------------------------------------------------
# SPIELER field indices (0-based from first data line after %SECT%SPIELER)
# ---------------------------------------------------------------------------
const SP_NACHNAME            := 0
const SP_VORNAME             := 1
const SP_HAUTFARBE           := 3
const SP_HAARFARBE           := 4
const SP_ALTER               := 5
const SP_STAERKE             := 6
const SP_LAND                := 7   # value & 127 = land index; value >= 128 → Fussballinlaender
const SP_HAUPTPOSITION       := 8
const SP_NEBENPOSITION1      := 9
const SP_NEBENPOSITION2      := 10
const SP_POSITIVE_FAEHIGKEITEN := 11  # bitmask
const SP_NEGATIVE_FAEHIGKEITEN := 12  # bitmask
const SP_EIGENSCHAFTEN       := 13   # bitmask
const SP_CHARAKTER           := 14   # bitmask
const SP_HAT_KUENSTLERNAME   := 15
const SP_KUENSTLERNAME       := 16   # may be empty string
const SP_FUSS                := 17   # 1=Rechts 2=Links 3=Beide
const SP_TALENT              := 18   # 1-based
const SP_GESUNDHEIT          := 19   # 0-based
const SP_PUBLIKUM            := 20   # 1-based
const SP_GEBURTSTAG          := 21
const SP_LAND2               := 23
const SP_NATIONALSPIELER     := 24   # 0=kein 1=National 2=Ruecktritt
const SP_KAPITAEN_RUECKTRITT := 27
const SP_RUECKENNUMMER       := 28
const SP_HAAR_BART           := 29   # Haar = val>>16 (0-3); Bart = val & 0xF
const SP_FIELD_COUNT         := 33   # indices 0..32

# ---------------------------------------------------------------------------
# VEREIN header field indices (0-based, before %SECT%TRAINER)
# ---------------------------------------------------------------------------
const VE_LAND          := 0
const VE_VEREINSNAME   := 1
const VE_KUERZEL       := 2
const VE_ANFEUERUNG    := 3
const VE_FANBEZEICHNUNG := 4
const VE_HEADER_COUNT  := 5

# VEREIN post-MANAGER field indices (0-based)
const VP_HEIMTRIKOT_FARBE1_MUSTER         := 0
const VP_HEIMTRIKOT_FARBE2                := 1
const VP_HEIMTRIKOT_HOSENFARBE            := 2
const VP_HEIMTRIKOT_STUTZEN_RINGEL        := 3
const VP_AUSWAERTZTRIKOT_FARBE1_MUSTER    := 4
const VP_AUSWAERTZTRIKOT_FARBE2           := 5
const VP_AUSWAERTZTRIKOT_HOSENFARBE       := 6
const VP_AUSWAERTZTRIKOT_STUTZEN_RINGEL   := 7
const VP_GUTHABEN                         := 8
const VP_KUERZEL_ARTIKEL                  := 9
const VP_FANAUFKOMMEN                     := 10
const VP_ART_DER_FANS                     := 11
const VP_FANFREUNDSCHAFT_MIT              := 12
const VP_ERZRIVALE                        := 13
const VP_VORSTAND                         := 14
const VP_POKALMANNSCHAFT                  := 15
const VP_MAP_ROT_X                        := 16
const VP_MAP_UNK                          := 17
const VP_MAP_GRUEN_X                      := 18
const VP_MAP_GRUEN_Y                      := 19
const VP_UNK21                            := 20
const VP_OPPOSITION                       := 21
const VP_AMATEURABTEILUNG_VON             := 22
const VP_PROFI_ABTEILUNG_VON              := 23
const VP_FINANZKRAFT                      := 24
const VP_MAX_FANAUFKOMMEN                 := 25
const VP_HOOLIGANS                        := 26
const VP_MEDIENSTADT                      := 27
const VP_EW_TORE                          := 28
const VP_EW_GEGENTORE                     := 29
const VP_EW_SPIELE                        := 30
const VP_EW_PUNKTE                        := 31
const VP_VORSITZENDER_NACHNAME            := 32
const VP_VORSITZENDER_VORNAME             := 33
const VP_VORSITZENDER_GEBURTSTAG          := 34
const VP_AKTIENGESELLSCHAFT               := 35
const VP_TITEL_MEISTERSCHAFTEN            := 36
const VP_TITEL_POKALE                     := 37
const VP_TITEL_LIGAPOKALE                 := 38
const VP_TITEL_EUROPA_LEAGUES             := 39
const VP_TITEL_CHAMPIONS_LEAGUES          := 40
const VP_TITEL_WELTPOKALE                 := 41
const VP_REGIONALLIGA_AB2000              := 42
const VP_GRUENDUNGSJAHR                   := 43
const VP_POST_FIELD_COUNT                 := 51  # indices 0..50 (50 = player count)

# ---------------------------------------------------------------------------
# TRAINER field indices (0-based)
# ---------------------------------------------------------------------------
const TR_VORNAME    := 0
const TR_NACHNAME   := 1
const TR_KOMPETENZ  := 2
const TR_RUF        := 3
const TR_ALTER      := 4
const TR_GEBURTSTAG := 5
const TR_FIELD_COUNT := 8

# ---------------------------------------------------------------------------
# MANAGER field indices (0-based)
# ---------------------------------------------------------------------------
const MA_VORNAME    := 0
const MA_NACHNAME   := 1
const MA_KOMPETENZ  := 2
const MA_ALTER      := 3
const MA_GEBURTSTAG := 4
const MA_FIELD_COUNT := 5

# ---------------------------------------------------------------------------
# STADION field indices (0-based)
# ---------------------------------------------------------------------------
const ST_NAME              := 0
const ST_ORT               := 1
const ST_ANZEIGETAFEL      := 2
const ST_RASENHEIZUNG      := 3
const ST_FLUTLICHT         := 6
const ST_HEIMTRIBUENE      := 7
const ST_GEGENTRIBUENE     := 8
const ST_CITYLAGE          := 9
const ST_IM_BESITZ         := 10
const ST_AUTOBAHN          := 11
const ST_FERNSEHTURM       := 12
const ST_HAUPT_STEH        := 13
const ST_HAUPT_SITZ        := 14
const ST_HAUPT_VIP         := 15
const ST_HAUPT_ZUSTAND     := 16
const ST_GEGEN_STEH        := 17
const ST_GEGEN_SITZ        := 18
const ST_GEGEN_VIP         := 19
const ST_GEGEN_ZUSTAND     := 20
const ST_LINKS_STEH        := 21
const ST_LINKS_SITZ        := 22
const ST_LINKS_VIP         := 23
const ST_LINKS_ZUSTAND     := 24
const ST_RECHTS_STEH       := 25
const ST_RECHTS_SITZ       := 26
const ST_RECHTS_VIP        := 27
const ST_RECHTS_ZUSTAND    := 28
const ST_DACH              := 29  # bitmask: 1=Haupt 2=Gegen 4=Links 8=Rechts
const ST_LAUFBAHN          := 30
const ST_WAERMESTRAHLER    := 31  # bitmask same as DACH
const ST_LUXUSKABINEN      := 32
const ST_SITZKISSEN        := 33
const ST_BEHEIZTE_SITZE    := 34
const ST_AUSFAHRBARES_FELD := 35
const ST_BERGE             := 36
const ST_BURG              := 37
const ST_SCHLOSS           := 38
const ST_FIELD_COUNT       := 39

# ---------------------------------------------------------------------------
# REPORTER field indices (0-based)
# ---------------------------------------------------------------------------
const RE_SENDER    := 0
const RE_NACHNAME  := 1
const RE_VORNAME   := 2
const RE_BOESE_LIEB := 3
const RE_FIELD_COUNT := 4

# ---------------------------------------------------------------------------
# SCHIRI / ISCHIRI field indices (0-based)
# ---------------------------------------------------------------------------
const SC_VORNAME           := 0
const SC_NACHNAME          := 1
const SC_KOMPETENZ         := 2
const SC_HAERTE            := 3
const SC_UNBELIEBTER_VEREIN := 4
const SC_EIGENSCHAFTEN     := 5  # bitmask
const SC_FIELD_COUNT       := 6

# ---------------------------------------------------------------------------
# PROMI field indices (0-based)
# ---------------------------------------------------------------------------
const PR_NACHNAME        := 0
const PR_VORNAME         := 1
const PR_LIEBLINGSVEREIN := 2
const PR_FIELD_COUNT     := 3

# ---------------------------------------------------------------------------
# Lookup tables
# ---------------------------------------------------------------------------

const HAUTFARBE: PackedStringArray = ["Hell", "Dunkel", "Schwarz", "Asiatisch"]

const HAARFARBE: PackedStringArray = [
	"Hellblond", "Blond", "Braun", "Rot", "Schwarz", "Glatze", "Grau"
]

const POSITION: PackedStringArray = [
	"Keine", "Torwart", "Libero", "Innenverteidiger",
	"LinkerVerteidiger", "RechterVerteidiger", "DefensivesMittelfeld",
	"LinkesMittelfeld", "RechtesMittelfeld", "OffensivesMittelfeld", "Stuermer"
]

# 1-based: index 0 unused
const FUSS: PackedStringArray = ["", "Rechts", "Links", "Beide"]

# 1-based: index 0 unused
const TALENT: PackedStringArray = [
	"", "Megatalent", "Talent", "Normal", "WenigBegabt", "ZweiLinkeFuesse"
]

const GESUNDHEIT: PackedStringArray = [
	"Normal", "Robust", "Anfaellig", "Knieprobleme",
	"SchnellWiederFit", "DauertBisWiederFit", "Wehleidig"
]

# 1-based: index 0 unused
const PUBLIKUM: PackedStringArray = ["", "Normal", "Liebling", "Hassfigur"]

const HAAR: PackedStringArray = ["ExtremKurz", "Kurz", "Wuschelkopf", "Lang"]

# Torwartfähigkeiten bitmask (bit → name)
const TORWART_FAEHIGKEITEN: Dictionary = {
	2: "Elfmetertoeter", 4: "StarkeReflexe", 8: "Herauslaufen",
	16: "Flanken", 32: "Fausten", 64: "Ballsicherheit",
	128: "Schnelligkeit", 256: "WeiteAbschlaege", 512: "WeiteAbwuerfe"
}

# Spielerfähigkeiten bitmask (bit → name)
const SPIELER_FAEHIGKEITEN: Dictionary = {
	2: "Kopfball", 4: "Zweikampf", 8: "Schnelligkeit",
	16: "Schusskraft", 32: "Elfmeter", 64: "Freistoesse",
	128: "Flanken", 256: "Torinstinkt", 512: "Laufstaerke",
	1024: "Technick", 2048: "Ballzauberer", 4096: "Spielmacher",
	8192: "Viererkette", 16384: "Spieluebersicht",
	32768: "BallHalten", 65536: "Dribbling"
}

const EIGENSCHAFTEN: Dictionary = {
	2: "Kaempfernatur", 4: "Trainingsweltmeister", 8: "TrainingsfaulerSpieler",
	16: "Treter", 32: "FairerSpieler", 64: "Mimose",
	128: "Schlitzohr", 256: "Spezialist", 512: "Allrounder",
	1024: "FlexiblerSpieler", 2048: "Schiriliebling", 4096: "Heimspieler",
	8192: "Schoenwetterfussballer", 16384: "Joker",
	32768: "Egoist", 65536: "BruderLeichtfuss"
}

const CHARAKTER: Dictionary = {
	2: "Fuehrungsperson", 4: "Hitzkopf", 8: "Frohnatur",
	16: "MannOhneNerven", 32: "Nervenbuendel", 64: "Phlegmatiker",
	128: "Geldgeier", 256: "Vereinsanhaenger", 512: "Musterprofi",
	1024: "Skandalnudel", 2048: "Sensibelchen", 4096: "Staralueren",
	8192: "TeenieStar", 16384: "Unruhestifter",
	32768: "Leberwurst", 65536: "Integrationsfigur"
}

const BART_BITS: Dictionary = {
	1: "Unrasiert", 2: "Bart", 4: "Schnurbart", 8: "Ziegenbart"
}

const TRAINER_RUF: PackedStringArray = [
	"Kumpeltyp", "LustigerGeselle", "Motivationskuenstler",
	"PrMann", "Schleifer", "Wissenschaftler", "Keiner"
]

const TRIKOT_FARBE: PackedStringArray = [
	"Weiss", "Rot", "Gelb", "Blau", "Hellgruen", "Gruen",
	"Tuerkis", "Hellblau", "Braun", "Lila", "Orange", "Schwarz", "Weinrot"
]

const TRIKOT_MUSTER: PackedStringArray = [
	"Neutral", "Laengs", "Quer", "HalbHalb", "Schulter",
	"Brustring", "Aermel", "Mittelstreifen", "Kariert", "Schraeg"
]

# 0-based
const KUERZEL_ARTIKEL: PackedStringArray = ["Keins", "Der", "Die"]

const FANAUFKOMMEN: PackedStringArray = [
	"WahreHorden", "SehrHoch", "Hoch", "Durchschnittlich",
	"Bescheiden", "Aermlich", "Fans?"
]

const ART_DER_FANS: PackedStringArray = [
	"Normal", "Lautstark", "Verwoehnt", "Anspruchsvoll",
	"Treu", "Erfolgshungrig", "Frustriert", "Euphorisch"
]

const VORSTAND: PackedStringArray = [
	"Pulverfass", "Schleudersitz", "Nervoes", "Normal", "Souveraen", "Treu"
]

const OPPOSITION: PackedStringArray = [
	"NichtVorhanden", "NurStuemper", "FormiertSich", "DurchausVorhanden",
	"Konkurenzfaehig", "SehrStark", "MaechtigUndKompetent"
]

const FINANZKRAFT: PackedStringArray = [
	"Minimal", "Schlecht", "Wenig", "Solide", "Gut", "Reich", "Gesegnet"
]

const HOOLIGANS: PackedStringArray = [
	"NichtVorhanden", "WenigeUndFeige", "EinPaarAberKraeftige", "VieleUndSchlimme"
]

const REGIONALLIGA: Dictionary = {2: "Nord", 5: "Sued"}

const ANZEIGETAFEL: PackedStringArray = [
	"KeineTafel", "Torschilder", "KleineLedTafel", "GrosseLedTafel", "Videowand"
]

const TRIBUNEN_TYP: PackedStringArray = ["Haupt", "Gegen", "Links", "Rechts"]

const STADION_ZUSTAND: PackedStringArray = [
	"Neu", "FastNeu", "Unmodern", "Angestaubt", "Baufaellig", "Vermodert", "Verfallen"
]

const DACH_BITS: Dictionary = {1: "Haupt", 2: "Gegen", 4: "Links", 8: "Rechts"}

const SCHIRI_EIGENSCHAFTEN: Dictionary = {
	1: "Heimschiedsrichter", 2: "Gastschiedsrichter",
	4: "HasstMeckern", 8: "HasstZeitspiel", 16: "HasstCoaching"
}

const BOESE_LIEB: PackedStringArray = ["Boese", "Neutral", "Lieb"]

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

static func lookup(arr: PackedStringArray, idx: int) -> String:
	if idx >= 0 and idx < arr.size():
		return arr[idx]
	return "UNKNOWN_%d" % idx


static func lookup_bits(bits_dict: Dictionary, mask: int) -> Array[String]:
	var result: Array[String] = []
	for bit: int in bits_dict:
		if mask & bit:
			result.append(bits_dict[bit])
	return result


static func trikot_farbe(combined: int) -> String:
	return lookup(TRIKOT_FARBE, combined & 0xF)


static func trikot_muster(combined: int) -> String:
	return lookup(TRIKOT_MUSTER, (combined >> 4) & 0xF)


static func stutzen_farbe(combined: int) -> String:
	return lookup(TRIKOT_FARBE, combined & 0xF)


static func stutzen_ringelsocken(combined: int) -> String:
	return "Ja" if (combined & 0x10) != 0 else "Nein"


static func haar_from_combined(combined: int) -> String:
	return lookup(HAAR, (combined >> 16) & 0x3)


static func bart_from_combined(combined: int) -> Array[String]:
	var mask: int = combined & 0xF
	if mask == 0:
		return ["Kein"]
	return lookup_bits(BART_BITS, mask)


static func land_index(raw: int) -> int:
	return raw & 0x7F


static func fussballinlaender(raw: int) -> String:
	return "Ja" if raw >= 128 else "Nein"
