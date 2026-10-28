extends AnimationPlayer

func _physics_process(delta):
	if General.dialog_activate == false and General.is_invent_show == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false and General.player_attack_activate == false and General.blocked == false and General.attacked == false:
		if General.run_activate and current_animation.find("Run") == - 1 and General.velocity_player != Vector2.ZERO:
			var animation = get_animation("RunStart")
			animation.track_set_key_value(0, 0, General.camera_scale)
			animation.track_set_key_value(0, 1, General.camera_scale + Vector2(0.2, 0.2))
			play("RunStart")
		
		if General.run_activate and current_animation.find("Run") != - 1 and General.velocity_player == Vector2.ZERO:
			if current_animation == "RunStart":
				yield(self, "animation_finished")
			var animation = get_animation("RunEnd")
			animation.track_set_key_value(0, 0, General.camera_scale + Vector2(0.2, 0.2))
			animation.track_set_key_value(0, 1, General.camera_scale)
			play("RunEnd")
		
		if General.run_activate == false and current_animation.find("Run") != - 1:
			if current_animation == "RunStart":
				yield(self, "animation_finished")
			var animation = get_animation("RunEnd")
			animation.track_set_key_value(0, 0, General.camera_scale + Vector2(0.2, 0.2))
			animation.track_set_key_value(0, 1, General.camera_scale)
			play("RunEnd")


func _on_AllAnimation_animation_finished(anim_name):
	if anim_name == "RunStart":
		var animation = get_animation("RunIdle")
		animation.track_set_key_value(0, 0, General.camera_scale + Vector2(0.2, 0.2))
		play("RunIdle")
