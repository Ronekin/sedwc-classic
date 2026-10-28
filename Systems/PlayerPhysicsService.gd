# PlayerPhysicsService.gd — покадровая физика и состояние игрока.
#
# Контракт: process() получает GGPlayer и работает с его узлами, полями и
# методами PlayerEntity; родительский _physics_process остаётся в GGPlayer.

extends Reference


func _remove_group(node: Node, group: String) -> void:
	# remove_from_group() для отсутствующей группы печатает ошибку движка.
	# Группы атак переключаются каждый кадр, поэтому membership проверяем явно.
	if node != null and is_instance_valid(node) and node.is_in_group(group):
		node.remove_from_group(group)


func process(player, delta):
	if player.stand_ability != null:
		if player.stand_ability.stand_number != General.stand_number:
			player.stand_ability.set_stand(General.stand_number)
		player.stand_ability.activated = General.stand_activated
	if player.technic_ability != null and player.technic_ability.technic_number != General.techic_number:
		player.technic_ability.set_technic(General.techic_number)
	if player.spec_ability != null and player.spec_ability.race_number != General.race_number:
		player.spec_ability.set_race(General.race_number)
	
	if General.race_number == 5:
		player.get_node("YSort/Texture/Equips/CyborgModifedEquip").visible = (General.other_save["Cyborg"][1][5] == "0")
		
		player.get_node("YSort/Texture/Equips/CyborgModifedEquip2").visible = (General.other_save["Cyborg"][1][4] == "2")
		player.get_node("YSort/Texture/Equips/CyborgModifedEquip3").visible = (General.other_save["Cyborg"][1][3] != "")
		
		
		var cyborg_bat_empty = true
		if General.other_save["Cyborg"][1][6] != "":
			var bat_parts_vis = General.other_save["Cyborg"][1][6].split("/")
			cyborg_bat_empty = bat_parts_vis.size() < 2 or float(bat_parts_vis[1]) <= 0.0
		if General.other_save["Cyborg"][1][6] == "" or cyborg_bat_empty:
				player.get_node("YSort/Texture/Equips/CyborgModifedEquip3").frame = 6
		else:
				if General.other_save["Cyborg"][1][3] == "6":
					player.get_node("YSort/Texture/Equips/CyborgModifedEquip3").frame = 4
				elif General.other_save["Cyborg"][1][3] == "7":
					player.get_node("YSort/Texture/Equips/CyborgModifedEquip3").frame = 5
		
		
		
		
		player.get_node("YSort/Texture/Equips/CyborgModifedEquip4").visible = General.race_number == 5 and (General.other_save["Cyborg"][1][1] != "")
		player.get_node("YSort/Texture/Equips/CyborgModifedEquip4").visible = General.race_number == 5 and (General.other_save["Cyborg"][1][1] != "")
		player.get_node("YSort/Texture/Equips/CyborgModifedEquip5").visible = General.race_number == 5 and (General.other_save["Cyborg"][1][2] != "")
	else:
		for i in [player.get_node("YSort/Texture/Equips/CyborgModifedEquip"), player.get_node("YSort/Texture/Equips/CyborgModifedEquip2"), player.get_node("YSort/Texture/Equips/CyborgModifedEquip3"), player.get_node("YSort/Texture/Equips/CyborgModifedEquip4"), player.get_node("YSort/Texture/Equips/CyborgModifedEquip5")]:
			i.visible = false
	
	if General.barrage_activate:
		if "barrage" in player.Timers:
			player.Timers["barrage"] += delta
			if player.Timers["barrage"] > 0.3:
				player.Timers["barrage"] = 0.0


		else:
			player.Timers["barrage"] = 0.0


	if General.mih_speed > 1.0 and General.stand_number == 23:
		player.get_node("YSort/Texture").material = load("res://Details/MIHboost.tres")
	else:
		player.get_node("YSort/Texture").material = load("res://Scenes/DamageEffect.tres")
	if General.EnemyName == "Diavolo":
		if General.enemy_health <= 400:
			if ("requim" in player.addition) == false:
				player.addition.append("requim")
							
							
							
				player.get_node("../../GUI").visible = false
				BlackLinesVertical.start_lines()
				var Enemy
				for i in player.get_parent().get_children():
					if i.name.find("Enemy") == 0:
						Enemy = i
				General.player_block_all = true
				General.enemy_block_all = true
				var zoom_save = General.camera_scale
				player.CameraZoom(0.7, 1.0, 0.3)
				yield(player.get_tree().create_timer(1), "timeout")
				player.CameraZoom(zoom_save, 1.0, 0.3)




	player.get_node("Light2D3").energy = 2
	player.get_node("Light2D3").mode = Light2D.MODE_ADD
	player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("width", 1)
	player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("aura_color", "ffffff")
	match General.stand_number:
		0, 1, 2, 16, 3, 6, 7, 18:
			player.get_node("Light2D").color = Color("ffe993")
			player.get_node("YSort/Texture/Node2D/StandAura").self_modulate = Color("ffffff")
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("outline_color", Color("ffeec6"))

			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("aura_color", Color("ffbb00"))
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("width", 0.5)
			player.get_node("Light2D3").color = Color("00ffffff")
		8, 13, 26:
			player.get_node("Light2D").color = Color("ffb0b0")
			player.get_node("YSort/Texture/Node2D/StandAura").self_modulate = Color("ffffff")
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("outline_color", Color("ff6cad"))
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("aura_color", Color("ff0000"))
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("width", 0.4)
			player.get_node("Light2D3").color = Color("ff0000")
		22, 27:
			player.get_node("Light2D").color = Color("b9ffb0")
			player.get_node("YSort/Texture/Node2D/StandAura").self_modulate = Color("81ff77")
			player.get_node("YSort/Texture/Node2D/StandAura").self_modulate.a = 0.6
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("outline_color", Color("81ff77"))
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("aura_color", Color("2c7825"))
			player.get_node("Light2D3").color = Color("81ff77")
		10, 25:
			player.get_node("Light2D").color = Color("00ffff")
			player.get_node("YSort/Texture/Node2D/StandAura").self_modulate = Color("00ffff")
			player.get_node("Light2D3").color = Color("0000c0b4")
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("width", 0.4)
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("outline_color", Color("00ffef"))
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("aura_color", Color("0099de"))
		24, 20:
			player.get_node("Light2D").color = Color("ffffff")
			player.get_node("YSort/Texture/Node2D/StandAura").self_modulate = Color("ffffff")

			player.get_node("Light2D3").color = Color("00ffffff")
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("outline_color", Color("e5f3ff"))
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("width", 0.4)
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("aura_color", Color("d097b7ef"))

		4, 5, 9, 11:
			player.get_node("Light2D").color = Color("ffffff")
			player.get_node("YSort/Texture/Node2D/StandAura").self_modulate = Color("ffffff")

			player.get_node("Light2D3").color = Color("00ffffff")
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("outline_color", Color("ff91ba"))
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("width", 0.4)
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("aura_color", Color("ff47ba"))





		14, 23:
			player.get_node("Light2D").color = Color("eb94ff")
			player.get_node("YSort/Texture/Node2D/StandAura").self_modulate = Color("550093")
			player.get_node("YSort/Texture/Node2D/StandAura").self_modulate.a = 0.5
			player.get_node("Light2D3").color = Color("ffffff")
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("aura_color", Color("db0089"))
			player.get_node("Light2D3").mode = Light2D.MODE_ADD
			player.get_node("Light2D3").energy = 4
			player.get_node("YSort/Texture/Node2D/StandAura").material.set_shader_param("outline_color", Color("35005b"))
	if General.stand_number != 13 or General.stand_activated == false:
		player.get_node("YSort/Texture/KKepitaf").visible = false
	else:
		player.get_node("YSort/Texture/KKepitaf").visible = true
	for bob in range(General.houses.size()):
		if General.houses[bob] == "100khouse":
			General.global_bonus["discount"] = 0.1
	if General.run_activate and player.anim_player.current_animation.find("Move") != - 1:
		player.anim_player.playback_speed = General.run_scale
	else:
		player.anim_player.playback_speed = 1
	
	if player.global_position.y - General.enemy_position.y < 50 and player.global_position.y - General.enemy_position.y > - 50:
		if player.global_position.x - General.enemy_position.x > 100 or player.global_position.x - General.enemy_position.x < - 100:
			player.get_node("TreeGoldExpSpawn").position.x = - 103
		else:
			if player.global_position.x - General.enemy_position.x < 0:
				if General.player_direct == "right":
					player.get_node("TreeGoldExpSpawn").position.x = player.global_position.x - General.enemy_position.x
				else:
					player.get_node("TreeGoldExpSpawn").position.x = - 103
			else:
				if General.player_direct == "left":
					player.get_node("TreeGoldExpSpawn").position.x = General.enemy_position.x - player.global_position.x
				else:
					player.get_node("TreeGoldExpSpawn").position.x = - 103
	else:
		player.get_node("TreeGoldExpSpawn").position.x = - 103
	player.get_node("Metka").position.x = player.get_node("TreeGoldExpSpawn").position.x
	
	if General.metka_tree_enabled:
		if (General.stand_number == 3 or General.stand_number == 17) and (player.get_tree().current_scene.name.find("Arena") != - 1):
			player.get_node("Metka").visible = true
		else:
			player.get_node("Metka").visible = false
	else:
		player.get_node("Metka").visible = false
	
	if player.global_position.distance_to(General.enemy_position) < 80:
		player.get_node("TuskBulletCreate").position = Vector2(0, - 64)
	else:
		player.get_node("TuskBulletCreate").position = Vector2( - 48, - 64)
	if is_instance_valid(General.combo_enemy_timer):
		if General.combo_enemy_timer and General.combo_enemy_timer.is_stopped() == false:
			General.player_block_all = true
	
	if General.bubble_go_beyound_start_activate and General.attacked == false:
		player.anim_player.play("TuskAct1Nail")
	
	if player.anim_player.current_animation.find("Move") != - 1 and (General.player_attack_activate or General.barrage_activate or General.player_block_all or General.dialog_activate or General.is_invent_show or General.quest_panel_activate or General.mini_game_activate or General.catscene_activated):
		if General.bubble_go_beyound_start_activate == false:
			if General.attacked == false:
				player.anim_player.play("IdleBEZ")
		else:
			if General.attacked == false:
				player.anim_player.play("TuskAct1Nail")
	
	player.dist_enemy_l = General.enemy_position - General.left_block_position
	player.dist_enemy_r = General.right_block_position - General.enemy_position
	player.dist_enemy_t = General.enemy_position - General.top_block_position
	player.dist_enemy_b = General.bottom_block_positon - General.enemy_position
	player.time_passed += delta
	player.jesus_timer += delta
	if player.time_passed > 0.075:
		player.time_passed = 0
		if General.barrage_activate and (player.anim_stand.current_animation == "Barrage"):
			if General.stand_number != 6:
				player.barrage_arm_spawn()
			else:
				player.barrage_nail_spawn()
	if player.jesus_timer > 10:
		player.jesus_timer = 0
		if (General.stand_number == 5 or General.stand_number == 4) and General.jesus_dialog_complete == false and General.dialog_activate == false and General.search_id(2.2) != - 1 and player.get_tree().current_scene.name != "MorioMap" and player.get_tree().current_scene.name != "TrainingArena" and General.heart_points >= 30 and General.attacked == false and General.player_attack_activate == false and General.player_block_all == false and General.dashed == false and General.stand_activate_activated == false:
			var random_number_chance = player.random.randf()
			if random_number_chance > 0.5 and random_number_chance < 0.6:
				player.jesus_dialog("Tusk")
		if General.stand_number == 1 and General.twoh_complete_quest["blood"] >= 100 and General.twoh_complete_quest["arrow"] == true and General.twoh_complete_quest["jesus"] == false and player.get_tree().current_scene.name != "MorioMap" and player.get_tree().current_scene.name != "TrainingArena" and General.heart_points >= 30 and General.attacked == false and General.player_attack_activate == false and General.player_block_all == false and General.dashed == false and General.stand_activate_activated == false:
			var random_number_chance = player.random.randf()
			if random_number_chance > 0.5 and random_number_chance < 0.6:
				player.jesus_dialog("Twoh")
	if General.time_erase == false and General.time_stop == false:
		General.player_pos_start_erase = General.player_pos
	General.player_warning_position = player.get_node("WarningPosition").position
	General.player_scale = player.scale
	player.position_first = Vector2(player.global_position.x, player.global_position.y - 35)
	if player.get_node("YSort/Animations/CameraZoomAnimation").current_animation == "":
		player.get_node("YSort/Camera2D").zoom = General.camera_scale
	else:
		General.camera_scale = player.get_node("YSort/Camera2D").zoom
	if General.attacked == false:
		player.movement(delta)
	player.stand_animation()
	player.move_stand_anim()
	if General.fast_pos_change == false:
		General.sync_player_pos_from_node(player)
	else:
		if General.teleport_pos == "Morio":
			General.other_save["world"] = "morio"
			Transition.change_scene("res://GeneralGameScenes/MorioMap.tscn", "Black")
		elif General.teleport_pos == "Desert":
			Transition.change_scene("res://GeneralGameScenes/SandWorld.tscn", "Black")
			General.other_save["world"] = "desert"
		elif General.teleport_pos == "jail":
			General.other_save["world"] = "jail"
			Transition.change_scene("res://GeneralGameScenes/JailDa.tscn", "Black")
		elif General.is_valid_map_position(General.player_pos):
			player.set_deferred("global_position", General.player_pos)
		General.teleport_pos = "None"
		General.fast_pos_change = false
	if General.fast_pos_change == false:
		General.stand_pos = player.stand.global_position
	
	if General.check_array_counts(6, 8) != - 1:
		General.pizza_8_yes = true
	else:
		General.pizza_8_yes = false
	
	if General.item_in_arm != "0":
		player.is_item_in_arm = "WITH"
	else:
		player.is_item_in_arm = "BEZ"
	
	if General.attacked:
		player.get_node("BARRAGE_STANDS").stop(true)
		player.get_node("BARRAGE_STANDS/BarrageStans").playing = false
		player.get_node("AUDIO_EFFECT_STANDS").stop(true)
		player.get_node("AUDIO_EFFECT_STANDS/AudioEffectStands").playing = false
	
	General.stand_activate_activated = player.stand_activate_activated
	
	if General.nail_count.count(1) < 10 and General.nail_timer.is_stopped():
		General.nail_timer_start()
	
	if player.get_tree().current_scene.name != "TrainingArena":
		if General.stand_number == 4:
			if General.search_id(2) != - 1 or General.complete_quests.find(2) != - 1:
				General.full_quest_delete(2)
				General.full_quest_delete(2.6)
			if General.search_id(2.05) != - 1 or General.complete_quests.find(2.05) != - 1:
				General.full_quest_delete(2.05)
				General.full_quest_delete(2.6)
		elif General.stand_number == 5:
			if General.search_id(2.1) != - 1 or General.complete_quests.find(2.1) != - 1:
				General.full_quest_delete(2.1)
			if General.search_id(2) != - 1 or General.complete_quests.find(2) != - 1:
				General.full_quest_delete(2)
			if General.search_id(2.05) != - 1 or General.complete_quests.find(2.05) != - 1:
				General.full_quest_delete(2.05)
		elif General.stand_number == 9:
			if General.search_id(2.2) != - 1 or General.complete_quests.find(2.2) != - 1:
				General.full_quest_delete(2.2)
			if General.search_id(2.1) != - 1 or General.complete_quests.find(2.1) != - 1:
				General.full_quest_delete(2.1)
			if General.search_id(2) != - 1 or General.complete_quests.find(2) != - 1:
				General.full_quest_delete(2)
			if General.search_id(2.05) != - 1 or General.complete_quests.find(2.05) != - 1:
				General.full_quest_delete(2.05)
	





































































	
	if General.barrage_activate and (player.anim_stand.current_animation.find("SecondDopAttack_Up") == - 1 and player.anim_stand.current_animation.find("SecondDopAttack_Mid") == - 1) and player.stand_activate_activated == false and General.stand_number == 2:
		pass

	if ("CutScene" in General.Addition) == false and (General.barrage_activate == false and (player.anim_stand.current_animation == "Barrage" or player.anim_stand.current_animation.find("SecondDopAttack_Up") != - 1 or player.anim_stand.current_animation.find("SecondDopAttack_Mid") != - 1) and player.stand_activate_activated == false):

		player.stand_sprite.frame = 0
		if ("CutScene" in General.Addition) == false:
			player.MoveAnimStand.play("ToBack")
		player.anim_stand.stop(true)
		if General.attacked == false:
			
			player.get_node("BARRAGE_STANDS").stop(true)
			player.get_node("BARRAGE_STANDS/BarrageStans").playing = false
		else:
			player.get_node("BARRAGE_STANDS").stop(true)
			player.get_node("BARRAGE_STANDS/BarrageStans").playing = false
	
	if player.anim_stand.current_animation != "Hit" and player.anim_stand.current_animation.find("StandDefaultAttack_Up") == - 1 and player.anim_stand.current_animation.find("StandDefaultAttack_Mid") == - 1 and player.stand_area_attack.is_in_group("StandAttack"):
		_remove_group(player.stand_area_attack, "StandAttack")
		_remove_group(player.get_node("YSort/Stand/StandArea/AreaStandHitBox"), "StandAttack")
	elif (player.anim_stand.current_animation.find("Hit") != - 1) and General.stand_index.find("TuskAct") == - 1 and player.stand_area_attack.is_in_group("StandAttack") == false:
		player.stand_area_attack.add_to_group("StandAttack")
		player.get_node("YSort/Stand/StandArea/AreaStandHitBox").add_to_group("StandAttack")
	
	if (player.anim_stand.current_animation.find("StandSecondDopAttack_Up") != - 1 or player.anim_stand.current_animation.find("StandSecondDopAttack_Mid") != - 1 or player.anim_stand.current_animation == "KC_Chop") and General.stand_index.find("TuskAct") == - 1 and player.stand_area_attack.is_in_group("StandAttackSecond") == false:
		player.stand_area_attack.add_to_group("StandAttackSecond")
		player.get_node("YSort/Stand/StandArea/AreaStandHitBox").add_to_group("StandAttackSecond")
	elif player.anim_stand.current_animation != "KC_Chop" and player.anim_stand.current_animation.find("StandSecondDopAttack_Up") == - 1 and player.anim_stand.current_animation.find("StandSecondDopAttack_Mid") == - 1 and player.stand_area_attack.is_in_group("StandAttackSecond"):
		_remove_group(player.stand_area_attack, "StandAttackSecond")
		_remove_group(player.get_node("YSort/Stand/StandArea/AreaStandHitBox"), "StandAttackSecond")
	
	if (player.anim_stand.current_animation.find("StandThreeDopAttack_Up") != - 1 or player.anim_stand.current_animation.find("StandThreeDopAttack_Mid") != - 1 or player.anim_stand.current_animation == "StarFinger") and General.stand_index.find("TuskAct") == - 1 and player.stand_area_attack.is_in_group("StandAttackThree") == false:
		player.stand_area_attack.add_to_group("StandAttackThree")
		player.get_node("YSort/Stand/StandArea/AreaStandHitBox").add_to_group("StandAttackThree")
	elif player.anim_stand.current_animation != "StarFinger" and player.anim_stand.current_animation.find("StandThreeDopAttack_Up") == - 1 and player.anim_stand.current_animation.find("StandThreeDopAttack_Mid") == - 1 and player.stand_area_attack.is_in_group("StandAttackThree"):
		_remove_group(player.stand_area_attack, "StandAttackThree")
		_remove_group(player.get_node("YSort/Stand/StandArea/AreaStandHitBox"), "StandAttackThree")
	
	if (player.anim_stand.current_animation == "BigHit" or player.anim_stand.current_animation.find("StandBigAttack_Up") != - 1 or player.anim_stand.current_animation.find("StandBigAttack_Mid") != - 1) and (General.stand_index in ["TuskAct1", "TuskAct2", "TuskAct3", ]) == false and player.stand_area_attack.is_in_group("StandAttackBig") == false:
		player.stand_area_attack.add_to_group("StandAttackBig")
		player.get_node("YSort/Stand/StandArea/AreaStandHitBox").add_to_group("StandAttackBig")
	elif player.anim_stand.current_animation != "BigHit" and player.anim_stand.current_animation.find("StandBigAttack_Up") == - 1 and player.anim_stand.current_animation.find("StandBigAttack_Mid") == - 1 and player.stand_area_attack.is_in_group("StandAttackBig"):
		_remove_group(player.stand_area_attack, "StandAttackBig")
		_remove_group(player.get_node("YSort/Stand/StandArea/AreaStandHitBox"), "StandAttackBig")
	
	if player.anim_player.current_animation != "Attack" and player.get_node("YSort/Texture/AttackArea").is_in_group("AttackPlayerArea"):
		_remove_group(player.get_node("YSort/Texture/AttackArea"), "AttackPlayerArea")
		_remove_group(player.get_node("YSort/Texture/AttackArea/AttackBoxHit"), "AttackPlayerArea")
	if player.anim_player.current_animation == "Attack" and player.get_node("YSort/Texture/AttackArea").is_in_group("AttackPlayerArea") == false:
		player.get_node("YSort/Texture/AttackArea").add_to_group("AttackPlayerArea")
		player.get_node("YSort/Texture/AttackArea/AttackBoxHit").add_to_group("AttackPlayerArea")
	if player.anim_player.current_animation != "AttackBig" and player.get_node("YSort/Texture/AttackArea").is_in_group("AttackPlayerAreaBig"):
		_remove_group(player.get_node("YSort/Texture/AttackArea"), "AttackPlayerAreaBig")
		_remove_group(player.get_node("YSort/Texture/AttackArea/AttackBoxHit"), "AttackPlayerAreaBig")
	if player.anim_player.current_animation == "AttackBig" and player.get_node("YSort/Texture/AttackArea").is_in_group("AttackPlayerAreaBig") == false:
		player.get_node("YSort/Texture/AttackArea").add_to_group("AttackPlayerAreaBig")
		player.get_node("YSort/Texture/AttackArea/AttackBoxHit").add_to_group("AttackPlayerAreaBig")
	if player.anim_player.current_animation != "AttackBigSpin" and player.get_node("YSort/Texture/AttackArea").is_in_group("AttackPlayerAreaBigSpin"):
		_remove_group(player.get_node("YSort/Texture/AttackArea"), "AttackPlayerAreaBigSpin")
		_remove_group(player.get_node("YSort/Texture/AttackArea/AttackBoxHit"), "AttackPlayerAreaBigSpin")
	if player.anim_player.current_animation == "AttackBigSpin" and player.get_node("YSort/Texture/AttackArea").is_in_group("AttackPlayerAreaBigSpin") == false:
		player.get_node("YSort/Texture/AttackArea").add_to_group("AttackPlayerAreaBigSpin")
		player.get_node("YSort/Texture/AttackArea/AttackBoxHit").add_to_group("AttackPlayerAreaBigSpin")
	if player.anim_player.current_animation == "":
		for i in player.get_node("YSort/Stand/StandArea").get_groups():
			if i != "Stand":
				_remove_group(player.get_node("YSort/Stand/StandArea"), i)
	if General.run_activate:
		player.get_node("Walk").pitch_scale = 1.3
	else:
		player.get_node("Walk").pitch_scale = 1
	
	General.camera_current_scale = player.cam_player.scale.x
	
	player.dist_l = General.player_pos - General.left_block_position
	player.dist_r = General.right_block_position - General.player_pos
	player.dist_t = General.player_pos - General.top_block_position
	player.dist_b = General.bottom_block_positon - General.player_pos
	
	if General.time_erase and player.health_timer.is_stopped():
		if not player.health_timer.is_connected("timeout", player, "time_health_up"):
			player.health_timer.connect("timeout", player, "time_health_up")
		player.health_timer.wait_time = 1
		player.health_timer.one_shot = true
		player._ensure_child_timer(player.health_timer)
		player.health_timer.start()
	elif not General.time_erase and player.health_timer.get_parent() == player:
		player.health_timer.stop()
		if player.health_timer.is_connected("timeout", player, "time_health_up"):
			player.health_timer.disconnect("timeout", player, "time_health_up")
		# Таймер остаётся ребёнком игрока и освободится вместе с ним.
