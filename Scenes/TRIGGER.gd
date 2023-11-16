extends Node

@onready var song = $Song
@onready var enemy = $"../Wolf"

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		song.play()
		enemy.start()
