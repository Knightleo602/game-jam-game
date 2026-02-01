class_name VelocityComponent extends Node

@export var max_speed: int = 200
@export var acceleration: float = 8.0
@export var friction: float = 13.0

var velocity: Vector2 = Vector2.ZERO


func accelerate_towards(direction: Vector2, delta: float = get_physics_process_delta_time()) -> void:
    var weight = acceleration if direction else friction
    velocity = lerp(velocity, direction * max_speed, delta * weight)
 

func decelerate(delta: float = get_physics_process_delta_time()) -> void:
    accelerate_towards(Vector2.ZERO, delta)


func move(body: CharacterBody2D) -> void:
    body.velocity = velocity

func set_global_position(body: Node2D) -> void:
    body.global_position += velocity