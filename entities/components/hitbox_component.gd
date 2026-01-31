class_name HitboxComponent extends Area2D

enum HitStrength {
	WEAK,
	STRONG
}

@export var damage: int = 10
@export var hit_strength: HitStrength = HitStrength.WEAK