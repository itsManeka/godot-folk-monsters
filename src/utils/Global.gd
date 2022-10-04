extends Node

var pre_skill_factory: SkillFactory = load("res://src/battle/combat/monster/skill/SkillFactory.gd")

var root
var world_scene
var skill_factory: SkillFactory

func _ready():
	randomize()
	root = get_tree().get_root()
	
	skill_factory = pre_skill_factory.new()
	skill_factory.inicialize()

func change_to_battle(path: String, enemy: Enemie):
	var new_scene_res = load(path)
	var new_scene = new_scene_res.instance()
	new_scene.set_enemy(enemy)
	world_scene = get_tree().get_current_scene()
	root.add_child(new_scene)
	get_tree().set_current_scene(new_scene)
	root.remove_child(world_scene)

func back_to_world():
	world_scene.back_to_world()
	root.remove_child(get_tree().get_current_scene())
	root.add_child(world_scene)
	get_tree().set_current_scene(world_scene)
