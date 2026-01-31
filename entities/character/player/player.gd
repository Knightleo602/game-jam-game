extends CharacterBody2D

signal player_died

@onready var velocityComponent: VelocityComponent = $VelocityComponent
@onready var healthComponent: HealthComponent = $HealthComponent


func _physics_process(_delta: float) -> void:
	if not healthComponent.is_dead():
		__movement()
		# __animate_movement()


func __movement():
	var input = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	velocityComponent.accelerate_towards(input)
	velocityComponent.move(self )


func __animate_movement():
	if velocity.x > 0:
		$AnimatedSprite2D.play("walk_right")
	elif velocity.x < 0:
		$AnimatedSprite2D.play("walk_left")
	elif velocity.y > 0:
		$AnimatedSprite2D.play("walk_down")
	elif velocity.y < 0:
		$AnimatedSprite2D.play("walk_up")
	else:
		$AnimatedSprite2D.stop()


func _on_death() -> void:
	player_died.emit()
	$AnimatedSprite2D.play("death")
