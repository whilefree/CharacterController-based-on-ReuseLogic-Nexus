extends CharacterBody3D

@export var _speed = 8.0
@export var _run_speed = 14.0
@export var _jump_velocity = 5.0
@export var _mouse_sensitivity = 0.001

@export_group("Signals")
@export var IsOnFloorSignal:SignalPickerChild
@export var IsFallingSignal:SignalPickerChild
@export var MoveSignal:SignalPickerChild
@export var JumpSignal:SignalPickerChild
@export var VelocityResetSignal:SignalPickerChild
@export var PickedCoinSignal:SignalPickerChild
@export var PickedDiamondSignal:SignalPickerChild

@onready var _brain:Brain = $Brain

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if MoveSignal:
		_brain.connect(MoveSignal.signal_name, move)
	if JumpSignal:
		_brain.connect(JumpSignal.signal_name, jump)
	if VelocityResetSignal:
		_brain.connect(VelocityResetSignal.signal_name, velocity_reset)
	if PickedCoinSignal:
		_brain.connect(PickedCoinSignal.signal_name, pick_coin)
	if PickedDiamondSignal:
		_brain.connect(PickedDiamondSignal.signal_name, pick_diamond)
		
func pick_diamond(data):
	print("Diamond Picked Up!")
	data["receiver"].received(data)

func pick_coin(data):
	print("Coin Picked Up!")
	data["receiver"].received(data)

func velocity_reset(_data):
	velocity.x = 0.0
	velocity.z = 0.0

func move(_data):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if _data["current_state"].name == "Walk":
			velocity.x = direction.x * _speed
			velocity.z = direction.z * _speed
		elif _data["current_state"].name == "Run":
			velocity.x = direction.x * _run_speed
			velocity.z = direction.z * _run_speed

func jump(_data):
	if _data["current_state"].name == "Jump":
		velocity.y = _jump_velocity
	elif _data["current_state"].name == "RunJump":
		velocity.y = _jump_velocity+_jump_velocity/2

func _physics_process(delta):
	if is_on_floor() && IsOnFloorSignal:
		_brain.emit_signal(IsOnFloorSignal.signal_name, {})
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	if velocity.y < 0 && IsFallingSignal:
		_brain.emit_signal(IsFallingSignal.signal_name, {})
	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate(Vector3.UP,-event.relative.x * _mouse_sensitivity)
		#upper limit
		if event.relative.y < 0:
			if rotation.x < deg_to_rad(30):
				rotate(transform.basis.x,-event.relative.y * _mouse_sensitivity)
		#lower limit
		if event.relative.y > 0:
			if rotation.x > deg_to_rad(-30):
				rotate(transform.basis.x,-event.relative.y * _mouse_sensitivity)
