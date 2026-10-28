extends Sprite

func _physics_process(delta):
	if General.epitafia_enabled == false:
		queue_free()
	if General.player_attack_activate:
		visible = false
	else:
		visible = true
