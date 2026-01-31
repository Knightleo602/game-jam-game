class_name VelocityComponent extends Node

@export var max_speed: int = 200
@export var acceleration: int = 8
@export var friction: int = 13

@export var stagger_force_on_weak: float = 150.0
@export var stagger_force_on_strong: float = 250.0

var velocity: Vector2 = Vector2.ZERO


func _get_force(hit_strength: HitboxComponent.HitStrength) -> float:
    return stagger_force_on_weak if hit_strength == HitboxComponent.HitStrength.WEAK else stagger_force_on_strong


func accelerate_towards(direction: Vector2) -> void:
    var weight = acceleration if direction else friction
    velocity = lerp(velocity, direction * max_speed, get_physics_process_delta_time() * weight)
 

func decelerate() -> void:
    accelerate_towards(Vector2.ZERO)


func move(body: CharacterBody2D) -> void:
    body.velocity = velocity
    body.move_and_slide()


func stagger(direction: Vector2, hit_strength: HitboxComponent.HitStrength) -> void:
    velocity = direction.normalized() * _get_force(hit_strength)