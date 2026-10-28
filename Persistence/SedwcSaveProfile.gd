# SedwcSaveProfile.gd — JSON-профиль SEDWC Classic.
#
# Ядро Core.Save хранит конверт; здесь — список полей мода и кодирование
# Vector2/Color/Rect2 в JSON-совместимые словари. Старый бинарный
# NewEraSave.save больше не читается: формат сохранения только JSON.
#
# Моддинг:
# - новое сохраняемое поле добавляйте в SAVE_FIELDS и в serialize/deserialize;
# - SAVE_VERSION повышайте при несовместимом изменении формата;
# - отсутствующие в сейве поля заполняет GeneralStateService.

extends Reference

const SAVE_VERSION = 6
const SAVE_SLOT = "sedwc_classic"

const SAVE_FIELDS = [
	"items_inventory",
	"stand_number",
	"techic_all",
	"techic_number",
	"hp_max",
	"level_points",
	"expirience_points",
	"quests",
	"complete_quests",
	"mini_true_game_complete",
	"money",
	"camera_speed",
	"camera_scale",
	"jesus_dialog_complete",
	"day_night_animation_second",
	"time",
	"stand_slots",
	"is_money_loosed",
	"add_damage_spin",
	"add_hand_damage",
	"talents_score",
	"houses",
	"tournir_record",
	"hands_opens",
	"hous_contains",
	"race_index",
	"race_number",
	"twoh_complete_quest",
	"event_coins",
	"talents_buff",
	"bonus_player",
	"limit_player",
	"teleport_charges",
	"cyborg_arms",
	"player_name",
	"sb_items",
	"timer_grass",
	"grasses",
	"day",
	"smokes",
	"loading",
	"points",
	"egg_coin",
	"egg_lvl",
	"egg_upgrade",
	"achievements",
	"kills",
	"deaths",
	"quequ_achiev",
	"player_statistic",
	"s_coins",
	"all_skins",
	"choose_skins",
	"talents",
	"LastToutnamentLvl",
	"sedwc_version",
	"donate",
	"global_bonus",
]


# Сохраняет профиль в Core.Save. false — если Core недоступен или запись не удалась.
func save_to_core(general):
	var core = _core(general)
	if core == null:
		return false
	var data = serialize(general)
	return core.save_game(SAVE_SLOT, data)


func load_from_core(general):
	var core = _core(general)
	if core == null:
		return false
	if not core.save_exists(SAVE_SLOT):
		return false
	var data = core.load_game(SAVE_SLOT)
	if typeof(data) != TYPE_DICTIONARY:
		# Повреждённый JSON откладываем в сторону, чтобы он не блокировал
		# запуск. Игра стартует с чистыми значениями по умолчанию.
		_quarantine_corrupt_save(core)
		return false
	deserialize(general, data)
	return true


# Собирает JSON-словарь из SAVE_FIELDS + метаданные формата.
func serialize(general):
	var data = {}
	for field in SAVE_FIELDS:
		if field == "achievements":
			var acs = _acs(general)
			data[field] = encode_value(acs.achievements if acs != null else [])
		else:
			data[field] = encode_value(general.get(field))
	data["save_version"] = SAVE_VERSION
	data["build_version"] = encode_value(general.get("build_version"))
	data["saved_at"] = OS.get_unix_time()
	return data


# Восстанавливает поля из JSON. Отсутствующие поля пропускаются, затем идут
# миграции _post_load().
func deserialize(general, data):
	if typeof(data) != TYPE_DICTIONARY:
		return false
	for field in SAVE_FIELDS:
		if not (field in data):
			continue
		if field == "achievements":
			var acs = _acs(general)
			if acs != null:
				acs.achievements = decode_value(data[field])
		else:
			general.set(field, decode_value(data[field]))
	_post_load(general)
	return true


# Кодирует Vector2/Vector3/Color/Rect2 в JSON-совместимые словари.
# Новый тип добавляйте одновременно в encode_value() и decode_value().
func encode_value(value):
	match typeof(value):
		TYPE_VECTOR2:
			return {"__type": "Vector2", "x": value.x, "y": value.y}
		TYPE_VECTOR3:
			return {"__type": "Vector3", "x": value.x, "y": value.y, "z": value.z}
		TYPE_COLOR:
			return {"__type": "Color", "r": value.r, "g": value.g, "b": value.b, "a": value.a}
		TYPE_RECT2:
			return {
				"__type": "Rect2",
				"x": value.position.x,
				"y": value.position.y,
				"w": value.size.x,
				"h": value.size.y
			}
		TYPE_DICTIONARY:
			var dict = {}
			for key in value:
				dict[str(key)] = encode_value(value[key])
			return dict
		TYPE_ARRAY:
			var list = []
			for item in value:
				list.append(encode_value(item))
			return list
	return value


func decode_value(value):
	if typeof(value) == TYPE_DICTIONARY:
		var kind = str(value.get("__type", ""))
		if kind == "Vector2":
			return Vector2(float(value.get("x", 0.0)), float(value.get("y", 0.0)))
		if kind == "Vector3":
			return Vector3(float(value.get("x", 0.0)), float(value.get("y", 0.0)), float(value.get("z", 0.0)))
		if kind == "Color":
			return Color(float(value.get("r", 0.0)), float(value.get("g", 0.0)), float(value.get("b", 0.0)), float(value.get("a", 1.0)))
		if kind == "Rect2":
			return Rect2(Vector2(float(value.get("x", 0.0)), float(value.get("y", 0.0))), Vector2(float(value.get("w", 0.0)), float(value.get("h", 0.0))))
		var dict = {}
		for key in value:
			dict[key] = decode_value(value[key])
		return dict
	if typeof(value) == TYPE_ARRAY:
		var list = []
		for item in value:
			list.append(decode_value(item))
		return list
	return value


func _post_load(general):
	# Турнирный уровень в старых JSON мог быть строкой.
	if general.get("LastToutnamentLvl") != null:
		general.set("LastToutnamentLvl", int(str(general.get("LastToutnamentLvl"))))


func _core(general):
	if general == null:
		return null
	return general.get_node_or_null("/root/Core")


func _acs(general):
	if general == null:
		return null
	return general.get_node_or_null("/root/acs")


func _quarantine_corrupt_save(core):
	var path = str(core.save_path(SAVE_SLOT))
	var dir = Directory.new()
	if not dir.file_exists(path):
		return
	var target = path + ".corrupt-" + str(OS.get_unix_time())
	dir.rename(path, target)
