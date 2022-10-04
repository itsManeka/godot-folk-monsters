extends Position2D

class_name Battler

signal target_selected

export(String) var assets_dir_name
export(String) var monster_name
export(Enums.Type) var type

var party_member: bool = false
var active: bool = false
var selectionable: bool = false
var selectionable_type

var stats: MonsterData setget set_stats, get_stats
var in_guard: bool setget set_in_guard, is_in_guard

onready var hit_label = $HitPosition/Hit
onready var body = $Skin/Body
onready var animation = $AnimationPlayer
onready var selection_rect = $SelectionRect

func _ready():
	if !is_party_member():
		flip()
		
	selection_rect.connect("clicked", self, "_on_clicked")
	selection_rect.connect("selected", self, "_on_selected")
	selection_rect.connect("unselected", self, "_on_unselected")
	body.connect("animation_finished", self, "_on_animation_finished")

func init_turn():
	in_guard = false

func get_type():
	return type

func set_in_guard(_guard: bool):
	in_guard = _guard
	
func is_in_guard() -> bool:
	return in_guard

func set_selectionable(_selectionable, _selectionable_type):
	selectionable = _selectionable
	selectionable_type = _selectionable_type
	
func apply(skill, value):
	stats.set_stat(skill, value)
	
func aplly_cost(cost: int):
	stats.set_mp(stats.get_mp() - cost)
	
func _on_animation_finished():
	if body.animation != "stand":
		stand()

func _on_selected():
	if selectionable && !active:
		match(selectionable_type):
			Enums.SKILL_FUNCTION.ATACK, Enums.SKILL_FUNCTION.DEBUFF:
				animation.play("SelectTarget")
			Enums.SKILL_FUNCTION.BUFF:
				animation.play("SelectTargetBuff")
	
func _on_unselected():
	if selectionable && !active:
		end_selection()

func _on_clicked():
	if selectionable && !active:
		end_selection()
		emit_signal("target_selected", self)

func get_assets_dir_name():
	return assets_dir_name

func guard():
	body.play("guarding")
	yield(body, "animation_finished")

func act(skill: Skill):
	if skill.get_function() == Enums.SKILL_FUNCTION.ATACK:
		body.play("atack")
	else:
		body.play("buff")
	
	yield(body, "animation_finished")
	
func hit(skill: Skill, value: int):
	hit_label.play(skill, value)
	yield(_play_hit(skill), "completed")

func _play_hit(skill: Skill):
	if skill.get_function() == Enums.SKILL_FUNCTION.ATACK:
		body.play("hurt")
		animation.play("Hit")
	else:
		body.play("buffed")
		
	yield(body, "animation_finished")

func stand():
	if is_in_guard():
		body.play("guard")
	else:
		body.play("stand")

func end_selection():
	animation.play("EndSelection")

func reset():
	active = false
	end_selection()

func select():
	active = true
	animation.play("Selected")
	
func appear():
	animation.play("Start")

func flip():
	self.scale *= Vector2(-1, 1)
	hit_label.rect_scale *= Vector2(-1, 1)

func set_stats(_stats: MonsterData):
	stats = _stats
	
func get_stats() -> MonsterData:
	return stats

func set_party_member():
	party_member = true
	
func is_party_member():
	return party_member
