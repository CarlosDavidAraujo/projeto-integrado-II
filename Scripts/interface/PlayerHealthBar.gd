extends TextureProgressBar

@export var player: Player
@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	value = player.current_health
	player.HealthChanged.connect(update)
	update()

func update():
	value = player.current_health
	label.text = str(player.current_health) + "/" + str(player.max_health)

