extends ColorRect

func _ready():
	if General.block_damage == 1:
		$AnimationPlayer.play("Idle")
	elif General.block_damage == 2:
		$AnimationPlayer.play("Idle3")
	elif General.block_damage == 3:
		$AnimationPlayer.play("Idle2")
	elif General.block_damage == 4:
		$AnimationPlayer.play("Idle4")
