class_name HurtboxComponent extends Area2D

signal hit_taken(hit_box: HitboxComponent)

@export var health_component: HealthComponent
@export var audio_player: AudioStreamPlayer2D


func _ready() -> void:
	assert(health_component != null, "HealthComponent not assigned in HurtboxComponent")


func can_accept_damage() -> bool:
	return health_component.damageable and not health_component.is_dead()


func take_damage(hit_box: HitboxComponent) -> bool:
	if can_accept_damage():
		if audio_player != null:
			SfxDeconflicter.play(audio_player)
		health_component.take_damage(hit_box.damage)
		hit_taken.emit(hit_box)
		hit_box.register_hit(self )
		return true
	return false


func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		take_damage(area)

func set_activated(activated: bool) -> void:
	monitoring = activated