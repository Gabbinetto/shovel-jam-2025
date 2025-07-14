class_name Player extends CharacterBody2D

const SPEED_TIME_LIMIT: float = 403.0
const ROTATION_TIME_LIMIT: float = 1.5

@export var speed: float = 300.0
@export var turn_speed: float = 0.5
@export var offroad_slowdown: float = 0.7

var offroad: bool = false
var _time_elapsed: float = 0.0
var _rotation_time_elapsed: float = 0.0
var _rotation_slowdown: float = 1.0


func _ready() -> void:
	Globals.player = self


func _physics_process(delta: float) -> void:
	var rotation_input: float = Input.get_action_raw_strength("ui_right") - Input.get_action_raw_strength("ui_left")
	if not Globals.playing:
		rotation_input = 0

	rotation += rotation_input * (turn_speed * (1.0 + exp(min(_rotation_time_elapsed, ROTATION_TIME_LIMIT)))) * delta * (offroad_slowdown if offroad else 1.0)

	_rotation_slowdown = lerpf(_rotation_slowdown, 0.75 if _rotation_time_elapsed > 0 else 1.0, 0.1)
	var time_modifier: float = log(1.0 + minf(3 * _time_elapsed, SPEED_TIME_LIMIT)) / 3 + exp(-_time_elapsed)
	velocity = Vector2.RIGHT.rotated(rotation) * speed * _rotation_slowdown * time_modifier
	if offroad:
		velocity *= offroad_slowdown

	move_and_slide()

	_time_elapsed += delta
	if rotation_input != 0.0:
		_rotation_time_elapsed += delta
	else:
		_rotation_time_elapsed = 0.0


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_SPACE and event.pressed:
		offroad = not offroad
