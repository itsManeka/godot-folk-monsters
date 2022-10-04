extends Node

class_name IA

signal action_pressed
signal target_selected

func do_something(battler: Battler):
	var random_action: int
	
	random_action = randi() % 3 + 1
	match random_action:
		1: #atack
			emit_signal("action_pressed", Enums.ACTION_TYPE.ATK, battler.get_stats().get_atack())
		2: #guard
			emit_signal("action_pressed", Enums.ACTION_TYPE.DEF, null)
		3: #random skill
			emit_signal("action_pressed", Enums.ACTION_TYPE.SKL, battler.get_stats().get_skills()[randi() % battler.get_stats().get_skills().size()])
			
func select_random_target(battlers: Array, skill: Skill):
	var targets: Array
	
	for battler in battlers:
		match(skill.get_function()):
			Enums.SKILL_FUNCTION.ATACK, Enums.SKILL_FUNCTION.DEBUFF:
				if battler.is_party_member():
					targets.append(battler)
			_:
				if !battler.is_party_member():
					targets.append(battler)
	
	emit_signal("target_selected", targets[randi() % targets.size()])
