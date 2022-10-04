extends KinematicBody2D

class_name Enemie

export(Resource) var enemy_box

export var ACCELERATION = 300
export var MAX_SPEED = 30
export var FRICTION = 200
export var SOFT_COLISION_MODIFIER = 400

const WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var direction = Vector2.ZERO
var state = CHASE

onready var animation_player = $AnimationPlayer
onready var player_detection_zone = $PlayerDetectionZone
onready var soft_collision = $SoftCollision 
onready var wander_controller = $WanderController
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

func _ready():
	update_state(pick_random_state([IDLE, WANDER]))
	set_meta("type", "enemie")

func _physics_process(delta):
	
	if direction != Vector2.ZERO:
		animation_tree.set("parameters/idle/blend_position", direction)
		animation_tree.set("parameters/run/blend_position", direction)
		animation_state.travel("run")
	else:
		animation_state.travel("idle")
	
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wander_controller.get_time_left() == 0:
				update_wander()
			
		WANDER:
			seek_player()
			
			if wander_controller.get_time_left() == 0:
				update_wander()
			
			accelerate_towards_point(wander_controller.target_position, delta)
			
			if global_position.distance_to(wander_controller.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
			
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				update_state(IDLE)
			
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * SOFT_COLISION_MODIFIER
		
	velocity = move_and_slide(velocity)
	
	if velocity == Vector2.ZERO:
		direction = Vector2.ZERO

func accelerate_towards_point(point, delta):
	direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func seek_player():
	if player_detection_zone.can_see_player():
		update_state(CHASE)
		
func update_state(new_state):
	state = new_state
	if state == IDLE:
		direction = Vector2.ZERO

func update_wander():
	update_state(pick_random_state([IDLE, WANDER]))
	wander_controller.start_wander_timer(rand_range(1, 2))

func pick_random_state(state_list: Array):
	state_list.shuffle()
	return state_list.pop_front()

func _on_PlayerDetectionZone_body_entered(body):
	animation_player.play("hey!")

