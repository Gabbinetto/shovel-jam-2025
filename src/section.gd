class_name Section extends Node2D

const SECTIONS: String = "res://src/sections/"

@export var road: Line2D
@export var path: Path2D
@export var follow: PathFollow2D
@export var visibility: Area2D
@export var end_point: Node2D
@export var bounding_box: Node2D

var previous_section: Section
var player: Player

var _local_player_position: Vector2
var _closest_point_to_player: Vector2
var _spawned: bool = false

func _ready() -> void:
	visibility.body_entered.connect(_on_entered)
	visibility.body_exited.connect(_on_exited)

	Globals.section_added.emit.call_deferred(self)


func _on_entered(body: PhysicsBody2D) -> void:
	if not body is Player:
		return
	player = body
	
	if _spawned:
		return
	
	_spawned = true
	
	var section: Section = get_random_section()
	section.name += "_"
	add_sibling.call_deferred(section)
	section.global_position = end_point.global_position
	section.global_rotation = end_point.global_rotation
	section.previous_section = self


func _on_exited(body: PhysicsBody2D) -> void:
	if not body is Player:
		return
	player = null
	
	if not is_instance_valid(previous_section):
		return
	Globals.section_removed.emit(previous_section)
	previous_section.queue_free()


func _physics_process(delta: float) -> void:
	if not player:
		return
	
	_local_player_position = to_local(player.global_position)

	player.offroad = is_on_road(_local_player_position)


func is_on_road(point: Vector2) -> bool:
	var closest_point: Vector2 = path.curve.get_closest_point(point)
	return closest_point.distance_to(point) > (road.width / 2.0)


func calculate_rect() -> Rect2:
	var r_position: Vector2 = Vector2.ZERO
	var r_size: Vector2 = Vector2.ZERO
	
	for child: Node2D in bounding_box.get_children():
		r_position = Vector2(
			minf(r_position.x, child.global_position.x),
			minf(r_position.y, child.global_position.y),
		)
		r_size = Vector2(
			maxf(r_size.x, child.global_position.x),
			maxf(r_size.y, child.global_position.y),
		)
	r_size = r_size - r_position
	
	return Rect2(r_position, r_size)


static func get_random_section() -> Section:
	var files: Array = Array(DirAccess.get_files_at(SECTIONS))
	return load(SECTIONS + files.pick_random()).instantiate()
