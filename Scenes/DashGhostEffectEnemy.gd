extends Sprite

func _ready():
	if General.time_erase:
		$AnimationPlayer.play("IdleTimeErase")
	else:
		$AnimationPlayer.play("Idle")
	$AnimationPlayer.playback_speed *= General.enemy_time_scale
