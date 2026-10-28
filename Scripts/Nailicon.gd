extends Panel

func _physics_process(delta):
	$Sprite.frame = General.nail_count[int(name.substr(4)) - 1]
