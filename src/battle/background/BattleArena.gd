extends Node2D

var enemy: Enemie

onready var combat_arena = $CombatArena

func set_enemy(_enemy: Enemie):
	enemy = _enemy
