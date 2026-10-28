extends StaticBody2D

func _physics_process(delta):
	if General.time == "day" or General.time == "rassvet":
		$Sprite.frame = 1
		$Lighting.visible = false
	else:
		$Sprite.frame = 0
		$Lighting.visible = true
