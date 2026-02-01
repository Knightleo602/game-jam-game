extends Node2D

@onready var path_follow: PathFollow2D = $ObjectLayer/Player/Camera/EnemySpawnPath/PathFollow2D
@onready var spawn_position: Marker2D = $ObjectLayer/Player/Camera/EnemySpawnPath/PathFollow2D/Position2D
@onready var object_layer: Node2D = $ObjectLayer
@onready var camera: Camera = $ObjectLayer/Player/Camera
@onready var player: Player = $ObjectLayer/Player

@export var enemies: Array[PackedScene] = []

@onready var rng = RandomNumberGenerator.new()

func _ready() -> void:
	$GameOverMenu.visible = false
	assert(enemies.size() > 0, "No enemy scenes assigned to MainScene!")
	$FadeTransicions/AnimationPlayer.play("fade_out")
	$Timer.start()

func _on_enemy_spawn_timer_timeout() -> void:
	if player.health_component.is_dead():
		return
	rng.randomize()
	var enemy_index = rng.randi_range(0, enemies.size() - 1)
	var enemy_instance: Node2D = enemies[enemy_index].instantiate()
	path_follow.progress_ratio = rng.randf()
	object_layer.add_child(enemy_instance)
	enemy_instance.global_position = spawn_position.global_position
	enemy_instance.player = player

func _on_player_player_health_changed(new_health: int, old_health: int, _max_health: int) -> void:
	if new_health < old_health:
		camera.shake_camera()

func _on_game_over():
	$GameOverMenu.visible = true

func _on_timer_timeout() -> void:
	get_tree().paused = false
