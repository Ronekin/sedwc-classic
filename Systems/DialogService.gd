# DialogService.gd — выбор диалога для NPC, с которым столкнулся игрок.
#
# Контракт:
# - start_dialog(player) вызывается из GGPlayer, когда игрок нажимает действие
#   рядом с NPC;
# - General.collision_npc — Vector2(active, npc_id). Первое поле: 1 — зона
#   активна, 0 — игрок вышел. Второе поле — стабильный номер NPC/объекта;
# - текст берётся только через General.dialogue_text(ключ_из_каталога);
# - сюжетные этапы квестов двигаются через General.replace_quest() и
#   General.remove_quest(), чтобы не менять General.quests вручную.
#
# Номера NPC — это не индексы массивов, а ключи из сцен. Меняя номер в сцене,
# проверьте все ветки ниже.

extends Reference


func _show_teleport_panel(player) -> void:
	# Панель телепорта есть не на каждой арене. Без get_node_or_null
	# отсутствие узла печатает ошибку и ломает диалог.
	var gui = player.get_node_or_null("/root/" + player.get_tree().current_scene.name + "/GUI")
	if gui == null:
		return
	var panel = gui.get_node_or_null("TeleportPanel")
	if panel == null:
		return
	panel.visible = true
	var animation_player = panel.get_node_or_null("AnimationPlayer")
	if animation_player != null:
		animation_player.play("start")


func start_dialog(player):
	if General.dialog_activate == false and General.is_invent_show == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false:
		
		if General.collision_npc == Vector2(true, - 3.11):
			General.collision_npc = Vector2(false, 0)
			General.remove_item(40, 3, 1)
			player.get_node("../../Centrifuges/Text").text = "процесс пошёл...\n\\/"
			player.get_node("../../Centrifuges/Area2D").remove_from_group("Centrifuges")
			General.SoundPlay("res://Music/CentrifugeWork.mp3", {"Volume_db": 5})
			yield(player.get_tree().create_timer(14), "timeout")
			player.get_node("../../Centrifuges/Text").text = "процесс окончен...\n\\/"
			General.SoundPlay("res://Music/CentrifugesEnd.mp3")
			General.add_item(42 - 1, 1)
			player.get_node("../../Centrifuges/Area2D").add_to_group("Centrifuges")
			
		elif General.collision_npc == Vector2(true, 1):
			if General.search_id(1) == - 1 and General.search_id(1.1) == - 1 and General.complete_quests.find(1) == - 1:
				player.dialog_create("Хорошо", "Позже", 0, 0, 0, General.dialogue_text("jotaro_house_intro"), "Джотаро", "Jotaro")
			elif General.search_id(1.1) == - 1 and General.complete_quests.find(1) != - 1:
				player.dialog_create("Понял", 0, 0, 0, 0, General.dialogue_text("jotaro_disks_start"), "Джотаро", "Jotaro")
			elif General.search_id(1) != - 1:
				player.dialog_create("Понял", 0, 0, 0, 0, General.dialogue_text("jotaro_arrow_reminder"), "Джотаро", "Jotaro")
			elif General.search_id(1.1) != - 1:
				player.dialog_create("Понял", 0, 0, 0, 0, General.dialogue_text("jotaro_disks_reminder"), "Джотаро", "Jotaro")
		elif General.collision_npc == Vector2(true, 2):
			General.SoundPlay("res://Music/ManVoice_0.mp3", {"Volume_db": 5})

			if (General.search_id(2) != - 1 and General.complete_quests.find(2) == - 1) or (General.search_id(2.05) != - 1 and General.complete_quests.find(2.05) == - 1) or (General.search_id(2.1) != - 1 and General.complete_quests.find(2.1) != - 1) or (General.search_id(2.2) != - 1 and General.complete_quests.find(2.2) == - 1) or General.search_id(2.6) != - 1:
				player.dialog_create("Понял", 0, 0, 0, 0, General.dialogue_text("johnny_quest_taken"), "Джонни", "Johny")
			elif General.stand_index == "TuskAct3" and General.techic_number == 1:
				player.dialog_create("Хорошо", "Потом", 0, 0, 0, General.dialogue_text("johnny_act3_hint"), "Джонни", "Johny")
			elif General.stand_index == "TuskAct3" and General.techic_number == 2:
				player.dialog_create("Хорошо", "Потом", 0, 0, 0, General.dialogue_text("johnny_final_tournament"), "Джонни", "Johny")
			elif General.stand_index == "TuskAct4" and General.stand_number == 11:
				player.dialog_create("Прощай!", 0, 0, 0, 0, General.dialogue_text("johnny_farewell"), "Джонни", "Johny")
			elif General.stand_index == "TuskAct1" and (General.techic_number == 1 or General.techic_number == 2) and General.complete_quests.find(2.1) == - 1:
				player.dialog_create("Как?", "Потом", 0, 0, 0, General.dialogue_text("johnny_golden_ratio"), "Джонни", "Johny")
			elif General.complete_quests.find(2.1) != - 1 and General.stand_index != "TuskAct2" and (General.techic_number == 1 or General.techic_number == 2):
				player.dialog_create("Понял", 0, 0, 0, 0, General.dialogue_text("johnny_act1_item"), "Джонни", "Johny")
			elif General.stand_index == "TuskAct2" and (General.techic_number == 1 or General.techic_number == 2) and General.complete_quests.find(2.2) == - 1:
				player.dialog_create("Хорошо", "Потом", 0, 0, 0, General.dialogue_text("johnny_act2_done"), "Джонни", "Johny")
			elif General.complete_quests.find(2.2) != - 1 and General.stand_index != "TuskAct3":
				player.dialog_create("Понял", 0, 0, 0, 0, General.dialogue_text("johnny_act2_item"), "Джонни", "Johny")
			elif General.complete_quests.find(2.05) != - 1 and General.stand_index != "TuskAct1":
				player.dialog_create("Понял", 0, 0, 0, 0, General.dialogue_text("johnny_act1_complete"), "Джонни", "Johny")
			elif General.complete_quests.find(2) != - 1 and General.complete_quests.find(2.05) == - 1:
				player.dialog_create("Понял", 0, 0, 0, 0, General.dialogue_text("johnny_paid_task"), "Джонни", "Johny")
			elif General.stand_index == "TuskAct1":
				player.dialog_create("Да.", "Нет", 0, 0, 0, General.dialogue_text("johnny_teach"), "Джонни", "Johny")
			else:
				player.dialog_create("таск", "....", "нечего", 0, 0, General.dialogue_text("johnny_why"), "Джонни", "Johny")

		elif General.collision_npc == Vector2(true, 3):
			
			General.SoundPlay("res://Music/GyroNyoHo.mp3", {"Volume_db": 8})
			if General.techic_number != 2:
				if General.search_id(3) == - 1 and General.complete_quests.find(3) == - 1 and General.complete_quests.find(3.1) == - 1 and General.complete_quests.find(3.2) == - 1 and General.complete_quests.find(3.3) == - 1:
					player.dialog_create("Спин", "Ничего", 0, 0, 0, General.dialogue_text("cyborg_need"), "Джайро", "Gyro")
				elif General.complete_quests.find(3) != - 1 and General.complete_quests.find(3.1) == - 1 and General.complete_quests.find(3.2) == - 1 and General.complete_quests.find(3.3) == - 1:
					player.dialog_create("Понял", 0, 0, 0, 0, General.dialogue_text("gyro_balls_task"), "Джайро", "Gyro")
				elif General.complete_quests.find(3) != - 1 and General.complete_quests.find(3.1) != - 1 and General.complete_quests.find(3.2) == - 1 and General.complete_quests.find(3.3) == - 1:
					player.dialog_create("Как?", "Потом", 0, 0, 0, General.dialogue_text("gyro_practice_ready"), "Джайро", "Gyro")
				elif General.complete_quests.find(3) != - 1 and General.complete_quests.find(3.1) != - 1 and General.complete_quests.find(3.2) != - 1 and General.complete_quests.find(3.3) == - 1:
					player.dialog_create("Готов", 0, 0, 0, 0, General.dialogue_text("gyro_ball_practice"), "Джайро", "Gyro")
				elif General.complete_quests.find(3) != - 1 and General.complete_quests.find(3.1) != - 1 and General.complete_quests.find(3.2) != - 1 and General.complete_quests.find(3.3) != - 1 and General.techic_number == 2:
					player.dialog_create("Удачи!", 0, 0, 0, 0, General.dialogue_text("johnny_top"), "Джайро", "Gyro")
				if General.search_id(3) != - 1 or General.search_id(3.1) != - 1 or General.search_id(3.2) != - 1 or General.search_id(3.3) != - 1 and General.search_id(3.8) != - 1:
					player.dialog_create("Ясно", 0, 0, 0, 0, General.dialogue_text("gyro_quest_taken"), "Джайро", "Gyro")
			if General.techic_all == [1] and (General.techic_number == 1 or General.techic_number == 2) and General.complete_quests.find(3.8) == - 1:
					player.dialog_create("Да!", "Нет", 0, 0, 0, General.dialogue_text("gyro_next_stage"), "Джайро", "Gyro")
			elif General.techic_number == 2 and General.complete_quests.find(3.8) != - 1:
				if General.search_id(3.7) == - 1:
					player.dialog_create("Спасибо", "Святой", 0, 0, 0, General.dialogue_text("gyro_perfect"), "Джайро", "Gyro")
				elif General.search_id(3.7) != - 1:
					player.dialog_create("Ясно", 0, 0, 0, 0, General.dialogue_text("gyro_quest_taken"), "Джайро", "Gyro")
			elif General.techic_number != 2 and General.techic_number != 1:
				if General.complete_quests.find(3) != - 1 and General.complete_quests.find(3.1) != - 1 and General.complete_quests.find(3.2) != - 1 and General.complete_quests.find(3.3) != - 1:
					player.dialog_create("Да", "Святой", "Поможешь?", "Нет", 0, General.dialogue_text("gyro_remember"), "Джайро", "Gyro")
		elif General.collision_npc == Vector2(true, 23):
			if General.search_id(11.3) != - 1:
				if General.stand_number == 22:
					
					GeneralMusicPlayer.theme_resong("Crucified_theme")
					yield(player.get_tree().create_timer(8), "timeout")
					General.message_spawn("Center", "вы достигли небес")
					General.remove_quest(11.3)
					player.get_node("../../GUI/Center/AnimationPlayer").play("Go")
					General.stand_number = 23
					General.AchievementGive(25)
					General.save_save()
				else:
					General.message_spawn("Center", "возьмите C-moon!")
			else:
					General.message_spawn("Center", "ещё не время...")
		elif General.collision_npc == Vector2(true, 24):

		
			player.dialog_create("проблемы?", "извините", 0, 0, 0, General.dialogue_text("luka_meet"), "Лука", "Luka")

		elif General.collision_npc == Vector2(true, 4):
			General.SoundPlay("res://Music/ManVoice_0.mp3", {"Volume_db": 5})
		
			if General.stand_number == 20:
				player.dialog_create("хорошо", "нет", 0, 0, 0, General.dialogue_text("johnny_same_type"), "Пуччи", "Pucci")
			if General.search_id(11) != - 1:
				
				if General.items_inventory[General.check_array(19)].y > 0:
					General.replace_quest(11, 11.1)
					
					player.dialog_create("понял", 0, 0, 0, 0, General.dialogue_text("pucci_dio_bone"), "Пуччи", "Pucci")
				else:
					player.dialog_create("понял", 0, 0, 0, 0, General.dialogue_text("pucci_need_bone"), "Пуччи", "Pucci")
			elif General.search_id(11.1) != - 1:
				
				if General.items_inventory[General.check_array(23)].y > 0:
					General.remove_quest(11.1)
					player.dialog_create("держи", "нет", 0, 0, 0, General.dialogue_text("pucci_jotaro_disk"), "Пуччи", "Pucci")
				else:
					player.dialog_create("понял", 0, 0, 0, 0, General.dialogue_text("pucci_need_disk"), "Пуччи", "Pucci")
			elif General.search_id(11.2) != - 1:
				if General.stand_number != 22:
					if General.items_inventory[General.check_array(21)].y > 0:
						player.dialog_create("понял", 0, 0, 0, 0, General.dialogue_text("pucci_white_snake"), "Пуччи", "Pucci")
					else:
						player.dialog_create("понял", 0, 0, 0, 0, General.dialogue_text("pucci_green_child"), "Пуччи", "Pucci")
				else:
					player.dialog_create("что дальше?", 0, 0, 0, 0, General.dialogue_text("pucci_power"), "Пуччи", "Pucci")
			elif General.search_id(11.3) == - 1:
				if General.stand_number == 24:
					player.dialog_create("спасибо", 0, 0, 0, 0, General.dialogue_text("pucci_heaven"), "Пуччи", "Pucci")

		elif General.collision_npc == Vector2(true, 20):
		

				General.enemy_collision_name = "dio"
				General.signal_create_fight_panel = true
				General.enemy_collision_stats = {
					"NAME": General.enemy_collision_name, 
					"NAMERUS": "дио брандо(вампир)", 
					"DMG": 8, 
					"HP": 700, 
					"DEF": 20, 
					"ID": 0, 
					"OSOBENNOSTI": "", 
					"OSOBENNOSTIRUS": "", 
					"RAGE": General.enemy_list[0]["RAGE"], 
					"REWARD_TEXT": "", 
				}
				General.capture_player_pos_save(player)





		elif General.collision_npc == Vector2(true, 29):
			General.SoundPlay("res://Music/ManVoice_0.mp3", {"Volume_db": 5})
			if player.get_tree().current_scene.name == "Rom":
				player.dialog_create("да", "нет", 0, 0, 0, General.dialogue_text("conductor_naples"), "Кондуктор", "Conductor")
			else:
				player.dialog_create("да", "нет", 0, 0, 0, General.dialogue_text("conductor_rome"), "Кондуктор", "Conductor")
		elif General.collision_npc == Vector2(true, 39):
			General.SoundPlay("res://Music/ManVoice_0.mp3", {"Volume_db": 5})
			

				

		elif General.collision_npc == Vector2(true, 25):
			General.SoundPlay("res://Music/ManVoice_0.mp3", {"Volume_db": 5})
			if player.get_tree().current_scene.name == "Rom":
				if General.search_id(12.34) != - 1:
					General.replace_quest(12.34, 12.35)
							
					
					
					
					
					player.dialog_create("понял", 0, 0, 0, 0, General.dialogue_text("bruno_boss_betrayal"), "Буччелати", "Bucciarati")




			elif player.get_tree().current_scene.name == "Rest":
				if General.search_id(12.3) != - 1:
					
					
					General.replace_quest(12.3, 12.31)
				
					player.dialog_create("спасибо", 0, 0, 0, 0, General.dialogue_text("bruno_new_partner"), "Буччелати", "Bucciarati")

					
					
					

				elif General.search_id(12.31) != - 1:
					player.dialog_create("кто эти?", 0, 0, 0, 0, General.dialogue_text("bruno_mission"), "Буччелати", "Bucciarati")
				elif General.search_id(12.33) != - 1:
					player.dialog_create("понял", 0, 0, 0, 0, General.dialogue_text("bruno_pesci_done"), "Буччелати", "Bucciarati")
					General.replace_quest(12.33, 12.34)
				
				else:
					player.dialog_create("давай", 0, 0, 0, 0, General.dialogue_text("bruno_bonjourno"), "Буччелати", "Bucciarati")
			else:
				if General.search_id(12.1) != - 1:
					player.dialog_create("что?", 0, 0, 0, 0, General.dialogue_text("bruno_luka_dead"), "Буччелати", "Bucciarati")

				elif General.search_id(12.2) != - 1:
					player.dialog_create("...", 0, 0, 0, 0, General.dialogue_text("bruno_respect"), "Буччелати", "Bucciarati")

				else:
					player.dialog_create("...", 0, 0, 0, 0, General.dialogue_text("bruno_arrive"), "Буччелати", "Bucciarati")





		elif General.collision_npc == Vector2(true, 30):
			if General.search_id(12.34) != - 1 or General.search_id(12.35) != - 1:
				if General.check_array(8) == - 1:
					General.add_item(8, 1)
					player.dialog_create("спасибо", 0, 0, 0, 0, General.dialogue_text("diavolo_arrow"), "Польнорефф", "Polnoreff")



		elif General.collision_npc == Vector2(true, 22):
		

				General.enemy_collision_name = "zeck"
				General.signal_create_fight_panel = true
				General.enemy_collision_stats = {
					"NAME": General.enemy_collision_name, 
					"NAMERUS": "заключённые", 
					"DMG": 8, 
					"HP": 600, 
					"DEF": 20, 
					"ID": 0, 
					"OSOBENNOSTI": "", 
					"OSOBENNOSTIRUS": "", 
					"RAGE": General.enemy_list[0]["RAGE"], 
					"REWARD_TEXT": "", 
				}
				General.capture_player_pos_save(player)


		elif General.collision_npc == Vector2(true, 21):
		

				General.enemy_collision_name = "jotaro6"
				General.signal_create_fight_panel = true
				General.enemy_collision_stats = {
					"NAME": General.enemy_collision_name, 
					"NAMERUS": "куджо джотаро", 
					"DMG": 8, 
					"HP": 600, 
					"DEF": 20, 
					"ID": 0, 
					"OSOBENNOSTI": "", 
					"OSOBENNOSTIRUS": "", 
					"RAGE": General.enemy_list[0]["RAGE"], 
					"REWARD_TEXT": "", 
				}
				General.capture_player_pos_save(player)


		elif General.collision_npc == Vector2(true, 7):
			if General.teleport_charges == 0 and General.infinity_teleports() == false:
				player.dialog_create("Да!", "Нет!", 0, 0, 0, General.dialogue_text("valentine_teleport_money"), "Валентайн", "Valentine")
			if General.teleport_charges > 0 and General.infinity_teleports() == false:
				_show_teleport_panel(player)

				General.save_save()
				General.SoundPlay("res://Music/FunnyValentineVoice_1.mp3")
				
			else:
				General.SoundPlay("res://Music/FunnyValentineVoice_0.mp3")

			if General.infinity_teleports() == true:
				_show_teleport_panel(player)
				General.SoundPlay("res://Music/FunnyValentineVoice_1.mp3")
		elif General.collision_npc == Vector2(true, 8):
			if General.complete_quests.find(8.1) == - 1 and General.search_id(8.1) == - 1:
				General.SoundPlay("res://Music/ManVoice_0.mp3", {"Volume_db": 5})
				player.dialog_create("Желаю", "Нет", 0, 0, 0, General.dialogue_text("cyborg_offer"), "Штройхам", "Shtroiham")
			elif General.complete_quests.find(8.1) != - 1 and General.complete_quests.find(8.2) == - 1:
				player.dialog_create("Хорошо", 0, 0, 0, 0, General.dialogue_text("cyborg_laser"), "Штройхам", "Shtroiham")
				General.SoundPlay("res://Music/ManVoice_0.mp3", {"Volume_db": 5})
			if General.race_number == 5:
				General.SoundPlay("res://Music/ShtroyhamVoice_0.mp3")
				player.dialog_create("Хорошо", 0, 0, 0, 0, General.dialogue_text("mechanic_greeting"), "Штройхам", "Shtroiham")
			if General.complete_quests.find(8.1) != - 1 and General.search_id(8.1) != - 1:
				player.dialog_create("Желаю", "Нет", 0, 0, 0, General.dialogue_text("cyborg_controls"), "Штройхам", "Shtroiham")
			if General.race_number == 5:
				if General.item_in_arm == "39" and (0 in General.other_save["CybSh"][1]) == false:
						player.dialog_create("Хорошо", "нет", 0, 0, 0, General.dialogue_text("scientist_reactor"), "Штройхам", "Shtroiham")
				if General.item_in_arm == "40" and (1 in General.other_save["CybSh"][1]) == false:
						player.dialog_create("Хорошо", "нет", 0, 0, 0, General.dialogue_text("scientist_fusion"), "Штройхам", "Shtroiham")






			elif General.complete_quests.find(8.1) != - 1 and General.complete_quests.find(8.2) == - 1 and General.techic_number == 6:
				player.dialog_create("Хорошо", "Нет", 0, 0, 0, General.dialogue_text("cyborg_chip"), "Штройхам", "Shtroiham")
			elif General.complete_quests.find(8.2) != - 1 and General.techic_number == 6:
				player.dialog_create("Хорошо", 0, 0, 0, 0, General.dialogue_text("cyborg_arms"), "Штройхам", "Shtroiham")
			elif General.complete_quests.find(8.2) != - 1 and General.techic_number == 7:
				player.dialog_create("Понял", 0, 0, 0, 0, General.dialogue_text("cyborg_future"), "Штройхам", "Shtroiham")
			elif General.complete_quests.find(8.2) != - 1 and General.techic_number != 7 and General.techic_number != 6:
				player.dialog_create("Да", "Нет", 0, 0, 0, General.dialogue_text("cyborg_controls"), "Штройхам", "Shtroiham")
			elif General.quests.find(8.1) != - 1:
				player.dialog_create("Хорошо", 0, 0, 0, 0, General.dialogue_text("valentine_conditions"), "Штройхам", "Shtroiham")
			elif General.quests.find(8.2) != - 1:
				player.dialog_create("Хорошо", 0, 0, 0, 0, General.dialogue_text("valentine_conditions"), "Штройхам", "Shtroiham")





		elif General.collision_npc == Vector2(true, 37):
			player.dialog_create("палладий", "нет спасибо", 0, 0, 0, General.dialogue_text("chemist_greeting"), "хим. рабочий", "хим. рабочий")

		elif General.collision_npc == Vector2(true, 38):
			General.SoundPlay("res://Music/GyroHeheheheVoice.mp3", {"Volume_db": 3})
			if ("carsky" in General.other_save["slow"]):
				player.dialog_create("нечего", "царская водка", 0, 0, 0, General.dialogue_text("merchant_greeting"), "Peter Dreher", "Peter Dreher")
			else:
				player.dialog_create("нечего", 0, 0, 0, 0, General.dialogue_text("merchant_need"), "Peter Dreher", "Peter Dreher")





		elif General.collision_npc == Vector2(true, 35):
			player.dialog_create("уран 235", "...", 0, 0, 0, General.dialogue_text("soldier_greeting"), "Ядерщик", "nuclearer")

		
		
		
		
		
		
		elif General.collision_npc == Vector2(true, 6):
			Transition.change_scene("res://SpidwagonShop.tscn", "Black")
			General.capture_player_pos_save(player)

		



		elif General.collision_npc == Vector2(true, 28):
			General.enemy_collision_name = "peshi"
			General.signal_create_fight_panel = true
			General.enemy_collision_stats = {
				"NAME": General.enemy_collision_name, 
				"NAMERUS": "пеши", 
				"DMG": 4, 
				"HP": 600, 
				"DEF": 20, 
				"ID": 0, 
				"OSOBENNOSTI": "", 
				"OSOBENNOSTIRUS": "", 
				"RAGE": General.enemy_list[0]["RAGE"], 
				"REWARD_TEXT": "", 
			}
			General.capture_player_pos_save(player)


		elif General.collision_npc == Vector2(true, 31):
			General.enemy_collision_name = "Diabolo"
			General.signal_create_fight_panel = true
			General.enemy_collision_stats = {
				"NAME": General.enemy_collision_name, 
				"NAMERUS": "дьяволо", 
				"DMG": 4, 
				"HP": 800, 
				"DEF": 20, 
				"ID": 0, 
				"OSOBENNOSTI": "", 
				"OSOBENNOSTIRUS": "", 
				"RAGE": General.enemy_list[0]["RAGE"], 
				"REWARD_TEXT": "", 
			}
			General.capture_player_pos_save(player)
		elif General.collision_npc == Vector2(true, 36):
			General.enemy_collision_name = "IronMan"
			General.signal_create_fight_panel = true
			General.enemy_collision_stats = {
				"NAME": General.enemy_collision_name, 
				"NAMERUS": "Магнус Фриц", 
				"DMG": 12, 
				"HP": 800, 
				"DEF": 20, 
				"ID": 0, 
				"OSOBENNOSTI": "анти-стан", 
				"OSOBENNOSTIRUS": "", 
				"RAGE": 4, 
				"REWARD_TEXT": "", 
			}
			General.capture_player_pos_save(player)

		elif General.collision_npc == Vector2(true, 32):
			General.enemy_collision_name = "Cars"
			General.signal_create_fight_panel = true
			General.enemy_collision_stats = {
				"NAME": General.enemy_collision_name, 
				"NAMERUS": "Cars", 
				"DMG": 12, 
				"HP": 1000, 
				"DEF": 20, 
				"ID": 0, 
				"OSOBENNOSTI": "", 
				"OSOBENNOSTIRUS": "", 
				"RAGE": General.enemy_list[0]["RAGE"], 
				"REWARD_TEXT": "", 
			}
			General.capture_player_pos_save(player)

		elif General.collision_npc == Vector2(true, 33):
			General.enemy_collision_name = "cyborg"
			General.signal_create_fight_panel = true
			General.enemy_collision_stats = {
				"NAME": General.enemy_collision_name, 
				"NAMERUS": "cyborg", 
				"DMG": 12, 
				"HP": 400, 
				"DEF": 20, 
				"ID": 0, 
				"OSOBENNOSTI": "", 
				"OSOBENNOSTIRUS": "", 
				"RAGE": General.enemy_list[0]["RAGE"], 
				"REWARD_TEXT": "", 
			}
			General.capture_player_pos_save(player)


		elif General.collision_npc == Vector2(true, - 1):
			General.enemy_collision_name = "DefaultEnemy"
			General.signal_create_fight_panel = true
			General.enemy_collision_stats = {
				"NAME": General.enemy_collision_name, 
				"NAMERUS": "враг", 
				"DMG": 4, 
				"HP": 75, 
				"DEF": 20, 
				"ID": 0, 
				"OSOBENNOSTI": "", 
				"OSOBENNOSTIRUS": "", 
				"RAGE": General.enemy_list[0]["RAGE"], 
				"REWARD_TEXT": "+" + str(10 * General.global_bonus["money"]) + "$," + " +25 exp", 
			}
			General.capture_player_pos_save(player)
			
			
			





		elif General.collision_npc == Vector2(true, - 1.01):
			General.enemy_collision_name = "BullingEnemy"
			General.signal_create_fight_panel = true
			General.enemy_collision_stats = {
				"NAME": General.enemy_collision_name, 
				"NAMERUS": "хулиган", 
				"DMG": 3, 
				"HP": 30, 
				"DEF": 10, 
				"ID": 0, 
				"OSOBENNOSTI": "", 
				"OSOBENNOSTIRUS": "", 
				"RAGE": General.enemy_list[0]["RAGE"], 
				"REWARD_TEXT": "+" + "50$," + " +10 exp"
			}
			General.capture_player_pos_save(player)
		elif General.collision_npc == Vector2(true, - 1.02):
			General.enemy_collision_name = "KarsEnemy"
			General.signal_create_fight_panel = true
			General.enemy_collision_stats = {
				"NAME": General.enemy_collision_name, 
				"NAMERUS": "Карс", 
				"DMG": 8, 
				"HP": 750, 
				"DEF": 30, 
				"ID": 0, 
				"OSOBENNOSTI": "", 
				"OSOBENNOSTIRUS": "", 
				"RAGE": General.enemy_list[3]["RAGE"], 
				"REWARD_TEXT": "+2500$, + 500 ед. маст."
			}
			General.capture_player_pos_save(player)
		
		
		
		elif General.collision_npc == Vector2(true, - 2):
			General.capture_player_pos_save(player)
			Transition.change_scene("res://GeneralGameScenes/Shop.tscn", "Black")
		elif General.collision_npc == Vector2(true, - 4.4):
			General.toGameGeneral("Black", true)
		elif General.collision_npc == Vector2(true, - 4.44):
			General.capture_player_pos_save(player)
			Transition.change_scene("res://GeneralGameScenes/Rest.tscn", "Black")






		elif General.collision_npc == Vector2(true, - 3.1):
			
			if player.get_tree().current_scene.name == "Germany":
				General.capture_player_pos_save(player)
				Transition.change_scene("res://GeneralGameScenes/PODVAL.tscn", "Black")
			else:
				General.apply_saved_player_position(player)
				Transition.change_scene("res://GeneralGameScenes/Germany.tscn", "Black")


		elif General.collision_npc == Vector2(true, - 3.12):
			
			var GUI = player.get_node_or_null("/root/" + player.get_tree().current_scene.name + "/GUI")

			if GUI != null:
				var da = preload("res://Scenes/MiniGame.tscn").instance()
				GUI.add_child(da)
		elif General.collision_npc == Vector2(true, - 3.13):

			var GUI = player.get_node_or_null("/root/" + player.get_tree().current_scene.name + "/GUI")

			if GUI != null:
				var da = preload("res://Scenes/MiniGame.tscn").instance()
				GUI.add_child(da)
				da.MiniGamaSet(1)


		elif General.collision_npc == Vector2(true, - 3):
			var obt = false
			for i in range(General.houses.size()):
				if General.houses[i] == "100khouse":
					General.message_spawn("Center", "Попробуйте в следующих обновлениях на данный момент вы имете скидку 10% на покупки в магазине")
					obt = true
				else:
					obt = false
			if obt == false:
				if General.money >= 100000:
					General.message_spawn("Center", "Успешно приобретено за 100к$")
					General.money -= 100000
					General.houses.append("100khouse")
				else:
					pass
