class_name Trail extends Line2D

@onready var curve: Curve2D = Curve2D.new()

@export var max_points: int = 20

var stopped = false
var should_free = false


func _ready() -> void:
	curve.clear_points()
	points = []


func _process(_delta: float) -> void:
	add_points()


func add_points():
	if stopped:
		if curve.get_point_count() == 0:
			if should_free:
				queue_free()
		else:
			curve.remove_point(0)
	else:
		var pos = get_parent().global_position
		curve.add_point(pos)

		if curve.get_point_count() > max_points:
			curve.remove_point(0)
	points = curve.get_baked_points()


func stop() -> void:
	stopped = true
	var tweeen: Tween = get_tree().create_tween()
	tweeen.tween_property(self , "modulate:a", 0.0, 0.5).as_relative()
	await tweeen.finished
	should_free = true