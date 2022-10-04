extends Control

class_name PlayerBar

var battler: Battler

func select():
	$AnimationPlayer.play("Select")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("Selected")

func deselect():
	$AnimationPlayer.play("Deselect")

func same_battler(_battler: Battler) -> bool:
	return _battler == battler

func _process(delta):
	if battler:
		$Life.text = str(battler.get_stats().get_hp()) + "/" + str(battler.get_stats().get_hp_max())
		$Mana.text = str(battler.get_stats().get_mp()) + "/" + str(battler.get_stats().get_mp_max())
	pass

func set_battler(_battler: Battler):
	battler = _battler
	$Icon.texture = load("res://assets/monsters/" + battler.get_assets_dir_name() + "/icon.png")
	$Name.text = battler.get_stats().get_name()
	if $Name.text == "":
		$Name.text = battler.monster_name
	$Life.text = str(battler.get_stats().get_hp()) + "/" + str(battler.get_stats().get_hp_max())
	$Mana.text = str(battler.get_stats().get_mp()) + "/" + str(battler.get_stats().get_mp_max())
