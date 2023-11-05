extends ProgressBar

@export var player: Player
# Called when the node enters the scene tree for the first time.
func _ready():
	player.HealthChanged.connect(update)
	update()

func update():
	value = player.current_health * 100 / player.max_health
