extends TouchScreenButton

signal quest_activate

func _on_TouchScreenButton_pressed():
	if General.dialog_activate == false and General.is_invent_show == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false:
		yield(get_tree().create_timer(0.1), "timeout")
		connect("quest_activate", get_parent(), "on_quest_activate")
		emit_signal("quest_activate")
		disconnect("quest_activate", get_parent(), "on_quest_activate")
	
func _process(delta):
	if General.quests.size() > 0:
		$Label2.text = str(General.quests.size())
		$Label2.visible = true
	else:
		$Label2.visible = false
