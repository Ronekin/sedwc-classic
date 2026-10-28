# HitBoxEnemy.gd — обработка попаданий атак игрока по врагам.
#
# Контракт: handle() получает Enemy и Area2D атаки; всё состояние игры — через
# General. Новые типы попаданий добавляйте сюда, а не в сцены.

extends Reference


func handle(Enemy, area):
	var random_crit_proc = Enemy.random_crit.randf()
	if area.is_in_group("ws_disc"):
		General.default_damage(Enemy, "lt", 10, 6, true, false)
		General.SoundPlay("res://Music/ws_Disc.mp3")
		var da = Sprite.new()
		da.texture = load("res://Textures/Details/WhSn_Disc.png")
		da.hframes = 3
		da.vframes = 3
		da.scale *= 2
		Enemy.get_parent().add_child(da)
		da.global_position = Enemy.global_position + Vector2(10, - 59)
		da.z_index = 4
		General.start_combo_timer_for_enemy(Enemy, 5)
		General.start_glush_enemy_timer(5)
		var h = preload("res://Scenes/Hieroglyph.tscn").instance()
		General.get_parent().add_child(h)
		if Enemy.global_position.x > General.player_pos.x:
			h.global_position = Enemy.global_position + Vector2(50, - 60)
		else:
			h.global_position = Enemy.global_position + Vector2( - 50, - 60)
		h.get_node("AnimationPlayer").play("Mega")
		if Enemy.health <= 0:
			General.loot_info.append("jotaro_disc")
		
		for i in 5:
			
			yield(General.get_tree().create_timer(0.1), "timeout")
			da.frame += 1
		da.frame = 6
		for i in 15:
			da.position.y += 5
			if i % 2 == 0:
				if da.frame == 5:
					da.frame = 6
				else:
					da.frame = 5
			yield(General.get_tree().create_timer(0.02), "timeout")
		h.queue_free()
		da.z_index = 2
		da.frame = 5
		yield(General.get_tree().create_timer(1.9), "timeout")
		for i in 10:
			yield(General.get_tree().create_timer(0.1), "timeout")
		
	elif area.is_in_group("Scorpio"):
		
		
		var Scorpio: Object = area.get_parent()

		General.default_damage(Enemy, "lt", 10, 6, true, false)
		
		yield(General.get_tree().create_timer(0.15), "timeout")
		General.SoundPlay("res://Music/NailDamage.mp3")
		if true:
			var da = preload("res://Scenes/Particles.tscn").instance()
			Enemy.get_parent().add_child(da)
			da.Play("MegaBlood")
			da.scale *= 0.5
			da.global_position = Scorpio.global_position + Vector2(0, - 40)
			da.global_position.x = Enemy.global_position.x
			da.z_index = 10
	elif area.is_in_group("LV"):
		var da = preload("res://Scenes/Particles.tscn").instance()
		Enemy.get_parent().add_child(da)
		da.Play("Blood")
		da.global_position = Vector2(Enemy.global_position.x, area.global_position.y - 50)
		da.z_index = 10
		General.SoundPlay("res://Music/BigPunchEffect.mp3")
		General.default_damage(Enemy, "lt", 2.0, 0, true, false)
	elif area.is_in_group("R_L"):
		var da = preload("res://Scenes/Particles.tscn").instance()
		Enemy.get_parent().add_child(da)
		da.Play("Blood")
		da.global_position = Vector2(Enemy.global_position.x, area.global_position.y - 50)
		da.z_index = 10
		General.SoundPlay("res://Music/BigPunchEffect.mp3")
		General.StunEnemy(Enemy, 2.5)
		General.default_damage(Enemy, "lt", 25.0, 0, true, false)
	elif area.is_in_group("C_L"):
		var da = preload("res://Scenes/Particles.tscn").instance()
		Enemy.get_parent().add_child(da)
		da.Play("Blood")
		da.global_position = Vector2(Enemy.global_position.x, area.global_position.y - 50)
		da.z_index = 10

		General.default_damage(Enemy, "lt", 3.0 * General.Stats["C_ED"], 0, true, false)
		
	elif area.is_in_group("GERstone"):
		
		
		General.SoundPlay("res://Music/GERhitLaser.mp3")

		General.default_damage(Enemy, "lt", 10, 6, true, false)
		var AreaPos: Vector2 = area.global_position
		if true:
			var da = preload("res://Scenes/Particles.tscn").instance()
			Enemy.get_parent().add_child(da)
			da.Play("Blood")
			da.global_position = AreaPos
			da.global_position.x = Enemy.global_position.x
			da.z_index = 10
		yield(General.get_tree().create_timer(0.5), "timeout")
		if true:
			var da = preload("res://Scenes/Particles.tscn").instance()
			Enemy.get_parent().add_child(da)
			da.Play("MegaBlood")
			da.scale *= 0.5
			da.global_position = AreaPos
			da.global_position.x = Enemy.global_position.x
			da.z_index = 10


	elif area.is_in_group("Metior"):
		General.default_damage(Enemy, "lt", 3, 6, true, false, 50)
		var da = preload("res://Scenes/Particles.tscn").instance()
		Enemy.get_parent().add_child(da)
		da.Play("Blood")
		da.global_position = area.global_position
		da.z_index = 10
		General.SoundPlay("res://Music/BigPunchEffect.mp3")
		

		
	elif area.is_in_group("ever_c_moon"):
		if General.stand_number == 22:
			Enemy.get_parent().get_node("GGPlayer").CameraShake(0.1, 56, 30)
			var h = preload("res://Scenes/Hieroglyph.tscn").instance()
			Enemy.get_parent().add_child(h)
			if Enemy.global_position.x > General.player_pos.x:
				h.global_position = Enemy.global_position + Vector2(50, - 60)
			else:
				h.global_position = Enemy.global_position + Vector2( - 50, - 60)
			h.get_node("AnimationPlayer").play("Mega")
			General.passive_damage(Enemy, "lt", 0.25, 16, 0.5, false)
			



			General.SoundPlay("res://Music/HitEpicPau.mp3")
			var da = preload("res://Scenes/Particles.tscn").instance()
			Enemy.add_child(da)
			da.Play("Blood")
			da.position.y -= 50
			da.z_index = 10
			
			
			var matSave = Enemy.get_node("Sprite").material.duplicate()
			matSave = matSave.duplicate()

			Enemy.get_node("Sprite").material = Enemy.get_node("Sprite").material.duplicate()
			Enemy.get_node("Sprite").material = load("res://Details/NeedCMoon.tres").duplicate()

			Enemy.get_node("Sprite").material.set_shader_param("hframes", float(Enemy.get_node("Sprite").hframes))
			var frameDa = float(Enemy.get_node("Sprite").frame)
			Enemy.get_node("Sprite").material.set_shader_param("frame", frameDa)
			Enemy.get_node("Sprite").material.set_shader_param("external_time", 0.0)
			Enemy.attacked = true

			
			var dafa = 0.0
			for i in 7:
					Enemy.get_node("Sprite").frame = frameDa

					Enemy.get_node("Sprite").material.set_shader_param("external_time", dafa + 0.1)
					dafa += 0.1
					yield(General.get_tree().create_timer(0.02), "timeout")
			Enemy.get_node("Sprite").self_modulate = Color(0.9, 0.3, 0.3)
			for i in 7:
					Enemy.get_node("Sprite").frame = frameDa
					
					Enemy.get_node("Sprite").material.set_shader_param("external_time", dafa - 0.1)
					dafa -= 0.1
					yield(General.get_tree().create_timer(0.02), "timeout")
			yield(General.get_tree().create_timer(3.5), "timeout")
			for i in 7:
					Enemy.get_node("Sprite").frame = frameDa
					Enemy.get_node("Sprite").material.set_shader_param("external_time", dafa + 0.1)
					dafa += 0.1
					yield(General.get_tree().create_timer(0.02), "timeout")
			Enemy.get_node("Sprite").self_modulate = Color(1, 1, 1)
			for i in 7:
					Enemy.get_node("Sprite").frame = frameDa
					Enemy.get_node("Sprite").material.set_shader_param("external_time", dafa - 0.1)
					dafa -= 0.1
					yield(General.get_tree().create_timer(0.02), "timeout")
			Enemy.get_node("Sprite").material = null
			Enemy.get_node("Sprite").material = matSave
			Enemy.attacked = false
		elif General.stand_number == 23:
			Enemy.get_parent().get_node("GGPlayer").CameraShake(0.1, 56, 30)
			var h = preload("res://Scenes/Hieroglyph.tscn").instance()
			Enemy.get_parent().add_child(h)
			if Enemy.global_position.x > General.player_pos.x:
				h.global_position = Enemy.global_position + Vector2(50, - 60)
			else:
				h.global_position = Enemy.global_position + Vector2( - 50, - 60)
			h.get_node("AnimationPlayer").play("Mega")
			General.passive_damage(Enemy, "lt", 0.5, 4, 3, false)
			



			General.SoundPlay("res://Music/HitEpic.mp3")
			var da = preload("res://Scenes/Particles.tscn").instance()
			Enemy.add_child(da)
			da.Play("MegaBlood")
			da.position.y -= 50
			da.z_index = 10


	elif area.is_in_group("C_Gatling"):
		General.default_damage(Enemy, "lt", 1.0, 0, true, false)



	elif area.is_in_group("overr"):


			Enemy.get_parent().get_node("GGPlayer").CameraShake(0.1, 56, 30)
			var h = preload("res://Scenes/Hieroglyph.tscn").instance()
			Enemy.get_parent().add_child(h)
			if Enemy.global_position.x > General.player_pos.x:
				h.global_position = Enemy.global_position + Vector2(75, - 60)
			else:
				h.global_position = Enemy.global_position + Vector2( - 75, - 60)
			h.get_node("AnimationPlayer").play("Mega")
			General.passive_damage(Enemy, "lt", 0.5, 4, 3, false)
			General.default_damage(Enemy, "lt", 2, 6, true, false, true, 25)



			General.SoundPlay("res://Music/twoh_overwrite.mp3", {"Volume_db": 10})
			General.SoundPlay("res://Music/HitEpicPau.mp3", {"Volume_db": 0})

			






	elif area.is_in_group("GERstart"):
		if General.get_node("/root/" + General.get_tree().current_scene.name + "/YSorting/GGPlayer"):
			General.dostup_combo = true
			General.get_node("/root/" + General.get_tree().current_scene.name + "/YSorting/GGPlayer").Attack("GER_bd")

	elif area.is_in_group("Bullet2"):
		General.default_damage(Enemy, "lt", 0.5, 0, true, false)
		General.barrage_arm_collision += 1
	elif area.is_in_group("Bullet4"):
		General.default_damage(Enemy, "lt", 1.0, 0, true, false)

	elif area.is_in_group("StandAttackBig"):
		General.GGPlayer.CameraShake(0.1, 40, 40)
		if General.debuff_enemy != "TwohSpeed" and General.debuff_enemy != "TwohStun":
			General.default_damage(Enemy, "_Hand_lt", 3, 150, true, true, true, 70)
		else:
			General.default_damage(Enemy, "_Hand_None", 3, 150, true, true, true, 70)
		Enemy.get_node("DAMAGE_SOUND").play("BigDamage")
	elif area.is_in_group("StandAttack"):

		if General.debuff_enemy != "TwohSpeed" and General.debuff_enemy != "TwohStun":
			General.default_damage(Enemy, "_Hand_lt", 1.5, 6, true, false)
		else:
			General.default_damage(Enemy, "_Hand_None", 1.5, 6, true, false)

		Enemy.Sound("damage")

	elif area.is_in_group("StandAttackThree") and General.stand_number == 2:
		General.default_damage(Enemy, "lt", 5, 100, true, true)
		Enemy.get_node("DAMAGE_SOUND").play("BigDamage")
		if General.time_stop == false:
			Enemy.dash("Garpun")
	elif area.is_in_group("BarrageArm"):
		if "CutScene" in General.Addition:


			General.SoundPlay("res://Music/HitEffectNumber1.mp3", {"Volume_db": - 5})
		Enemy.get_parent().get_node("GGPlayer").CameraShake(0.06, 4, 60)
		if General.velocity_player != Vector2(0, 0):
			General.default_damage(Enemy, "lt", 0.25, 0, true, false, true, 5)
		else:
			General.default_damage(Enemy, "lt", 0.25, 0, true, false)
	elif area.is_in_group("EchoesBarrageNail") and General.stand_number == 6:
		General.default_damage(Enemy, "lt", 0.25, 0, true, false)
		General.barrage_arm_collision += 1
	elif area.is_in_group("AttackPlayerArea"):
		if random_crit_proc <= 0.3 and General.add_hand_crit > 0:
			if General.debuff_enemy != "TwohSpeed" and General.debuff_enemy != "TwohStun":
				General.default_damage(Enemy, "_Hand_lt", (1 + General.add_hand_damage) + (1 + General.add_hand_damage) / 100 * General.add_hand_crit, 3, true, false)
			else:
				General.default_damage(Enemy, "_Hand_None", (1 + General.add_hand_damage) + (1 + General.add_hand_damage) / 100 * General.add_hand_crit, 3, true, false)
		else:
			if General.debuff_enemy != "TwohSpeed" and General.debuff_enemy != "TwohStun":
				General.default_damage(Enemy, "_Hand_lt", 1 + General.add_hand_damage * 2, 3, true, false)
			else:
				General.default_damage(Enemy, "_Hand_None", 1 + General.add_hand_damage * 2, 3, true, false)
		if (General.hands_opens["slow"] == true and (General.techic_number == 0 or General.techic_number == 3)):
			General.enemy_current_status.append(4)
			Enemy.slow -= 0.1
			yield(General.get_tree().create_timer(8), "timeout")
			General.remove_status(4)
			Enemy.slow += 0.1
		Enemy.Sound("damage")

	elif area.is_in_group("AttackPlayerAreaBig"):
		if random_crit_proc <= 0.3 and General.add_hand_crit > 0:
			if General.debuff_enemy != "TwohSpeed" and General.debuff_enemy != "TwohStun":
				General.default_damage(Enemy, "lt", (2 + General.add_hand_damage * 2) + (2 + General.add_hand_damage * 2) / 100 * General.add_hand_crit, 100, true, true)
			else:
				General.default_damage(Enemy, "None", (2 + General.add_hand_damage * 2) + (2 + General.add_hand_damage * 2) / 100 * General.add_hand_crit, 100, true, true)
		else:
			if General.debuff_enemy != "TwohSpeed" and General.debuff_enemy != "TwohStun":
				General.default_damage(Enemy, "lt", 2 + General.add_hand_damage * 2, 100, true, true)
			else:
				General.default_damage(Enemy, "None", 2 + General.add_hand_damage * 2, 100, true, true)
		if (General.hands_opens["blood"] == true and (General.techic_number == 0 or General.techic_number == 3)):
			if random_crit_proc <= 0.3 and General.add_hand_crit > 0:
				if General.debuff_enemy != "TwohSpeed" and General.debuff_enemy != "TwohStun":
					General.passive_damage(Enemy, "lt", 1, 4, (0.25 + General.add_hand_damage * 2) + (0.25 + General.add_hand_damage * 2) / 100 * General.add_hand_crit, false)
				else:
					General.passive_damage(Enemy, "None", 1, 4, (0.25 + General.add_hand_damage * 2) + (0.25 + General.add_hand_damage * 2) / 100 * General.add_hand_crit, false)
			else:
				if General.debuff_enemy != "TwohSpeed" and General.debuff_enemy != "TwohStun":
					General.passive_damage(Enemy, "lt", 1, 4, 0.25 + General.add_hand_damage * 2, false)
				else:
					General.passive_damage(Enemy, "None", 1, 4, 0.25 + General.add_hand_damage * 2, false)
			General.enemy_current_status.append(3)
			yield(General.get_tree().create_timer(5), "timeout")
			General.remove_status(3)
		Enemy.get_node("DAMAGE_SOUND").play("BigDamage")
	elif area.is_in_group("AttackPlayerAreaBigSpin"):
		if random_crit_proc <= 0.3 and General.add_hand_crit > 0:
			General.default_damage(Enemy, "lt", (4 + General.add_hand_damage * 4) + (4 + General.add_hand_damage * 4) / 100 * General.add_hand_crit, 150, true, true)
		else:
			General.default_damage(Enemy, "lt", 4 + General.add_hand_damage * 4, 150, true, true)
		if (General.hands_opens["blood"] == true and (General.techic_number == 0 or General.techic_number == 3)):
			if random_crit_proc <= 0.3 and General.add_hand_crit > 0:
				General.passive_damage(Enemy, "lt", 1, 4, (0.25 + General.add_hand_damage * 2) + (0.25 + General.add_hand_damage * 2) / 100 * General.add_hand_crit, false)
			else:
				General.passive_damage(Enemy, "lt", 1, 4, 0.25 + General.add_hand_damage * 2, false)
			General.enemy_current_status.append(4)
			yield(General.get_tree().create_timer(4), "timeout")
			General.remove_status(4)
		Enemy.get_node("DAMAGE_SOUND").play("BigDamage")
	elif area.is_in_group("StandAttackSecond") and General.stand_number == 8:
		yield(General.get_tree().create_timer(0.2), "timeout")
		Enemy.get_node("DAMAGE_SOUND").play("ImpaleDamage")
		if Enemy.enemy_block_timer.is_stopped() == false:
			Enemy.enemy_block_timer_end()
		Enemy.enemy_block_timer.connect("timeout", Enemy, "enemy_block_timer_end")
		Enemy.enemy_block_timer.wait_time = 0.05
		Enemy.enemy_block_timer.one_shot = true
		Enemy.add_child(Enemy.enemy_block_timer)
		Enemy.enemy_block_timer.start()
		var time_erase_inst = Enemy.time_erase.instance()
		Enemy.get_parent().get_parent().add_child(time_erase_inst)
		yield(General.get_tree().create_timer(0.05), "timeout")
		General.chop_damage(Enemy, 8)
	elif area.is_in_group("DefaultNail"):
		General.default_damage(Enemy, "lt", 2, 3, false, false)
	elif area.is_in_group("ribcage"):
		General.default_damage(Enemy, "lt", 5, 3, false, false)
	elif area.is_in_group("Hg_gem"):
		General.default_damage(Enemy, "lt", 2, 3, false, false)
	elif area.is_in_group("GoldNail"):
		if General.global_buffs["johny_awakeng"] == false:
			General.default_damage(Enemy, "None", 4, 6, false, false)
		if General.global_buffs["johny_awakeng"] == true:
			General.default_damage(Enemy, "None", 5.2, 6, false, false)
	elif area.is_in_group("GoldNailDa"):
		General.passive_damage(Enemy, "lt", 0.5, 10, 3, false)
	elif area.is_in_group("zahvat_hg"):
		General.passive_damage(Enemy, "lt", 1, 5, 5, false)
	elif area.is_in_group("Ehos1t1"):
		General.default_damage(Enemy, "lt", 3, 6, false, false)
	elif area.is_in_group("Ehos1t2"):
		General.default_damage(Enemy, "lt", 2, 6, false, false)
	elif area.is_in_group("Ehos1t3"):
		General.default_damage(Enemy, "lt", 2, 6, false, false)
	elif area.is_in_group("Ehos1t4"):
		General.default_damage(Enemy, "lt", 3, 6, false, false)
	elif area.is_in_group("Ehos1t5"):
		General.default_damage(Enemy, "lt", 2, 6, false, false)
	elif area.is_in_group("SCRetroGun"):
		General.default_damage(Enemy, "lt", 8, 6, false, false)
	elif area.is_in_group("LaserBullet"):
		General.default_damage(Enemy, "lt", 4 * General.add_hand_damage, 6, false, false)
		General.passive_damage(Enemy, "lt", 0.1, 10, 0.5, false)
	elif area.is_in_group("KnifeTW"):
		

		
		
		
		if General.stand_number != 16:
			General.default_damage(Enemy, "lt", 3, 6, false, false)
		elif General.stand_number == 16:
			General.default_damage(Enemy, "None", 0.0125 * Enemy.max_hp, 6, false, false)
	elif area.is_in_group("LightTwoh"):
		General.default_damage(Enemy, "None", 0.1 * Enemy.max_hp, 6, false, false)
		yield(General.get_tree().create_timer(0.1), "timeout")
		var h = preload("res://Scenes/Hieroglyph.tscn").instance()
		Enemy.get_parent().add_child(h)
		if Enemy.global_position.x > General.player_pos.x:
				h.global_position = Enemy.global_position + Vector2(50, - 60)
		else:
				h.global_position = Enemy.global_position + Vector2( - 50, - 60)
		h.get_node("AnimationPlayer").play("Pau")
	elif area.is_in_group("SecondDopEhosAct1"):
		General.default_damage(Enemy, "lt", 2, 6, false, false)
		General.enemy_current_status.append(1)
		var ehos_vfx = Enemy.ehos_effect.instance()
		var ehoes_vfx = Enemy.ehos_effect_audio_second_attack.instance()
		ehoes_vfx.global_position = Enemy.get_node("Center").global_position
		Enemy.get_parent().add_child(ehoes_vfx)
		Enemy.add_child(ehos_vfx)
		ehoes_vfx.z_index = 2
		ehos_vfx.z_index = 2
		General.start_glush_enemy_timer(3)
		General.passive_damage(Enemy, "lt", 1, 3, 1, false)
		yield(General.get_tree().create_timer(3), "timeout")
		General.remove_status(1)
	elif area.is_in_group("SpinBall"):
			if General.global_buffs["johny_awakeng"] == false:

				General.default_damage(Enemy, "None", (0.1), 1, false, true)
			if General.global_buffs["johny_awakeng"] == true:
				
				General.default_damage(Enemy, "None", (0.1) * 1.3, 1, false, false)

	elif area.is_in_group("DestroyBall"):
		if General.global_buffs["johny_awakeng"] == false:

			General.passive_damage(Enemy, "None", 2, 2, 6, false)
		if General.global_buffs["johny_awakeng"] == true:

			General.passive_damage(Enemy, "None", 2, 2 * 1.3, (6) * 1.3, false)
	elif area.is_in_group("InfBalll"):
			if General.global_buffs["johny_awakeng"] == false:

				General.default_damage(Enemy, "None", 0.01 + (0.03) * General.Addition["spin"] / 10, 1, false, true)
			if General.global_buffs["johny_awakeng"] == true:
				General.default_damage(Enemy, "None", 0.01 + (0.03) * 1.3 * General.Addition["spin"] / 10, 1, false, false)

	elif area.is_in_group("BigNail"):
		General.default_damage(Enemy, "None", 4, 100, false, true)
	elif area.is_in_group("EhosBigAttack"):
		General.default_damage(Enemy, "lt", 4, 100, false, true)
	elif area.is_in_group("BubbleEyes"):
		General.enemy_current_status.append(0)
		General.default_damage(Enemy, "lt", 2, 0, false, true)
		if Enemy.enemy_block_timer.is_stopped() == false:
			Enemy.enemy_block_timer_end()
		Enemy.enemy_block_timer.connect("timeout", Enemy, "enemy_block_timer_end")
		Enemy.enemy_block_timer.wait_time = 3
		Enemy.enemy_block_timer.one_shot = true
		Enemy.add_child(Enemy.enemy_block_timer)
		Enemy.enemy_block_timer.start()
		yield(General.get_tree().create_timer(3), "timeout")
		General.remove_status(0)
	elif area.is_in_group("BubbleBeyound"):
		General.passive_damage(Enemy, "lt", 0.0001, 30, 0.5, false)
	elif area.is_in_group("SpinNail"):
		General.passive_damage(Enemy, "lt", 0.5, 5, 0.8, false)
	elif area.is_in_group("GeTree"):
		if General.stand_number == 17:
			General.jump_damage(Enemy, "None", Enemy.max_hp * 0.125, 0, false, true)
		else:
			General.jump_damage(Enemy, "lt", 6, 0, false, true)
		Enemy.Sound("damage")

	elif area.is_in_group("HoleTusk3Nail"):
		General.default_damage(Enemy, "lt", 2, 0, false, true)
	elif area.is_in_group("NailBDTusk3"):
		General.default_damage(Enemy, "None", 1, 0, false, true)
		var tusk_bd = Enemy.tusk_3_hole_bd.instance()
		Enemy.get_parent().add_child(tusk_bd)
		tusk_bd.global_position = Enemy.global_position
		if Enemy.enemy_block_timer.is_stopped() == false:
			Enemy.enemy_block_timer_end()
		Enemy.enemy_block_timer.connect("timeout", Enemy, "enemy_block_timer_end")
		Enemy.enemy_block_timer.wait_time = 4
		Enemy.enemy_block_timer.one_shot = true
		Enemy.add_child(Enemy.enemy_block_timer)
		Enemy.enemy_block_timer.start()
	elif area.is_in_group("NailBDTusk3Start"):
		if General.stand_number == 11:
			if General.global_buffs["johny_awakeng"] == false:
				General.passive_damage(Enemy, "None", 0.1, 2, 1, false)
			elif General.global_buffs["johny_awakeng"] == true:
				General.passive_damage(Enemy, "None", 0.1, 2, 1.3, false)
		else:
				General.passive_damage(Enemy, "None", 0.1, 2, 0.5, false)
