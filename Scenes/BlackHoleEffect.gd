extends Particles2D

func _physics_process(delta):
	if emitting == false:
		queue_free()
