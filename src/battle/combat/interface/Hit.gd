extends Control

class_name Hit

var text

func set_hit(skill: Skill):
	match(skill.get_function()):
		Enums.SKILL_FUNCTION.ATACK, Enums.SKILL_FUNCTION.DEBUFF:
			text = skill.get_function_stat() + " -"
			$Label.add_color_override("font_color", Color(230, 20, 20))
			$Label.add_color_override("font_color_shadow", Color(80, 0, 0))
			
		Enums.SKILL_FUNCTION.BUFF:
			text = skill.get_function_stat() + " +"
			$Label.add_color_override("font_color", Color(20, 230, 20))
			$Label.add_color_override("font_color_shadow", Color(0, 80, 0))

func set_value(value: int):
	$Label.text = text + str(value)

func play(skill: Skill, value: int):
	set_hit(skill)
	set_value(value)
	$AnimationPlayer.play("Appear")
