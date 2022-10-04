extends Node

class_name RandomStats

static func get_random_data() -> MonsterData:
	var data: MonsterData = load("res://src/battle/combat/monster/stats/MonsterData.gd").new()
	
	data.set_level(5)
	data.set_spd(randi() % 10 + 1)
	data.set_atk(randi() % 30 + 1)
	data.set_def(randi() % 30 + 1)
	data.set_hp_max(randi() % 150 + 80)
	data.set_hp(data.get_hp_max())
	data.set_mp_max(randi() % 80 + 40)
	data.set_mp(data.get_mp_max())
	
	data.set_atack(Global.skill_factory.get_atack())
	for i in randi() % 3 + 1:
		data.add_skill(Global.skill_factory.get_random_skill())
		
	return data
