# GeneralStateService.gd — инициализация и синхронизация полей General.
#
# Контракт: physics_process() заполняет отсутствующие поля старых сейвов и
# обновляет производные индексы stand/technic/race. Новые поля состояния
# добавляйте с безопасным значением по умолчанию.

extends Reference


func physics_process(general):
	if general.race_number == 5 and ("Cyborg" in general.other_save) == false:
		general.other_save["Cyborg"] = [[], [["", "", ""], "", "", "", "", "", "", "", "", ""]]
	
	
	if not ("spin" in general.Addition):
				general.Addition["spin"] = 0.0
	if Input.is_action_just_pressed("Z"):
		general.BeatDownCharge = 333
	general.delete_support()
	general.stand_power()
	general.player_power()
	var stand_def = general.content_db().get_stand(general.stand_number)
	general.stand_index = str(stand_def.get("index", "None"))
	var stand_direction = str(stand_def.get("direction", ""))
	if stand_direction != "":
		general.stand_direction_set = stand_direction
	var technic_def = general.content_db().get_technic(general.techic_number)
	general.techic_index = str(technic_def.get("index", "None"))
	if general.build_version == null:
		general.build_version = 0.122
	if general.global_bonus == null:
		general.global_bonus = {
	"money": 1, 
	"exp": 1
}
	if general.sedwc_version == null:
		general.sedwc_version = 0
	if general.all_skins == null:
		general.all_skins = []
	if general.donate == null:
		general.donate = []
	if general.choose_skins == null:
		general.choose_skins = {
			"spin": "default"
		}
	if general.s_coins == null:
		general.s_coins = 0
	if general.talents == null:
		general.talents = {"race": [], "technic": [], "stand": []}
	if general.player_statistic == null:
		general.player_statistic = {}
	if general.kills == null:
		general.kills = 0
	if general.deaths == null:
		general.deaths = 0
	if general.quequ_achiev == null:
		general.quequ_achiev = []
	if general.egg_coin == null:
		general.egg_coin = 0
	if general.play_time == null:
		general.play_time = 0
	if general.egg_lvl == null:
		general.egg_lvl = 1
	if general.egg_upgrade == null:
		general.egg_upgrade = {
	"power": 0, 
	"auto_count": 0, 
	"auto_power": 0, 
	"chance_double": 0
	}
	if general.timer_grass == null:
		general.timer_grass = 1
	if general.points == null:
		general.points = 0
	if general.make_dur == null:
		general.make_dur = false
	if general.loading == null:
		general.loading = false
	if general.smokes == null:
		general.smokes = []
	if general.day == null:
		general.day = 0
	if general.teleport_charges == null:
		general.teleport_charges = 0
	if general.grasses == null:
		general.grasses = []
	if general.cyborg_arms == null:
		general.cyborg_arms = 0
	if general.event_coins == null:
		general.event_coins = 0
	if general.talents_buff == null:
		general.talents_buff = {}
	if general.sb_items == null:
		general.sb_items = {
			"roka": 0, 
			"arrow": 0, 
			"disc": 0, 
			"gold_roka": 0, 
			"pizza": 0, 
			"broken_disk": 0
		}
	if general.bonus_player == null:
		general.bonus_player = {
	"health": 0, 
	"dmg_gg": 0, 
	"dmg_st": 0
	}
	if general.player_name == null or str(general.player_name).strip_edges() == "":
		general.player_name = "Игрок"
	if general.limit_player == null:
		general.limit_player = {
	"hp": 0, 
	"dmg_gg": 0, 
	"dmg_st": 0
	}
	if general.twoh_complete_quest == null:
		general.twoh_complete_quest = {
	"blood": 0.0, 
	"arrow": false, 
	"jesus": false, 
	"eye": 0, 
	"arms": 0, 
	"pelvis": false, 
	"rib": false, 
	"bone": false
	}
	if general.race_number == null:
		general.race_number = 0
	if general.race_index == null:
		general.race_index = "human"
	general.race_index = str(general.content_db().get_race(general.race_number).get("index", "human"))
	if general.throwing_spinb == null:
		general.throwing_spinb = 0
	if general.hands_opens == null:
		general.hands_opens = {
	"slow": false, 
	"agility": false, 
	"blood": false
		}
	if general.add_hand_crit == null:
		general.add_hand_crit = 0
	if general.tournir_record == null:
		general.tournir_record = 0
	if general.npc_dead_spin == null:
		general.npc_dead_spin = 0
	if general.techic_all == null:
		general.techic_all = []
	if general.houses == null:
		general.houses = ["Street"]
	if general.hous_contains == null:
		general.hous_contains = {
	"roof": "", 
	"facad": "", 
	"windows": ""
}
	if general.current_support == null:
		general.current_support = {
	"Name": "None", 
	"Cost": 0, 
	"Fights": 0
}
	if general.talents_score == null:
		general.talents_score = 0
	if general.add_attacks_spin == null:
		general.add_attacks_spin = 0
	if general.add_damage_spin == null:
		general.add_attacks_spin = 0
	if general.add_time_spin == null:
		general.add_time_spin = 0
	if general.add_hand_damage == null:
		general.add_hand_damage = 0
	if general.quests == null:
		general.quests = []
	if general.complete_quests == null:
		general.complete_quests = []
	if general.level_points == null:
		general.level_points = 1
	if general.expirience_points == null:
		general.expirience_points = 0
	if general.stand_number == null:
		general.stand_number = 0
	if general.techic_number == null:
		general.techic_number = 0
	if general.items_inventory == null:
		general.items_inventory = [Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0)]
	if general.hp_max == null:
		general.hp_max = 100
	if general.mini_true_game_complete == null:
		general.mini_true_game_complete = false
	if general.money == null:
		general.money = 0
	if general.euro == null:
		general.euro = 0
	if general.pucci_money_quest == null:
		general.pucci_money_quest = 10000
	if general.speedwagond_dialog_start == null:
		general.speedwagond_dialog_start = false
	if general.camera_speed == null:
		general.camera_speed = 7
	if general.block_glush == null:
		general.block_glush = Timer.new()
		general.timer_service.ensure_autoload_timer(general, general.block_glush)
	if general.tea_timer == null:
		general.tea_timer = Timer.new()
		general.timer_service.ensure_autoload_timer(general, general.tea_timer)
	if general.grass_collect == null:
		general.grass_collect = Timer.new()
		general.timer_service.ensure_autoload_timer(general, general.grass_collect)
	if general.glush_enemy_timer == null:
		general.glush_enemy_timer = Timer.new()
		general.timer_service.ensure_autoload_timer(general, general.glush_enemy_timer)
	if general.nail_timer == null:
		general.nail_timer = Timer.new()
		general.timer_service.ensure_autoload_timer(general, general.nail_timer)
	if general.camera_scale == null:
		general.camera_scale = Vector2(1, 1)
	if general.combo_enemy_timer == null:
		general.combo_enemy_timer = Timer.new()
		general.timer_service.ensure_autoload_timer(general, general.combo_enemy_timer)
	if general.combo_timer == null:
		general.combo_timer = Timer.new()
		general.timer_service.ensure_autoload_timer(general, general.combo_timer)
	if general.fps_show_enabled == null:
		general.fps_show_enabled = false
	if general.activate_codes == null:
		general.activate_codes = []
	if general.money_indicator_cratco == null:
		general.money_indicator_cratco = false
	if general.jesus_dialog_complete == null:
		general.jesus_dialog_complete = false
	if general.tree_gold_mini_game_completed == null:
		general.tree_gold_mini_game_completed = 0
	if general.expirience_points >= (10 * general.level_points) * 1.5 and general.level_points < 100:
		general.expirience_points -= (10 * general.level_points) * 1.5
		general.level_points += 1
		general.points += 1
	elif general.expirience_points >= (10 * general.level_points) * 1.5 and general.level_points >= 100 and general.level_points < 200:
		general.expirience_points -= (10 * general.level_points) * 1.5
		general.level_points += 1
		general.s_coins += 2
	if general.day_night_animation_second == null:
		general.day_night_animation_second = 0
	if general.enabled_to_check_current_scene:
		general.current_scene_name = general.get_tree().current_scene.name
	if general.time == null:
		general.time = "day"
	if general.db_music == null:
		general.db_music = - 10.0
	if general.db_sfx == null:
		general.db_sfx == - 5.0
	if general.music_enabled == null:
		general.music_enabled = true
	if general.sfx_enabled == null:
		general.sfx_enabled = true
	if general.stand_slots == null:
		general.stand_slots = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	if general.is_money_loosed == null:
		general.is_money_loosed = false
	
	if general.run_activate:
		general.run_scale = 1.3
	else:
		general.run_scale = 1.0
	
	if general.stand_slots.size() < 12:
		for i in range(12 - general.stand_slots.size()):
			general.stand_slots.append(0)
		general.save_save()
	if general.nail_timer.is_stopped() and general.nail_count.count(1) < 10:
		general.nail_timer_start()
	if general.nail_count.size() > 10 or general.nail_count.count(10) > 10:
		for i in range(10 - general.nail_count.size()):
			general.nail_count.pop_back()
	general.audio_settings_check()
