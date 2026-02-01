extends CharacterBody2D

signal died

@export var player: Player
@onready var movement_component: MovementComponent = $MovementComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var death_despawn_timer: Timer = $DeathDespawnTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _direction_to_target() -> Vector2:
	if player == null || health_component.is_dead():
		return Vector2.ZERO
	return (player.global_position - global_position).normalized()


func _physics_process(delta: float) -> void:
	var direction = _direction_to_target()
	movement_component.move(self , direction, delta)


func _on_death_despawn_timer_timeout() -> void:
	queue_free()


func _on_health_component_died() -> void:
	disable()
	died.emit()
	death_despawn_timer.start()
	$CollisionShape2D.call_deferred("set_disabled", true)
	animated_sprite.play("death")

func disable() -> void:
	hitbox_component.set_activated(false)
	$CollisionShape2D.call_deferred("set_disabled", true)
	death_despawn_timer.start()