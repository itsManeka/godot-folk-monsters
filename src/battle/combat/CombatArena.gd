extends Node2D

class_name CombatArena

const MonsterFactory = preload("res://src/battle/combat/monster/factory/MonsterFactory.tscn")
const PlayerBar = preload("res://src/battle/combat/interface/PlayerBar.tscn")
const IA = preload("res://src/battle/combat/monster/auxscripts/IA.gd") #test for now

var monster_factory: MonsterFactory
var active_battler: Battler
var ia: IA #test for now

var current_skill: Skill
var enemies: Array

onready var turn_queue: TurnQueue = $TurnQueue
onready var action_menu: ActionMenu = $Interface/ActionMenu
onready var party_positions = $Positions/Party
onready var enemies_positions = $Positions/Enemy
onready var bar_positions = $Interface/BarPositions

func _ready():
	ia = IA.new() #test for now
	monster_factory = MonsterFactory.instance()
	action_menu.initialize()
	
	initialize(get_parent().enemy)
	
	turn_queue.connect("queue_changed", self, "_on_queue_changed")
	action_menu.connect("action_pressed", self, "_on_action_pressed")
	ia.connect("action_pressed", self, "_on_action_pressed") # test for now
	ia.connect("target_selected", self, "_on_target_selected") # test for now
	
	set_positions()
	
	yield(play_intro(), "completed")
	
	turn_queue.initialize()
	pass

func initialize(enemy: Enemie):
	var battler: Battler
	var enemy_res: EnemyRes
	var data: MonsterData
	for res in enemy.enemy_box.enemy_resource:
		enemy_res = res
		battler = monster_factory.get_node(enemy_res.node_name).duplicate()
		data = enemy_res.monster_data
		data.initialize()
		battler.set_stats(data)
		enemies.append(battler)

func _on_action_pressed(action, skill):
	current_skill = null
	
	active_battler.reset()
	
	match(action):
		Enums.ACTION_TYPE.ATK:
			current_skill = active_battler.get_stats().get_atack()
			set_targets_selectionables(true, current_skill.get_function())
			return
		Enums.ACTION_TYPE.DEF:
			active_battler.set_in_guard(true)
			yield(active_battler.guard(), "completed")
		_:
			current_skill = skill
			set_targets_selectionables(true, current_skill.get_function())
			return
	
	next_turn()

func next_turn():
	select_bar(false)
	turn_queue.next_battler()

func set_targets_selectionables(selectionable: bool, selectionable_type = Enums.SKILL_FUNCTION.ATACK):
	if active_battler.is_party_member():
		for battler in turn_queue.get_children():
			if battler != active_battler || selectionable_type != Enums.SKILL_FUNCTION.ATACK || !selectionable:
				battler.set_selectionable(selectionable, selectionable_type)
	else:
		if selectionable:
			ia.select_random_target(turn_queue.get_children(), current_skill) #test for now

func _on_target_selected(target: Battler):
	var value: int = 0
	
	set_targets_selectionables(false)
	
	active_battler.aplly_cost(current_skill.get_cost())
	yield(active_battler.act(current_skill), "completed")
	
	match(current_skill.get_function()):
		Enums.SKILL_FUNCTION.ATACK:
			value = BattleManager.get_damage(active_battler, target, current_skill)
		_:
			value = current_skill.get_power()
			
	target.apply(current_skill, value)
	yield(target.hit(current_skill, value), "completed")
	
	next_turn()

func select_bar(select: bool):
	var bar: PlayerBar
	for bar_pos in bar_positions.get_children():
		bar = bar_pos.get_child(0)
		if bar.same_battler(active_battler):
			if select:
				bar.select()
			else:
				bar.deselect()

func _on_queue_changed(_active_battler: Battler):
	yield(get_tree().create_timer(0.5), "timeout")
	
	active_battler = _active_battler
	active_battler.init_turn()
	
	if active_battler.is_party_member():
		active_battler.select()
		action_menu.set_battler(active_battler)
		action_menu.appear()
		select_bar(true)
	else:
		ia.do_something(active_battler) #test for now

func set_positions():
	var bar: PlayerBar
	
	for i in range(3): 
		var spawn = party_positions.get_child(i)
		var battler: Battler = monster_factory.get_random_monster()
		battler.set_stats(RandomStats.get_random_data())
		battler.set_party_member()
		battler.position = spawn.position
		battler.connect("target_selected", self, "_on_target_selected")
		turn_queue.add_child(battler)
		
		bar = PlayerBar.instance()
		bar.set_battler(battler)
		bar_positions.get_child(i).add_child(bar)
		
	for i in range(enemies.size()): 
		var spawn = enemies_positions.get_child(i)
		enemies[i].position = spawn.position
		enemies[i].connect("target_selected", self, "_on_target_selected")
		turn_queue.add_child(enemies[i])

func play_intro():
	for battler in turn_queue.get_party():
		battler.show()
		battler.appear()
	yield(get_tree().create_timer(0.5), "timeout")
	for battler in turn_queue.get_monsters():
		battler.show()
		battler.appear()
	yield(get_tree().create_timer(0.5), "timeout")

func _on_run_clicked():
	Global.back_to_world()
