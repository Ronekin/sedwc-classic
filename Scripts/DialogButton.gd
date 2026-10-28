extends TouchScreenButton

signal dialog

func _on_TextureButton_pressed():
	var player
	if get_tree().current_scene.name != "MorioMap":
				player = get_node("/root/" + get_tree().current_scene.name + "/YSorting/GGPlayer")
				if player == null:
					player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
	elif get_tree().current_scene.name == "MorioMap":
		player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
	connect("dialog", player, "on_dialog_activate")
	emit_signal("dialog")
	disconnect("dialog", player, "on_dialog_activate")

