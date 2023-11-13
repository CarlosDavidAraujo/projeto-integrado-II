extends Control

@export var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	game_manager.connect("toogle_game_paused", _on_game_manager_toogle_game_paused)

func _on_game_manager_toogle_game_paused(is_paused: bool):
	if is_paused:
		show()
	else:
		hide()

func _on_resume_button_pressed():
	game_manager.game_paused = false

func _on_exit_button_pressed():
	get_tree().quit()

