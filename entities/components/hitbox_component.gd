class_name HitboxComponent extends Area2D

signal hit_registered(target: HurtboxComponent)

@export var hit_source: Node2D = self
@export var damage: int = 10
@export var hit_strength: KnockbackComponent.KnockbackStrength = KnockbackComponent.KnockbackStrength.WEAK

func register_hit(target: HurtboxComponent):
	hit_registered.emit(target)

func set_activated(activated: bool) -> void:
	monitorable = activated