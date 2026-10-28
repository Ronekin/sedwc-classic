extends TouchScreenButton

signal invent_activate

func _on_InventoryButton_pressed():
	connect("invent_activate", get_parent(), "on_invent_activate")
	emit_signal("invent_activate")
	disconnect("invent_activate", get_parent(), "on_invent_activate")
