# SpecAbility.gd — расовая специализация игрока как AbilityMassive.
#
# Данные рас — в Data/Races.gd (человек, вампир, пилармен, эволюционировавший
# пилармен, совершенное существо, киборг). Пассивки применяются к
# AbilityMassive; киборг дополнительно инициализирует батарею из сейва.
#
# Моддинг: новая раса — запись в Data/Races.gd и ветка в set_race().

extends "res://Core/CoreResources/AbilityMassive.gd"
class_name SpecAbility

var player = null
var content = null
var race_number = 0
var race_index = "human"
var base_hp = 100.0


func setup(owner_entity, content_db):
	player = owner_entity
	content = content_db
	set_owner_entity(owner_entity)
	am_type = "spec"
	ability_name = "Spec"
	return self


func set_race(number):
	race_number = int(number)
	if content == null:
		return self
	var data = content.get_race(race_number)
	race_index = str(data.get("index", "human"))
	base_hp = float(data.get("hp", 100.0))
	passives.clear()
	for passive_id in data.get("passives", []):
		apply_passive(str(passive_id), true)
	return self


func apply_cyborg_battery(general):
	if race_number != 5 or general == null:
		return
	yield(general.get_tree().create_timer(0.5), "timeout")
	if general.Stats.get("C_max_bullets", 0) > 0:
		general.Addition["C_bullets"] = general.Stats["C_max_bullets"]
	if general.Stats.get("C_Volume", 0) > 0:
		general.Addition["C_Charge"] = general.Stats["C_Volume"]
		general.Addition["C_ChargeStart"] = float(general.Stats["C_Volume"]) * 0.95
	general.Addition["C_Worched"] = 0.0
	if "Cyborg" in general.other_save:
		var parts = general.other_save["Cyborg"][1]
		if parts.size() > 6 and parts[3] != "" and parts[6] != "":
			var bat_parts = parts[6].split("/")
			if bat_parts.size() >= 2:
				general.Addition["C_Battery"] = max(0.0, float(bat_parts[1]))


func serialize():
	var data = .serialize()
	data["race_number"] = race_number
	data["race_index"] = race_index
	data["base_hp"] = base_hp
	return data
