extends CharacterBody3D
class_name Enemy

signal healthChanged
@export var maxHealth = 30
@onready var currentHealth: int = maxHealth
@onready var wolf_anim = $espirito_02/AnimationPlayer

func _physics_process(delta):
	wolf_anim.play("idle")

func hurt():
	currentHealth -= 3
	if currentHealth < 0:
		currentHealth = maxHealth
	healthChanged.emit()
