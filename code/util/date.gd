class_name Date
extends RefCounted

var day: int
var month: int
var year: int


func _init(d: int, m: int, y: int) -> void:
	day = d
	month = m
	year = y


func _to_string() -> String:
	return "%02d.%02d.%d" % [day, month, year]


func add_days(n: int) -> Date:
	var d: int = day + n
	var m: int = month
	var y: int = year
	while d > _days_in_month(m, y):
		d -= _days_in_month(m, y)
		m += 1
		if m > 12:
			m = 1
			y += 1
	return Date.new(d, m, y)


func days_until(other: Date) -> int:
	return other._to_julian_day() - _to_julian_day()


func _to_julian_day() -> int:
	var a: int = (14 - month) / 12
	var y: int = year + 4800 - a
	var m: int = month + 12 * a - 3
	return day + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y / 400 - 32045


static func _days_in_month(m: int, y: int) -> int:
	match m:
		2:
			return 29 if (y % 4 == 0 and (y % 100 != 0 or y % 400 == 0)) else 28
		4, 6, 9, 11:
			return 30
		_:
			return 31
