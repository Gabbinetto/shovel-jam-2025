extends Section


const MENU_SECTION: PackedScene = preload("res://src/menu_section.tscn")


static func get_random_section() -> Section:
	if not Globals.playing:
		return MENU_SECTION.instantiate()
	else:
		return super()
