class_name Game extends Node2D

const BG_TILE: Vector2i = Vector2i(0, 1)

@export var bg_tilemap: TileMapLayer


func _ready() -> void:
	Globals.section_added.connect(_on_section_added.call_deferred)
	#Globals.section_removed.connect(_on_section_removed.call_deferred)


func _on_section_added(section: Section) -> void:
	var rect: Rect2 = section.calculate_rect()
	var size: Vector2i = bg_tilemap.tile_set.tile_size
	
	rect = rect.grow(size.x * 16)
	
	for x: int in range(0, rect.size.x, size.x):
		for y: int in range(0, rect.size.y, size.y):
			bg_tilemap.set_cell(
				bg_tilemap.local_to_map(bg_tilemap.to_local(rect.position + Vector2(x, y))),
				1, BG_TILE
			)


func _on_section_removed(section: Section) -> void:
	var rect: Rect2 = section.calculate_rect()
	var size: Vector2i = bg_tilemap.tile_set.tile_size

	rect = rect.grow_individual(
		size.x * 16,
		size.x * 16,
		0,
		size.x * 16,
	)

	for x: int in range(0, rect.size.x, size.x):
		for y: int in range(0, rect.size.y, size.y):
			bg_tilemap.set_cell(
				bg_tilemap.local_to_map(bg_tilemap.to_local(rect.position + Vector2(x, y))),
			)
