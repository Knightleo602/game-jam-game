class_name EnemyBloodTrail extends Node2D

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var trail_line: Trail = $EnemyBloodTrail

@export var target: Node2D


func _physics_process(delta: float) -> void:
	var direction: Vector2 = _direction_to_target()
	velocity_component.accelerate_towards(direction, delta)
	velocity_component.set_global_position(self )
	trail_line.global_position = global_position


func _direction_to_target() -> Vector2:
	if target == null or trail_line.stopped:
		return Vector2.ZERO
	return (target.global_position - global_position).normalized()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	trail_line.stop()


func _on_enemy_blood_trail_tree_exited() -> void:
	queue_free()
