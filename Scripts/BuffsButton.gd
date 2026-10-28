extends TouchScreenButton

signal buffs_activate

func _on_TouchScreenButton_pressed():
	if General.dialog_activate == false and General.is_invent_show == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false:
		yield(get_tree().create_timer(0.1), "timeout")
		connect("buffs_activate", get_parent(), "on_buffs_activate")
		emit_signal("buffs_activate")
		disconnect("buffs_activate", get_parent(), "on_buffs_activate")
	
