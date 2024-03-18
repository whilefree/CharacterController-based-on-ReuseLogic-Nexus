extends Area3D

@export var TouchedSignal:SignalPickerChild
@export var PickedSignal:SignalPickerChild

@onready var _brain:Brain = $Brain

func _ready():
	if PickedSignal:
		_brain.connect(PickedSignal.signal_name, picked)

func picked(data):
	queue_free()

func _on_body_entered(body):
	_brain.emit_signal(TouchedSignal.signal_name, {"sender_target" : body})
