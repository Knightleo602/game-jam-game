extends Node2D

var button_type = null

func _on_start_button_button_down() -> void:
	button_type = "start"
	fade_transicion()

func _on_ranking_button_down() -> void:
	button_type = "ranking"

func fade_transicion() -> void:
	$FadeTransicions.show()
	$FadeTransicions/FadeTimer.start()
	$FadeTransicions/AnimationPlayer.play("fade_in")

func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_fade_timer_timeout() -> void:
	match button_type:
		"start":
			get_tree().change_scene_to_file("res://stages/main_scene.tscn")
		"ranking":
			get_tree().change_scene_to_file("res://ui/ranking_menu.tscn")
