# SedwcContent.gd — загрузчик и индекс Data/*.gd.
#
# Только чтение данных: никакой игровой логики и записи. Один экземпляр
# создаётся через General.content_db().
#
# Форматы и правила:
# - Items.gd — словарь; публичный ID = ключ (0-based);
# - Enemies.gd — словарь по именам врагов;
# - TournamentRules.gd — 0-based item_id в дропах;
# - Dialogues.gd — ручной каталог реплик: DATA.lines["ключ"] = "текст";
# - остальные файлы: ShopItems, Tutorials, Talents, StandPower, EnemyRoster,
#   TournamentPools, Stands, Technics, Races, Defaults, Achievements.
#
# Моддинг: данные лежат в Data/*.gd в виде const DATA. Меняйте значения там,
# затем запускайте smoke-тесты. ID не переставляйте: они попадают в сохранения.

extends Reference
class_name SedwcContent

const ItemsData = preload("res://Data/Items.gd")
const EnemiesData = preload("res://Data/Enemies.gd")
const ShopItemsData = preload("res://Data/ShopItems.gd")
const TutorialsData = preload("res://Data/Tutorials.gd")
const TalentsData = preload("res://Data/Talents.gd")
const StandPowerData = preload("res://Data/StandPower.gd")
const EnemyRosterData = preload("res://Data/EnemyRoster.gd")
const TournamentPoolsData = preload("res://Data/TournamentPools.gd")
const TournamentRulesData = preload("res://Data/TournamentRules.gd")
const StandsData = preload("res://Data/Stands.gd")
const TechnicsData = preload("res://Data/Technics.gd")
const RacesData = preload("res://Data/Races.gd")
const DefaultsData = preload("res://Data/Defaults.gd")
const AchievementsData = preload("res://Data/Achievements.gd")
const DialoguesData = preload("res://Data/Dialogues.gd")

var items = {}
var enemies = {}
var shop_items = []
var tutorials = []
var talents = {}
var stand_power_values = []
var enemy_roster = []
var tournament_pools = {}
var tournament_rules = {}
var stands = {}
var technics = {}
var races = {}
var defaults = {}
var achievements = []
var dialogues = []
var dialogue_by_id = {}
var dialogue_by_text = {}
var dialogue_parity_sha256 = ""
var dialogue_counts = {}

var _loaded = false


# Копирует данные из Data/*.gd в индексы. Повторный вызов возвращает этот же объект.
func load_all():
	if _loaded:
		return self
	items = ItemsData.DATA.duplicate(true)
	enemies = EnemiesData.DATA.duplicate(true)
	shop_items = ShopItemsData.DATA.duplicate(true)
	tutorials = TutorialsData.DATA.duplicate(true)
	talents = TalentsData.DATA.duplicate(true)
	stand_power_values = StandPowerData.DATA.duplicate(true)
	enemy_roster = EnemyRosterData.DATA.duplicate(true)
	tournament_pools = TournamentPoolsData.DATA.duplicate(true)
	tournament_rules = TournamentRulesData.DATA.duplicate(true)
	stands = StandsData.DATA.duplicate(true)
	technics = TechnicsData.DATA.duplicate(true)
	races = RacesData.DATA.duplicate(true)
	defaults = DefaultsData.DATA.duplicate(true)
	achievements = AchievementsData.DATA.duplicate(true)
	var dialogue_data = DialoguesData.DATA.duplicate(true)
	var dialogue_lines = dialogue_data.get("lines", {})
	dialogues = []
	dialogue_parity_sha256 = str(dialogue_data.get("parity_sha256", ""))
	dialogue_counts = dialogue_data.get("counts", {})
	dialogue_by_id.clear()
	dialogue_by_text.clear()
	for dialogue_key in dialogue_lines:
		var entry_id = str(dialogue_key)
		var entry_text = str(dialogue_lines[dialogue_key])
		if entry_id == "":
			continue
		var entry = {"id": entry_id, "text": entry_text}
		dialogues.append(entry)
		dialogue_by_id[entry_id] = entry
		dialogue_by_text[entry_text] = entry_id
	_loaded = true
	return self


func is_loaded():
	return _loaded


# ------------------------------------------------------------
# ПРЕДМЕТЫ (0-based ID = индекс)
# ------------------------------------------------------------

# item_id — 0-based ID из Items.gd. Возвращает копию или {}.
func get_item(item_id):
	var key = str(int(item_id))
	if key in items:
		return items[key].duplicate(true)
	return {}


func get_item_name(item_id):
	var item = get_item(item_id)
	return str(item.get("item_name", ""))


func get_item_message_name(item_id):
	var item = get_item(item_id)
	var name_ = str(item.get("message_name", ""))
	if name_ == "":
		name_ = str(item.get("item_name", ""))
	return name_


func get_item_message_suffix(item_id):
	var item = get_item(item_id)
	return str(item.get("message_suffix", ""))


# Копия всей таблицы предметов; менять её для правок контента нельзя.
func get_items():
	return items.duplicate(true)


# ------------------------------------------------------------
# ВРАГИ (ключ = имя из Enemies.gd)
# ------------------------------------------------------------

# enemy_name — ключ из Enemies.gd (например, "Dio"). Возвращает копию или {}.
func get_enemy(enemy_name):
	var key = str(enemy_name)
	if key in enemies:
		return enemies[key].duplicate(true)
	return {}


func get_enemy_roster():
	return enemy_roster.duplicate(true)


func get_tournament_pool(is_boss):
	var key = "bosses" if is_boss else "regular"
	if key in tournament_pools:
		return tournament_pools[key].duplicate(true)
	return {}


func get_tournament_keys(is_boss):
	var key = "boss_order" if is_boss else "regular_order"
	if key in tournament_pools:
		return tournament_pools[key].duplicate(true)
	# Если порядок не задан в TournamentPools.gd, используем порядок ключей.
	return get_tournament_pool(is_boss).keys()


func get_tournament_rules():
	return tournament_rules.duplicate(true)


# ------------------------------------------------------------
# МАГАЗИН / ТУТОРИАЛЫ / ТАЛАНТЫ / СИЛА СТЕНДОВ
# ------------------------------------------------------------

func get_shop_items():
	return shop_items.duplicate(true)


func get_tutorials():
	return tutorials.duplicate(true)


func get_tutorial(tutorial_id):
	var wanted = float(tutorial_id)
	for entry in tutorials:
		if abs(float(entry.get("id", -1.0)) - wanted) < 0.0001:
			return entry.duplicate(true)
	return {}


# Расы 3 и 4 — эволюции пилламенов, поэтому используют дерево расы 2.
# Возвращаем ID расы, для которой реально есть данные талантов.
func get_talent_race_number(race_number):
	var race_id = int(race_number)
	if str(race_id) in talents:
		return race_id
	if race_id in [3, 4] and "2" in talents:
		return 2
	return race_id


func get_talent(race_number, talent_id):
	var race_key = str(int(race_number))
	var talent_key = str(int(talent_id))
	if race_key in talents and talent_key in talents[race_key]:
		return talents[race_key][talent_key].duplicate(true)
	return [4, 0, "", {}]


func get_stand_power(stand_number):
	var index = int(stand_number)
	if index >= 0 and index < stand_power_values.size():
		return float(stand_power_values[index])
	return 1.0


func get_stand(stand_number):
	var key = str(int(stand_number))
	if key in stands:
		return stands[key].duplicate(true)
	return {"index": "None", "direction": ""}


func get_technic(technic_number):
	var key = str(int(technic_number))
	if key in technics:
		return technics[key].duplicate(true)
	return {"index": "None", "stand_power_bonus": 0.0, "hand_damage_bonus": 0.0, "hp_bonus": 0.0}


func get_race(race_number):
	var key = str(int(race_number))
	if key in races:
		return races[key].duplicate(true)
	return {"index": "human", "hp": 100.0}


# ------------------------------------------------------------
# ЗНАЧЕНИЯ ПО УМОЛЧАНИЮ
# ------------------------------------------------------------

func get_default(key, fallback = null):
	if key in defaults:
		return defaults[key].duplicate(true)
	return fallback


func get_achievements():
	return achievements.duplicate(true)


# ------------------------------------------------------------
# ДИАЛОГИ (ручной каталог Data/Dialogues.gd)
# ------------------------------------------------------------

func get_dialogues():
	return dialogues.duplicate(true)


# dialogue_id — понятный ключ из Data/Dialogues.gd; {} для неизвестной строки.
func get_dialogue(dialogue_id):
	var wanted = str(dialogue_id)
	if wanted in dialogue_by_id:
		return dialogue_by_id[wanted].duplicate(true)
	return {}


# Текст по ID; пустая строка, если строка не найдена.
func get_dialogue_text(dialogue_id):
	var entry = get_dialogue(dialogue_id)
	if entry.empty():
		push_error("SedwcContent: неизвестный ключ диалога: " + str(dialogue_id))
		return ""
	return str(entry.get("text", ""))


# Обратный поиск ID по тексту; пустая строка, если текст не найден.
func get_dialogue_id(text):
	return str(dialogue_by_text.get(str(text), ""))


func get_dialogue_parity_sha256():
	return dialogue_parity_sha256


func get_dialogue_counts():
	return dialogue_counts.duplicate(true)
