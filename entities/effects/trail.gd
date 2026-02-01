class_name Trail extends Line2D

const MAX_POINTS: int = 20

@onready var curve: Curve2D = Curve2D.new()

var stopped = false
var should_free = false

var position_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	curve.clear_points()
	points = []


func _process(_delta: float) -> void:
	if stopped:
		if curve.get_point_count() == 0:
			if should_free:
				queue_free()
		else:
			curve.remove_point(0)
	else:
		curve.add_point(get_parent().global_position + position_offset)
		

		if curve.get_point_count() > MAX_POINTS:
			curve.remove_point(0)
	points = curve.get_baked_points()

func stop() -> void:
	stopped = true
	var tweeen: Tween = get_tree().create_tween()
	tweeen.tween_property(self , "modulate:a", 0.0, 0.5).as_relative()
	await tweeen.finished
	should_free = true