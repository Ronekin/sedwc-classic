extends GridContainer
signal ButtonTruePressed

func on_button_will_pressed():
	connect("ButtonTruePressed", get_parent().get_parent(), "button_finally_pressed")
	emit_signal("ButtonTruePressed")
