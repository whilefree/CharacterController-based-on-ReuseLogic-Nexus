extends MeshInstance3D

@export var toggle_signal:SignalPickerChild
@onready var brain = $Brain as Brain

var opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	brain.register_signal(toggle_signal, toggle)

func toggle(data):
	if opened:
		show()
		opened = false
	else:
		hide()
		opened = true
