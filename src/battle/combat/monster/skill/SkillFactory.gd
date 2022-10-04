extends Resource

class_name SkillFactory

var skills = {}

func inicialize():
	skills[Enums.SKILL.ATACK] = create_skill("Atack", "", 50, 0, null, Enums.SKILL_FUNCTION.ATACK, Enums.SKILL_FUNCTION_STATS.HP)
	skills[Enums.SKILL.BITE] = create_skill("Bite", "bite", 10, 5, Enums.Type.DARKNESS, Enums.SKILL_FUNCTION.ATACK, Enums.SKILL_FUNCTION_STATS.HP)
	skills[Enums.SKILL.FIREBALL] = create_skill("Fire Ball", "fireball", 20, 8, Enums.Type.FIRE, Enums.SKILL_FUNCTION.ATACK, Enums.SKILL_FUNCTION_STATS.HP)
	skills[Enums.SKILL.INFECT] = create_skill("Infect", "infect", 15, 9, Enums.Type.EARTH, Enums.SKILL_FUNCTION.ATACK, Enums.SKILL_FUNCTION_STATS.HP)
	skills[Enums.SKILL.CURE] = create_skill("Cure", "heal", 100, 30, Enums.Type.LIGHT, Enums.SKILL_FUNCTION.BUFF, Enums.SKILL_FUNCTION_STATS.HP)

func create_skill(sname, icon, power, cost, type, function, function_stat) -> Skill:
	var skill: Skill = load("res://src/battle/combat/monster/skill/Skill.gd").new()
	
	skill.set_name(sname)
	skill.set_icon(icon)
	skill.set_power(power)
	skill.set_cost(cost)
	skill.set_type(type)
	skill.set_function(function)
	skill.set_function_stat(function_stat)
	
	return skill

func get_atack() -> Skill:
	return skills.get(Enums.SKILL.ATACK)

func get_skill(skill_name) -> Skill:
	for skill in skills:
		if skills.has(skill_name):
			return skills[skill_name]
	return null
	
func get_random_skill() -> Skill:
	return skills[randi() % Enums.SKILL.size()]
