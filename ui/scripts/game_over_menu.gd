extends Node2D

var button_type = null

func _ready() -> void:
	$CanvasLayer.visible = false

func _on_start_button_button_down() -> void:
	button_type = "start"
	fade_transicion()

func _on_quit_button_down() -> void:
	button_type = "quit"
	fade_transicion()
	
func fade_transicion() -> void:
	get_tree().paused = false
	$CanvasLayer.visible = false
	$FadeTransicions.show()
	$FadeTransicions/FadeTimer.start()
	$FadeTransicions/AnimationPlayer.play("fade_in")

func _on_fade_timer_timeout() -> void:
	match button_type:
		"start":
			get_tree().change_scene_to_file("res://stages/main_scene.tscn")
		"quit":
			get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _on_player_player_died() -> void:
	get_tree().paused = true
	$CanvasLayer.visible = true
	$AudioStreamPlayer.play()
