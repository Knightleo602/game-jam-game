class_name HealthComponent extends Node

signal health_changed(new_health: int, old_health: int)
signal died

@export var health: int = 100
@export var max_health: int = 100
@export var defense: int = 0
@export var damageable: bool = true

func __subtract_damage(amount: int) -> int:
	var effective_damage = max(amount - defense, 0)
	return effective_damage

func take_damage(amount: int) -> void:
	if not damageable:
		return
	var new_health = max(health - __subtract_damage(amount), 0)
	health_changed.emit(new_health, health)
	health = new_health
	if health == 0:
		died.emit()

func heal(amount: int) -> void:
	if health == max_health:
		return
	var new_health = min(health + amount, max_health)
	health_changed.emit(new_health, health)
	health = new_health

func is_dead() -> bool:
	return health <= 0