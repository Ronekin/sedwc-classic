extends TextureProgress

func _physics_process(delta):
	value = General.heart_points
	max_value = General.hp_max
	$value.text = "Текущее хп:" + str(stepify(General.heart_points, 0.1))
