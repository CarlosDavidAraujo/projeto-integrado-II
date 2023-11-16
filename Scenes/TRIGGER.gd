extends Node

@onready var song = $Song
@onready var enemy = $"../Wolf"

var a = true

func _on_area_3d_body_exited(body):
	if body.is_in_group("player") && a:
		a = false
		song.play()
		enemy.start()
