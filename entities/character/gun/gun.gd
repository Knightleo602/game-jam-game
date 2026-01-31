class_name Gun extends Node2D

@export var bullet_scene: PackedScene = preload("res://entities/character/bullet/bullet.tscn")
@onready var shoot_timer: Timer = $FireRateTimer

@export var fire_rate: float = 0.5

var can_shoot: bool = true

func _ready() -> void:
	shoot_timer.wait_time = fire_rate


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		print("Shooting")
		shoot_bullet()
		shoot_timer.start()
	elif Input.is_action_just_released("shoot"):
		print("Stopped Shooting")
		shoot_timer.stop()


func not_shooting() -> bool:
	return shoot_timer.is_stopped()


func shoot_bullet() -> void:
	var mouse_position = get_global_mouse_position()
	var bullet_instance: Bullet = bullet_scene.instantiate()
	bullet_instance.global_position = global_position
	bullet_instance.look_at(mouse_position)
	get_tree().get_root().add_child(bullet_instance)

func _on_single_press_recover_timer_timeout() -> void:
	pass # Replace with function body.
