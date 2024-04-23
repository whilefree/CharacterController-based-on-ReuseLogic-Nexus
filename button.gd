extends Area3D

@export var pressed_signal:SignalPickerChild
@onready var brain = $Brain as Brain

@export var node_array:Array[Node]

func _on_body_entered(body):
	for item in node_array:
		if is_instance_valid(item):
			brain.emit_signal(pressed_signal.signal_name, {"sender_target" : item})
