extends Control

func button_finally_pressed():
	if $AnimationPlayer.current_animation == "":
		General.is_invent_show = false
		visible = false
		

func _on_GUI_inventory_will_activate():
	if visible == false and General.dialog_activate == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false and General.attacked == false and General.dashed == false:
		General.is_invent_show = true
		visible = true
		
	elif visible == true and General.dialog_activate == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false and General.attacked == false and General.dashed == false:
		
		
		General.is_invent_show = false
		visible = false
		
