extends ProgressBar

@export var enemy: Wolf
# Called when the node enters the scene tree for the first time.
func _ready():
	enemy.healthChanged.connect(update)
	update()

func update():
	value = enemy.currentHealth * 100 / enemy.maxHealth
