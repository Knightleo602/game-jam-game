class_name Camera extends Camera2D

@export var velocity_component: VelocityComponent = VelocityComponent.new()
@export var max_zoom_in: float = 1.5
@export var max_zoom_out: float = 0.4
@export var shake_random_strength: float = 5.0

@onready var rng = RandomNumberGenerator.new()

var shake: float = 0


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("zoom_in"):
		zoom = Vector2.ONE * max(max_zoom_in, zoom.x + 0.1 * delta * 10)
	elif Input.is_action_pressed("zoom_out"):
		zoom = Vector2.ONE * min(max_zoom_out, zoom.x - 0.1 * delta * 10)
	if shake > 0:
		shake = lerpf(shake, 0, velocity_component.friction * delta)
		offset = random_offset()


func shake_camera() -> void:
	shake = shake_random_strength


func random_offset() -> Vector2:
	rng.randomize()
	return Vector2(rng.randf_range(-shake, shake), rng.randf_range(-shake, shake))