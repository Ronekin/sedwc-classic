extends CanvasLayer

func _ready():
	$Control / Eff.visible = false

func start_lines():
	$AnimationPlayer.play("Start")

func end_lines():
	var animation = $AnimationPlayer.get_animation("End")
	animation.track_set_key_value(0, 0, $Control / ColorRect2.rect_position)
	animation.track_set_key_value(1, 0, $Control / ColorRect.rect_position)
	$AnimationPlayer.play("End")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Start":
		$AnimationPlayer.play("Aviable")
