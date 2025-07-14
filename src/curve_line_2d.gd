@tool
class_name CurveLine2D extends Line2D


@export var curve: Curve2D
@export_range(1, 100) var precision: int = 8
@export_tool_button("Bake points") var bake_points_button: Callable = func(): bake()


func bake() -> void:
	clear_points()
	
	if not curve:
		return
	
	var points: PackedVector2Array = curve.get_baked_points()
	for i: int in range(0, points.size(), precision):
		add_point(points[i])
	
	if points.size() % precision != 0:
		add_point(points[-1])
	
