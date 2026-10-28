extends TouchScreenButton

signal stand_activate

func _on_TextureButton_pressed():
	var player
	if get_tree().current_scene.name != "MorioMap":
				player = get_node("/root/" + get_tree().current_scene.name + "/YSorting/GGPlayer")
				if player == null:
					player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
	elif get_tree().current_scene.name == "MorioMap":
		player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
	if General.debuff_enemy != "HgZahvat":
		connect("stand_activate", player, "on_stand_activate")
		emit_signal("stand_activate")
		disconnect("stand_activate", player, "on_stand_activate")
	else:
		pass
