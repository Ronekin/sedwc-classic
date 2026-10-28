extends Label


func _physics_process(delta):
	if General.fps_show_enabled:
		text = "FPS: " + str(Engine.get_frames_per_second())
		visible = true
	else:
		visible = false
