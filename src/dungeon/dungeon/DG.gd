extends Node2D

var enemie_to_free

onready var tank = $YSort/Tank

func _ready():
	pass
	
func back_to_world():
	tank.set_accept_collision(true)
	enemie_to_free.queue_free()

func _on_enemie_collision(enemy: Enemie):
	enemie_to_free = enemy
	Global.change_to_battle("res://src/battle/background/Forest.tscn", enemy)
