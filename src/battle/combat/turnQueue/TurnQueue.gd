extends YSort

class_name TurnQueue

signal queue_changed

onready var active_battler: Battler

func initialize():
	sort_queue()
	active_battler = get_child(0)
	emit_signal("queue_changed", active_battler)

func next_battler():
	var next_battler_index: int = ((active_battler.get_index() + 1) % get_child_count())
	active_battler = get_child(next_battler_index)
	emit_signal("queue_changed", active_battler)

func sort_queue():
	var battlers = get_battlers()
	battlers.sort_custom(self, 'sort_battlers')
	for battler in battlers:
		battler.raise()

func get_battlers():
	return get_children()

static func sort_battlers(a: Battler, b: Battler) -> bool:
	return a.get_stats().get_spd() > b.get_stats().get_spd()

func get_party():
	return _get_targets(true)
	
func get_monsters():
	return _get_targets(false)

func _get_targets(is_party_member: bool = false) -> Array:
	var targets: Array = []
	for child in get_children():
		if child.is_party_member() == is_party_member:
			targets.append(child)
	return targets
