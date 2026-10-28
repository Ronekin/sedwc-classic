# GUI.gd — корневой CanvasLayer интерфейса.
#
# Создаёт панели как сцены, переключает их и хранит только UI-состояние.
# Игровые данные читаются через General; логика боя и предметов остаётся в
# соответствующих сервисах.
#
# Моддинг: новую панель добавляйте отдельной сценой и инстанцируйте здесь; не
# храните в GUI игровое состояние, которое должно попадать в сейв.

extends CanvasLayer
signal inventory_will_activate
signal stand_attack_go
signal stand_activate_go
signal item_activate_go
signal dialog_activate_go
onready var dialog_for_inst = preload("res://Scenes/DialogWindow.tscn")
onready var quest_panel = preload("res://Scenes/QuestPanel.tscn")
onready var settings = preload("res://GeneralGameScenes/Settings.tscn")
onready var fight_panel = preload("res://Scenes/FightStartPanel.tscn")
onready var stands_panel = preload("res://Scenes/SelectStand.tscn")
onready var technic_panel = preload("res://Scenes/SelectTehcnic.tscn")
var choose_grass = ""
var random = RandomNumberGenerator.new()
var chill = false
var empty_garden = true
var spent_grass = 0
var _spawned_dialog: Node = null
var _spawned_fight_panel: Node = null
var _loot_chill_timer: Timer = null
var _loot_busy: = false
var _select_item_busy: = false






func _ready():
	visible = true
	# Не все арены имеют TeleportPanel. get_node_or_null не печатает ошибку
	# каждый кадр, если панели нет (например, TrainingArena).
	var teleport_panel = get_node_or_null("TeleportPanel")
	if teleport_panel != null:
		teleport_panel.visible = false

func _ensure_child_timer(t: Timer) -> void :
	if t == null:
		return
	if t.get_parent() != self:
		if t.get_parent():
			t.get_parent().remove_child(t)
		add_child(t)

func _has_ui_child(child_name: String) -> bool:
	for child in get_children():
		if child.name == child_name and is_instance_valid(child):
			return true
	return false

func _get_map_player() -> Node2D:
	var scene_name = get_tree().current_scene.name
	var player_path = "/root/" + scene_name + "/YSorting/GGPlayer"
	if scene_name == "MorioMap":
		player_path = "/root/" + scene_name + "/SortingY/GGPlayer"
	if has_node(player_path):
		return get_node(player_path) as Node2D
	return null

func _disconnect_gui_signals() -> void :
	if has_node("Inventory") and is_connected("inventory_will_activate", $Inventory, "on_button_inventory_pressed"):
		disconnect("inventory_will_activate", $Inventory, "on_button_inventory_pressed")
	var parent = get_parent()
	if parent != null and is_instance_valid(parent):
		if is_connected("stand_attack_go", parent, "on_button_attack_pressed"):
			disconnect("stand_attack_go", parent, "on_button_attack_pressed")
		if is_connected("stand_activate_go", parent, "on_button_stand_activate_pressed"):
			disconnect("stand_activate_go", parent, "on_button_stand_activate_pressed")
		if is_connected("item_activate_go", parent, "on_button_item_activate_pressed"):
			disconnect("item_activate_go", parent, "on_button_item_activate_pressed")
		if is_connected("dialog_activate_go", parent, "on_button_dialog_activate_pressed"):
			disconnect("dialog_activate_go", parent, "on_button_dialog_activate_pressed")

func _stop_loot_chill() -> void :
	_loot_busy = false
	if _loot_chill_timer != null:
		_loot_chill_timer.stop()
		if _loot_chill_timer.is_connected("timeout", self, "_on_loot_chill_timeout"):
			_loot_chill_timer.disconnect("timeout", self, "_on_loot_chill_timeout")

func _clear_spawned_ui_panels() -> void :
	if _spawned_dialog != null and is_instance_valid(_spawned_dialog):
		_spawned_dialog.queue_free()
	_spawned_dialog = null
	if _spawned_fight_panel != null and is_instance_valid(_spawned_fight_panel):
		_spawned_fight_panel.queue_free()
	_spawned_fight_panel = null
	for child in get_children():
		if child.name in ["QuestPanel", "FightStartPanel", "Settings", "SelectStand", "BuffsInfo"]:
			child.queue_free()
		elif child.get_script() != null:
			var script_path = child.get_script().resource_path
			if script_path.find("DialogWindow.gd") != - 1:
				child.queue_free()

func _exit_tree() -> void :
	_stop_loot_chill()
	_clear_spawned_ui_panels()
	_disconnect_gui_signals()
	General.quest_panel_activate = false
	General.stands_panel_activate = false

func _physics_process(delta):
	if ("BERSERK" in General.Addition):
		if General.Addition["BERSERK"] == 1:
			$Center / AnimationPlayer.play("BerserkMode")
		else:
			$Center / AnimationPlayer.play("None")
	
	
	
	var teleport_panel = get_node_or_null("TeleportPanel")
	if teleport_panel != null:
		if teleport_panel.visible:
			General.dialog_activate = true
		var teleports_text = teleport_panel.get_node_or_null("TeleportsText")
		if teleports_text != null:
			if General.infinity_teleports() == false:
				teleports_text.text = "у вас есть " + str(General.teleport_charges) + " телепортов"
			else:
				teleports_text.text = "Бесплатные путешествия за счет бонуса"

	
	
	
	
	if chill == true:
		$Right_Less / TrashLootButton.visible = false
	if General.dialog_create_signal == true:
		dialog_spawn()
		General.dialog_create_signal = false
	if General.signal_create_fight_panel == true:
		fight_panel_spawn()
		General.signal_create_fight_panel = false
	if get_tree().current_scene.name == "MorioMap":
		if General.tree_mini_game_collision and General.search_id(2.1) != - 1:
			$Right_Less / MiniGameTreeButton.visible = true
		else:
			$Right_Less / MiniGameTreeButton.visible = false
	if get_tree().current_scene.name in ["MorioMap", "Italy", "Rom", "Jail", "Germany", "Desert"] and chill == false:
		if General.Trash_obtained == true:
			$Right_Less / TrashLootButton.visible = true
		else:
			$Right_Less / TrashLootButton.visible = false
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	if get_tree().current_scene.name == "MorioMap":
		if General.grass_around == true and General.timer_grass == 1:
			$Right_Less / GrassCollectButton.visible = true
		else:
			$Right_Less / GrassCollectButton.visible = false
	


















func _on_InventoryButton_invent_activate():
	connect("inventory_will_activate", $Inventory, "on_button_inventory_pressed")
	emit_signal("inventory_will_activate")
	disconnect("inventory_will_activate", $Inventory, "on_button_inventory_pressed")
func _on_TextureButton3_attack_activate():
	connect("stand_attack_go", get_parent(), "on_button_attack_pressed")
	emit_signal("stand_attack_go")
	disconnect("stand_attack_go", get_parent(), "on_button_attack_pressed")
func _on_TextureButton_stand_activate():
	connect("stand_activate_go", get_parent(), "on_button_stand_activate_pressed")
	emit_signal("stand_activate_go")
	disconnect("stand_activate_go", get_parent(), "on_button_stand_activate_pressed")
func _on_TextureButton2_item_activate():
	connect("item_activate_go", get_parent(), "on_button_item_activate_pressed")
	emit_signal("item_activate_go")
	disconnect("item_activate_go", get_parent(), "on_button_item_activate_pressed")
func _on_TextureButton_dialog():
	connect("dialog_activate_go", get_parent(), "on_button_dialog_activate_pressed")
	emit_signal("dialog_activate_go")
	disconnect("dialog_activate_go", get_parent(), "on_button_dialog_activate_pressed")
func dialog_spawn():
	if _spawned_dialog != null and is_instance_valid(_spawned_dialog):
		return
	var dialog_create = dialog_for_inst.instance()
	_spawned_dialog = dialog_create
	add_child(dialog_create)
func _on_Control_use_move_vector(move_vector):
	General.velocity_player = move_vector
func _on_TouchScreenButton_quest_activate():
	if General.quest_panel_activate == true:
		for child in get_children():
			if child.name == "QuestPanel":
				child.queue_free()
		General.quest_panel_activate = false
	else:
		if _has_ui_child("QuestPanel"):
			General.quest_panel_activate = true
			return
		General.quest_panel_activate = true
		var quest_panel_creat = quest_panel.instance()
		add_child(quest_panel_creat)

func _on_TouchScreenButton2_pressed():
	if General.settings_activate == false and General.is_invent_show == false and General.dialog_activate == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false:
		if _has_ui_child("Settings"):
			General.settings_activate = true
			return
		General.player_block_all = true
		General.settings_activate = true
		var settings_create = settings.instance()
		add_child(settings_create)

func fight_panel_spawn():
	if _spawned_fight_panel != null and is_instance_valid(_spawned_fight_panel):
		return
	var panel_create = fight_panel.instance()
	_spawned_fight_panel = panel_create
	add_child(panel_create)

func _on_TouchScreenButton_pressed():
	if General.stands_panel_activate == false and General.player_attack_activate == false and General.player_block_all == false and General.time_stop == false and General.time_erase == false and General.barrage_activate == false and General.epitafia_enabled == false and $Right_Less / TouchScreenButton3.bubble_beyound_timer.is_stopped() and $Right_Less / TouchScreenButton4.bubble_beyound_timer.is_stopped() and $Right_Less / TouchScreenButton5.bubble_beyound_timer.is_stopped():
		if _has_ui_child("SelectStand"):
			General.stands_panel_activate = true
			return
		var stands_panel_inst = stands_panel.instance()
		add_child(stands_panel_inst)
		General.stands_panel_activate = true
		
func _on_TouchScreenButton21_pressed():
	if General.stands_panel_activate == false and General.player_block_all == false:
		Transition.change_scene("res://GeneralGameScenes/GeneralMenu.tscn", "Black")

func _on_TouchScreenButton122_pressed():
	if General.stands_panel_activate == false and General.player_attack_activate == false and General.player_attack_activate == false and General.player_block_all == false and General.time_stop == false and General.time_erase == false and General.barrage_activate == false and General.epitafia_enabled == false and $Right_Less / TouchScreenButton3.bubble_beyound_timer.is_stopped() and $Right_Less / TouchScreenButton4.bubble_beyound_timer.is_stopped() and $Right_Less / TouchScreenButton5.bubble_beyound_timer.is_stopped():
		if _has_ui_child("SelectStand"):
			General.stands_panel_activate = true
			return
		var stands_panel_inst = technic_panel.instance()
		add_child(stands_panel_inst)
		General.stands_panel_activate = true

func _on_MiniGameTreeButton_pressed():
	if $Right_Less / MiniGameTreeButton.visible and General.dialog_activate == false and General.is_invent_show == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false and General.attacked == false and General.dashed == false:
		var player = _get_map_player()
		if player != null:
			General.capture_player_pos_save(player)
		Transition.change_scene("res://GeneralGameScenes/TuskAct2MiniGame.tscn", "Black")
func _on_TrashLootButton_pressed():
	if $Right_Less / TrashLootButton.visible and General.dialog_activate == false and General.is_invent_show == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false and General.attacked == false and General.dashed == false:
		LootTrash()

func LootTrash():
	if _loot_busy:
		return
	General.SoundPlay("res://Music/Metal_da.mp3")
	random.randomize()
	var chance = random.randf() * 100
	if chance < 0.5:
		General.s_coins += 1
		General.message_spawn("Center", "Вы нашли s-койн! Вы немного устали подождите 5 секунд.")
	elif chance < 3:
		General.add_item(0, 1, 1)
		General.message_spawn("Center", "Вы нашли стрелу! Вы немного устали подождите 5 секунд.")
	elif chance < 6:
		General.add_item(1, 1, 1)
		General.message_spawn("Center", "Вы нашли диск! Вы немного устали подождите 5 секунд.")
	elif chance < 9:
		General.add_item(6, 1, 1)
		General.message_spawn("Center", "Вы нашли пиццу! Вы немного устали подождите 5 секунд.")
	elif chance < 12:
		General.money_change(200)
		General.message_spawn("Center", "Вы нашли деньги в размере 200! Вы немного устали подождите 5 секунд.")
	elif chance < 13:
		General.euro += 1
		General.message_spawn("Center", "Вы нашли 1 евро! Вы немного устали подождите 5 секунд.")
	elif chance < 30:
		General.add_item(27, 1, 1)
		General.message_spawn("Center", "Вы нашли старую микросхему! Вы немного устали, подождите 5секунд.")
	elif chance < 50:
		General.add_item(33, 1, 1)
		General.message_spawn("Center", "Вы нашли ржавое железо! Вы немного устали, подождите 5 секунд.")
	elif chance < 70:
		General.add_item(34, 1, 1)
		General.message_spawn("Center", "Вы нашли свинец! Вы немного устали, подождите 5 секунд.")

	else:
		General.message_spawn("Center", "Вы ничего не нашли. Вы немного устали подождите 5 секунд.")
	chill = true
	_loot_busy = true
	if _loot_chill_timer == null:
		_loot_chill_timer = Timer.new()
		_loot_chill_timer.one_shot = true
	_ensure_child_timer(_loot_chill_timer)
	if _loot_chill_timer.is_connected("timeout", self, "_on_loot_chill_timeout"):
		_loot_chill_timer.disconnect("timeout", self, "_on_loot_chill_timeout")
	_loot_chill_timer.connect("timeout", self, "_on_loot_chill_timeout")
	_loot_chill_timer.wait_time = 5.0
	_loot_chill_timer.start()

func _on_loot_chill_timeout() -> void :
	if not is_inside_tree():
		return
	chill = false
	_loot_busy = false
	General.save_save()



func GrassCollect():
	
	randomize()
	var chance = randf()
	
	if chance > 0 and chance < 0.25:
		General.add_item(30, 10, 1)
		General.message_spawn("Center", "Вы собрали подозрительную траву в количестве 10 грамм")
	elif chance > 0.25 and chance < 0.5:
		General.add_item(30, 20, 1)
		General.message_spawn("Center", "Вы собрали подозрительную траву в количестве 20 грамм")
	elif chance > 0.5 and chance < 0.75:
		General.add_item(30, 30, 1)
		General.message_spawn("Center", "Вы собрали подозрительную траву в количестве 30 грамм")
	else:
		General.add_item(30, 40, 1)
		General.message_spawn("Center", "Вы собрали подозрительную траву в количестве 40 грамм")
	General.save_save()
	
	General.timer_grass = 0
	General.grass_around = false
	
	
	General.save_save()
func _on_GrassCollectButton_pressed():
	if $Right_Less / GrassCollectButton.visible and General.dialog_activate == false and General.is_invent_show == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false and General.attacked == false and General.dashed == false:
		GrassCollect()


func _on_GardenBuyButton_pressed():
	if $Right_Less / GardenBuyButton.visible == false:
		return
	
	if General.item_in_arm == "31" and General.items_inventory[General.check_array(30)].y >= 10 and General.euro >= 1000:
		General.remove_item(30, 10, 1)
		General.euro -= 1000
		General.grasses.append(General.current_grass_id)
		
		
		var territory_id = str(General.current_grass_id)
		if territory_id in General.collected_grasses:
			General.collected_grasses.erase(territory_id)
		
		General.message_spawn("Center", "Вы приобрели территорию и посадили подозрительную траву!")
		General.save_save()
		update_buy_button_visibility()
	else:
		General.message_spawn("Center", "Для покупки территории и посадки подозрительной травы вам понадобится 1000 евро и 10 грамм травы")


func update_buy_button_visibility():
	var can_buy_garden = true
	if General.current_grass_id > - 1 and General.current_grass_id in General.grasses:
		can_buy_garden = false
	
	if get_tree().current_scene.name == "MorioMap":
		if General.buy_garden and General.item_in_arm == "31":
			$Right_Less / GardenBuyButton.visible = can_buy_garden
		else:
			$Right_Less / GardenBuyButton.visible = false
	else:
		$Right_Less / GardenBuyButton.visible = false

func _input(event):
	if event is InputEventScreenTouch and choose_grass != "":
		if choose_grass == "bad":
			General.remove_item(30, 1, 1)
			spent_grass += 1
			
			
		elif choose_grass == "good":
			General.remove_item(30, 1, 1)
			spent_grass += 1
			
			
	
func _on_Drug_choose_pressed():
	var grass_index = General.check_array(30)
	if choose_grass == "" and grass_index != - 1 and General.items_inventory[grass_index].y >= 1:
		choose_grass = "bad"

func _on_Drug_choose2_pressed():
	var grass_index = General.check_array(30)
	if choose_grass == "" and grass_index != - 1 and General.items_inventory[grass_index].y >= 1:
		choose_grass = "good"


func _on_Create_smoke_pressed():
	var names = ""
	var bonus_effect = ""
	if spent_grass > 0 and spent_grass < 5:
		names = "косячек"
	if spent_grass > 5 and spent_grass < 10:
		names = "малый косяк"
	if spent_grass > 10 and spent_grass < 20:
		names = "косяк"
	if spent_grass > 20 and spent_grass < 40:
		names = "большой косяк"
	if spent_grass > 40 and spent_grass < 100:
		names = "плотный косяк"
		bonus_effect = "speedv1"
	if spent_grass > 100 and spent_grass < 200:
		names = "мощный косяк"
		bonus_effect = "speedv1,healthv1"
	if spent_grass > 200 and spent_grass < 500:
		names = "невероятный косяк"
		bonus_effect = "speedv1,healthv1,damagev1"
	if spent_grass > 500 and spent_grass < 1000:
		names = "огромнейший косяк"
		bonus_effect = "speedv2,healthv2,damagev2"
	
func SelectItem():
	if _select_item_busy:
		return
	_select_item_busy = true
	yield(get_tree(), "idle_frame")
	if not is_inside_tree():
		_select_item_busy = false
		return
	yield(get_tree(), "idle_frame")
	if not is_inside_tree():
		_select_item_busy = false
		return
	yield(get_tree(), "idle_frame")
	if not is_inside_tree():
		_select_item_busy = false
		return
	if General.item_in_arm != "0":
		var item_data = General.content_db().get_item(int(General.item_in_arm) - 1)
		if not item_data.empty():
			$CenterMessage / ItemBoxMessage.get_node("AnimationPlayer").play("Idle")
			$CenterMessage / ItemBoxMessage.get_node("Sprite/Label").text = str(item_data.get("item_name", ""))
			$CenterMessage / ItemBoxMessage.get_node("Sprite/Label2").text = str(item_data.get("description", ""))
	_select_item_busy = false





func ToMenu_Pressed():
	General.SoundPlay("res://Music/HitUI.mp3")
	Transition.change_scene("res://GeneralGameScenes/TournirSelect.tscn", "Black")



func NextStage_Pressed():
	General.SoundPlay("res://Music/HitUI.mp3")
	var da = General.GetTournamentEnemy(General.tournament_lvl)
	General.tournir_character = da["name"]
	General.LastToutnamentLvl = General.tournament_lvl
	General.EnemyName = General.tournir_character

	General.save_save()
	Transition.change_scene("res://GeneralGameScenes/TournirEnemyArena.tscn", "White")

func AfterTournament():
	$Center / AfterWin.visible = true
	$Center / AfterWin / AnimationPlayer.play("Show")

	var DopData = General.GetTournamentEnemy(General.tournament_lvl)
	$Center / AfterWin / NextStage / Node2D / EnemyTexture.texture = load(DopData["texture"])
	$Center / AfterWin / NextStage / Node2D / EnemyTexture.hframes = DopData["hframes"]
	$Center / AfterWin / NextStage / Node2D / EnemyTexture.vframes = DopData["vframes"]
	$Center / AfterWin / Text.text = "этап " + str(General.tournament_lvl - 1) + " пройден!"
	$Center / AfterWin / NextStage / Node2D / Name.text = ""
	
	if DopData["type"] != "Classic": $Center / AfterWin / NextStage / Node2D / Name.text += DopData["type"] + " "
	if DopData["version"] != "Normal": $Center / AfterWin / NextStage / Node2D / Name.text += "ист."
	$Center / AfterWin / NextStage / Node2D / Name.text += DopData["name"] + "\n"
	$Center / AfterWin / NextStage / Node2D / Name.text += "HP: " + str(DopData["hp"])
	
