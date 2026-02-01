class_name Gun extends Node2D

signal ammo_changed(new_ammo: int, max_ammo: int)

@export var bullet_scene: PackedScene = preload("res://entities/character/weapon/bullet/bullet.tscn")
@export var no_ammo_sound: AudioStreamPlayer2D
@export var ammo_capacity: int = 15
@export var reload_time: float = 0.4
@export var fire_rate: float = 0.5

@onready var reload_timer: Timer = $ReloadTimer
@onready var shoot_timer: Timer = $FireRateTimer

var current_ammo: int = ammo_capacity

func _ready() -> void:
	reload_timer.wait_time = reload_time
	shoot_timer.wait_time = fire_rate


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reload"):
		_reload()


func _reload():
	if reload_timer.is_stopped():
		shoot_timer.stop()
		reload_timer.start()


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("shoot") and shoot_timer.is_stopped():
		if not reload_timer.is_stopped():
			return
		if current_ammo == 0:
			if no_ammo_sound != null:
				no_ammo_sound.play()
			else:
				_reload()
			return
		shoot_bullet()
		shoot_timer.start()
	elif Input.is_action_just_released("shoot"):
		shoot_timer.stop()


func not_shooting() -> bool:
	return shoot_timer.is_stopped()


func shoot_bullet() -> void:
	current_ammo -= 1
	ammo_changed.emit(current_ammo, ammo_capacity)
	var mouse_position = get_local_mouse_position()
	var bullet_instance: Bullet = bullet_scene.instantiate()
	bullet_instance.look_at(mouse_position)
	bullet_instance.global_position = global_position
	get_tree().get_root().add_child(bullet_instance)
	bullet_instance.hitbox_component.hit_source = get_parent()
	if current_ammo == 0:
		shoot_timer.stop()


func _on_reload_timer_timeout() -> void:
	current_ammo = ammo_capacity
	ammo_changed.emit(current_ammo, ammo_capacity)
