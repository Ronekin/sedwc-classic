# PanelDialog.gd — обработчик нажатий в диалоговом окне.
#
# Как устроен диалог:
# - General.text_dialog хранит текущую реплику;
# - General.answer_1..answer_5 — подписи кнопок ответа;
# - is_current_line(ключ_из_каталога) проверяет, какая реплика показана сейчас;
# - show_dialog_line(...) заменяет реплику и ответы;
# - close_dialog() закрывает окно.
#
# Текст реплик лежит в Data/Dialogues.gd. Здесь только ключи и игровые
# действия: выдать квест, забрать предмет, перейти на арену и т.п.
#
# Чтобы добавить ветку:
# 1. добавьте текст в Data/Dialogues.gd;
# 2. найдите в этом файле место, где показывается предыдущая реплика;
# 3. добавьте elif is_current_line(новый_ключ): с нужными действиями.
#
# ВАЖНО: ключи должны совпадать с Data/Dialogues.gd. Если ключ не найден,
# General.dialogue_text() вернёт пустую строку, и ветка не сработает.

extends TextureButton


func _show_teleport_panel() -> void:
	# Панель телепорта есть не на каждой арене; не роняем диалог, если её нет.
	var gui = get_node_or_null("/root/" + get_tree().current_scene.name + "/GUI")
	if gui == null:
		return
	var panel = gui.get_node_or_null("TeleportPanel")
	if panel == null:
		return
	panel.visible = true
	var animation_player = panel.get_node_or_null("AnimationPlayer")
	if animation_player != null:
		animation_player.play("start")


func _on_Panel_pressed():
	if General.text_get_animated == false:
		General.text_speed = 0.05
		
		
		
		if is_current_line("jotaro_house_intro"):
			if $TextAnswer.text == "Хорошо":
				show_dialog_line("Понял", 0, 0, 0, 0, General.dialogue_text("jotaro_house_accept"))
				General.add_quest("Джотаро", 1, "Жильё", [], [], "", "Покупка дома", "Джотаро Куджо", "", false, "", "", "Купить дом за 100к$", "Новые задания")
			elif $TextAnswer.text == "Позже":
				close_dialog()
		elif is_current_line("jotaro_house_accept"):
			if $TextAnswer.text == "Понял":
				close_dialog()
		elif is_current_line("jotaro_disks_start"):
			if $TextAnswer.text == "Понял":
				General.add_quest("Джотаро", 1.1, "Тест 2", [Vector2(2, 3)], [Vector2(7, 1)], "", "Проверочный Квест 2", "Джотаро Куджо", "", true, "", "", "", "")
				close_dialog()
		elif is_current_line("jotaro_disks_reminder"):
			if $TextAnswer.text == "Понял":
				close_dialog()
		elif is_current_line("jotaro_arrow_reminder"):
			if $TextAnswer.text == "Понял":
				close_dialog()
				
				
				
				
				
				
				
				
				
	
		elif is_current_line("luka_meet"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("у меня нету денег", "держи 1к$", 0, 0, 0, General.dialogue_text("luka_rules"))
			if $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("luka_rules"):
			if $TextAnswer.text == General.answer_1:
				if General.money >= 1000:
					show_dialog_line("что?", 0, 0, 0, 0, General.dialogue_text("luka_angry"))
				else:
					show_dialog_line("ок", "нет!", 0, 0, 0, General.dialogue_text("luka_leave"))
			elif $TextAnswer.text == General.answer_2:
				if General.money >= 1000:
					General.money -= 1000
					General.message_spawn("Center", "вы отдали 1к$")
					show_dialog_line("ок", 0, 0, 0, 0, General.dialogue_text("luka_paid"))
				else:
					General.message_spawn("Center", "у вас нету 1000$")
					close_dialog()
					
		elif is_current_line("luka_leave"):
			if $TextAnswer.text == General.answer_2:
				show_dialog_line("что?", 0, 0, 0, 0, General.dialogue_text("luka_red"))
			else:
				close_dialog()
				
				
		elif is_current_line("luka_angry") or is_current_line("luka_red"):
			General.EnemyName = "luka"
			Transition.change_scene("res://GeneralGameScenes/LukaEnemyArena.tscn", "Black")
			General.seconds_get_start = false
			close_dialog()



		elif is_current_line("bruno_arrive"):
			close_dialog()
			if General.search_id(12.0) == - 1:
				General.add_quest("", 12.0, "", [], [], "", "", "", "", false, "", "", "", "")
		elif is_current_line("bruno_luka_dead"):

			show_dialog_line("нет", 0, 0, 0, 0, General.dialogue_text("bruno_accuse"))

		elif is_current_line("bruno_accuse"):
			General.SoundPlay("res://Music/ManVoice_0.mp3", {"Volume_db": 5})

			show_dialog_line("что?!", 0, 0, 0, 0, General.dialogue_text("bruno_lick"))
		elif is_current_line("bruno_lick"):

			show_dialog_line("чего нафиг?", 0, 0, 0, 0, General.dialogue_text("bruno_liar"))
			General.SoundPlay("res://Music/PunchPlayer.mp3")
			yield(get_tree().create_timer(0.1), "timeout")
			General.SoundPlay("res://Music/PunchPlayer.mp3")

		elif is_current_line("bruno_respect"):
			show_dialog_line("могу попробовать", "нет спасибо", 0, 0, 0, General.dialogue_text("bruno_recruit"))

		elif is_current_line("bruno_recruit"):
			show_dialog_line("так", 0, 0, 0, 0, General.dialogue_text("bruno_mafia"))
		elif is_current_line("bruno_mafia"):
			show_dialog_line("я согласен", "отказываюсь", 0, 0, 0, General.dialogue_text("bruno_intro"))


		elif is_current_line("bruno_intro"):
			if $TextAnswer.text == General.answer_1:
				
				General.replace_quest(12.2, 12.3)
				
				
				
				
				show_dialog_line("понял", 0, 0, 0, 0, General.dialogue_text("bruno_restaurant"))
			else:
				close_dialog()
		elif is_current_line("bruno_mission"):
			show_dialog_line("понял", 0, 0, 0, 0, General.dialogue_text("bruno_pesci"))

		elif is_current_line("bruno_pesci"):

				
				
				General.replace_quest(12.31, 12.32)
				close_dialog()


		elif is_current_line("bruno_liar"):
			General.EnemyName = "bucciarati"
			Transition.change_scene("res://GeneralGameScenes/LukaEnemyArena.tscn", "Black")
			General.seconds_get_start = false
			close_dialog()
		
		
		
		
		
		elif is_current_line("conductor_rome"):
			if $TextAnswer.text == General.answer_1:
				if General.money >= 1000:
					General.money -= 1000
					General.other_save["world"] = "rom"
			
					General.save_save()
					General.toGameGeneral("Black", true)
			elif $TextAnswer.text == General.answer_2:
				close_dialog()

		elif is_current_line("conductor_naples"):
			if $TextAnswer.text == General.answer_1:
				if General.money >= 1000:
					General.money -= 1000
					General.other_save["world"] = "italy"
			
					General.save_save()
					General.toGameGeneral("Black", true)
			elif $TextAnswer.text == General.answer_2:
				close_dialog()


		elif is_current_line("johnny_why"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("понял", 0, 0, 0, 0, General.dialogue_text("johnny_task"))

			else:
				close_dialog()
		elif is_current_line("johnny_teach"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("Хорошо", "Потом", 0, 0, 0, General.dialogue_text("johnny_price"))

			else:
				close_dialog()
		elif is_current_line("johnny_hand"):
			if $TextAnswer.text == General.answer_1:
				General.add_quest("Джонни", 2.6, "Валентайн", [Vector2(8, 1)], [], "", "Принесите руку святого трупа одолев Валентайна", "Джонни Джостар", "", false, "", "", "", "Дальнейшее развитие таска")
				close_dialog()
			else:
				close_dialog()
		elif is_current_line("johnny_same_stand"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("Я готов", "Лучше потом", 0, 0, 0, General.dialogue_text("johnny_teacher"))
			else:
				close_dialog()
		elif is_current_line("johnny_teacher"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("По рукам", "Грабеж!", 0, 0, 0, General.dialogue_text("johnny_price"))
			else:
				close_dialog()
		elif is_current_line("johnny_price"):
			if $TextAnswer.text == General.answer_1:
				if General.money >= 3000:
					General.SoundPlay("res://Music/BuySound.mp3")
					General.money -= 3000
					show_dialog_line("как?", 0, 0, 0, 0, General.dialogue_text("johnny_golden_ratio"))


			else:
				close_dialog()
		elif is_current_line("johnny_golden_ratio"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("Чего", 0, 0, 0, 0, General.dialogue_text("johnny_ratio_explain"))
			else:
				close_dialog()
		elif is_current_line("johnny_ratio_explain"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("Но как?", 0, 0, 0, 0, General.dialogue_text("johnny_spiral"))
			else:
				close_dialog()
		elif is_current_line("johnny_spiral"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("Понял", 0, 0, 0, 0, General.dialogue_text("johnny_leaves"))
			else:
				close_dialog()
		elif is_current_line("johnny_leaves"):
			if $TextAnswer.text == General.answer_1:
				General.add_quest("Джонни", 2.1, "Акт 2", [], [], "", "Квест на Таск Акт 2", "Джонни Джостар", "", false, "", "", "Найти 25 идеальных листочков с деревьев", "Возможность развития таска с помощью ребра святого трупа")
				close_dialog()
			else:
				close_dialog()
			
		elif is_current_line("johnny_final_tournament"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
			else:
				close_dialog()
		elif is_current_line("johnny_farewell"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
			if $TextAnswer.text == General.answer_2:
				show_dialog_line("Хорошо!", "Проехали", 0, 0, 0, General.dialogue_text("johnny_buff"))
		elif is_current_line("johnny_buff"):
			if $TextAnswer.text == General.answer_1:
				if General.current_support["Name"] == "None":
					General.create_support("Johny", 10, 0)
					General.message_spawn("Center", "Джонни теперь ваш помощник!")
					close_dialog()
				else:
					General.message_spawn("Center", "У вас уже есть помощник!")
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("johnny_act2_done"):
			if $TextAnswer.text == General.answer_1:
				General.add_quest("Джонни", 2.2, "Акт 3", [], [], "TuskAct2", "Квест на Таск Акт 3", "Джонни Джостар", "Таск Акт 2", false, "", "", "Поговорить с странником, который имеет отверстия в руках", "Возможность развития таск акт 2 с помощью таза святого трупа")
				close_dialog()
				General.message_spawn("Center", "Странника можно встретить в бою. Поговорите с ним, и он даст вам совет.")
			else:
				close_dialog()
		elif is_current_line("johnny_act3_hint"):
			if $TextAnswer.text == General.answer_1:
				General.add_quest("Джонни", 2.3, "Акт 3.5", [], [], "TuskAct3", "Промежуточный этап для таск акт 4", "Джонни Джостар", "Таск Акт 3", false, "PERFECT SPIN", "ИДЕАЛЬНЫЙ СПИН", "", "Возможность противостоять последнему врагу")
				close_dialog()
			else:
				close_dialog()
		elif is_current_line("johnny_quest_taken"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
			else:
				close_dialog()
		elif is_current_line("johnny_act4_wait"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("johnny_act2_complete") or is_current_line("johnny_act3_complete"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("johnny_first_task"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("johnny_act1_reset"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("johnny_act2_item"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("johnny_act1_item"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
	
		elif is_current_line("valentine_teleport_money"):
			if $TextAnswer.text == General.answer_1:
				if General.money >= 25000:
					close_dialog()
					General.money -= 25000
					General.message_spawn("Center", "Вы приобрели телепорт!")
					General.teleport_charges += 1
					General.save_save()
					General.SoundPlay("res://Music/BuySound.mp3", {"Volume_db": 5})
					_show_teleport_panel()


				else:
					General.message_spawn("Center", "У вас нет 25000$")
					close_dialog()
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("valentine_teleport_eye5"):
			if $TextAnswer.text == General.answer_1:
				if General.items_inventory[General.check_array(16)].y > 0:
					General.message_spawn("Center", "Вы приобрели 5 телепорта!")
					General.teleport_charges += 5
					General.save_save()
					
					General.SoundPlay("res://Music/BuySound.mp3", {"Volume_db": 5})
					_show_teleport_panel()
					
					
					

				else:
					General.message_spawn("Center", "У вас нет Глаза Святого трупа!")
					close_dialog()
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("valentine_teleport_eye6"):
			if $TextAnswer.text == General.answer_1:
				if General.items_inventory[General.check_array(16)].y > 0:
					General.message_spawn("Center", "Вы приобрели 6 телепорта!")
					General.teleport_charges += 6
					General.save_save()
					General.SoundPlay("res://Music/BuySound.mp3", {"Volume_db": 5})
					_show_teleport_panel()

				else:
					General.message_spawn("Center", "У вас нет Глаза Святого трупа!")
					close_dialog()
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("valentine_where"):
			General.fast_pos_change = true
			if $TextAnswer.text == General.answer_1:
				General.teleport_pos = "Morio"
				General.teleport_charges -= 1
				General.message_spawn("Center", "Вы успешно телепортировались в морио! У вас осталось " + str(General.teleport_charges) + " телепортации")
				General.save_save()
				close_dialog()
			elif $TextAnswer.text == General.answer_2:
				General.teleport_pos = "Desert"
				General.teleport_charges -= 1
				General.message_spawn("Center", "Вы успешно телепортировались в пустыню! У вас осталось " + str(General.teleport_charges) + " телепортации")
				General.save_save()
				close_dialog()
			elif $TextAnswer.text == General.answer_3:
				General.teleport_pos = "jail"
				General.teleport_charges -= 1
				General.message_spawn("Center", "Вы успешно телепортировались в тюрьму! У вас осталось " + str(General.teleport_charges) + " телепортации")
				General.save_save()
				close_dialog()
			elif $TextAnswer.text == General.answer_4:
				close_dialog()
		
		elif is_current_line("valentine_boss_contract"):
			if $TextAnswer.text == General.answer_1:
				General.add_quest("Польнарефф", 9.1, "Мафия", [Vector2(26, 1)], [], "", "Убийства босса мафии", "Жан Пьер Польнарефф", "", false, "", "", "", "1000$")
				close_dialog()
			if $TextAnswer.text == General.answer_2:
				close_dialog()
		
		elif is_current_line("valentine_dio_contract"):
			if $TextAnswer.text == General.answer_1:
				General.add_quest("Спидвагон", 10.1, "Вампир", [Vector2(27, 1)], [], "", "Убийства Дио", "Спидвагон", "", false, "", "", "", "10€")
				close_dialog()
			if $TextAnswer.text == General.answer_2:
				close_dialog()
		
		elif is_current_line("valentine_conditions"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		
		elif is_current_line("cyborg_offer"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("Хорошо", "...", 0, 0, 0, General.dialogue_text("cyborg_materials"))
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("cyborg_materials"):
			if $TextAnswer.text == General.answer_1:
				General.add_quest("Штройхам", 8.1, "Этап 1", [Vector2(28, 10)], [Vector2(28, 1)], "", "Путь к модификации", "Штройхам", "", false, "", "", "", "")
				close_dialog()
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("cyborg_controls"):
			if $TextAnswer.text == General.answer_1:

				General.TalentTreeReset("race")
				General.race_number = 5
				General.update_stats()
				close_dialog()
				General.message_spawn("Center", "Вы вспомнили управление техникой киборга!")


			elif $TextAnswer.text == General.answer_2:
				close_dialog()
	
		elif is_current_line("cyborg_chip"):
			if $TextAnswer.text == General.answer_1:
				General.add_quest("Штройхам", 8.2, "Этап 2", [Vector2(28, 15)], [Vector2(28, 1)], "", "Путь к окончательной модификации", "Штройхам", "", false, "", "", "", "")
				close_dialog()
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("cyborg_future"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("cyborg_arms"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		
		
		elif is_current_line("cyborg_need"):
			
			if $TextAnswer.text == General.answer_1:
				General.SoundPlay("res://Music/ManVoice_0.mp3", {"Volume_db": 5})
				show_dialog_line("Рассказали", "Проехали", 0, 0, 0, General.dialogue_text("gyro_spin_deny"))
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("gyro_remember"):
			if $TextAnswer.text == General.answer_1:
				General.techic_number = 2
				close_dialog()
				General.message_spawn("Center", "Вы вспомнили технику идеального вращения!")
			elif $TextAnswer.text == General.answer_2:
					show_dialog_line("Хорошо", "Проехали", 0, 0, 0, General.dialogue_text("gyro_eye_pizza"))
			elif $TextAnswer.text == General.answer_3 and General.current_support["Name"] == "None":
					show_dialog_line("Хорошо", "Дорого!", 0, 0, 0, General.dialogue_text("gyro_service_1m"))
			elif $TextAnswer.text == General.answer_3 and General.current_support["Name"] != "None":
					General.message_spawn("Center", "У вас уже есть помощник!")
					close_dialog()
			elif $TextAnswer.text == General.answer_4:
				close_dialog()
		elif is_current_line("gyro_spin_deny"):
			if $TextAnswer.text == General.answer_1:
				General.SoundPlay("res://Music/GyroHeheheheVoice.mp3", {"Volume_db": 5})
				show_dialog_line("Ладно?", 0, 0, 0, 0, General.dialogue_text("gyro_first_lesson"))
				General.add_quest("Джайро", 3, "Спин", [Vector2(7, 8)], [], "", "Квест на Спин", "Джайро Цеппели", "", false, "", "", "", "Задания для Спина")
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("gyro_first_lesson"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("gyro_balls_task"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
				General.add_quest("Джайро", 3.1, "Спин 2", [Vector2(11, 5)], [Vector2(11, 1)], "", "Квест на Спин (Этап 2)", "Джайро Цеппели", "", false, "", "", "", "")
		elif is_current_line("gyro_practice_ready"):
			if $TextAnswer.text == General.answer_1:
				General.SoundPlay("res://Music/ManVoice_0.mp3", {"Volume_db": 5})
				show_dialog_line("Понял", "Чего?", 0, 0, 0, General.dialogue_text("gyro_cork_timer"))
				General.add_quest("Джайро", 3.2, "Спин 3", [Vector2(13, 1)], [Vector2(13, 1)], "", "Квест на Спин (Этап 3)", "Джайро Цеппели", "", false, "", "", "Пройти Испытание с Пробкой", "")
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("gyro_cork_timer"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
			if $TextAnswer.text == General.answer_2:
				show_dialog_line("Понял", 0, 0, 0, 0, General.dialogue_text("gyro_cork_zone"))
		elif is_current_line("gyro_cork_zone"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("gyro_ball_practice"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
				General.add_quest("Джайро", 3.3, "Спин 4", [], [], "", "Квест на Спин (Этап 4)", "Джайро Цеппели", "", false, "", "", "Пройти Испытание с Стальным Шаром", "Конец обучения обычного спина.")
		elif is_current_line("gyro_final"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("gyro_quest_taken"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("gyro_perfect"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
			elif $TextAnswer.text == General.answer_2:
					show_dialog_line("Хорошо", "Проехали", 0, 0, 0, General.dialogue_text("gyro_eye_pizza"))
			elif $TextAnswer.text == General.answer_3 and General.current_support["Name"] == "None":
					show_dialog_line("Хорошо", "Дорого!", 0, 0, 0, General.dialogue_text("gyro_service_1m"))
			elif $TextAnswer.text == General.answer_3 and General.current_support["Name"] != "None":
					General.message_spawn("Center", "У вас уже есть помощник!")
					close_dialog()
		elif is_current_line("gyro_eye_pizza"):
				if $TextAnswer.text == General.answer_1:
					General.add_quest("Джайро", 3.7, "Святой", [Vector2(7, 100)], [Vector2(16, 1)], "", "Получение Глаза Святого Трупа", "Джайро Цеппели", "", true, "", "", "", "")
					close_dialog()
				elif $TextAnswer.text == General.answer_2:
					close_dialog()
		elif is_current_line("gyro_service_1m"):
				if $TextAnswer.text == General.answer_1:
					if General.money >= 1000000:
						General.create_support("Gyro", 20, 1000000)
						General.money -= 1000000
						General.message_spawn("Center", "Джайро теперь ваш помощник!")
						General.save_save()
					else:
						General.message_spawn("Center", "У вас недостаточно средств!")
					close_dialog()
				elif $TextAnswer.text == General.answer_2:
					close_dialog()
		elif is_current_line("gyro_next_stage"):
				if $TextAnswer.text == General.answer_1:
					show_dialog_line("приступаем!", "позже", 0, 0, 0, General.dialogue_text("gyro_doppelganger"))
				elif $TextAnswer.text == General.answer_2:
					close_dialog()
		elif is_current_line("gyro_doppelganger"):
				if $TextAnswer.text == General.answer_1:
					
					General.add_quest("Джайро", 3.8, "Вращение", [], [], "", "Улучшение навыков вращения", "Джайро Цеппели", "", false, "", "", "Убить двойника джайро", "Первый навык вращения")
					close_dialog()
				elif $TextAnswer.text == General.answer_2:
					close_dialog()
		elif is_current_line("gyro_leave"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
				show_gyro_quest_hint()
		elif is_current_line("gyro_no_balls"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("...", 0, 0, 0, 0, General.dialogue_text("gyro_leave"))
			else:
				close_dialog()
		
		
		
		elif is_current_line("gyro_discs_service"):
			if $TextAnswer.text == General.answer_2:
				var disc_index = General.check_array(General.items_shop[5]["ID"])
				var disc_count = 0
				if disc_index != - 1:
					disc_count = General.items_inventory[disc_index].y
				if disc_count >= 20 and General.current_support["Name"] == "None":
					General.create_support("Pucci", 15, 20)
					General.message_spawn("Center", "Пуччи теперь ваш помощник!")
					General.remove_item(2, 20, 1)
					General.save_save()
					close_dialog()
				elif General.current_support["Name"] != "None":
					General.message_spawn("Center", "У вас уже есть помощник!")
				elif disc_count < 20:
					General.message_spawn("Center", "У вас недостаточно сломанных дисков!")
					
			elif $TextAnswer.text == General.answer_1:
				close_dialog()
				
		elif is_current_line("johnny_same_type"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("Держи", "Потом", 0, 0, 0, General.dialogue_text("johnny_service_5000"))
					
			elif $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("pucci_jotaro_disk"):
			if $TextAnswer.text == General.answer_1:
				General.add_quest("", 11.2, "", [], [], "", "", "", "", false, "", "", "", "")
				General.remove_item(22, 1, 1)

				show_dialog_line("Давай", 0, 0, 0, 0, General.dialogue_text("pucci_plan"))
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("pucci_plan"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("Давай", 0, 0, 0, 0, General.dialogue_text("pucci_green_baby"))
		elif is_current_line("pucci_power"):
			if $TextAnswer.text == General.answer_1:
				General.remove_quest(11.2)
				General.add_item(22, 1, 1)
				show_dialog_line("понял", 0, 0, 0, 0, General.dialogue_text("pucci_desert"))
		elif is_current_line("pucci_desert"):
			if $TextAnswer.text == General.answer_1:
					close_dialog()
		elif is_current_line("pucci_heaven"):
			if $TextAnswer.text == General.answer_1:
					close_dialog()
		elif is_current_line("johnny_service_5000"):
			if $TextAnswer.text == General.answer_1:
				if General.money >= 5000:
					General.money -= 5000
					General.add_quest("", 11.0, "", [], [], "", "", "", "", false, "", "", "", "")
					
					show_dialog_line("Понял", 0, 0, 0, 0, General.dialogue_text("pucci_cmoon"))
					
				else:
					close_dialog()
					General.message_spawn("Center", "У тебя нету 5000$!")
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
				
		elif is_current_line("pucci_cmoon"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
				
		elif is_current_line("pucci_discs_offer"):
			if $TextAnswer.text == General.answer_1:
				General.add_quest("Пуччи", 4, "Деньги", [Vector2(3, 5)], [], "", "Квест на Деньги", "Энрико Пуччи", "", true, "", "", "", "2000$")
				close_dialog()
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("pucci_dio_power"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("Хорошо", "Потом", 0, 0, 0, General.dialogue_text("pucci_dio_disk"))
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("pucci_dio_disk"):
			if $TextAnswer.text == General.answer_1:
				General.add_quest("Пуччи", 4.1, "Диск", [Vector2(3, 200)], [Vector2(17, 1)], "", "Квест на диск обретение полной силы стенда", "Энрико Пуччи", "", true, "", "", "", "")
				close_dialog()
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("pucci_conditions"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("cyborg_laser"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("chemist_greeting"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("ясно", "что дальше?", 0, 0, 0, General.dialogue_text("chemist_palladium"))
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("chemist_palladium"):
			if $TextAnswer.text == General.answer_2:
				show_dialog_line("ясно", "царская водка? что?", 0, 0, 0, General.dialogue_text("chemist_sludge"))

			elif $TextAnswer.text == General.answer_1:
				close_dialog()
				
		elif is_current_line("chemist_sludge"):
			if $TextAnswer.text == General.answer_2:
		
				show_dialog_line("ясно", "где её взять?", 0, 0, 0, General.dialogue_text("chemist_aqua_regia"))
			elif $TextAnswer.text == General.answer_1:
				close_dialog()
				
		elif is_current_line("chemist_aqua_regia"):
			if $TextAnswer.text == General.answer_2:
				if ("carsky" in General.other_save["slow"]) == false: General.other_save["slow"].append("carsky")
				General.save_save()
				show_dialog_line("ок", "где твой френд?", 0, 0, 0, General.dialogue_text("chemist_friend"))
			elif $TextAnswer.text == General.answer_1:
				close_dialog()
		
		
		elif is_current_line("chemist_friend"):
			if $TextAnswer.text == General.answer_2:
				show_dialog_line("понял", 0, 0, 0, 0, General.dialogue_text("chemist_upstairs"))
			elif $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("merchant_greeting"):
			General.SoundPlay("res://Music/ManVoice_0.mp3", {"Volume_db": 5})
			if $TextAnswer.text == General.answer_2:
				show_dialog_line("пока", "да", 0, 0, 0, General.dialogue_text("merchant_bag"))
			elif $TextAnswer.text == General.answer_1:
				close_dialog()
		
		elif is_current_line("merchant_bag"):
			if $TextAnswer.text == General.answer_2:
				show_dialog_line("сколько сколько?!", "я согласен!", "пока", 0, 0, General.dialogue_text("merchant_vodka"))
			elif $TextAnswer.text == General.answer_1:
				close_dialog()
		
		elif is_current_line("merchant_vodka"):
			if $TextAnswer.text == General.answer_1:
				General.SoundPlay("res://Music/ManVoice_0.mp3", {"Volume_db": 5})
				show_dialog_line("ладно(", "шуткааа!", 0, 0, 0, General.dialogue_text("merchant_poor"))
			elif $TextAnswer.text == General.answer_2:
				if General.money >= 5000:
					General.money -= 5000
					General.SoundPlay("res://Music/BuySound.mp3")
					General.add_item(42, 1)
					General.save_save()
					General.SoundPlay("res://Music/ManVoice_0.mp3", {"Volume_db": 5})
					show_dialog_line("да", 0, 0, 0, 0, General.dialogue_text("merchant_acid"))
				else:
					show_dialog_line("ладно", 0, 0, 0, 0, General.dialogue_text("merchant_not_enough"))

			elif $TextAnswer.text == General.answer_3:
				close_dialog()
				
				
		elif is_current_line("merchant_poor"):
			if $TextAnswer.text == General.answer_2:
				if General.money >= 90000:
					General.money -= 90000
					General.SoundPlay("res://Music/BuySound.mp3")
					General.add_item(42, 1)
					General.SoundPlay("res://Music/ManVoice_0.mp3", {"Volume_db": 5})
					show_dialog_line("да", 0, 0, 0, 0, General.dialogue_text("merchant_acid2"))
				else:
					show_dialog_line("ок...", 0, 0, 0, 0, General.dialogue_text("merchant_joke"))
			elif $TextAnswer.text == General.answer_1:
				close_dialog()
				
				
				
				
		elif is_current_line("mechanic_greeting"):
			if $TextAnswer.text == General.answer_1:
				General.player_pos_save = General.player_pos
				General.save_save()
				Transition.change_scene("res://Scenes/CyborgShop.tscn", "Black")
				
				
				
				
				
				
		elif is_current_line("soldier_greeting"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("понятно", 0, 0, 0, 0, General.dialogue_text("scientist_uranium"))
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
				
				
				
				
				
		elif is_current_line("scientist_reactor"):
			if $TextAnswer.text == General.answer_1:
				General.remove_item(38, 1, 1)
				General.other_save["CybSh"][1].append(0)
			close_dialog()
		elif is_current_line("scientist_fusion"):
			if $TextAnswer.text == General.answer_1:
				General.remove_item(39, 1, 1)
				General.other_save["CybSh"][1].append(1)
			close_dialog()









		elif is_current_line("money_gone"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("pucci_disk_use"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("pucci_diary"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		
		elif is_current_line("dio_plan"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("Дальше", "...", 0, 0, 0, General.dialogue_text("dio_blood"))
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("dio_blood"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("Дальше", "...", 0, 0, 0, General.dialogue_text("dio_stranger"))
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("dio_stranger"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("Дальше", "...", 0, 0, 0, General.dialogue_text("dio_parts"))
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("dio_parts"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("Дальше", "...", 0, 0, 0, General.dialogue_text("dio_bone"))
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("dio_bone"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("Дальше", 0, 0, 0, 0, General.dialogue_text("dio_heaven"))
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("dio_heaven"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		elif is_current_line("dio_bone_price"):
			if $TextAnswer.text == General.answer_1:
				General.add_quest("Дневник", 5, "Небеса", [Vector2(6, 10)], [Vector2(19, 1)], "", "Квест на получение кости", "Дневник", "", false, "", "", "", "Кость дио достигшего рая")
				
				close_dialog()
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
		elif is_current_line("dio_challenge"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
				Transition.change_scene("res://GeneralGameScenes/DefaultEnemyArena.tscn", "Black")
			if $TextAnswer.text == General.answer_2:
				close_dialog()
		
		
		elif is_current_line("jesus_advice1"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("...", 0, 0, 0, 0, General.dialogue_text("jesus_advice2"))
			elif $TextAnswer.text == General.answer_2:
				close_dialog()
				General.enemy_block_all = false
				General.player_block_all = false
		elif is_current_line("jesus_advice2"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("...", 0, 0, 0, 0, General.dialogue_text("jesus_advice3"))
		elif is_current_line("jesus_heaven"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("...", 0, 0, 0, 0, General.dialogue_text("jesus_worthy"))
		elif is_current_line("jesus_advice3"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
				General.jesus_dialog_complete = true
				General.enemy_block_all = false
				General.player_block_all = false
				General.save_save()
		elif is_current_line("jesus_worthy"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
				General.twoh_complete_quest["jesus"] = true
				General.enemy_block_all = false
				General.player_block_all = false
				General.save_save()
		elif is_current_line("jesus_early"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
				General.enemy_block_all = false
				General.player_block_all = false
		elif is_current_line("jesus_given"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
				General.enemy_block_all = false
				General.player_block_all = false

		elif is_current_line("gyro_thanks"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("...", 0, 0, 0, 0, General.dialogue_text("johnny_golden"))
		elif is_current_line("doppio_help"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("Хорошо", 0, 0, 0, 0, General.dialogue_text("doppio_swap"))
		elif is_current_line("doppio_swap"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
				General.stand_number = 8
				General.AchievementGive(20)
				General.player_statistic["KingCrimson"] = 1
				General.message_spawn("Center", "Вы обрели полную силу своего стенда....")
				General.save_save()
		elif is_current_line("johnny_golden"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("...", 0, 0, 0, 0, General.dialogue_text("valentine_tusk4"))
				General.AchievementGive(24)
				General.stand_number = 11
				General.stand_activated = true
				General.stand_activate_activated = true
				
				General.save_save()
				

				
		elif is_current_line("valentine_tusk4"):
			if $TextAnswer.text == General.answer_1:
				show_dialog_line("...", 0, 0, 0, 0, General.dialogue_text("arigato"))
				General.player_block_all = false
		elif is_current_line("arigato"):
			if $TextAnswer.text == General.answer_1:
				close_dialog()
		else:
			close_dialog()

# Проверить, показана ли сейчас реплика с указанным ключом из Data/Dialogues.gd.
func is_current_line(dialogue_id):
	return General.text_dialog == General.dialogue_text(dialogue_id)


# Показать новую реплику и до пяти вариантов ответа.
# answer_1..answer_5 — тексты кнопок; 0 означает, что кнопка скрыта.
# text — сама реплика NPC; её берут из Data/Dialogues.gd.
func show_dialog_line(answer_1, answer_2, answer_3, answer_4, answer_5, text):
	General.answer_1 = answer_1
	General.answer_2 = answer_2
	General.answer_3 = answer_3
	General.answer_4 = answer_4
	General.answer_5 = answer_5
	General.text_dialog = text
	General.dialog_recheck = true


# Закрыть диалоговое окно. Окончательную очистку делает DialogWindow.
func close_dialog():
	General.dialog_destroy_signal = true


# Подсказка, если игрок ещё не получил задание Джонни.
func show_gyro_quest_hint():
	General.message_spawn("Center", "Что-бы взять квест у джайро вам надо получить одно из заданий джонни")
