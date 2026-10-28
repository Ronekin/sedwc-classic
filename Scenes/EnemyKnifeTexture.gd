extends Sprite



func _ready():
	if General.enemy_direct == "Left":
		scale.x = - 1
	else:
		scale.x = 1
