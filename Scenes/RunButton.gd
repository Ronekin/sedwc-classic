extends TouchScreenButton

var is_pressed = false

func _physics_process(delta):
	if is_pressed:
		modulate = Color("868686")
	else:
		modulate = Color("ffffff")
	
	if General.run_activate == false:
		$Node2D / ColorRect.visible = false
		$Node2D / ColorRect2.visible = true
	else:
		$Node2D / ColorRect.visible = true
		$Node2D / ColorRect2.visible = false

func _on_RunButton_pressed():
	is_pressed = true
	if General.run_activate:
		General.run_activate = false
	else:
		General.run_activate = true

func _on_RunButton_released():
	is_pressed = false
