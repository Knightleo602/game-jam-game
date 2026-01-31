class_name VelocityComponent extends Node

@export var max_speed: int = 200
@export var acceleration: int = 8
@export var friction: int = 13

var velocity: Vector2 = Vector2.ZERO

func accelerate_towards(direction: Vector2) -> void:
    var weight = acceleration if direction else friction
    velocity = lerp(velocity, direction * max_speed, get_physics_process_delta_time() * weight)
 
func decelerate() -> void:
    accelerate_towards(Vector2.ZERO)

func move(body: CharacterBody2D) -> void:
    body.velocity = velocity
    body.move_and_slide()