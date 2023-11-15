extends TextureProgressBar

@export var wolf: Wolf
@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	value = wolf.currentHealth
	wolf.healthChanged.connect(update)
	update()

func update():
	value = wolf.currentHealth
	label.text = str(wolf.currentHealth) + "/" + str(wolf.maxHealth)
