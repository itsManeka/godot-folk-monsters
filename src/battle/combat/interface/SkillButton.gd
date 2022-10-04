extends Control

class_name SkillButton

signal selected

var skill: Skill setget set_skill, get_skill

func _ready():
	pass

func show_button():
	$AnimationPlayer.play("Show")

func hide_button():
	$AnimationPlayer.play("Hide")

func _on_button_clicked():
	emit_signal("selected", skill)

func set_skill(_skill: Skill):
	skill = _skill
	$Button.texture_normal = load("res://assets/monsters/skills/" + skill.get_icon() + ".png")
	
func get_skill() -> Skill:
	return skill
