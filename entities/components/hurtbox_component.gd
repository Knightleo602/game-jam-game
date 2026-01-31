class_name HurtboxComponent extends Area2D

@export var health_component: HealthComponent


func _ready() -> void:
	assert(health_component != null, "HealthComponent not assigned in HurtboxComponent")


func can_accept_damage() -> bool:
	return health_component.damageable and not health_component.is_dead()
