# GENERAL.gd — автолоад SEDWC Classic и фасад состояния игры.
#
# Здесь живёт состояние, которое переживает смену сцен: инвентарь, квесты,
# деньги, здоровье, таймеры и сохранение. Игровая логика живёт в Systems/*,
# данные — в Data/*.gd (доступ через content_db()).
#
# Моддинг:
# - публичные ID предметов — 0-based; слоты items_inventory — 1-based;
# - новые данные добавляйте в Data/*.gd, а не в match-таблицы;
# - не переставляйте SAVE_FIELDS в Persistence/SedwcSaveProfile.gd;
# - play_time живёт на General.play_timer, не на General.timer.

extends Node

var general_state_service = preload("res://Systems/GeneralStateService.gd").new()
var general_process_service = preload("res://Systems/GeneralProcessService.gd").new()
var stats_service = preload("res://Systems/StatsService.gd").new()
var player_damage_service = preload("res://Systems/PlayerDamageService.gd").new()
var enemy_damage_service = preload("res://Systems/EnemyDamageService.gd").new()
var quest_service = preload("res://Systems/QuestService.gd").new()
var inventory_service = preload("res://Systems/InventoryService.gd").new()
var timer_service = preload("res://Systems/GeneralTimerService.gd").new()
var display_service = preload("res://Systems/DisplayService.gd").new()
var player_state_service = preload("res://Systems/PlayerStateService.gd").new()
var economy_service = preload("res://Systems/EconomyService.gd").new()
var save_service = preload("res://Systems/GeneralSaveService.gd").new()
var audio_service = preload("res://Systems/GeneralAudioService.gd").new()

const SedwcContentScript = preload("res://Data/SedwcContent.gd")
const SedwcSaveProfileScript = preload("res://Persistence/SedwcSaveProfile.gd")
var content = null
# Формат, миграции и список сохраняемых полей — в SedwcSaveProfile.gd.
var save_profile = SedwcSaveProfileScript.new()

# Ленивая загрузка Data/*.gd. Не создавайте SedwcContent вручную в сценах.
func content_db():
	if content == null:
		content = SedwcContentScript.new().load_all()
	return content


func dialogue_text(dialogue_id):
	# {player} — локальное имя игрока, без аккаунта и сети.
	return content_db().get_dialogue_text(dialogue_id).replace("{player}", str(player_name))


func dialogue_id(text):
	return content_db().get_dialogue_id(text)


var PathCurrentScene = ""
var left_block_position = Vector2.ZERO
var right_block_position = Vector2.ZERO
var top_block_position = Vector2.ZERO
var bottom_block_positon = Vector2.ZERO

var all_skins = []
var choose_skins = {}


var egg_coin = 0
var egg_lvl = 1
var egg_upgrade = {}
var merchant_info = {}
var count = 5
var blood = 0
var enemy_position = Vector2.ZERO
onready var item_create = preload("res://Scenes/Item.tscn")
var random = RandomNumberGenerator.new()
onready var timer_spin = Timer.new()
onready var timer = Timer.new()
onready var nail_timer = Timer.new()
onready var merchant_timer = Timer.new()
var smokes = []
var build_version = 0.122
var block_type = "None"
var throwing_spinb = 0
var npc_dead_spin = 0
var points = 0
var s_coins = 0
var day = 0
var deaths = 0
var kills = 0
var play_time = 0
var houses = []
var hous_contains = {}
var loading = false
var stand = {}
var battery_charge = 100
var cyborg_arms = 0
var talents_buff = {}
var sb_items = {}
var sedwc_version = 0
var stand_power = 1.0
var timer_health_regen = Timer.new()
var debuff_enemy = ""
var race_number = 0
var talents: Dictionary = {"race": [], "technic": [], "stand": []}
var extra_heal = 0
var race_index = "human"
var stand_index = "None"
var stand_number = 0
var buy_garden = false
var techic_index = "None"
var techic_number = 0
var steam_tree = ""
var timer_grass = 1
var current_grass_id = 0
var grass_around = false
var grasses = []








var WasInArena: bool
var global_buffs = {}







var techic_all = []
var item_in_arm = "0"
var items_inventory = [Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0)]
onready var message = preload("res://Scenes/Message.tscn")
onready var message_r = preload("res://Scenes/MessageRight.tscn")
onready var message_l = preload("res://Scenes/MessageLeft.tscn")
var check_array_invnet = 0
var velocity_player = Vector2.ZERO
var player_pos = Vector2.ZERO
var dialog_create_signal = false
var dialog_destroy_signal = false
var dialog_recheck = false
var player_on_ysort_area = false
var player_pos_save = Vector2()
var fast_pos_change = false
var is_invent_show = false
var stand_pos = Vector2.ZERO
var vfx_stand_random = "TuskAct1"
var signal_reset_spin_bar_lesson = false
var text_message = ""
var message_activate = false
var stand_direction_set = "Left"
signal arrow_activated
var catscene_activated = false
var pucci_money_quest = 10000
var nail_count = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
var player_scale = 1
var player_warning_position = Vector2.ZERO
onready var damage_effect = preload("res://Scenes/DamageVFX.tscn")
var block_damage = false
var damage_text = "-0"
var camera_scale = Vector2(1, 1)



var current_achiviement = {}
var quequ_achiev = []

var gold_listya_count = 0
var tree_gold_mini_game_completed = 0


var is_tournir = false
var LastToutnamentLvl: int
var tournament_lvl = 1
var tournir_record = 0
var tournir_all_reward_items = {}
var tournir_character = ""
var tournir_money_reward = 0
var make_dur = false



var twoh_complete_quest = {}
var bonus_player = {}
var limit_player = {}
var global_bonus = {}
var global_debuffs = {}
var add_time_spin = 0
var add_damage_spin = 0
var add_attacks_spin = 0
var add_hand_damage = 0
var add_hand_crit = 0
var hands_opens = {
	"slow": false, 
	"agility": false, 
	"blood": false
	}

var answer_1 = 0
var answer_2 = 0
var answer_3 = 0
var answer_4 = 0
var answer_5 = 0
var text_dialog = ""
var dialog_activate = false
var text_get_animated = false
var npc_name = ""
var npc_eng_name = ""
var text_speed = 0.05
var collision_npc = Vector2.ZERO
var qa_text = ""
var enemy_collision_name = "None"
var enemy_collision_stats = {
	"NAME": enemy_collision_name, 
	"NAMERUS": "", 
	"DMG": 0, 
	"HP": 0, 
	"DEF": 0, 
	"OSOBENNOSTI": "", 
	"OSOBENNOSTIRUS": "", 
	"RAGE": 0, 
	"REWARD_TEXT": ""
}
var enemy_list = []
var enemy_direct = "left"
var enemy_block_all = false
var current_support = {
	"Name": "None", 
	"Cost": 0, 
	"Fights": 0
}

var signal_create_fight_panel = false



var time = "day"

var stand_activate_activated = false

var hp_max = 100
var heart_points = 100
var expirience_points = 0
var level_points = 1
var money = 0
var euro = 0
var event_coins = 0
var talents_score = 0
var attacked = false
var dashed = false
var direct = "None"
var pre_bullet_direct = "None"
var blocked = false
var attack_activate = false
var block_glush = Timer.new()
var tea_timer = Timer.new()
# play_time не должен сбрасываться Transition.change_scene.
var play_timer = Timer.new()
var parirovanie = Timer.new()
var grass_collect = Timer.new()
var player_direct = "left"
var stand_activated = false
var player_attack_activate = false
var barrage_activate = false
var combo_timer: Timer = Timer.new()
var combo_enemy_timer = Timer.new()
var default_attack_count = 0
var count_attacks = 0
var popadania = 0
var damage_for_player_counts = 0
var damage_for_enemy_counts = 0
var fight_timer = 0
var last_fight_area = ""
var item_arm_message_activate = false

var enemy_time_scale = 1.0

var time_erase = false
var time_stop = false

var player_pos_start_erase = Vector2.ZERO
var glush_enemy_timer = Timer.new()

# --- Таймеры боя (реализация — GeneralTimerService) ---
func start_combo_timer_for_enemy(enemy: Object, wait_time: float) -> void :
	timer_service.start_combo_timer_for_enemy(self, enemy, wait_time)

func start_glush_enemy_timer(wait_time: float) -> void :
	timer_service.start_glush_enemy_timer(self, wait_time)

func start_combo_enemy_timer_for_enemy(enemy: Object, wait_time: float) -> void :
	timer_service.start_combo_enemy_timer_for_enemy(self, enemy, wait_time)

func disconnect_fight_timers_from(enemy: Object) -> void :
	timer_service.disconnect_fight_timers_from(self, enemy)

func release_player_refs(player: Object) -> void :
	timer_service.release_player_refs(self, player)

# --- Позиция игрока и границы арены (PlayerStateService) ---
func map_bounds_active() -> bool:
	return player_state_service.map_bounds_active(self)

func is_valid_map_position(pos: Vector2) -> bool:
	return player_state_service.is_valid_map_position(self, pos)

func sync_player_pos_from_node(player: Node2D) -> void :
	player_state_service.sync_player_pos_from_node(self, player)

func capture_player_pos_save(player: Node2D) -> void :
	player_state_service.capture_player_pos_save(self, player)

func apply_saved_player_position(player: Node2D) -> void :
	player_state_service.apply_saved_player_position(self, player)

func persist_cyborg_battery_to_save() -> void :
	player_state_service.persist_cyborg_battery_to_save(self)

var fps_show_enabled = false

var enemy_health = 100

var player_block_attack = false



var quests = []
var complete_quests = []
var signal_deleted_for_rechek = false
var signal_animation = false
var quest_animation_play = false
var id_for_check = 0
var podrobnosti_activate = false
var quest_panel_activate = false
var pizza_8_yes = false
var speedwagond_dialog_start = false



var item_name = ""

var mini_game_activate = false
var mini_true_game_complete = false
var mini_game_first_number = 0
var mini_game_second_number = 0



var player_block_all = false
var settings_activate = false
var qa_activate = false
var qa_text_activate = false
var max_default_attack_count = 3
var dostup_combo = true
var epitafia_enabled = false


var general_map_enabled = [1, 2, 3, 4]
var stands_panel_activate = false
var jesus_dialog_complete = false
var bubble_go_beyound_start_activate = false



var player_statistic = {




















		}
var money_indicator_cratco = false
var activate_codes = []
var general_codes = []
var items_shop = []
var teleport_charges = 0
var player_name = "Игрок"
var teleport_pos = "None"

var tree_mini_game_collision = false
var Trash_obtained
var bubble_bey_stop = false



var is_saves_load = false

var tutorial_array = []
var tutorial_text = ""
var tutorial_id = 0.0



var camera_speed = 7

var seconds_get_start = false
var day_night_animation_second = 0.0

var barrage_arm_collision = 0

var all_damage_tren = 0
var panel_help_tutor_enabled = false
var kd_end = false

var enabled_to_check_current_scene = true
var current_scene_name = ""
var metka_tree_enabled = true

var db_sfx = - 5.0
var db_music = - 10.0
var music_enabled = true
var sfx_enabled = true

var run_activate = false
var run_scale = 1.0

var quest_complete = preload("res://Scenes/QuestComplete.tscn")

var is_money_loosed = false
var arm_barrage_count = 0

var camera_current_scale = Vector2(1, 1)

var last_scene = ""

var is_bubble_beyound_activate = false

var enemy_current_status = []
var enemy_panel_status = []

var stand_slots = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var GGPlayer: Object
var loot_info = []
var other_save: Dictionary = {}
var fight_with = 0
var mih_speed = 1.0
var EnemyName = ""
var Addition: Dictionary = {"spin": 0, "balls": [true, true]}
var BeatDownCharge: float = 0.0
var Stats = {}
var SoundsDa = {}
var LastGameSceneLink = ""
var TimerDa = 0.0
var donate = []
var stable = []

func remove_status(status_id):
	for i in range(enemy_current_status.size()):
		if enemy_current_status[i] == status_id:
			enemy_current_status.remove(i)
			break

func add_stand_to_slot(slot_id):
	if slot_id < stand_slots.size():
		if stand_slots[slot_id] == 0 and stand_number != 0:
			var stand_slot_temp = stand_number
			stand_number = stand_slots[slot_id]
			stand_slots[slot_id] = stand_slot_temp
			stand_slot_temp = 0
	General.save_save()

func return_stand_from_slot(slot_id):
	if slot_id < stand_slots.size():
		if stand_slots[slot_id] != 0 and stand_number == 0:
			var stand_slot_temp = stand_slots[slot_id]
			stand_slots[slot_id] = stand_number
			stand_number = stand_slot_temp
			stand_slot_temp = 0
	General.save_save()

func restand_to_slot(slot_id):
	if slot_id < stand_slots.size():

			var stand_slot_temp = stand_slots[slot_id]
			stand_slots[slot_id] = stand_number
			stand_number = stand_slot_temp
			stand_slot_temp = 0
	General.save_save()

func tutorial_general_add(id: float, text):
	var tutorial = {
		"ID": id, 
		"Text": text
	}
	tutorial_array.append(tutorial)
	
func check_tutorial_array(id):
	for i in range(tutorial_array.size()):
		if tutorial_array[i]["ID"] == id:
			return i
	return - 1

func tutorials_add():
	tutorial_array.clear()
	for entry in content_db().get_tutorials():
		tutorial_general_add(float(entry.get("id", 0.0)), str(entry.get("text", "")))
func create_support(name_: String, fights: int, cost: int):
	current_support = {
		"Name": name_, 
		"cost": cost, 
		"Fights": fights
	}
func items_shop_add():
	items_shop.clear()
	for entry in content_db().get_shop_items():
		items_shop.append({
			"NAME": str(entry.get("item_name", "")),
			"COST": int(entry.get("price", 0)),
			"DISCRIPTION": str(entry.get("description", "")),
			"ID": int(entry.get("item_id", 0))
		})
func remove_code_from_general_code(code):
	for cod in general_codes:
		if cod == code:
			general_codes.remove(cod)




	
	
	

func merchant_spawn():
	random.randomize()
	var chances = random.randf()
	random.randomize()
	var type = ""
	var position = random.randi_range(0, 10) % 10
	
	
	
	
	
	
	

	

	
	
	
	
func regen_hp_timer():
	timer_service.regen_hp_timer(self)

func regen_hp():
	timer_service.regen_hp(self)

func _process(delta):
	general_process_service.process(self, delta)


func stand_power():
	var btsd = float(content_db().get_technic(techic_number).get("stand_power_bonus", 0.0))
	stand_power = content_db().get_stand_power(stand_number) + bonus_player["dmg_st"] + btsd
func player_power():
	var btd = float(content_db().get_technic(techic_number).get("hand_damage_bonus", 0.0))
	add_hand_damage = bonus_player["dmg_gg"] + btd
	add_attacks_spin = 0
	add_hand_crit = 0
	add_damage_spin = 0
	add_time_spin = 0
func delete_support():
	if current_support["Fights"] == 1 or current_support["Name"] == "None":
		current_support = {
	"Name": "None", 
	"Cost": 0, 
	"Fights": 0
}
func _physics_process(_delta):
	general_state_service.physics_process(self)


func learn_talent(id: int, steam: String):
	talents[str(steam)].append(id)
func find_talent(id: int, steam: String):
	for i in range(talents[str(steam)].size()):
		if talents[str(steam)][i] == id:
			return true
	return false
func update_stats():
	stats_service.update(self)


func audio_settings_check():
	audio_service.audio_settings_check(self)

# --- Сохранение профиля (GeneralSaveService) ---
func saves_exist_check():
	save_service.saves_exist_check(self)

func save_save_extended():
	save_service.save_save_extended(self)

func save_save():
	save_service.save_save(self)

func load_save():
	save_service.load_save(self)


# --- Квесты (QuestService; требования 1-based, награды 0-based) ---
func add_quest(author, id, name, trebovania, reward, stand, rusname, rusauthor, russtand, is_last, technic, rustechnic, custom_treb, custom_reward):
	quest_service.add_quest(self, author, id, name, trebovania, reward, stand, rusname, rusauthor, russtand, is_last, technic, rustechnic, custom_treb, custom_reward)

func quest_complete(id):
	return quest_service.quest_complete(self, id)

func replace_quest(old_id, new_id):
	return quest_service.replace_quest(self, old_id, new_id)

func remove_quest(id):
	return quest_service.remove_quest(self, id)

func quest_delete(id, last):
	quest_service.quest_delete(self, id, last)

func full_quest_delete(id):
	quest_service.full_quest_delete(self, id)

func check_selected_quests(id):
	return quest_service.can_complete(self, id)

func can_complete_quest(id):
	return quest_service.can_complete(self, id)

func get_quest(id):
	return quest_service.get_quest(self, id)

func quest_index(id):
	return quest_service.quest_index(self, id)

func refresh_quest_indices():
	quest_service.refresh_quest_indices(self)

func id_set():
	quest_service.refresh_quest_indices(self)

func search_id(id):
	return quest_service.search_id(self, id)

func _apply_content_defaults():
	var db = content_db()
	choose_skins = db.get_default("choose_skins", {})
	egg_upgrade = db.get_default("egg_upgrade", {})
	merchant_info = db.get_default("merchant_info", {})
	houses = db.get_default("houses", [])
	hous_contains = db.get_default("hous_contains", {})
	talents_buff = db.get_default("talents_buff", {})
	sb_items = db.get_default("sb_items", {})
	global_buffs = db.get_default("global_buffs", {})
	current_achiviement = db.get_default("current_achiviement", {})
	tournir_all_reward_items = db.get_default("tournir_all_reward_items", {})
	twoh_complete_quest = db.get_default("twoh_complete_quest", {})
	bonus_player = db.get_default("bonus_player", {})
	limit_player = db.get_default("limit_player", {})
	global_bonus = db.get_default("global_bonus", {})
	global_debuffs = db.get_default("global_debuffs", {})
	general_codes = db.get_default("general_codes", [])


func _ready():
	content_db()
	_apply_content_defaults()
	last_fight_area = ""
	# Все таймеры живут под General. Это важно: Timer.new() без родителя
	# переживает смену сцены и оставляет предупреждение ObjectDB при выходе.
	timer_service.ensure_all_timers(self)
	display_service.apply_startup_window(get_tree())
	load_save()
	play_time_timer(60)
	check_array_invent_zero()
	enemy_add()
	items_shop_add()
	saves_exist_check()
	tutorials_add()
	timer_grass_collect(300)
	# Stats нужен GGPlayer._physics_process() до первого _process(); заполняем
	# здесь, чтобы первый кадр движения видел все ключи.
	update_stats()
	yield(get_tree().create_timer(0.3), "timeout")


func _exit_tree():
	# Страховка для таймеров, которые временно жили на игроке или враге.
	timer_service.free_orphan_timers(self)









# --- Экономика и донат-бонусы (EconomyService) ---
func get_donate_level(bonus_type: String) -> int:
	return economy_service.get_donate_level(self, bonus_type)

func money_change(amount):
	economy_service.money_change(self, amount)

func exp_change(amount):
	return economy_service.exp_change(self, amount)

func enemy_add():
	enemy_list.clear()
	for entry in content_db().get_enemy_roster():
		enemy_list.append(entry.duplicate(true))
# --- Инвентарь (InventoryService; публичные item_id — 0-based) ---
func check_array_invent_zero():
	inventory_service.check_array_invent_zero(self)

func check_array(item_index_check):
	return inventory_service.check_array(self, item_index_check)

func check_array_counts(item_index_check, item_count):
	return inventory_service.check_array_counts(self, item_index_check, item_count)

func ItemCount(ItemIndex: int) -> int:
	return inventory_service.ItemCount(self, ItemIndex)

func add_item(item_index, item_count, message_visible = 1):
	# Публичный API: item_index — 0-based ID из Data/Items.gd.
	inventory_service.add_item(self, item_index, item_count, message_visible)

func remove_item(item_id, item_count, message_visible = 1):
	# Публичный API: item_id — индекс предмета из Data/Items.gd (0-based).
	inventory_service.remove_item(self, item_id, item_count, message_visible)

func remove_item_slot(slot_id, item_count, message_visible = 1):
	# Внутренний/UI-API: slot_id — значение items_inventory[i].x (1-based).
	inventory_service.remove_item_slot(self, slot_id, item_count, message_visible)

func delete_item(item_id):
	# Публичный API: item_id — индекс предмета из Data/Items.gd (0-based).
	inventory_service.delete_item(self, item_id)

func ItemSpawn(array):
	inventory_service.item_spawn(self, array)

func message_spawn(type, text):
	if get_tree().current_scene.name != "Shop" and get_tree().current_scene.name != "TournirSelect" and get_tree().current_scene.name != "SpidwagonShop":
		while get_tree().current_scene.name == "GameSettings" or get_tree().current_scene.name == "TuskAct2MiniGame":
			yield(get_tree().create_timer(0.1), "timeout")
		# В тестовых сценах и мини-играх GUI может отсутствовать. Без
		# get_node_or_null движок печатает ошибку на каждый вызов.
		var node = get_node_or_null("/root/" + get_tree().current_scene.name + "/GUI")
		if node != null:
			text_message = text
			if type == "Center":
				var mess_spwn = message.instance()
				node.add_child(mess_spwn)
			elif type == "Quest":
				var mess_spwn = message_r.instance()
				node.add_child(mess_spwn)
			elif type == "Item":
				var mess_spwn = message_l.instance()
				
				node.add_child(mess_spwn)
	
func on_anim_activate_end():
	var player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
	connect("arrow_activated", player, "arrow_activated")
	emit_signal("arrow_activated")
	disconnect("arrow_activated", player, "arrow_activated")
func find_skin(skin):
	for i in range(all_skins.size()):
		if all_skins[i] == skin:
			return 1
# --- Игровые таймеры: play_time, трава, ногти (GeneralTimerService) ---
func play_time_add():
	timer_service.play_time_add(self)

func play_time_timer(sec):
	timer_service.play_time_timer(self, sec)

func grass_colectiong():
	timer_service.grass_colectiong(self)

func timer_grass_collect(sec):
	timer_service.timer_grass_collect(self, sec)

func nail_timer_start():
	timer_service.nail_timer_start(self)

func nail_plus():
	timer_service.nail_plus(self)

func damage_effect(type):
	if type == "Default":
		block_damage = 1
	elif type == "Aggresive":
		block_damage = 2
	elif type == "Parirovanie":
		block_damage = 4
	else:
		block_damage = 3
	var damage_inst = damage_effect.instance()
	var node = get_node("/root/" + get_tree().current_scene.name)
	node.add_child(damage_inst)
func create_smoke(name_, weight, base_cost, bonus_effect):
		smokes.append({
			"name": name_, 
			"weight": weight, 
			"base_cost": base_cost, 
			"bonus_effect": bonus_effect
		})

var combat_hitboxes = preload("res://Systems/HitBoxEnemy.gd").new()


func HitBoxEnemy(Enemy, area):
	combat_hitboxes.handle(Enemy, area)


func infinity_teleports():
	return economy_service.infinity_teleports(self)

func chance_calculate(amount):
	return economy_service.chance_calculate(self, amount)
	
func add_stand_slots():
	General.stand_slots.append(0)
# --- Урон по врагам (EnemyDamageService) ---
func jump_damage(Enemy, damage_yes, amount_hp, amount_dist: int, direct_player_set: bool, block_destroy: bool) -> void :
	enemy_damage_service.jump_damage(self, Enemy, damage_yes, amount_hp, amount_dist, direct_player_set, block_destroy)


func StunEnemy(Enemy, StunTime: float):
	enemy_damage_service.StunEnemy(self, Enemy, StunTime)


func _track_training_damage(Enemy, amount):
	enemy_damage_service._track_training_damage(self, Enemy, amount)


func default_damage(Enemy, damage_yes, amount_hp, amount_dist: int, direct_player_set: bool, block_destroy: bool, popadanie_check: bool = true, push: float = 0.0) -> void :
	enemy_damage_service.default_damage(self, Enemy, damage_yes, amount_hp, amount_dist, direct_player_set, block_destroy, popadanie_check, push)


func chop_damage(Enemy, amount_hp: int):
	enemy_damage_service.chop_damage(self, Enemy, amount_hp)


func passive_damage(Enemy, damage_yes, wait_time: float, count_attacks: int, amount_hp, chop: bool):
	enemy_damage_service.passive_damage(self, Enemy, damage_yes, wait_time, count_attacks, amount_hp, chop)
# --- Звук (GeneralAudioService) ---
func SoundPlay(link_to_sound: String, Dop: Dictionary = {}):
	audio_service.sound_play(self, link_to_sound, Dop)
func toGameGeneral(TypeTransition: String = "Black", FromSave: bool = false):
	var LinkToScene: String
	EnemyName = ""
	if FromSave or LastGameSceneLink == "":
		if "world" in other_save: match other_save["world"]:
				"morio": LinkToScene = "res://GeneralGameScenes/MorioMap.tscn"
				"desert": LinkToScene = "res://GeneralGameScenes/SandWorld.tscn"
				"jail": LinkToScene = "res://GeneralGameScenes/JailDa.tscn"
				"italy": LinkToScene = "res://GeneralGameScenes/Italy.tscn"
				"rom": LinkToScene = "res://GeneralGameScenes/Rom.tscn"
				"germany": LinkToScene = "res://GeneralGameScenes/Germany.tscn"
				_: LinkToScene = "res://GeneralGameScenes/MorioMap.tscn"
		else: LinkToScene = "res://GeneralGameScenes/MorioMap.tscn"
		LastGameSceneLink = LinkToScene
	else:
		LinkToScene = LastGameSceneLink
	Transition.change_scene(LinkToScene, TypeTransition)
	if FromSave: player_pos_save = Vector2.ZERO
func PlayerDamage(Damage: float, Dop: Dictionary = {}):
	player_damage_service.apply(self, Damage, Dop)


# Расы 3/4 используют дерево пилламенов; для расы 5 дерева нет.
func talent_race_number() -> int:
	return content_db().get_talent_race_number(race_number)


func GetTalentInfo(Type: String, ID: int):
	if Type == "race":
		return content_db().get_talent(talent_race_number(), ID)
	return [4, 0, "", {}]
func TalentTreeReset(TreeDa: String):
	for i in General.talents[TreeDa]:
		var Cost = General.GetTalentInfo(TreeDa, i)[1]
		points += Cost
	points = General.level_points - 1
	talents[TreeDa].clear()
	complete_quests.erase(8.1)
	save_save()

func AddItemToCyborgInv(ID: String):
		var base_id = ID.split("/")[0] if ID.find("/") != - 1 else ID
		if base_id == "10":
			General.other_save["Cyborg"][0].append(["10/750", 1])
		elif base_id == "11":
			General.other_save["Cyborg"][0].append(["11/1200", 1])
		else:
			var FindDa = - 1
			for i in General.other_save["Cyborg"][0].size():
				if General.other_save["Cyborg"][0][i][0] == str(ID):
					FindDa = i
					break
			if FindDa == - 1:
				General.other_save["Cyborg"][0].append([str(ID), 1])
			else:
				General.other_save["Cyborg"][0][FindDa][1] += 1

func AchievementGive(ID: int):
	for i in acs.achievements.size():
		if acs.achievements[i]["id"] == ID:
			if not acs.achievements[i]["completed"]:
				acs.achievements[i]["completed"] = true
				Transition.NewAchievent(ID)
			break
# --- Данные врагов и турнира ---
func GetEnemyInfo(EnemyNameDa: String):
	var data = content_db().get_enemy(EnemyNameDa)
	if data.empty():
		return {}
	var items = []
	for entry in data.get("Items", []):
		if entry.size() >= 2:
			var base_chance = float(entry[1])
			var item_name = str(entry[2]) if entry.size() > 2 else ""
			items.append([int(entry[0]), base_chance + chance_calculate(base_chance), item_name])
	data["Items"] = items
	return data

var tournament_enemy_factory = preload("res://Systems/TournamentEnemyFactory.gd").new()


# Турнирный враг генерируется из Data/Tournament*.gd; не дублируйте формулы в UI.
func GetTournamentEnemy(level: int) -> Dictionary:
	return tournament_enemy_factory.generate(level)


func GetItemInfo(ID: int):
	# Исторический 1-based API для старых вызовов. Новый код использует
	# 0-based item_id и content_db().get_item().
	var item = content_db().get_item(int(ID) - 1)
	if item.empty():
		return {"name": ""}
	return {"name": str(item.get("item_name", ""))}
