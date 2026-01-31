class_name KnockbackComponent extends Node

enum KnockbackStrength {
	WEAK,
	STRONG
}

@export var velocity_component: VelocityComponent

@export_group("Weak Knockback Settings")
@export var force_on_weak: int = 5
@export var duration_on_weak: float = 0.2

@export_group("Strong Knockback Settings")
@export var force_on_strong: int = 5
@export var duration_on_strong: float = 0.4


var _knockback_vector: Vector2 = Vector2.ZERO
var _knockback_timer: float = 0.0

func _ready() -> void:
	assert(velocity_component != null, "VelocityComponent not assigned in KnockbackComponent")

func knockback(direction: Vector2, hit_strength: KnockbackStrength) -> void:
	var force: int
	if hit_strength == KnockbackStrength.WEAK:
		force = force_on_weak
		_knockback_timer = duration_on_weak
	else:
		force = force_on_strong
		_knockback_timer = duration_on_strong
	_knockback_vector = direction * force

func is_knockback_ative() -> bool:
	return _knockback_timer > 0.0

func move_knockback(target: CharacterBody2D, delta: float = get_physics_process_delta_time()) -> void:
	_knockback_timer -= delta
	velocity_component.accelerate_towards(_knockback_vector, delta)
	velocity_component.move(target)
	if _knockback_timer <= 0.0:
		_knockback_vector = Vector2.ZERO

func get_velocity() -> Vector2:
	return velocity_component.velocity
