extends Node

signal section_added(section: Section)
signal section_removed(section: Section)

var playing: bool = false
var player: Player


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		playing = true
