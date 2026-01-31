class_name HurtboxComponent extends Area2D

signal hit_taken(hit_box: HitboxComponent)

@export var health_component: HealthComponent


func _ready() -> void:
	assert(health_component != null, "HealthComponent not assigned in HurtboxComponent")


func _take_damage(hit_box: HitboxComponent) -> bool:
	if can_accept_damage():
		health_component.take_damage(hit_box.damage)
		hit_taken.emit(hit_box)
		return true
	return false


func _on_area_entered(area: Area2D) -> void:
	if area is not HitboxComponent:
		return
	var hitbox = area as HitboxComponent
	_take_damage(hitbox)


func can_accept_damage() -> bool:
	return health_component.damageable and not health_component.is_dead()
