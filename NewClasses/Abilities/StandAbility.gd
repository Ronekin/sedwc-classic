# StandAbility.gd — стенд игрока как AbilityMassive.
#
# Данные стенда (номер, index, direction, power, frame) — в Data/Stands.gd;
# способности регистрируются из данных. GGPlayer владеет сценой и делегирует
# сюда призыв и анимации стенда.
#
# Моддинг: новый стенд — запись в Data/Stands.gd + сцена/анимации; не добавляйте
# стендовые ветки в GGPlayer.

extends "res://Core/CoreResources/AbilityMassive.gd"
class_name StandAbility

const STAND_PARTICLES = preload("res://Scenes/StandEffect.tscn")

var player = null
var content = null
var stand_number = 0
var stand_index = "None"
var stand_direction = "Left"
var frame = 0
var power = 1.0
var activated = false
# Кэш пути текстуры: stand_animation() вызывается каждый кадр, а load()
# каждый кадр — лишняя работа и ошибка, если для стенда нет PNG (например,
# stand_index == "None").
var _stand_texture_path = ""


func setup(owner_entity, content_db):
	player = owner_entity
	content = content_db
	set_owner_entity(owner_entity)
	am_type = "stand"
	ability_name = "Stand"
	return self


func set_stand(number):
	stand_number = int(number)
	if content == null:
		return self
	var data = content.get_stand(stand_number)
	stand_index = str(data.get("index", "None"))
	stand_direction = str(data.get("direction", "Left"))
	frame = int(data.get("frame", 0))
	power = float(content.get_stand_power(stand_number))
	_register_data_abilities(data.get("abilities", []))
	return self


# Регистрирует ровно те способности, которые перечислены в Data/Stands.gd.
# Базовые summon/default_attack/barrage тоже лежат в данных, чтобы не было
# скрытых способностей, которых нет в таблице.
func _register_data_abilities(ids):
	abilities.clear()
	cooldowns.clear()
	if not (ids is Array):
		return
	for ability_id in ids:
		register_ability(str(ability_id), {"cooldown": 0.0})


# Публичный снимок списка способностей для UI, тестов и модов.
func get_ability_ids() -> Array:
	return abilities.keys()


func can_summon():
	return stand_index != "None"


func activate_stand():
	activated = true
	emit_signal("ability_activated", "summon", {})


func deactivate_stand():
	activated = false
	emit_signal("ability_deactivated", "summon")


func stand_activate():
	if player == null:
		return
	if General.stand_index != "None" and player.anim_stand.current_animation.find("Hiden") == - 1:
		if General.stand_activated == false and General.player_attack_activate == false and General.barrage_activate == false:
			player.stand_activate_activated = true
			player.stand_sprite.show()
			var stand_particles_create = STAND_PARTICLES.instance()
			if General.player_on_ysort_area == false:
				player.get_parent().get_parent().add_child(stand_particles_create)
				stand_particles_create.z_index = 3
			else:
				player.get_parent().add_child(stand_particles_create)
				stand_particles_create.z_index = 1
			stand_particles_create.emitting = true
			stand_particles_create.one_shot = true
			stand_particles_create.position = Vector2(player.global_position.x, player.global_position.y - 60)
			player.anim_stand.play("Show" + General.stand_direction_set)
			player.anim_stand.seek(0)
			player.get_node("AuraAnim").play("Show")
			General.stand_activated = true
			activated = true
			match General.stand_number:
				20: player.SoundPlay("res://Music/WSsummon.mp3")
				22: player.SoundPlay("res://Music/C_Moon_Summon.mp3", {"Volume_db": 15})
				23: player.SoundPlay("res://Music/MIHsummon.mp3")
				24:
					player.SoundPlay("res://Music/GERsummon.mp3")
					player.SoundPlay("res://Music/StandSummonEffect.mp3", {"Volume_db": 5})
				25:
					player.SoundPlay("res://Music/D4Csummon.mp3")
					player.SoundPlay("res://Music/StandSummonEffect.mp3", {"Volume_db": 5})
				26:
					player.SoundPlay("res://Music/WoU_Summon.mp3")
					player.SoundPlay("res://Music/StandSummonEffect.mp3", {"Volume_db": 5})
				_:
					player.get_node("STANDSUMMON").play(General.stand_index + "StandSummon")
		elif General.stand_activated and General.player_attack_activate == false and General.barrage_activate == false:
			player.stand_activate_activated = true
			player.anim_stand.play("Hiden" + General.stand_direction_set)
			player.get_node("AuraAnim").play("Hide")
			player.anim_stand.seek(0)
			activated = false


func on_stand_animation_finished(anim_name):
	if player == null:
		return
	if anim_name.find("Show") != - 1:
		if General.stand_index != "EhosAct0":
			player.anim_stand.play(General.stand_direction_set + "Idle")
		else:
			if General.velocity_player == Vector2.ZERO:
				player.anim_stand.play(General.stand_direction_set + "Idle")
			else:
				player.anim_stand.play(General.stand_direction_set + "Move")
		player.stand_activate_activated = false
		General.stand_activated = true
		activated = true
	elif anim_name.find("_Back") != - 1:
		if General.stand_index != "EhosAct0":
			player.anim_stand.play(General.stand_direction_set + "Idle")
		else:
			if General.velocity_player == Vector2.ZERO:
				player.anim_stand.play(General.stand_direction_set + "Idle")
			else:
				player.anim_stand.play(General.stand_direction_set + "Move")
		General.player_attack_activate = false
		General.dostup_combo = true
	elif anim_name.find("Hiden") != - 1:
		player.stand_sprite.hide()
		player.stand_activate_activated = false
		General.stand_activated = false
		activated = false
	elif anim_name.find("_Up") != - 1 or anim_name.find("_Mid") != - 1:
		if anim_name.find("StandDefaultAttack") != - 1:
			player.anim_stand.play("Hit")
		elif anim_name.find("StandSecondDopAttack") != - 1 and General.stand_number != 3 and General.stand_number != 2 and General.stand_number != 16:
			player.anim_stand.play(General.stand_index + "StandSecondDopAttack_Back")
			if General.stand_number == 8:
				# В разных аренах враг лежит в YSorting или SortingY, а в
				# сценах без врага узла может не быть вовсе. Не роняем удар
				# из-за отсутствующего Enemy.
				var scene = player.get_tree().current_scene
				var enemy = scene.get_node_or_null("YSorting/Enemy")
				if enemy == null:
					enemy = scene.get_node_or_null("SortingY/Enemy")
				if enemy != null and is_instance_valid(enemy) and enemy.has_method("chop_end"):
					player.connect("chop_end", enemy, "chop_end")
					player.emit_signal("chop_end")
					player.disconnect("chop_end", enemy, "chop_end")
		elif anim_name.find("StandBigAttack") != - 1:
			player.anim_stand.play(General.stand_index + "StandBigAttack_Back")
		elif anim_name.find("StandThreeDopAttack") != - 1 and General.stand_number != 1 and General.stand_number != 10 and General.stand_number != 6 and General.stand_number != 18 and General.stand_number != 19:
			player.anim_stand.play(General.stand_index + "StandThreeDopAttack_Back")
		elif anim_name.find("StandSecondDopAttack") != - 1 and (General.stand_number == 3 or General.stand_number == 2 or General.stand_number == 16):
			player.anim_stand.play(General.stand_index + "StandSecondDopAttack_Mid")
		elif anim_name.find("StandThreeDopAttack") != - 1 and (General.stand_number == 1 or General.stand_number == 10 or General.stand_number == 6 or (General.stand_number != 18 and General.stand_number != 19)):
			player.anim_stand.play(General.stand_index + "StandThreeDopAttack_Mid")
	if anim_name.find("Show") == - 1:
		if not (General.stand_number in [13, 7]):
			player.MoveAnimStand.play("ToBack")
		else:
			player.anim_stand.play(General.stand_direction_set + "Idle")
			General.player_attack_activate = false
			General.dostup_combo = true
		player.stand_sprite.frame = 0
	var stand_area = player.get_node("YSort/Stand/StandArea")
	for group in stand_area.get_groups():
		if stand_area.is_in_group(group):
			stand_area.remove_from_group(group)


func stand_attack_anim(anim_name):
	if player == null:
		return
	if General.dostup_combo and player.stand_activate_activated == false:
		if player.MoveAnimStand.current_animation.find("Front") != - 1:
			player.anim_stand.play(anim_name)
			if General.stand_number != 13:
				player.MoveAnimStand.stop()
				player.MoveAnimStand.play("Mid")
			if anim_name == "Hit":
				General.default_attack_count += 1
		elif player.MoveAnimStand.current_animation.find("Mid") != - 1:
			player.anim_stand.stop()
			if General.stand_number != 13:
				player.MoveAnimStand.stop()
				player.MoveAnimStand.play("Mid")
			player.anim_stand.play(anim_name)
			if anim_name == "Hit":
				General.default_attack_count += 1
		else:
			if player.anim_stand.current_animation.find("Idle") == - 1 and player.anim_stand.current_animation.find("Move") == - 1:
				pass
			if General.stand_number != 13:
				player.MoveAnimStand.play("ToFront")
				player.MoveAnimStand.seek(0)
			player.anim_stand.play(anim_name)
			player.anim_stand.seek(0)
			if anim_name == "Hit":
				General.default_attack_count += 1
			if anim_name == "Idle":
				player.anim_player.play("SpinDestroy")
				yield(player.get_tree().create_timer(4.6), "timeout")
				yield(player.anim_stand, "animation_finished")
		General.player_attack_activate = true
		General.dostup_combo = false
		if anim_name == "StandDefaultAttack" and General.stand_number != 14:
			player.get_node("ATTACK_SOUND").play("EPMTYPUNCH")
		if anim_name == "StandDefaultAttack" and General.stand_number == 14:
			player.get_node("ATTACK_SOUND").play("ShadowTWAttack")
		player.position_first = player.global_position


func barrage_start(anim_name):
	if player == null:
		return
	if General.player_attack_activate != true:
		player.anim_stand.play(General.stand_index + anim_name + "_Up")
	General.player_attack_activate = true
	player.position_first = player.global_position


func move_stand_anim():
	if player == null:
		return
	if General.player_attack_activate == false and player.stand_activate_activated == false and General.stand_activated and General.dashed == false and General.attacked == false:
		if General.stand_index != "EhosAct0":
			player.anim_stand.play(General.stand_direction_set + "Idle")
		else:
			if General.velocity_player != Vector2.ZERO:
				player.anim_stand.play(General.stand_direction_set + "Move")
				yield(player.anim_stand, "animation_finished")
				player.anim_stand.play(General.stand_direction_set + "Move")
			else:
				yield(player.anim_stand, "animation_finished")
				player.anim_stand.play(General.stand_direction_set + "Idle")


func stand_animation():
	if player == null:
		return
	if player.anim_stand.current_animation.find("Idle") != - 1 or player.anim_stand.current_animation.find("Show") != - 1 or player.anim_stand.current_animation.find("Hiden") != - 1:
		var texture_path = "res://Textures/Stands/" + General.stand_index + ".png"
		if "NoArmor" in player.addition:
			texture_path = "res://Textures/Stands/SCRetroNoArmor.png"
		if _stand_texture_path != texture_path:
			_stand_texture_path = texture_path
			if ResourceLoader.exists(texture_path):
				player.stand_sprite.texture = load(texture_path)
			else:
				# У стенда "None" и у модовых стендов без PNG текстуры может
				# не быть. Не печатаем ошибку загрузки каждый кадр.
				player.stand_sprite.texture = null
		if player.stand_sprite.texture:
			if ("NoArmor" in player.addition):
				player.stand_sprite.hframes = player.stand_sprite.texture.get_width() / 150
				player.stand_sprite.vframes = player.stand_sprite.texture.get_height() / 100
			elif player.stand_sprite.texture.get_width() == 800 or General.stand_number == 13:
				player.stand_sprite.hframes = player.stand_sprite.texture.get_width() / 200
				player.stand_sprite.vframes = player.stand_sprite.texture.get_height() / 200
			elif player.stand_sprite.texture.get_width() > 1000:
				player.stand_sprite.hframes = player.stand_sprite.texture.get_width() / 330
				player.stand_sprite.vframes = player.stand_sprite.texture.get_height() / 330
			elif player.stand_sprite.texture.get_width() < 800:
				player.stand_sprite.hframes = 1
				player.stand_sprite.vframes = 1
		player.stand_sprite.frame = frame
	if General.stand_activated == false:
		player.stand_sprite.hide()


func on_stand_move_anim_finished(anim_name):
	if player == null:
		return
	if anim_name.find("Show") != - 1:
		if General.stand_index != "EhosAct0":
			player.anim_stand.play(General.stand_direction_set + "Idle")
		else:
			if General.velocity_player == Vector2.ZERO:
				player.anim_stand.play(General.stand_direction_set + "Idle")
			else:
				player.anim_stand.play(General.stand_direction_set + "Move")
		player.stand_activate_activated = false
		General.stand_activated = true
		activated = true
	elif anim_name.find("Back") != - 1:
		if General.stand_index != "EhosAct0":
			player.anim_stand.play(General.stand_direction_set + "Idle")
		else:
			if General.velocity_player == Vector2.ZERO:
				player.anim_stand.play(General.stand_direction_set + "Idle")
			else:
				player.anim_stand.play(General.stand_direction_set + "Move")
		General.player_attack_activate = false
		General.dostup_combo = true
	elif anim_name.find("Hiden") != - 1:
		player.stand_sprite.hide()
		player.stand_activate_activated = false
		General.stand_activated = false
		activated = false
	elif anim_name.find("Up") != - 1 or anim_name.find("Mid") != - 1:
		if ("CutScene" in General.Addition) == false:
			player.MoveAnimStand.play("ToBack")
		if anim_name.find("StandDefaultAttack") != - 1:
			player.anim_stand.play("Hit")
		elif anim_name.find("StandSecondDopAttack") != - 1 and General.stand_number != 3 and General.stand_number != 2 and General.stand_number != 16:
			player.anim_stand.play(General.stand_index + "StandSecondDopAttack_Back")
			if General.stand_number == 8:
				# В разных аренах враг лежит в YSorting или SortingY, а в
				# сценах без врага узла может не быть вовсе. Не роняем удар
				# из-за отсутствующего Enemy.
				var scene = player.get_tree().current_scene
				var enemy = scene.get_node_or_null("YSorting/Enemy")
				if enemy == null:
					enemy = scene.get_node_or_null("SortingY/Enemy")
				if enemy != null and is_instance_valid(enemy) and enemy.has_method("chop_end"):
					player.connect("chop_end", enemy, "chop_end")
					player.emit_signal("chop_end")
					player.disconnect("chop_end", enemy, "chop_end")
		elif anim_name.find("StandBigAttack") != - 1:
			player.anim_stand.play(General.stand_index + "StandBigAttack_Back")
		elif anim_name.find("StandThreeDopAttack") != - 1 and General.stand_number != 1 and General.stand_number != 10 and General.stand_number != 6 and General.stand_number != 18 and General.stand_number != 19:
			player.anim_stand.play(General.stand_index + "StandThreeDopAttack_Back")
		elif anim_name.find("StandSecondDopAttack") != - 1 and (General.stand_number == 3 or General.stand_number == 2 or General.stand_number == 16):
			player.anim_stand.play(General.stand_index + "StandSecondDopAttack_Mid")
		elif anim_name.find("StandThreeDopAttack") != - 1 and (General.stand_number == 1 or General.stand_number == 10 or General.stand_number == 6 or (General.stand_number != 18 and General.stand_number != 19)):
			player.anim_stand.play(General.stand_index + "StandThreeDopAttack_Mid")


func serialize():
	var data = .serialize()
	data["stand_number"] = stand_number
	data["stand_index"] = stand_index
	data["stand_direction"] = stand_direction
	data["frame"] = frame
	data["power"] = power
	data["activated"] = activated
	return data
