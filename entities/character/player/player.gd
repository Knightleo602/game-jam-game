class_name Player extends CharacterBody2D

signal player_died
signal player_health_changed(new_health: int, old_health: int, max_health: int)

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var movement_component: MovementComponent = $MovementComponent

func _get_input() -> Vector2:
	if health_component.is_dead():
		return Vector2.ZERO
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()


func _physics_process(delta: float) -> void:
	var input = _get_input()
	movement_component.move(self , input, delta)


func _process(_delta: float) -> void:
	if health_component.is_dead():
		return
	movement_component.animate_movement()


func _on_death() -> void:
	player_died.emit()
	print("Player has died.")
	$AnimatedSprite2D.play("death")


func _on_health_changed(new_health: int, old_health: int) -> void:
	player_health_changed.emit(new_health, old_health, health_component.max_health)
