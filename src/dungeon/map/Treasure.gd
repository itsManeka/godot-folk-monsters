extends StaticBody2D

class_name Treasure

var opened: bool = false

onready var sprite = $Sprite

func _ready():
	pass

func open():
	if !opened:
		opened = true
		sprite.play("open")
