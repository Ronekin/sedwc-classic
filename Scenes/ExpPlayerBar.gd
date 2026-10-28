extends TextureProgress

func _physics_process(delta):
	value = General.expirience_points
	max_value = 10 * (General.level_points) * 1.5
	$Label.text = "lvl:" + str(int(General.level_points)) + " EXP:" + str(int(General.expirience_points)) + "/" + str(int((10 * General.level_points) * 1.5))
