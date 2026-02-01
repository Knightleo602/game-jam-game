class_name HitboxComponent extends Area2D

signal hit_registered(target: HurtboxComponent)

enum HitStrength {
	WEAK,
	STRONG
}

@export var damage: int = 10
@export var hit_strength: HitStrength = HitStrength.WEAK


func register_hit(target: HurtboxComponent):
	hit_registered.emit(target)
