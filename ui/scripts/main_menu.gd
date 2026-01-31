extends Node2D

func _on_start_button_button_down() -> void:
	get_tree().change_scene_to_file("res://stages/main_scene.tscn")

func _on_options_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/option_menu.tscn")

func _on_ranking_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/ranking_menu.tscn")

func _on_quit_button_down() -> void:
	get_tree().quit()
