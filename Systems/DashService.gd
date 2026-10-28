# DashService.gd — рывки игрока, анимации и таймеры.
#
# Контракт: execute() получает GGPlayer и работает с его узлами и таймерами;
# кулдаун и боевые флаги остаются в player/General.

extends Reference


func execute(player, type):
	if General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false:
		if type == "DefaultDash" and player.dash_kuldown.is_stopped():
			var animation_player
			if player.get_tree().current_scene.name != "MorioMap":
				animation_player = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/PlayerFightAnimations")
			else:
				animation_player = player.get_node("/root/" + player.get_tree().current_scene.name + "/SortingY/PlayerFightAnimations")
			var animation_hor = animation_player.get_animation("PlayerDashHor")
			var animation_ver = animation_player.get_animation("PlayerDashVert")
			if player.dash_kuldown.is_connected("timeout", player, "do_this"):
				player.dash_kuldown.disconnect("timeout", player, "do_this")
			player.dash_kuldown.connect("timeout", player, "do_this")
			player.dash_kuldown.wait_time = 3
			player.dash_kuldown.one_shot = true
			player._ensure_child_timer(player.dash_kuldown)
			player.dash_kuldown.start()
			if General.stand_number == 23:
				player.SoundPlay("res://Music/MIHdash.mp3")
				animation_player.playback_speed = 2
			else:
				player.get_node("DASH_SOUND_EFFECT").play("DefaultDash")
				animation_player.playback_speed = 1
			if General.direct == "Left" or General.direct == "Right":
				player.get_node("GhostDashEffect").wait_time = 0.025
				if General.direct == "Left":
						if player.dist_l.x < 175:
							animation_hor.track_set_key_value(0, 0, General.player_pos)
							animation_hor.track_set_key_value(0, 1, Vector2((General.player_pos.x - player.dist_l.x) + 35, General.player_pos.y))
						else:
							animation_hor.track_set_key_value(0, 0, General.player_pos)
							animation_hor.track_set_key_value(0, 1, Vector2(General.player_pos.x - 150, General.player_pos.y))
				else:
						if player.dist_r.x < 175:
							animation_hor.track_set_key_value(0, 0, General.player_pos)
							animation_hor.track_set_key_value(0, 1, Vector2((General.player_pos.x + player.dist_r.x) - 35, General.player_pos.y))
						else:
							animation_hor.track_set_key_value(0, 0, General.player_pos)
							animation_hor.track_set_key_value(0, 1, Vector2(General.player_pos.x + 150, General.player_pos.y))
				animation_player.play("PlayerDashHor")
				player.dash_start_kd()
			if General.direct == "Up" or General.direct == "Down":
				player.get_node("GhostDashEffect").wait_time = 0.05
				if General.direct == "Up":
						if player.dist_t.y < 135:
							animation_ver.track_set_key_value(0, 0, General.player_pos)
							animation_ver.track_set_key_value(0, 1, Vector2(General.player_pos.x, (General.player_pos.y - player.dist_t.y) + 35))
						else:
							animation_ver.track_set_key_value(0, 0, General.player_pos)
							animation_ver.track_set_key_value(0, 1, Vector2(General.player_pos.x, General.player_pos.y - 100))
				else:
						if player.dist_b.y < 135:
							animation_ver.track_set_key_value(0, 0, General.player_pos)
							animation_ver.track_set_key_value(0, 1, Vector2(General.player_pos.x, (General.player_pos.y + player.dist_b.y) - 35))
						else:
							animation_ver.track_set_key_value(0, 0, General.player_pos)
							animation_ver.track_set_key_value(0, 1, Vector2(General.player_pos.x, General.player_pos.y + 100))
				animation_player.play("PlayerDashVert")
				player.dash_start_kd()
			General.dashed = true
			player.get_node("GhostDashEffect").start()
			yield(animation_player, "animation_finished")
			General.dashed = false
			animation_player.playback_speed = 1
		elif type == "AttackDash":
			var animation_player
			if player.get_tree().current_scene.name != "MorioMap":
				animation_player = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/PlayerFightAnimations")
			else:
				animation_player = player.get_node("/root/" + player.get_tree().current_scene.name + "/SortingY/PlayerFightAnimations")
			var animation_hor = animation_player.get_animation("PlayerDashAttack")
			if General.player_direct == "left":
					if player.dist_l.x < 40:
						animation_hor.track_set_key_value(0, 0, General.player_pos)
						animation_hor.track_set_key_value(0, 1, Vector2((General.player_pos.x - player.dist_l.x) + 35, General.player_pos.y))
					else:
						animation_hor.track_set_key_value(0, 0, General.player_pos)
						animation_hor.track_set_key_value(0, 1, Vector2(General.player_pos.x - 5, General.player_pos.y))
			else:
					if player.dist_r.x < 40:
						animation_hor.track_set_key_value(0, 0, General.player_pos)
						animation_hor.track_set_key_value(0, 1, Vector2((General.player_pos.x + player.dist_r.x) - 35, General.player_pos.y))
					else:
						animation_hor.track_set_key_value(0, 0, General.player_pos)
						animation_hor.track_set_key_value(0, 1, Vector2(General.player_pos.x + 5, General.player_pos.y))
			animation_player.play("PlayerDashAttack")
			player.get_node("YSort/Animations").stop(true)
			player.get_node("YSort/Animations").play("Attack")
			General.dashed = true
			General.player_attack_activate = true
			General.count_attacks += 1
			General.default_attack_count += 1
		elif type == "TSDash":
			var animation_effect
			if player.get_tree().current_scene.name != "MorioMap":
				animation_effect = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/GeneralEffectAnimaion")
			else:
				animation_effect = player.get_node("/root/" + player.get_tree().current_scene.name + "/SortingY/GeneralEffectAnimaion")
			var red_effect = preload("res://Scenes/RedScreenVFX.tscn")
			if General.stand_number == 1 or General.stand_number == 2 or General.stand_number == 14 or General.stand_number == 16 or General.stand_number == 15:
				animation_effect.play("RESET")
				animation_effect.play("TheWorldDash")
				player.get_node("DASH_SOUND_EFFECT").play("TC_Dash")
				
			elif General.stand_number == 8:
				var red_effect_inst = red_effect.instance()
				player.get_parent().get_parent().add_child(red_effect_inst)
				yield(player.get_tree().create_timer(0.05), "timeout")
				player.get_node("DASH_SOUND_EFFECT").play("TE_Dash")
			if General.direct == "Left":
				if player.dist_l.x < 175:
					player.global_position.x = (player.global_position.x - player.dist_l.x) + 35
				else:
					player.global_position.x -= 150
			elif General.direct == "Right":
				if player.dist_r.x < 175:
					player.global_position.x = (player.global_position.x + player.dist_r.x) - 35
				else:
					player.global_position.x += 150
			elif General.direct == "Down":
				if player.dist_b.y < 175:
					player.global_position.y = (player.global_position.y + player.dist_b.y) - 35
				else:
					player.global_position.y += 150
			elif General.direct == "Up":
				if player.dist_t.y < 175:
					player.global_position.y = (player.global_position.y - player.dist_t.y) + 35
				else:
					player.global_position.y -= 150
			player.dash_start_kd()
		elif type == "AttackBigDash":
			var animation_player
			if player.get_tree().current_scene.name != "MorioMap":
				animation_player = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/PlayerFightAnimations")
			else:
				animation_player = player.get_node("/root/" + player.get_tree().current_scene.name + "/SortingY/PlayerFightAnimations")
			var animation_hor = animation_player.get_animation("PlayerDashAttack")
			if General.player_direct == "left":
					if player.dist_l.x < 70:
						animation_hor.track_set_key_value(0, 0, General.player_pos)
						animation_hor.track_set_key_value(0, 1, Vector2((General.player_pos.x - player.dist_l.x) + 35, General.player_pos.y))
					else:
						animation_hor.track_set_key_value(0, 0, General.player_pos)
						animation_hor.track_set_key_value(0, 1, Vector2(General.player_pos.x - 35, General.player_pos.y))
			else:
					if player.dist_r.x < 70:
						animation_hor.track_set_key_value(0, 0, General.player_pos)
						animation_hor.track_set_key_value(0, 1, Vector2((General.player_pos.x + player.dist_r.x) - 35, General.player_pos.y))
					else:
						animation_hor.track_set_key_value(0, 0, General.player_pos)
						animation_hor.track_set_key_value(0, 1, Vector2(General.player_pos.x + 35, General.player_pos.y))
			animation_player.play("PlayerDashAttack")
			if General.stand_activated == false:
				player.get_node("YSort/Animations").play("AttackBig")
			else:
				if General.stand_number != 4 and General.stand_number != 5 and General.stand_number != 9 and General.stand_number != 11:
					player.get_node("YSort/Animations").play("AttackBig")
				else:
					player.get_node("YSort/Animations").play("AttackBigSpin")
			General.dashed = true
			General.player_attack_activate = true
			General.count_attacks += 1
			General.default_attack_count += 1
			player.start_kd_default_attack(true)
			yield(animation_player, "animation_finished")
			General.dashed = false
			General.player_attack_activate = false
	if General.attacked == false and General.blocked == false and General.dashed == false:
		if type == "MiniDash":
			var animation_player
			if player.get_tree().current_scene.name != "MorioMap":
				animation_player = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/PlayerFightAnimations")
			else:
				animation_player = player.get_node("/root/" + player.get_tree().current_scene.name + "/SortingY/PlayerFightAnimations")
			var animation_hor = animation_player.get_animation("PlayerDashAttack")
			if General.player_direct == "left":
					if player.dist_l.x < 40:
						animation_hor.track_set_key_value(0, 0, General.player_pos)
						animation_hor.track_set_key_value(0, 1, Vector2((General.player_pos.x - player.dist_l.x) + 35, General.player_pos.y))
					else:
						animation_hor.track_set_key_value(0, 0, General.player_pos)
						animation_hor.track_set_key_value(0, 1, Vector2(General.player_pos.x - 5, General.player_pos.y))
			else:
					if player.dist_r.x < 40:
						animation_hor.track_set_key_value(0, 0, General.player_pos)
						animation_hor.track_set_key_value(0, 1, Vector2((General.player_pos.x + player.dist_r.x) - 35, General.player_pos.y))
					else:
						animation_hor.track_set_key_value(0, 0, General.player_pos)
						animation_hor.track_set_key_value(0, 1, Vector2(General.player_pos.x + 5, General.player_pos.y))
			animation_player.play("PlayerDashAttack")
			General.dashed = true
			General.count_attacks += 1
			yield(animation_player, "animation_finished")
			General.dashed = false
