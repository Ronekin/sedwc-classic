extends TouchScreenButton

signal item_activate

func _on_TextureButton2_pressed():
	var player
	if get_tree().current_scene.name != "MorioMap":
				player = get_node("/root/" + get_tree().current_scene.name + "/YSorting/GGPlayer")
				if player == null:
					player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
	elif get_tree().current_scene.name == "MorioMap":
		player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
	connect("item_activate", player, "on_item_activate")
	emit_signal("item_activate")
	disconnect("item_activate", player, "on_item_activate")

