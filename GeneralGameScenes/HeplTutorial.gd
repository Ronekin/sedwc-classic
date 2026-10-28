extends Control

signal panel_closed

func _on_TouchScreenButton_pressed():
	visible = false
	yield(get_tree().create_timer(0.1), "timeout")
	General.panel_help_tutor_enabled = false
	queue_free()
	
