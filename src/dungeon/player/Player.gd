extends KinematicBody2D

class_name Tank

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

var velocity = Vector2.ZERO

onready var treasure_area_pivot = $TreasureAreaPivot
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

var accept_collision: bool = false
var treasure
var input_vector = Vector2.ZERO

signal enemie_collided

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	if Input.is_action_pressed("ui_accept"):
		if treasure:
			treasure.open()
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized() #make angle move use same speed of normal move
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/idle/blend_position", input_vector)
		animation_tree.set("parameters/run/blend_position", input_vector)
		animation_state.travel("run")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("idle")
		
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)

func is_accept_collision() -> bool:
	return accept_collision

func set_accept_collision(accept: bool):
	accept_collision = accept

func _on_EnemieArea_body_entered(body):
	if !is_accept_collision():
		set_accept_collision(false)
		emit_signal("enemie_collided", body)

func _on_treasure_seen(treasure_seen):
	treasure = treasure_seen

func _on_treasure_unseen(treasure_seen):
	treasure = null
