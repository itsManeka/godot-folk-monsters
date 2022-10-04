extends Control

class_name SelectionRect

signal selected
signal unselected
signal clicked

func on_mouse_in():
	emit_signal("selected")
	
func on_mouse_out():
	emit_signal("unselected")

func on_gui_input(event: InputEvent):
	if event.is_action("mouse_click"):
		emit_signal("clicked")
