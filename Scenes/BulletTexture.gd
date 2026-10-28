extends Sprite

onready var random = RandomNumberGenerator.new()

func _ready():



	if General.player_direct == "right":
		scale.x = - 1
	else:
		scale.x = 1
