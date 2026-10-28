# Transition.gd — затемнение и смена сцены.
#
# Контракт: change_scene() сохраняет позицию игрока, сбрасывает боевые
# таймеры и переключает сцену. General.play_timer не трогайте: он должен
# переживать переходы, иначе play_time и достижения времени ломаются.

extends CanvasLayer

func change_scene(target, type):
	if $AnimationPlayer.current_animation == "Idle" or $AnimationPlayer.current_animation == "":
		if true:
			General.PathCurrentScene = target
			if get_tree().current_scene.name.find("Arena") != - 1:
				General.WasInArena = true
			if get_tree().current_scene.name.find("TrainingArena") != - 1:
				General.load_save()


			
			if General.race_number == 5 and General.other_save["Cyborg"][1][3] != "" and General.other_save["Cyborg"][1][6] != "":
				General.persist_cyborg_battery_to_save()
			
			
			
			
			if General.stand_number == 19:
				General.stand_number = 18
			
			General.battery_charge = 100
			General.debuff_enemy = ""
			General.global_debuffs = {"hand_fear": false}
			General.global_buffs = {"johny_awakeng": false}
			General.player_block_all = true
			General.enemy_block_all = true
			General.mih_speed = 1.0
			if target.find("Arena") == - 1:
				General.fight_with = 0
			if type == "White":
				$AnimationPlayer.play("TrnstUpWht")
				yield($AnimationPlayer, "animation_finished")
				get_tree().change_scene(target)
				yield(get_tree().create_timer(0.5), "timeout")
				$AnimationPlayer.play("TrnstDownWht")
			elif type == "Black":
				$AnimationPlayer.play("TrnstUp")
				yield($AnimationPlayer, "animation_finished")
				get_tree().change_scene(target)
				yield(get_tree().create_timer(0.5), "timeout")
				$AnimationPlayer.play("TrnstDown")
			elif type == "D4C":
				$AnimationPlayer.play("TrnstUpD4C")
				yield($AnimationPlayer, "animation_finished")
				get_tree().change_scene(target)
				yield(get_tree().create_timer(0.0), "timeout")
				$AnimationPlayer.play("TrnstDownD4C")
				
				
				
			General.block_type = "None"
			General.player_attack_activate = false
			General.is_invent_show = false
			General.dialog_activate = false
			General.mini_game_activate = false
			General.qa_activate = false
			General.catscene_activated = false
			General.settings_activate = false
			General.is_bubble_beyound_activate = false
			General.kd_end = false
			General.blocked = false
			General.dashed = false
			General.bubble_go_beyound_start_activate = false
			General.podrobnosti_activate = false
			General.quest_panel_activate = false
			General.qa_text_activate = false
			General.epitafia_enabled = false
			General.time_erase = false
			General.attacked = false
			General.metka_tree_enabled = true
			General.time_stop = false
			General.dostup_combo = true
			General.barrage_activate = false
			General.enemy_time_scale = 1.0
			General.enemy_current_status = []
			# Таймеры General не пересоздаём: старые экземпляры оставались бы
			# без родителя. Сервис останавливает их и отцепляет от старых сцен.
			General.timer_service.reset_for_scene_change(General)
			General.is_bubble_beyound_activate = false
			General.stands_panel_activate = false
			BlackLinesVertical.end_lines()
			General.Addition.clear()
			yield($AnimationPlayer, "animation_finished")
			$AnimationPlayer.play("Idle")
			if target == "res://GeneralGameScenes/Italy.tscn":
				General.AchievementGive(36)
		General.player_block_all = false
		General.enemy_block_all = false

func NewAchievent(ID: int):
	var da = preload("res://Scenes/NewAchiev.tscn").instance()
	da.ID = ID
	$VBoxContainer.add_child(da)
	yield(get_tree().create_timer(4), "timeout")
	$VBoxContainer.rect_size.y = 0
