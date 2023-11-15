extends Control

func _on_jogar_pressed():
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn")

func _on_controles_pressed():
	pass # Replace with function body.

func _on_sair_pressed():
	get_tree().quit()
