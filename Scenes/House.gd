extends StaticBody2D

func _physics_process(delta):
	if General.time == "day" or General.time == "rassvet":
		$Sprite.frame = 0
		$Node2D.visible = false
	else:
		$Sprite.frame = 1
		$Node2D.visible = true

