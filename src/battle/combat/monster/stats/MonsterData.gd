extends Resource

class_name MonsterData

var atack: Skill
var skills: Array
export(Array, Enums.SKILL) var skills_name
export(String) var name: String = "" setget set_name, get_name
export var level: int = 0 setget set_level, get_level

export var stats = {
	"atk": 0,
	"def": 0,
	"spd": 0,
	"hp": 0,
	"mp": 0,
	"hp_max": 0,
	"mp_max": 0
}

func initialize():
	atack = Global.skill_factory.get_atack()
	
	var skill: Skill
	for skill_name in skills_name:
		skill = Global.skill_factory.get_skill(skill_name)
		if skill != null:
			add_skill(skill)

func set_stat(skill, _value: int):
	var stat: String = skill.get_function_stat()
	var subtract: bool = true
	var value: int
	var current_value: int
	
	match(skill.get_function()):
		Enums.SKILL_FUNCTION.BUFF:
			subtract = false
		
	current_value = stats.get(stat)
	value = (current_value - _value) if subtract else (current_value + _value)
	if stats.has(stat + "_max"):
		stats[stat] = clamp(value, 0, stats[stat + "_max"])
	else:
		stats[stat] = value

func set_atack(skill: Skill):
	atack = skill
	
func get_atack() -> Skill:
	return atack
	
func add_skill(skill: Skill):
	skills.append(skill)

func get_skills() -> Array:
	return skills
	
func set_name(_name: String):
	name = _name
	
func get_name():
	return name
	
func set_level(_level: int):
	level = _level
	
func get_level() -> int:
	return level

func set_hp_max(hp_max: int):
	stats.hp_max = hp_max
	
func get_hp_max() -> int:
	return stats.hp_max
	
func set_mp_max(mp_max: int):
	stats.mp_max = mp_max

func set_hp(hp: int):
	stats.hp = hp

func set_mp(mp: int):
	stats.mp = mp

func get_mp_max() -> int:
	return stats.mp_max

func get_hp() -> int:
	return stats.hp

func get_mp() -> int:
	return stats.mp

func set_spd(spd: int):
	stats.spd = spd
	
func get_spd() -> int:
	return stats.spd

func set_atk(atk: int):
	stats.atk = atk
	
func get_atk() -> int:
	return stats.atk
	
func set_def(def: int):
	stats.def = def
	
func get_def() -> int:
	return stats.def
