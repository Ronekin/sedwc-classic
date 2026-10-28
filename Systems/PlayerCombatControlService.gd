# PlayerCombatControlService.gd — ввод, кулдауны и переключение боевых действий.
#
# Контракт: получает GGPlayer, работает с его узлами/сигналами и вызывает
# AttackService/BulletAttackService. Кулдауны остаются на player.

extends Reference


func on_attack_activate(player):
	if General.stand_index != "None" and General.stand_index != "EhosAct0" and General.dialog_activate == false and General.is_invent_show == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false and General.attacked == false and General.dashed == false and General.blocked == false and General.stand_activated and player.stand_activate_activated == false:
		if General.dostup_combo:
			player.start_kd_default_attack(false)
			if (General.stand_index in ["EhosAct1"]):
				player.stand_attack_anim("NailTusk")
				General.count_attacks += 1
				General.default_attack_count += 1
			elif not (General.stand_index in ["TuskAct1", "TuskAct2", "TuskAct3", "TuskAct4"]):
				player.anim_player.play("IdleBEZ")
				player.dash("MiniDash")
				player.stand_attack_anim("Hit")
				General.count_attacks += 1
			else:
				if General.nail_count.count(1) >= 1:
					player.anim_player.play("TuskAct1Nail")
					player.stand_attack_anim("NailTusk")
					General.count_attacks += 1
				else:
					General.message_spawn("Center", "У вас недостаточно ногтей")
	elif General.dialog_activate == false and General.is_invent_show == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false and General.attacked == false and General.dashed == false and General.blocked == false:
		if General.stand_activated == false:
			if General.dostup_combo:
				player.start_kd_default_attack(false)
				player.dash("AttackDash")
				player.get_node("ATTACK_SOUND").play("EPMTYPUNCH")
				General.count_attacks += 1
		if General.stand_index == "EhosAct0" and General.stand_activated:
			if General.dostup_combo:
				player.start_kd_default_attack(false)
				player.dash("AttackDash")
				player.get_node("ATTACK_SOUND").play("EPMTYPUNCH")
				General.count_attacks += 1


func on_attack_activate_big(player):
	if General.stand_index != "None" and General.stand_index != "EhosAct0" and General.dialog_activate == false and General.is_invent_show == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false and General.attacked == false and General.dashed == false and General.blocked == false and General.stand_activated and player.stand_activate_activated == false:
		if General.stand_index == "EhosAct1":
			player.stand_attack_anim("Bull_1.5")
			General.count_attacks += 1
			player.start_kd_default_attack(true)
		elif General.stand_index != "TuskAct1" and General.stand_index != "TuskAct2" and General.stand_index != "TuskAct3":
			if General.dostup_combo:
				player.start_kd_default_attack(true)
				player.dash("MiniDash")
				player.get_node("ATTACK_SOUND").play("EPMTYPUNCH")
			player.anim_player.play("IdleBEZ")
			player.stand_attack_anim("BigHit")

			if General.stand_index != "EhosAct1" and General.stand_index != "EhosAct0":
				if General.stand_index == "TWOH":
					player.SoundPlay("res://Music/TheWorldStrengthAttack.mp3")
				elif General.stand_number == 11:
					player.SoundPlay("res://Music/Tusk4BarrageEnd.mp3")
				elif General.stand_number == 24:
					player.get_node("STRENGTH_ATTACK_SOUND").play("GoldExp")
				else:
					player.get_node("STRENGTH_ATTACK_SOUND").play(General.stand_index)
			General.count_attacks += 1
		else:
			if General.dostup_combo:
				player.dash("AttackBigDash")
				player.get_node("ATTACK_SOUND").play("EPMTYPUNCH")
	elif General.dialog_activate == false and General.is_invent_show == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false and General.attacked == false and General.dashed == false and General.blocked == false:
		if General.stand_activated == false:
			if General.dostup_combo:
				player.dash("AttackBigDash")
				player.get_node("ATTACK_SOUND").play("EPMTYPUNCH")
			General.count_attacks += 1
		if General.stand_index == "EhosAct0" and General.stand_activated:
			if General.dostup_combo:
				player.dash("AttackBigDash")
				player.get_node("ATTACK_SOUND").play("EPMTYPUNCH")
			General.count_attacks += 1


func on_dash_activate(player):
	if General.stand_number != 8 and General.stand_number != 1 and General.stand_number != 2:
		player.dash("DefaultDash")
	else:
		if General.time_erase == false and General.time_stop == false:
			player.dash("TSDash")
		else:
			player.dash("DefaultDash")


func block(player):
	var block_button = player.get_node("/root/" + player.get_tree().current_scene.name + "/GUI/Right_Less/TouchScreenButton2")
	if General.attacked == false and General.dashed == false and General.player_attack_activate == false and General.block_glush.is_stopped() and General.player_attack_activate == false:
		General.blocked = true
		player.get_node("YSort/Animations").play("Block")
		yield(block_button, "released")
		yield(player.get_tree().create_timer(0.1), "timeout")
		General.blocked = false


func start_dop_kooldown(player, attack_number_id: int):
	if General.dostup_combo:
		if attack_number_id == 1:
			var button_dop_attack = player.get_node("/root/" + player.get_tree().current_scene.name + "/GUI/Right_Less/TouchScreenButton3")
			player.connect("first_attack_kd", button_dop_attack, "first_attack_kd")
			player.emit_signal("first_attack_kd")
			player.disconnect("first_attack_kd", button_dop_attack, "first_attack_kd")
		elif attack_number_id == 2:
			var button_dop_attack = player.get_node("/root/" + player.get_tree().current_scene.name + "/GUI/Right_Less/TouchScreenButton4")
			player.connect("second_attack_kd", button_dop_attack, "second_attack_kd")
			player.emit_signal("second_attack_kd")
			player.disconnect("second_attack_kd", button_dop_attack, "second_attack_kd")
		elif attack_number_id == 6:
			var button_dop_attack = player.get_node("/root/" + player.get_tree().current_scene.name + "/GUI/Right_Less/TouchScreenButton4")
			player.connect("bd_attack_kd", button_dop_attack, "bd_attack_kd")
			player.emit_signal("bd_attack_kd")
			player.disconnect("bd_attack_kd", button_dop_attack, "bd_attack_kd")


func start_kd_default_attack(player, is_strength: bool):
	if General.dostup_combo or General.stand_number == 6:
		if is_strength:
			var button_dop_attack = player.get_node("/root/" + player.get_tree().current_scene.name + "/GUI/Right_Less/BigAttackTextureButton")
			player.connect("attack_kd_start", button_dop_attack, "attack_kd_start")
			player.emit_signal("attack_kd_start")
			player.disconnect("attack_kd_start", button_dop_attack, "attack_kd_start")
		else:
			var button_dop_attack = player.get_node("/root/" + player.get_tree().current_scene.name + "/GUI/Right_Less/TextureButton3")
			player.connect("attack_kd_start", button_dop_attack, "attack_kd_start")
			player.emit_signal("attack_kd_start")
			player.disconnect("attack_kd_start", button_dop_attack, "attack_kd_start")


func dash_start_kd(player):
	var button = player.get_node("/root/" + player.get_tree().current_scene.name + "/GUI/Right_Less/TouchScreenButton")
	player.connect("kd_dash_start", button, "kd_dash_start")
	player.emit_signal("kd_dash_start")
	player.disconnect("kd_dash_start", button, "kd_dash_start")


func techinc_first_attack_start_kd(player):
	var button = player.get_node("/root/" + player.get_tree().current_scene.name + "/GUI/Right_Less/DopButton")
	player.connect("technic_attack_kd", button, "technic_attack_kd")
	player.emit_signal("technic_attack_kd")
	player.disconnect("technic_attack_kd", button, "technic_attack_kd")


func attack_combo_dostup(_player):
	General.dostup_combo = true


func dash_attack_end(_player):
	General.dashed = false
	General.player_attack_activate = false


func preduprejenie_for_enemy_before_attack(player):
	var enemy = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/Enemy")
	player.connect("enemy_attacked", enemy, "pre_attack")
	player.emit_signal("enemy_attacked")
	player.disconnect("enemy_attacked", enemy, "pre_attack")


func preduprejenie_for_enemy_before_bullet(player):
	var enemy = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/Enemy")
	if General.stand_index == "TuskAct1" or General.stand_index == "TuskAct2" or General.stand_index == "TuskAct3" or General.stand_index == "TuskAct4":
		if General.nail_count.find(1) != - 1:
			player.connect("enemy_attacked", enemy, "pre_bullet")
			player.emit_signal("enemy_attacked")
			player.disconnect("enemy_attacked", enemy, "pre_bullet")
	else:
		player.connect("enemy_attacked", enemy, "pre_bullet")
		player.emit_signal("enemy_attacked")
		player.disconnect("enemy_attacked", enemy, "pre_bullet")
