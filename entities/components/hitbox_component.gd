class_name HitboxComponent extends Area2D

signal damage_dealt(hurtbox_component: HurtboxComponent, damage: int)

@export var damage: int = 10

func _on_body_entered(body: Node2D) -> void:
	if body is HurtboxComponent:
		var hurtbox = body as HurtboxComponent
		if hurtbox.can_accept_damage():
			damage_dealt.emit(hurtbox, damage)
