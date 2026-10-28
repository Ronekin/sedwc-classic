# PlayerCombatActionService.gd — именованные атаки, снаряды и VFX игрока.
#
# Контракт: получает GGPlayer и использует его сцены, узлы, позиции и методы
# PlayerEntity. Новые атаки — отдельные функции и ветка в
# PlayerCombatControlService.

extends Reference


func chop_attack_kc(player):
	player.start_dop_kooldown(2)
	player.stand_attack_anim("StandSecondDopAttack")
	var enemy = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/Enemy")
	player.connect("enemy_timer_start", enemy, "enemy_timer_start")
	player.emit_signal("enemy_timer_start")
	player.disconnect("enemy_timer_start", enemy, "enemy_timer_start")
	player.get_node("ATTACK_SOUND").play("EPMTYPUNCH")
	General.count_attacks += 1


func overwrite_twoh_enemy_activ(player):
	# Сброс RNG и один randf() перед атакой — часть контракта разброса
	# последующих снарядов; не убирайте их без перебалансировки.
	player.random.randomize()
	player.random.randf()
	player.stand_attack_anim("Overr")
	player.get_node("AUDIO_EFFECT_STANDS").play("TwohSelfOverWrite")
	General.debuff_enemy = "TwohStun"
	General.enemy_block_all = true
	yield(player.get_tree().create_timer(5), "timeout")
	General.enemy_block_all = false
	General.debuff_enemy = ""


func zahvat_hg_enemy_activ(player):
	player.stand_attack_anim("zahvat_hg")


func barrage_ge_attack(player):
	if player.anim_stand.current_animation.find("Idle") == - 1 and player.anim_stand.current_animation.find("Move") == - 1:
		yield(player.anim_stand, "animation_finished")
	player.stand_attack_anim("StandSecondDopAttack")
	player.get_node("BARRAGE_STANDS").play("BarrageGoldExp")


func barrage_scretro_attack(player):
	if player.anim_stand.current_animation.find("Idle") == - 1 and player.anim_stand.current_animation.find("Move") == - 1:
		yield(player.anim_stand, "animation_finished")
	player.stand_attack_anim("StandThreeDopAttack")
	player.get_node("BARRAGE_STANDS").play("BarrageSCRetro")


func barrage_arm_spawn(player):
	var bararm: Object = player.barrage_arm.instance()
	bararm.global_position = player.get_node("YSort/Stand/Stand_Texture").global_position + Vector2(player.random.randi_range( - 3, 3), player.random.randi_range( - 30, 25))

	if General.player_direct == "left":
		bararm.start_position = player.get_node("YSort/Stand/Stand_Texture").global_position - Vector2(15, 0)
		bararm.rotation_degrees = player.get_node("YSort/Stand/Stand_Texture").rotation_degrees
	else:
		bararm.start_position = player.get_node("YSort/Stand/Stand_Texture").global_position + Vector2(15, 0)
		bararm.rotation_degrees = - player.get_node("YSort/Stand/Stand_Texture").rotation_degrees
	player.get_parent().add_child(bararm)
	bararm.velocity = bararm.global_position.direction_to(player.get_node("YSort/Stand/Stand_Texture/PunchPos").global_position)
	bararm.look_at(player.get_node("YSort/Stand/Stand_Texture/PunchPos").global_position)


func barrage_nail_spawn(player):
	var bararm = player.echoes_nail_arm.instance()
	if General.player_direct == "left":
		bararm.global_position = player.get_node("YSort/Stand/Stand_Texture").global_position - Vector2(player.random.randi_range( - 10, 30), player.random.randi_range( - 10, 20))
	else:
		bararm.global_position = player.get_node("YSort/Stand/Stand_Texture").global_position + Vector2(player.random.randi_range( - 10, 30), player.random.randi_range( - 10, 20))
	player.get_parent().add_child(bararm)


func knife_tw(player):
	if not General.player_attack_activate:
		General.player_attack_activate = true
		player.anim_player.play("Knife")
		yield(player.get_tree().create_timer(0.15), "timeout")
		player.attack_bullet(1)


func weapon_scr(player):
	player.attack_bullet(1)
	General.count_attacks += 1


func tusk2_hole_go(player):
	player.stand_attack_anim("TuskHole")
	General.count_attacks += 1


func echoes_glush_go(player):
	player.start_dop_kooldown(1)
	player.stand_attack_anim("StandSecondDopAttack")
	player.get_node("ATTACK_SOUND").play("EPMTYPUNCH")
	General.count_attacks += 1


func spin_default_go(player):
	if not General.player_attack_activate:
		General.player_attack_activate = true
		player.anim_player.play("Knife")
		yield(player.get_tree().create_timer(0.2), "timeout")

		player.attack_bullet( - 1)
		player.get_node("ATTACK_SOUND").play("EPMTYPUNCH")
		General.count_attacks += 1


func spin_infinity_go(player):
	player.attack_bullet( - 1)
	player.SoundPlay("res://Music/InfinitySpinBall.mp3", {"Volume_db": 15})
	player.get_node("ATTACK_SOUND").play("Infinityg_spin_go")
	General.count_attacks += 1


func laser_cyborg_go(player):
	if General.battery_charge >= 10:
		player.attack_bullet( - 1)
		player.get_node("ATTACK_SOUND").play("EPMTYPUNCH")
		General.count_attacks += 1
		General.battery_charge -= 10
	else:
		General.message_spawn("Center", "У вас недостаочно энергии, требуется 10")


func spin_inf_defense_go(player):
	General.block_type = "spin"
	player.get_node("ATTACK_SOUND").play("defense_spin_go")
	yield(player.get_tree().create_timer(5 + General.add_time_spin), "timeout")
	General.block_type = "None"


func spin_gyro_go(player):
	var hp_do = General.heart_points
	if General.dialog_activate == false and General.is_invent_show == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false and General.attacked == false and General.dashed == false and General.blocked == false:
		if General.dostup_combo:
			player.get_node("ATTACK_SOUND").play("SGyro")
			yield(player.get_tree().create_timer(4.6), "timeout")
			player.anim_player.play("Idle")
			if General.attacked == false and hp_do <= General.heart_points:
				player.attack_bullet( - 2)


func bubble_saw(player):
	player.start_dop_kooldown(1)
	player.attack_bullet(1)
	General.count_attacks += 1


func go_beyond_bubble_saw(player):
	player.attack_bullet(2)
	player.start_dop_kooldown(2)
	General.count_attacks += 1


func go_beyond_bubble_saw_start(player):
	player.anim_player.play("TuskAct1Nail")
	var bubble_inst = player.bubble_beyound_start.instance()
	player.get_parent().add_child(bubble_inst)
	bubble_inst.z_index = 1
	if player.global_position.distance_to(General.enemy_position) < 80:
		bubble_inst.global_position = player.get_node("TuskBulletCreate").global_position + Vector2(48, 0)
	else:
		bubble_inst.global_position = player.get_node("TuskBulletCreate").global_position


func spin_nail_go(player):
	if General.dostup_combo:
		player.stand_attack_anim("StandThreeDopAttack")
		player.anim_player.play("TuskAct1Nail")
		General.count_attacks += 3


func epitafia_damage(player):
	if General.enemy_direct == "Left":
		yield(player.get_tree().create_timer(0.05), "timeout")
		if player.dist_enemy_r.x < 100:
			player.global_position.x = (General.enemy_position.x + player.dist_r.x) - 35
		else:
			player.global_position.x = General.enemy_position.x + 65

	elif General.enemy_direct == "Right":
		yield(player.get_tree().create_timer(0.05), "timeout")
		if player.dist_enemy_l.x < 100:
			player.global_position.x = (General.enemy_position.x - player.dist_l.x) + 35
		else:
			player.global_position.x = General.enemy_position.x - 65

	if player.dist_enemy_b.y > 35 and player.dist_enemy_t.y > 35:
		player.global_position.y = General.enemy_position.y
	elif player.dist_enemy_b.y < 35:
		player.global_position.y = General.enemy_position.y - 35
	elif player.dist_enemy_t.y < 35:
		player.global_position.y = General.enemy_position.y + 35

	yield(player.get_tree().create_timer(0.05), "timeout")
	player.povorot_check(true)


func epitafia_vfx_spawn(player):
	var effect = player.vfx_epitafia.instance()
	player.get_node("YSort/Stand/Stand_Texture/EpitafiaEffectPos").add_child(effect)
	effect.z_index = 3


func za_warudo_tw(player):
	player.get_node("AUDIO_EFFECT_STANDS").play("ZaWarudoStart")
	yield(player.get_tree().create_timer(12), "timeout")
	player.get_node("AUDIO_EFFECT_STANDS").play("ZaWarudoEnd")


func ts_twoh(player):
	player.get_node("AUDIO_EFFECT_STANDS").play("TwohStart")
	yield(player.get_tree().create_timer(20), "timeout")
	player.get_node("AUDIO_EFFECT_STANDS").play("ZaWarudoEnd")


func shadow_tw_ts(player):
	player.get_node("AUDIO_EFFECT_STANDS").play("ShadowTwTimestopStart")
	yield(player.get_tree().create_timer(9), "timeout")
	player.get_node("AUDIO_EFFECT_STANDS").play("ShadowTWTimestopEnd")


func za_warudo_sp(player):
	player.get_node("AUDIO_EFFECT_STANDS").play("StarPlatinumZaWarudoStart")
	yield(player.get_tree().create_timer(8), "timeout")
	player.get_node("AUDIO_EFFECT_STANDS").play("ZaWarudoEnd")


func time_erase_kc(player):
	player.get_node("AUDIO_EFFECT_STANDS").play("TimeEraseStart")
	while General.time_erase:
		yield(player.get_tree().create_timer(0.1), "timeout")
	player.get_node("AUDIO_EFFECT_STANDS").play("TimeEraseEnd")


func barrage_tw_attack(player):
	if player.anim_stand.current_animation.find("Idle") == - 1 and player.anim_stand.current_animation.find("Move") == - 1:
		yield(player.anim_stand, "animation_finished")
	player.stand_attack_anim("StandThreeDopAttack")
	player.get_node("BARRAGE_STANDS").play("BarrageTheWorld")


func barrage_twoh_attack(player):
	if player.anim_stand.current_animation.find("Idle") == - 1 and player.anim_stand.current_animation.find("Move") == - 1:
		yield(player.anim_stand, "animation_finished")
	player.stand_attack_anim("StandSecondDopAttack")
	player.get_node("BARRAGE_STANDS").play("BarrageTheWorld")


func barrage_sp_attack(player):
	if player.anim_stand.current_animation.find("Idle") == - 1 and player.anim_stand.current_animation.find("Move") == - 1:
		yield(player.anim_stand, "animation_finished")
	player.stand_attack_anim("StandSecondDopAttack")
	player.get_node("BARRAGE_STANDS").play("BarrageStarPlatinum")


func barrage_saw_attack(player):
	if player.anim_stand.current_animation.find("Idle") == - 1 and player.anim_stand.current_animation.find("Move") == - 1:
		yield(player.anim_stand, "animation_finished")
	player.stand_attack_anim("StandThreeDopAttack")
	player.get_node("BARRAGE_STANDS").play("BarrageSoft&Wet")


func barrage_e1_attack(player):
	if player.anim_stand.current_animation.find("Idle") == - 1 and player.anim_stand.current_animation.find("Move") == - 1:
		yield(player.anim_stand, "animation_finished")
	player.stand_attack_anim("StandThreeDopAttack")


func ge_tree_spawn(player):
	var tree_inst = player.tree_ge.instance()
	if player.get_node("TreeGoldExpSpawn").global_position.y + 30 < General.enemy_position.y:
		tree_inst.area_enabled = false
	else:
		tree_inst.area_enabled = true
	player.get_parent().add_child(tree_inst)
	tree_inst.global_position = player.get_node("TreeGoldExpSpawn").global_position
	General.count_attacks += 1


func ger_tree_spawn(player):
	var tree_inst = player.tree_ge.instance()
	if player.get_node("TreeGoldExpSpawn").global_position.y + 30 < General.enemy_position.y:
		tree_inst.area_enabled = false
	else:
		tree_inst.area_enabled = true
	player.get_parent().add_child(tree_inst)
	tree_inst.global_position = player.get_node("TreeGoldExpSpawn").global_position
	General.count_attacks += 1


func twoh_light_spawn(player):
	player.SoundPlay("res://Music/TWOHlighting.mp3", {"Volume_db": 3})
	var twoh_light_inst = player.twoh_light.instance()
	if player.get_node("TreeGoldExpSpawn").global_position.y + 30 < General.enemy_position.y:
		twoh_light_inst.area_enabled = false
	else:
		twoh_light_inst.area_enabled = true
	player.get_parent().add_child(twoh_light_inst)
	twoh_light_inst.global_position = player.get_node("TreeGoldExpSpawn").global_position
	General.count_attacks += 1


func tusk_3_hole_go(player):
	if General.dostup_combo:
		General.attacked = true
		player.anim_player.play("TuskAct3HoleAttack")
		var effect = player.tusk_3_hole.instance()
		if General.enemy_direct == "Right":
			player.tusk_3_hole_position = General.enemy_position - Vector2(100, 60)
		else:
			player.tusk_3_hole_position = General.enemy_position + Vector2(100, - 60)
		effect.global_position = player.tusk_3_hole_position
		var pos_save = player.get_node("TuskBulletCreate").position

		player.get_parent().add_child(effect)

		for i in 3:
			player.get_node("TuskBulletCreate").global_position = player.tusk_3_hole_position
			player.attack_bullet(1.5)
			yield(player.get_tree().create_timer(0.2), "timeout")
		General.attacked = false
		player.get_node("TuskBulletCreate").position = pos_save


func black_hole_save(player):
	if General.dostup_combo:
		var effect = player.tusk_4_hole.instance()
		player.tusk_4_hole_position = General.player_pos
		effect.global_position = player.tusk_4_hole_position
		player.get_parent().add_child(effect)
		player.get_node("YSort/Animations/DopAnimations").play("InHoleTusk")
		yield(player.get_node("YSort/Animations/DopAnimations"), "animation_finished")
		player.visible = false
		if General.techic_number == 2:
			yield(player.get_tree().create_timer(5), "timeout")
			player.health_up(General.heart_points * 0.5)
		if General.techic_number != 2:
			yield(player.get_tree().create_timer(3), "timeout")
			player.health_up(General.heart_points * 0.25)
		var effectes = player.tusk_4_hole.instance()
		player.tusk_4_hole_position_2 = General.player_pos
		effectes.global_position = player.tusk_4_hole_position_2
		player.get_parent().add_child(effectes)
		player.visible = true
		player.get_node("YSort/Animations/DopAnimations").play("ExitHoleTusk")
		yield(player.get_node("YSort/Animations/DopAnimations"), "animation_finished")


func tusk_3_bd_go(player):
	if General.dostup_combo:
		player.stand_attack_anim("StandThreeDopAttack")
		player.anim_player.play("TuskAct1Nail")
		General.count_attacks += 1


func tusk_4_bd_go(player):
	if General.dostup_combo:
		player.stand_attack_anim("StandThreeDopAttack")
		player.anim_player.play("TuskAct1Nail")
		General.count_attacks += 1


func sp_starfinger_go(player):
	if General.dostup_combo:
		player.stand_attack_anim("StandThreeDopAttack")
		player.get_node("AUDIO_EFFECT_STANDS").play("StarPlatinumStarFinger")
		General.count_attacks += 1
