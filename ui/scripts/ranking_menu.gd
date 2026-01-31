extends Node2D

func _on_quit_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
