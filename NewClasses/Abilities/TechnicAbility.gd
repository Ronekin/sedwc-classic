# TechnicAbility.gd — техника игрока как AbilityMassive.
#
# Данные техник (SPIN, Perfect Spin, Combat Master, Vampirism, Pillarmen,
# Swordmaster) — в Data/Technics.gd; класс регистрирует способности и
# бонусы.
#
# Моддинг: новая техника — запись в Data/Technics.gd и ветка в set_technic().

extends "res://Core/CoreResources/AbilityMassive.gd"
class_name TechnicAbility

var player = null
var content = null
var technic_number = 0
var technic_index = "None"
var stand_power_bonus = 0.0
var hand_damage_bonus = 0.0
var hp_bonus = 0.0


func setup(owner_entity, content_db):
	player = owner_entity
	content = content_db
	set_owner_entity(owner_entity)
	am_type = "technic"
	ability_name = "Technic"
	return self


func set_technic(number):
	technic_number = int(number)
	if content == null:
		return self
	var data = content.get_technic(technic_number)
	technic_index = str(data.get("index", "None"))
	stand_power_bonus = float(data.get("stand_power_bonus", 0.0))
	hand_damage_bonus = float(data.get("hand_damage_bonus", 0.0))
	hp_bonus = float(data.get("hp_bonus", 0.0))
	_register_data_abilities(data.get("abilities", []))
	return self


func _register_data_abilities(ids):
	abilities.clear()
	cooldowns.clear()
	for ability_id in ids:
		register_ability(str(ability_id), {"cooldown": 0.0})


func serialize():
	var data = .serialize()
	data["technic_number"] = technic_number
	data["technic_index"] = technic_index
	data["stand_power_bonus"] = stand_power_bonus
	data["hand_damage_bonus"] = hand_damage_bonus
	data["hp_bonus"] = hp_bonus
	return data
