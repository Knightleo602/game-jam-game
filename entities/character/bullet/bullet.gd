class_name Bullet extends Node2D

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var animation_player: AnimationPlayer = $PlayerBullet/AnimationPlayer

@export var speed: int = 600

func _ready() -> void:
	velocity_component.velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta: float) -> void:
	velocity_component.decelerate(delta)
	velocity_component.set_global_position(self )
	

func _on_distance_timeout() -> void:
	queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "remove":
		queue_free()


func _on_hitbox_component_hit_registered(_target: HurtboxComponent) -> void:
	animation_player.play("remove")
