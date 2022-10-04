extends Node

class_name BattleManager

static func get_damage(source: Battler, target: Battler, skill: Skill) -> int:
	var damage: float = 0
	
	var source_level: float = source.get_stats().get_level()
	var skill_power: float = skill.get_power()
	var source_atk: float = source.get_stats().get_atk()
	var target_def: float = target.get_stats().get_def()
	
	damage = ((source_level / 5) + 2)
	damage = (damage * skill_power * (source_atk / target_def))
	damage = ((damage / 50) + 2)
	damage = (damage * get_modifier(source, target, skill))
	
	return int(round(damage))
	
static func get_modifier(source: Battler, target: Battler, skill: Skill) -> float:
	var modifier: float = 1
	
	var terrain: float = get_terrain_modifier() #terrain type x source type
	var weater: float = get_weater_modifier() #weater type x source and skill type
	var critical: float = get_critical_modifier(source) # critical
	var random: float = get_random_modifier() #random modifier 85% to 100%
	var same_atack_bonus: float = get_same_atack_bonus(source, skill) #when skill type is equals source type
	var type: float = get_type_modifier(skill, source, target) #source type x target type
	var area: float = get_area_modifier(source, target, skill) #area (flying x ground)
	var guard: float = get_guard_modifier(target) #when target is in guard
	
	modifier = (terrain * weater * critical * random * same_atack_bonus * type * area * guard)
	
	return modifier

static func get_type_modifier(skill: Skill, source: Battler, target: Battler) -> float:
	var modifier: float = 1
	
	var sourceType = skill.get_type()
	var targetType = target.get_type()
	
	if sourceType == null:
		sourceType = source.get_type()
	
	match sourceType:
		Enums.Type.DARKNESS:
			match targetType:
				Enums.Type.EARTH, Enums.Type.ARTIFICIAL:
					modifier = 2
				Enums.Type.LIGHT:
					modifier = 0
				Enums.Type.THUNDER:
					modifier = 0.5
		Enums.Type.EARTH:
			match targetType:
				Enums.Type.LIGHT:
					modifier = 2
				Enums.Type.METAL:
					modifier = 0.5
		Enums.Type.FIRE:
			match targetType:
				Enums.Type.METAL, Enums.Type.THUNDER:
					modifier = 2
				Enums.Type.EARTH:
					modifier = 0.5
		Enums.Type.LIGHT:
			match targetType:
				Enums.Type.DARKNESS:
					modifier = 2
				Enums.Type.FIRE, Enums.Type.THUNDER:
					modifier = 0.5
		Enums.Type.METAL:
			match targetType:
				Enums.Type.DARKNESS:
					modifier = 2
				Enums.Type.WATER:
					modifier = 0.5
		Enums.Type.THUNDER:
			match targetType:
				Enums.Type.METAL, Enums.Type.WATER:
					modifier = 2
				Enums.Type.EARTH:
					modifier = 0.5
		Enums.Type.WATER:
			match targetType:
				Enums.Type.EARTH, Enums.Type.FIRE:
					modifier = 2
				Enums.Type.WIND:
					modifier = 0.5
		Enums.Type.WIND:
			match targetType:
				Enums.Type.LIGHT, Enums.Type.WATER:
					modifier = 2
				Enums.Type.EARTH, Enums.Type.FIRE, Enums.Type.METAL, Enums.Type.ARTIFICIAL:
					modifier = 0.5
		Enums.Type.ARTIFICIAL:
			match targetType:
				Enums.Type.THUNDER:
					modifier = 2
				Enums.Type.LIGHT:
					modifier = 0.5
	
	return modifier
	
static func get_area_modifier(source: Battler, target: Battler, skill: Skill) -> float:
	var modifier: float = 1
	
	#Flying or ground stats
	
	return modifier
	

static func get_random_modifier() -> float:
	var modifier: float = 1
	
	modifier = rand_range(.85, 1)
	
	return modifier
	
static func get_guard_modifier(target: Battler) -> float:
	var modifier: float = 1
	
	if target.is_in_guard():
		modifier = .25
	
	return modifier

static func get_critical_modifier(source: Battler) -> float:
	var modifier: float = 1
	var probability: float = 1
	var random_number: int = 1
	
	probability = (source.get_stats().get_spd() / 2)
	random_number = randi() % 999
	
	if random_number < probability:
		modifier = (((2 * source.get_stats().get_level()) + 5) / (source.get_stats().get_level() + 5))
	
	return modifier

static func get_same_atack_bonus(source: Battler, skill: Skill) -> float:
	var modifier: float = 1
	
	if source.get_type() == skill.get_type():
		modifier = 1.5
	
	return modifier
	
static func get_terrain_modifier() -> float:
	var modifier: float = 1
	# calc terrain type x source type
	return modifier
	
static func get_weater_modifier() -> float:
	var modifier: float = 1
	# calc weater type x source type,  weater type x atack type and weater type x target type
	return modifier
