extends Sprite

func _physics_process(delta):
	if General.global_buffs["johny_awakeng"] == false:
		queue_free()
