extends Node2D

@onready var attack_timer: Timer = $AttackTimer
@onready var invert_direction_timer: Timer = $InvertDirectionTimer
@export var sword_trail: PackedScene = preload("res://entities/effects/sword_trail.tscn")

var trail: Node2D
var attacking: bool = false
var invert_direction: bool = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("sword_attack") and not attacking:
		var mouse_pos = get_global_mouse_position()
		var cardinal_direction = _get_cardinal_direction(mouse_pos)
		rotation = cardinal_direction.angle()
		attacking = true
		_create_trail(cardinal_direction)
		attack_timer.start()


func _get_cardinal_direction(mouse_pos: Vector2) -> Vector2:
	var direction = mouse_pos - global_position
	if abs(direction.x) > abs(direction.y):
		return Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	else:
		return Vector2.DOWN if direction.y > 0 else Vector2.UP


func _create_trail(direction: Vector2) -> void:
	trail = sword_trail.instantiate()
	add_child(trail)
	if direction == Vector2.LEFT:
		trail.position = Vector2(30, 0)
	elif direction == Vector2.UP:
		trail.position = Vector2(30, -20)
	elif direction == Vector2.DOWN:
		trail.position = Vector2(30, 20)
	if invert_direction:
		trail.scale.y *= -1


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		attacking = false
		trail.stop()
		trail = null


func _on_attack_timer_timeout() -> void:
	attacking = false
	trail.queue_free()
	trail = null
	invert_direction = not invert_direction
	invert_direction_timer.start()


func _on_invert_direction_timer_timeout() -> void:
	invert_direction = false
