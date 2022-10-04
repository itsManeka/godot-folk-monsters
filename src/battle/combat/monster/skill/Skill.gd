extends Resource

class_name Skill

var type
var function
var function_stat
var sname: String setget set_name, get_name
var icon_name: String setget set_icon, get_icon
var power: int setget set_power, get_power
var cost: int setget set_cost, get_cost

func set_function_stat(_function_stat):
	function_stat = _function_stat
	
func get_function_stat():
	return function_stat

func set_function(_function):
	function = _function
	
func get_function():
	return function

func set_type(_type):
	type = _type
	
func get_type():
	return type

func set_name(_name: String):
	sname = _name
	
func get_name() -> String:
	return sname

func set_power(_power: int):
	power = _power
	
func get_power() -> int:
	return power

func set_icon(_icon_name: String):
	icon_name = _icon_name

func get_icon() -> String:
	return icon_name

func set_cost(_cost: int):
	cost = _cost
	
func get_cost() -> int:
	return cost
