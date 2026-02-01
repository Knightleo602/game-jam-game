class_name Enemy extends CharacterBody2D

signal died(exp: int, score_on_death: int)

@export var player: Player
@export var exp_on_death: int = 10
@export var score_on_death: int = 100
@export var random_move_max_distance: float = 100.0
@export var random_move_min_distance: float = 40.0

@onready var movement_component: MovementComponent = $MovementComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var death_despawn_timer: Timer = $DeathDespawnTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var flash_animator: AnimationPlayer = $AnimationPlayer

var random_movement: Vector2 = Vector2.ZERO

func _direction_to_target() -> Vector2:
	if health_component.is_dead() or player == null or player.health_component.is_dead():
		return Vector2.ZERO
	return (player.global_position - global_position).normalized()


func _physics_process(delta: float) -> void:
	var direction = _direction_to_target()
	movement_component.move(self , direction, delta)


func _on_death_despawn_timer_timeout() -> void:
	GameManager.notify_enemy_death(exp_on_death)
	queue_free()


func _on_health_component_died() -> void:
	disable()
	died.emit(exp_on_death, score_on_death)
	death_despawn_timer.start()
	animated_sprite.play("death")

func disable() -> void:
	hurtbox_component.queue_free()
	hitbox_component.queue_free()
	$CollisionShape2D.call_deferred("set_disabled", true)

func _on_hurtbox_component_hit_taken(_hit_box: HitboxComponent) -> void:
	flash_animator.play("flash")
