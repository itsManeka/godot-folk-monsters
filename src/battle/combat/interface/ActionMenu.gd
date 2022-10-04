extends Control

class_name ActionMenu

var pre_skill_button = preload("res://src/battle/combat/interface/SkillButton.tscn")

var skill_showing: bool
var pressed: bool
var skills_created: bool
var skills_clickable: bool
var skills: Array

signal action_pressed

func initialize():
	pass

func set_battler(active_battler: Battler):
	var assets_dir_name
	assets_dir_name = active_battler.get_assets_dir_name()
	$Menu/Action.texture_normal = load("res://assets/monsters/" + assets_dir_name + "/icon.png")
	
	skills = active_battler.get_stats().get_skills()
	pass

func show_skills():
	if !skills_created:
		skills_created = true
		var button: SkillButton
		var buttonPos = Vector2(0, 0)
		
		for skill in skills:
			print(buttonPos)
			button = pre_skill_button.instance()
			button.set_skill(skill)
			button.rect_position = buttonPos
			$Menu/Submenu/SKL/SkillPos.add_child(button)
			button.show_button()
			yield(get_tree().create_timer(0.2), "timeout")
			button.connect("selected", self, "_on_SKL_selected")
			buttonPos += Vector2(60, 0)
	else:
		print("print else")
		print($Menu/Submenu/SKL/SkillPos.get_children())
		for button in $Menu/Submenu/SKL/SkillPos.get_children():
			button.show_button()
			yield(get_tree().create_timer(0.2), "timeout")
			
	skills_clickable = true
		
func hide_skills():
	for i in range($Menu/Submenu/SKL/SkillPos.get_child_count() -1, -1, -1):
		$Menu/Submenu/SKL/SkillPos.get_child(i).hide_button()
		yield(get_tree().create_timer(0.2), "timeout")
	
	skills_clickable = true

func appear():
	for button in $Menu/Submenu/SKL/SkillPos.get_children():
		button.queue_free()
	
	skills_clickable = true
	skill_showing = false
	pressed = false
	skills_created = false
	$Menu/AnimationPlayer.play("Start")

func hide_menu():
	$Menu/AnimationPlayer.play_backwards("Open")
	yield(get_tree().create_timer(0.3), "timeout")
	$Menu/AnimationPlayer.play("Close")
	yield(get_tree().create_timer(0.3), "timeout")

func _on_Action_button_down():
	if !pressed:
		pressed = true
		$Menu/AnimationPlayer.play("Open")
	else:
		pressed = false
		$Menu/AnimationPlayer.play_backwards("Open")

func _on_ATK_button_down():
	yield(hide_menu(), "completed")
	
	emit_signal("action_pressed", Enums.ACTION_TYPE.ATK, null)
	
func _on_DEF_button_down():
	yield(hide_menu(), "completed")
	
	emit_signal("action_pressed", Enums.ACTION_TYPE.DEF, null)

func _on_SKL_selected(skill: Skill):
	yield(hide_menu(), "completed")
	
	emit_signal("action_pressed", Enums.ACTION_TYPE.SKL, skill)

func _on_SKL_button_down():
	if skills_clickable:
		skills_clickable = false
		if !skill_showing:
			skill_showing = true
			show_skills()
		else:
			skill_showing = false
			hide_skills()
	
func _on_started():
	$Menu/Submenu.show()
