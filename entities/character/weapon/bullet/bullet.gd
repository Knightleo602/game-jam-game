class_name Bullet extends Node2D

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var animation_player: AnimationPlayer = $PlayerBullet/AnimationPlayer
@onready var hitbox_component: HitboxComponent = $HitboxComponent

@export var trail: bool = true
@export var speed: int = 600

var trail_instance: Trail = null

var extra_damage = 0

func _ready() -> void:
	if trail:
		trail_instance = preload("res://entities/effects/trail.tscn").instantiate()
		add_child(trail_instance)
	velocity_component.velocity = Vector2(speed, 0).rotated(rotation)
	hitbox_component.damage += extra_damage

func _physics_process(delta: float) -> void:
	velocity_component.decelerate(delta)
	velocity_component.set_global_position(self )
	

func _on_distance_timeout() -> void:
	queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "remove":
		queue_free()


func _on_hitbox_component_hit_registered(_target: HurtboxComponent) -> void:
	velocity_component.velocity = Vector2.ZERO
	if trail_instance != null:
		trail_instance.stop()
	animation_player.play("remove")