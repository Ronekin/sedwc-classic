extends AnimatedSprite


func _ready():
	frame = 0
	play("default")

func _on_Explosion_animation_finished():
	visible = false
	yield(get_tree().create_timer(0.5), "timeout")
	General.bubble_bey_stop = false
	queue_free()


func _on_AudioStreamPlayer_finished():
	queue_free()
