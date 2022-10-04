extends Node2D

class_name MonsterFactory

func get_monster(index: int):
	return get_children()[index].duplicate()

func get_random_monster():
	return get_children()[randi() % get_children().size()].duplicate()
