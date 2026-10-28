extends AnimationPlayer

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	if General.day_night_animation_second != null:
		seek(General.day_night_animation_second)

func _on_AnimationPlayer_tree_exited():
	General.day_night_animation_second = get_current_animation_position()
	General.save_save()
