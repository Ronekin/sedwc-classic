# ItemUseService.gd — применение предметов из инвентаря.
#
# Контракт: activate() получает GGPlayer и 1-based slot_id; эффекты предметов
# остаются здесь, UI только вызывает активацию. Новый предмет с эффектом
# добавляйте сюда и в Data/Items.gd.

extends Reference


func activate(player, slot_id):
	var random_stand_chance = 0
	player.random.randomize()
	if slot_id == "1" and General.stand_index == "None" and General.stand_number == 0:
		General.catscene_activated = true
		var vfx = player.vfx_arrow_activate.instance()
		if General.player_on_ysort_area == false:
			player.get_parent().get_parent().add_child(vfx)
			
		else:
			player.get_parent().add_child(vfx)
		vfx.global_position = player.global_position
		if not ("arrows_used" in General.player_statistic): General.player_statistic["arrows_used"] = 0
		General.player_statistic["arrows_used"] += 1
		
		
		player.get_node("ITEM_ACTIVATE").play("Arrow")
		General.stand_activated = false
		General.remove_item_slot(int(slot_id), 1, 1)
		random_stand_chance = player.random.randf()
		if random_stand_chance < 0.075:
			General.stand_number = 14
			General.save_save()
		elif random_stand_chance < 0.15:
			General.stand_number = 3
			General.save_save()
		elif random_stand_chance < 0.3:
			General.stand_number = 27
			General.save_save()
		elif random_stand_chance < 0.4:
			General.stand_number = 7
			General.save_save()
			yield(player.get_tree().create_timer(1), "timeout")
			General.message_spawn("Center", "Для развития Эхос Акт 0 - идите в бой.")
		elif random_stand_chance < 0.6:
			General.stand_number = 13
			General.save_save()
		elif random_stand_chance < 0.7:
			General.stand_number = 2
			General.save_save()
		elif random_stand_chance < 0.8:
			General.stand_number = 18
			General.save_save()
		elif random_stand_chance < 1:
			General.stand_number = 20
			General.save_save()
			General.message_spawn("Center", "для развития вайт снейка - идите к пуччи")
		player.random.randomize()
		General.catscene_activated = true
	elif slot_id == "6" and General.stand_index == "None" and General.stand_number == 0:
		General.remove_item_slot(int(slot_id), 1, 1)
		random_stand_chance = player.random.randf()
		if random_stand_chance <= 0.9 or General.money < 20000:
			General.stand_number = 10
			General.AchievementGive(23)
		elif random_stand_chance <= 1:
			General.stand_number = 26
			General.AchievementGive(27)
		player.get_node("ITEM_ACTIVATE").play("Rokakaka")
		General.save_save()
	elif slot_id == "6" and General.stand_index == "KKDopio" and General.stand_number == 13:
		General.remove_item_slot(int(slot_id), 1, 1)
		player.dialog_create("Да, босс", 0, 0, 0, 0, General.dialogue_text("doppio_help"), "Главный герой", "GeneralCharacter")
		player.get_node("ITEM_ACTIVATE").play("Arrow")
		General.save_save()
	elif slot_id == "25" and General.limit_player["hp"] < 10:
		General.remove_item_slot(int(slot_id), 1, 1)
		General.bonus_player["health"] += 10
		General.limit_player["hp"] += 1
		General.message_spawn("Center", "Вы получили 10 здоровья лимит " + str(General.limit_player["hp"]) + "/10")
		General.save_save()
	elif slot_id == "24" and General.limit_player["dmg_gg"] < 10:
		General.remove_item_slot(int(slot_id), 1, 1)
		General.bonus_player["dmg_gg"] += 0.4
		General.limit_player["dmg_gg"] += 1
		General.message_spawn("Center", "Ваш общий множитель силы ударов персонажа, а также техник был увеличен на 0.4 лимит " + str(General.limit_player["dmg_gg"]) + "/10")
		General.save_save()
	elif slot_id == "22" and General.limit_player["dmg_st"] < 20:
		General.remove_item_slot(int(slot_id), 1, 1)
		General.bonus_player["dmg_st"] += 0.1
		General.limit_player["dmg_st"] += 1
		General.message_spawn("Center", "Ваша общая сила стенда была увеличена на 0.1 лимит " + str(General.limit_player["dmg_st"]) + "/20")
		General.save_save()
	elif slot_id == "1" and General.stand_index == "TheWorld" and General.stand_number == 1 and General.twoh_complete_quest["blood"] >= 100 and General.twoh_complete_quest["arrow"] == false:
		General.remove_item_slot(int(slot_id), 1, 1)
		General.twoh_complete_quest["arrow"] = true
		player.get_node("ITEM_ACTIVATE").play("Arrow")
		General.save_save()
	elif slot_id == "99":
		General.make_dur = true
	elif slot_id == "19":
		if General.twoh_complete_quest["blood"] >= 100 and General.twoh_complete_quest["arrow"] == true and General.twoh_complete_quest["jesus"] == true and General.twoh_complete_quest["eye"] >= 2 and General.twoh_complete_quest["arms"] >= 2 and General.twoh_complete_quest["rib"] == true and General.twoh_complete_quest["pelvis"] == true:
			if General.stand_number == 1 and General.search_id(5) == - 1:
				player.dialog_create("По рукам!", "...", 0, 0, 0, General.dialogue_text("dio_bone_price"), "Дневник", "Diary")
		else:
			player.dialog_create("Дальше", "...", 0, 0, 0, General.dialogue_text("dio_plan"), "Дневник", "Diary")
	elif slot_id == "20" and General.stand_index == "ShadowTW" and General.stand_number == 14:
		General.remove_item_slot(int(slot_id), 1, 1)
		random_stand_chance = player.random.randf()
		if random_stand_chance > 0 and random_stand_chance <= 0.5:
			General.stand_number = 1
			if General.race_number == 0:
				
				General.TalentTreeReset("race")
				yield(player.get_tree(), "idle_frame")
				General.race_number = 1
				General.update_stats()
		elif random_stand_chance > 0.5 and random_stand_chance <= 1:
			General.stand_number = 1
			if General.race_number == 0:
				General.TalentTreeReset("race")
				yield(player.get_tree(), "idle_frame")
				General.race_number = 1
				General.update_stats()
		player.get_node("ITEM_ACTIVATE").play("Arrow")
		General.save_save()
	elif slot_id == "33" and General.race_number == 0:
		General.TalentTreeReset("race")
		yield(player.get_tree(), "idle_frame")
		General.remove_item_slot(int(slot_id), 1, 1)
		General.message_spawn("Center", "Вы стали вампиром")

		General.race_number = 1
		General.update_stats()
		player.get_node("ITEM_ACTIVATE").play("Arrow")
		General.save_save()

	elif slot_id == "5" and General.race_number != 0:
		General.TalentTreeReset("race")
		General.remove_item_slot(int(slot_id), 1, 1)
		General.race_number = 0
		player.get_node("ITEM_ACTIVATE").play("Rokakaka")
		General.save_save()
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	elif slot_id == "29" and General.techic_number != 6 and General.techic_number != 7:
		General.remove_item_slot(int(slot_id), 1, 1)

		General.TalentTreeReset("race")
		General.race_number = 5
		General.message_spawn("Center", "Вы модифицировали своё тело!")
		General.save_save()
	elif slot_id == "29" and General.techic_number == 6 and General.cyborg_arms == 2:
		General.remove_item_slot(int(slot_id), 1, 1)
		
		
						
		General.race_number = 5
		
		

		General.message_spawn("Center", "Вы окончательно модифицировали своё тело!")
		General.TalentTreeReset("race")
		General.save_save()
	elif slot_id == "8" and General.techic_number == 6 and General.cyborg_arms < 2:
		General.remove_item_slot(int(slot_id), 1, 1)
		General.cyborg_arms += 1
		General.message_spawn("Center", "Вы слились с рукой святого трупа для получение кибернетических рук")
		player.get_node("ITEM_ACTIVATE").play("Arrow")
		General.save_save()
	elif slot_id == "17" and General.stand_number == 1 and General.twoh_complete_quest["blood"] >= 100 and General.twoh_complete_quest["arrow"] == true and General.twoh_complete_quest["jesus"] == true and General.twoh_complete_quest["eye"] < 2:
		General.remove_item_slot(int(slot_id), 1, 1)
		General.twoh_complete_quest["eye"] += 1
		General.message_spawn("Center", "Вы слились с глазом святого трупа")
		player.get_node("ITEM_ACTIVATE").play("Arrow")
		General.save_save()
	elif slot_id == "8" and General.stand_number == 1 and General.twoh_complete_quest["blood"] >= 100 and General.twoh_complete_quest["arrow"] == true and General.twoh_complete_quest["jesus"] == true and General.twoh_complete_quest["eye"] == 2 and General.twoh_complete_quest["arms"] < 2:
		General.remove_item_slot(int(slot_id), 1, 1)
		General.twoh_complete_quest["arms"] += 1
		General.message_spawn("Center", "Вы слились с руокй святого трупа")
		player.get_node("ITEM_ACTIVATE").play("Arrow")
		General.save_save()
	elif slot_id == "10" and General.stand_number == 1 and General.twoh_complete_quest["blood"] >= 100 and General.twoh_complete_quest["arrow"] == true and General.twoh_complete_quest["jesus"] == true and General.twoh_complete_quest["eye"] == 2 and General.twoh_complete_quest["arms"] == 2 and General.twoh_complete_quest["rib"] == false:
		General.remove_item_slot(int(slot_id), 1, 1)
		General.twoh_complete_quest["rib"] = true
		General.message_spawn("Center", "Вы слились с ребром святого трупа")
		player.get_node("ITEM_ACTIVATE").play("Arrow")
		General.save_save()
	elif slot_id == "21" and General.stand_number == 20:
		General.remove_item_slot(int(slot_id), 1, 1)
		General.message_spawn("Center", "Вы слились с зелёным ребёнком")
		player.get_node("ITEM_ACTIVATE").play("Arrow")
		General.stand_number = 22
		General.save_save()
	elif slot_id == "23" and General.stand_number == 22:
		General.remove_item_slot(int(slot_id), 1, 1)
		player.get_node("../../GUI/JotaroRemembers/AnimationPlayer").play("Go")
		yield(player.get_tree().create_timer(1.5), "timeout")
		General.add_quest("", 11.3, "", [], [], "", "", "", "", false, "", "", "", "")


		General.save_save()
	elif slot_id == "15" and General.stand_number == 1 and General.twoh_complete_quest["blood"] >= 100 and General.twoh_complete_quest["arrow"] == true and General.twoh_complete_quest["jesus"] == true and General.twoh_complete_quest["eye"] == 2 and General.twoh_complete_quest["arms"] == 2 and General.twoh_complete_quest["rib"] == true and General.twoh_complete_quest["pelvis"] == false:
		General.remove_item_slot(int(slot_id), 1, 1)
		General.twoh_complete_quest["pelvis"] = true
		General.message_spawn("Center", "Вы слились с тазом свявтого трупа")
		player.get_node("ITEM_ACTIVATE").play("Arrow")
		General.save_save()
	elif slot_id == "20" and General.stand_number == 1 and General.twoh_complete_quest["blood"] >= 100 and General.twoh_complete_quest["arrow"] == true and General.twoh_complete_quest["jesus"] == true and General.twoh_complete_quest["eye"] == 2 and General.twoh_complete_quest["arms"] == 2 and General.twoh_complete_quest["rib"] == true and General.twoh_complete_quest["pelvis"] == true and General.twoh_complete_quest["bone"] == false:
		General.remove_item_slot(int(slot_id), 1, 1)
		General.stand_number = 16
		General.AchievementGive(26)
		
		General.twoh_complete_quest = null
		General.message_spawn("Center", "Вы достигли рая......")
		player.get_node("ITEM_ACTIVATE").play("Arrow")
		General.save_save()
	elif (slot_id == "17" or slot_id == "8" or slot_id == "10" or slot_id == "15") and General.stand_index == "None" and General.stand_number == 0 and (General.techic_number == 2 or General.techic_number == 1):
		General.item_in_arm = "0"
		General.remove_item_slot(int(slot_id), 1, 1)
		random_stand_chance = player.random.randf()
		General.event_coins += 2
		if General.search_id(2.05) != - 1 or General.complete_quests.find(2.05) != - 1:
			General.full_quest_delete(2.05)
		if General.search_id(2) != - 1 or General.complete_quests.find(2) != - 1:
			General.full_quest_delete(2)
		if random_stand_chance > 0 and random_stand_chance < 0.2:
			General.stand_number = 4
			General.save_save()
		elif random_stand_chance > 0.2 and random_stand_chance < 1:
			General.message_spawn("Center", "Святой труп не признал вас")
	elif (slot_id == "17" or slot_id == "8" or slot_id == "10" or slot_id == "15") and General.stand_index == "None" and General.stand_number == 0:
		General.item_in_arm = "0"
		General.remove_item_slot(int(slot_id), 1, 1)
		random_stand_chance = player.random.randf()
		if random_stand_chance > 0 and random_stand_chance < 0.1:
			General.stand_number = 25
			General.message_spawn("Center", "Святой труп одарил вас силой")
			General.save_save()
		elif random_stand_chance > 0.1 and random_stand_chance < 1:
			General.message_spawn("Center", "Святой труп не признал вас")
	elif (slot_id == "8" or slot_id == "10" or slot_id == "15") and General.stand_index == "D4C" and General.stand_number == 25:
		General.item_in_arm = "0"
		General.remove_item_slot(int(slot_id), 1, 1)
		random_stand_chance = player.random.randf()
		if random_stand_chance > 0 and random_stand_chance < 0.1:
			General.message_spawn("Center", "D4c получил силу телепортации из святого трупа")
			General.teleport_charges += 1
			General.save_save()
		elif random_stand_chance > 0.1 and random_stand_chance < 1:
			General.message_spawn("Center", "D4с не смог получить силу телепортации из святого трупа")
	elif slot_id == "2" and General.stand_index != "None" and General.stand_number != 0 and (player.anim_stand.current_animation.find("Idle") != - 1 or player.anim_stand.current_animation.find("Move") != - 1):
		General.catscene_activated = true
		General.jesus_dialog_complete = false
		General.item_in_arm = "0"
		General.event_coins += 1
		if General.stand_number == 4:
			if General.search_id(2.2) != - 1 or General.complete_quests.find(2.2) != - 1:
				General.full_quest_delete(2.2)
				General.full_quest_delete(2.6)
			if General.search_id(2.1) != - 1 or General.complete_quests.find(2.1) != - 1:
				General.full_quest_delete(2.1)
				General.full_quest_delete(2.6)
			if General.search_id(2) != - 1 or General.complete_quests.find(2) != - 1:
				General.full_quest_delete(2)
				General.full_quest_delete(2.6)
			if General.search_id(2.05) != - 1 or General.complete_quests.find(2.05) != - 1:
				General.full_quest_delete(2.05)
				General.full_quest_delete(2.6)
		if General.stand_number == 5:
			if General.search_id(2.2) != - 1 or General.complete_quests.find(2.2) != - 1:
				General.full_quest_delete(2.2)
			if General.search_id(2.1) != - 1 or General.complete_quests.find(2.1) != - 1:
				General.full_quest_delete(2.1)
			if General.search_id(2) != - 1 or General.complete_quests.find(2) != - 1:
				General.full_quest_delete(2)
			if General.search_id(2.05) != - 1 or General.complete_quests.find(2.05) != - 1:
				General.full_quest_delete(2.05)
		if General.stand_number == 9:
			if General.search_id(2.2) != - 1 or General.complete_quests.find(2.2) != - 1:
				General.full_quest_delete(2.2)
			if General.search_id(2.1) != - 1 or General.complete_quests.find(2.1) != - 1:
				General.full_quest_delete(2.1)
			if General.search_id(2) != - 1 or General.complete_quests.find(2) != - 1:
				General.full_quest_delete(2)
			if General.search_id(2.05) != - 1 or General.complete_quests.find(2.05) != - 1:
				General.full_quest_delete(2.05)
		if General.stand_number == 11:
			if General.search_id(2.2) != - 1 or General.complete_quests.find(2.2) != - 1:
				General.full_quest_delete(2.2)
			if General.search_id(2.1) != - 1 or General.complete_quests.find(2.1) != - 1:
				General.full_quest_delete(2.1)
			if General.search_id(2) != - 1 or General.complete_quests.find(2) != - 1:
				General.full_quest_delete(2)
			if General.search_id(2.05) != - 1 or General.complete_quests.find(2.05) != - 1:
				General.full_quest_delete(2.05)
		
		General.remove_item_slot(int(slot_id), 1, 1)
		General.stand_number = 0
		General.AchievementGive(33)
		player.get_node("ITEM_ACTIVATE").play("Disc")
		if player.anim_stand.current_animation.find("Show") != - 1 or player.anim_stand.current_animation.find("Idle") != - 1 or player.anim_stand.current_animation.find("Move") != - 1:
			player.stand_activate_activated = true
			player.anim_stand.play("Hiden" + General.stand_direction_set)
			player.get_node("AuraAnim").play("Hide")
		General.save_save()
		yield(player.get_tree().create_timer(1.5), "timeout")
		General.catscene_activated = false
	elif slot_id == "10" and General.stand_index == "TuskAct1" and General.stand_number == 4 and (player.anim_stand.current_animation.find("Idle") != - 1 or player.anim_stand.current_animation.find("Move") != - 1) and General.complete_quests.find(2.1) != - 1:
		General.item_in_arm = "0"
		General.remove_item_slot(int(slot_id), 1, 1)
		General.stand_number = 5
		General.stand_activated = false
		General.event_coins += 3
		player.stand_activate()
		if General.search_id(2.1) != - 1 or General.complete_quests.find(2.1) != - 1:
			General.full_quest_delete(2.1)
		if General.search_id(2.05) != - 1 or General.complete_quests.find(2.05) != - 1:
			General.full_quest_delete(2.05)
		if General.search_id(2) != - 1 or General.complete_quests.find(2) != - 1:
			General.full_quest_delete(2)
		General.save_save()
	elif slot_id == "12" and General.search_id(3.2) != - 1:
		var random_index = player.random.randi_range(0, player.random_spin_timer.size() - 1)
		var random_value = player.random_spin_timer[random_index]
		if General.mini_game_second_number == 0:
			General.mini_game_first_number = random_value
			General.mini_game_second_number = General.mini_game_first_number + 0.25
		if player.attemp_lesson_spin_count < 4:
			if General.timer_spin.is_stopped():
				General.mini_game_activate = true
				General.message_spawn("Center", "Жмите на кнопку активации, когда стрелка находится в зеленой зоне.")
				if General.timer_spin.is_connected("timeout", player, "false_lesson_timer_end"):
					General.timer_spin.disconnect("timeout", player, "false_lesson_timer_end")
				General.timer_spin.connect("timeout", player, "false_lesson_timer_end")
				General.timer_spin.wait_time = 1
				General.timer_spin.one_shot = true
				if General.timer_spin.get_parent() != player:
					player.add_child(General.timer_spin)
				General.timer_spin.start()
				General.signal_reset_spin_bar_lesson = true
			else:
				General.mini_game_activate = true
				player.attemp_lesson_spin_count += 1
				if 1 - General.timer_spin.time_left >= General.mini_game_first_number and 1 - General.timer_spin.time_left < General.mini_game_second_number:
					player.false_spin_count += 1
					General.timer_spin.start()
					General.signal_reset_spin_bar_lesson = true
				else:
					General.mini_game_activate = false
					General.timer_spin.stop()
					player.remove_child(General.timer_spin)
					player.attemp_lesson_spin_count = 0
					General.mini_game_first_number = 0
					General.mini_game_second_number = 0
		else:
			General.mini_game_activate = false
			General.timer_spin.stop()
			player.attemp_lesson_spin_count = 0
			if player.false_spin_count == 4:
				General.remove_item(11, 1, 1)
				General.add_item(12, 1, 1)
			General.mini_game_first_number = 0
			General.mini_game_second_number = 0
			player.false_spin_count = 0
			General.save_save()
	elif slot_id == "14" and General.search_id(3.3) != - 1:
		var random_index = player.random.randi_range(0, player.random_spin_timer.size() - 1)
		var random_value = player.random_spin_timer[random_index]
		if General.mini_game_second_number == 0:
			General.mini_game_first_number = random_value
			General.mini_game_second_number = General.mini_game_first_number + 0.15
		if player.attemp_lesson_spin_count < 4:
			if General.timer_spin.is_stopped():
				General.mini_game_activate = true
				if General.timer_spin.is_connected("timeout", player, "false_lesson_timer_end"):
					General.timer_spin.disconnect("timeout", player, "false_lesson_timer_end")
				General.timer_spin.connect("timeout", player, "false_lesson_timer_end")
				General.timer_spin.wait_time = 1
				General.timer_spin.one_shot = true
				if General.timer_spin.get_parent() != player:
					player.add_child(General.timer_spin)
				General.timer_spin.start()
				General.signal_reset_spin_bar_lesson = true
			else:
				General.mini_game_activate = true
				player.attemp_lesson_spin_count += 1
				if 1 - General.timer_spin.time_left >= General.mini_game_first_number and 1 - General.timer_spin.time_left < General.mini_game_second_number:
					player.true_spin_count += 1
					General.timer_spin.start()
					General.signal_reset_spin_bar_lesson = true
				else:
					General.mini_game_activate = false
					General.timer_spin.stop()
					player.remove_child(General.timer_spin)
					General.mini_game_first_number = 0
					General.mini_game_second_number = 0
					player.attemp_lesson_spin_count = 0
		else:
			General.mini_game_activate = false
			General.timer_spin.stop()
			player.attemp_lesson_spin_count = 0
			if player.true_spin_count == 4:
				var vfx = player.vfx_spin_up.instance()
				if General.player_on_ysort_area == false:
					player.get_parent().get_parent().add_child(vfx)
					vfx.z_index = 3
				else:
					player.get_parent().add_child(vfx)
					vfx.z_index = 1
				General.message_spawn("Center", "Вы достойны для спина... для обретения спина завершите последний квест")
				vfx.position = Vector2(player.global_position.x, player.global_position.y - 20)
				vfx.one_shot = true
				vfx.emitting = true
				General.remove_item(13, 1, 1)
				General.mini_true_game_complete = true
			General.mini_game_first_number = 0
			General.mini_game_second_number = 0
			player.true_spin_count = 0
			General.save_save()
	elif slot_id == "12" and General.search_id(3.2) == - 1 and not General.message_activate:
		General.message_spawn("Center", "В данный момент вы не можете активировать этот предмет. Поговорите с тем, кто вам его дал")
		General.message_activate = true
	elif slot_id == "14" and General.search_id(3.3) == - 1 and not General.message_activate:
		General.message_spawn("Center", "В данный момент вы не можете активировать этот предмет. Поговорите с тем, кто вам его дал")
		General.message_activate = true
	elif slot_id == "15" and General.stand_index == "TuskAct2" and General.stand_number == 5 and (player.anim_stand.current_animation.find("Idle") != - 1 or player.anim_stand.current_animation.find("Move") != - 1) and General.complete_quests.find(2.2) != - 1:
		General.item_in_arm = "0"
		General.remove_item_slot(int(slot_id), 1, 1)
		General.stand_number = 9
		General.stand_activated = false
		player.stand_activate()
		if General.search_id(2.2) != - 1 or General.complete_quests.find(2.2) != - 1:
			General.full_quest_delete(2.2)
		if General.search_id(2.1) != - 1 or General.complete_quests.find(2.1) != - 1:
			General.full_quest_delete(2.1)
		if General.search_id(2.05) != - 1 or General.complete_quests.find(2.05) != - 1:
			General.full_quest_delete(2.05)
		if General.search_id(2) != - 1 or General.complete_quests.find(2) != - 1:
			General.full_quest_delete(2)
		General.save_save()
