extends CanvasLayer

func _physics_process(delta):
	if General.epitafia_enabled == false and $AnimationPlayer.current_animation != "End":
		$AnimationPlayer.play("End")
		$AudioStreamPlayer2.play()
		yield($AnimationPlayer, "animation_finished")
		queue_free()
