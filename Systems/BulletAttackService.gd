# BulletAttackService.gd — спавн снарядов и VFX атак игрока.
#
# Контракт: attack()/bullet_attack() получают GGPlayer; позиция, направление
# и состояние стенда читаются из player/General. Сервис не хранит состояния.
#
# Моддинг: новый тип снаряда — ветка в attack() и сцена в Scenes/.

extends Reference


func attack(player, attack_type):
	if (General.stand_index == "TuskAct1" or General.stand_index == "TuskAct2" or General.stand_index == "TuskAct3" or General.stand_index == "TuskAct4") and attack_type == 1:
		if General.nail_count.find(1) != - 1:
			General.nail_timer_start()
			for i in range(General.nail_count.size()):
				if General.nail_count[i] == 1:
					General.nail_count[i] = 0
					break
			var bullet_create = player.bullet_spawn.instance()
			bullet_create.is_dop_attack_second = false
			bullet_create.is_dop_attack_three = false
			bullet_create.bubble = false
			bullet_create.is_attack_strength = false
			var vfx_nail_create = player.vfx_nail_tusk_spawn.instance()
			if General.player_on_ysort_area == false:
				player.get_parent().get_parent().add_child(bullet_create)
				player.get_parent().get_parent().add_child(vfx_nail_create)
				vfx_nail_create.z_index = 0
				bullet_create.z_index = 0
			else:
				player.get_parent().add_child(bullet_create)
				player.get_parent().add_child(vfx_nail_create)
				vfx_nail_create.z_index = 0
				bullet_create.z_index = 0
			bullet_create.position = player.get_node("TuskBulletCreate").global_position
			vfx_nail_create.position = player.get_node("TuskBulletCreate").global_position
			vfx_nail_create.emitting = true
			vfx_nail_create.one_shot = true
			if General.player_direct == "left":
				bullet_create.velocity = Vector2( - 1, 0)
				vfx_nail_create.scale.x = - 1
			else:
				bullet_create.velocity = Vector2(1, 0)
				vfx_nail_create.scale.x = 1
		else:
			General.message_spawn("Center", "У вас недостаточно ногтей")
	if (General.stand_index == "EhosAct1" or General.stand_index == "TheWorld" or General.stand_index == "MIH" or General.stand_index == "ShadowTW" or General.stand_index == "TWOH" or General.stand_index == "SCRetro" or General.stand_index == "SCRetroW" or General.stand_index == "HeirophantGreen") and attack_type == 1:
		var bullet_create = player.bullet_spawn.instance()
		bullet_create.is_dop_attack_second = false
		bullet_create.is_attack_strength = false
		bullet_create.is_dop_attack_three = false
		bullet_create.bubble = false
		if General.player_on_ysort_area == false:
			player.get_parent().get_parent().add_child(bullet_create)
			bullet_create.z_index = 0
		else:
			player.get_parent().add_child(bullet_create)
			bullet_create.z_index = 0
		bullet_create.position = player.get_node("TuskBulletCreate").global_position
		if General.player_direct == "left":
			bullet_create.velocity = Vector2( - 1, 0)
		else:
			bullet_create.velocity = Vector2(1, 0)
	if General.stand_index == "TuskAct2" and attack_type == 2:
		if General.nail_count.find(1) != - 1:
			General.nail_timer_start()
			for i in range(General.nail_count.size()):
				if General.nail_count[i] == 1:
					General.nail_count[i] = 0
					break
			player.get_node("YSort/Animations").play("TuskAct2HoleAttack")
			var blckhole = player.black_hole_bullet.instance()
			blckhole.global_position = player.get_node("TuskHoleCreate").global_position
			player.get_parent().add_child(blckhole)
		else:
			General.message_spawn("Center", "У вас недостаточно ногтей")
	if General.stand_index == "EhosAct1" and attack_type == 2:
		var bullet_create = player.bullet_spawn.instance()
		bullet_create.is_dop_attack_second = true
		bullet_create.is_attack_strength = false
		bullet_create.is_dop_attack_three = false
		bullet_create.bubble = false
		if General.player_on_ysort_area == false:
			player.get_parent().get_parent().add_child(bullet_create)
			bullet_create.z_index = 0
		else:
			player.get_parent().add_child(bullet_create)
		bullet_create.z_index = 0
		bullet_create.position = player.get_node("TuskBulletCreate").global_position
		if General.player_direct == "left":
			bullet_create.velocity = Vector2( - 1, 0)
		else:
			bullet_create.velocity = Vector2(1, 0)
	if General.techic_number == 1 and attack_type == - 1:
		var spinball_create = player.spinball_spawn.instance()
		if General.player_on_ysort_area == false:
			player.get_parent().get_parent().add_child(spinball_create)
			spinball_create.z_index = 0
		else:
			player.get_parent().add_child(spinball_create)
		spinball_create.type = 1
		spinball_create.z_index = 1
		spinball_create.position = player.get_node("TuskBulletCreate").global_position
		if General.player_direct == "left":
			spinball_create.velocity = Vector2( - 1, 0)
		else:
			spinball_create.velocity = Vector2(1, 0)
	if General.techic_number == 2 and attack_type == - 2:
		var spinball_create = player.spinball_spawn.instance()
		if General.player_on_ysort_area == false:
			player.get_parent().get_parent().add_child(spinball_create)
			spinball_create.z_index = 0
		else:
			player.get_parent().add_child(spinball_create)
		spinball_create.z_index = 1
		spinball_create.type = 0
		spinball_create.position = player.get_node("TuskBulletCreate").global_position
		if General.player_direct == "left":
			spinball_create.velocity = Vector2( - 1, 0)
		else:
			spinball_create.velocity = Vector2(1, 0)
	if (General.techic_number == 6 or General.techic_number == 7) and attack_type == - 1:
		var laser_create = player.laser_spawn.instance()
		if General.player_on_ysort_area == false:
			player.get_parent().get_parent().add_child(laser_create)
			laser_create.z_index = 0
		else:
			player.get_parent().add_child(laser_create)
		laser_create.z_index = 1
		laser_create.position = player.get_node("TuskBulletCreate2").global_position
		if General.player_direct == "left":
			laser_create.velocity = Vector2( - 1, 0)
		else:
			laser_create.velocity = Vector2(1, 0)
	if General.techic_number == 2 and attack_type == - 1:
		var spinball_create = player.spinball_spawn.instance()
		if General.player_on_ysort_area == false:
			player.get_parent().get_parent().add_child(spinball_create)
			spinball_create.z_index = 0
		else:
			player.get_parent().add_child(spinball_create)
		player.techinc_first_attack_start_kd()
		spinball_create.type = 1
		spinball_create.z_index = 1
		spinball_create.position = player.get_node("TuskBulletCreate").global_position
		if General.player_direct == "left":
			spinball_create.velocity = Vector2( - 1, 0)
		else:
			spinball_create.velocity = Vector2(1, 0)
	if General.techic_number == 2 and attack_type == - 2:
		var spinball_create = player.spinball_spawn.instance()
		spinball_create.type = 0
		if General.player_on_ysort_area == false:
			player.get_parent().get_parent().add_child(spinball_create)
			spinball_create.z_index = 0
		else:
			player.get_parent().add_child(spinball_create)
		player.techinc_first_attack_start_kd()
		spinball_create.z_index = 1
		spinball_create.position = player.get_node("TuskBulletCreate").global_position
		if General.player_direct == "left":
			spinball_create.velocity = Vector2( - 1, 0)
		else:
			spinball_create.velocity = Vector2(1, 0)
	if (General.stand_index == "TuskAct1" or General.stand_index == "TuskAct2" or General.stand_index == "TuskAct3" or General.stand_index == "TuskAct4") and attack_type == 1.5:
		if General.nail_count.find(1) != - 1:
			General.nail_timer_start()
			for i in range(General.nail_count.size()):
				if General.nail_count[i] == 1:
					General.nail_count[i] = 0
					break
			var bullet_create = player.bullet_spawn.instance()
			bullet_create.is_dop_attack_second = false
			bullet_create.is_attack_strength = false
			bullet_create.is_dop_attack_three = false
			bullet_create.bubble = false
			var vfx_nail_create = player.vfx_nail_tusk_spawn.instance()
			if General.player_on_ysort_area == false:
				player.get_parent().get_parent().add_child(bullet_create)
				player.get_parent().get_parent().add_child(vfx_nail_create)
				vfx_nail_create.z_index = 0
				bullet_create.z_index = 0
			else:
				player.get_parent().add_child(bullet_create)
				player.get_parent().add_child(vfx_nail_create)
				vfx_nail_create.z_index = 0
				bullet_create.z_index = 0
			bullet_create.position = player.get_node("TuskBulletCreate").global_position
			vfx_nail_create.position = player.get_node("TuskBulletCreate").global_position
			vfx_nail_create.emitting = true
			vfx_nail_create.one_shot = true

			if player.get_node("YSort/Animations").current_animation == "TuskAct3HoleAttack":

				
				if General.enemy_direct == "Left":
					bullet_create.velocity = Vector2( - 1, 0)
					vfx_nail_create.scale.x = - 1
				else:
					bullet_create.velocity = Vector2(1, 0)
					vfx_nail_create.scale.x = 1
			else:
				if General.player_direct == "left":
					bullet_create.velocity = Vector2( - 1, 0)
					vfx_nail_create.scale.x = - 1
				else:
					bullet_create.velocity = Vector2(1, 0)
					vfx_nail_create.scale.x = 1
		else:
			General.message_spawn("Center", "У вас недостаточно ногтей")
	if General.stand_index in ["EhosAct1", "WhiteSnake"] and attack_type == 1.5:

		var bullet_create = player.bullet_spawn.instance()
		bullet_create.is_dop_attack_second = false
		bullet_create.is_attack_strength = true
		bullet_create.is_dop_attack_three = false
		bullet_create.bubble = false
		if General.player_on_ysort_area == false:
			player.get_parent().get_parent().add_child(bullet_create)
			bullet_create.z_index = 0
		else:
			player.get_parent().add_child(bullet_create)
			bullet_create.z_index = 0
		bullet_create.position = player.get_node("TuskBulletCreate").global_position
		if General.player_direct == "left":
			bullet_create.velocity = Vector2( - 1, 0)
		else:
			bullet_create.velocity = Vector2(1, 0)
	if General.stand_index == "Soft&Wet" and attack_type == 1:
		var bullet_create = player.bullet_spawn.instance()
		bullet_create.is_dop_attack_second = false
		bullet_create.is_attack_strength = false
		bullet_create.is_dop_attack_three = false
		bullet_create.bubble = true
		bullet_create.bubble_id = 1
		if General.player_on_ysort_area == false:
			player.get_parent().get_parent().add_child(bullet_create)
			bullet_create.z_index = 0
		else:
			player.get_parent().add_child(bullet_create)
			bullet_create.z_index = 0
		bullet_create.position = player.get_node("TuskBulletCreate").global_position
		if General.player_direct == "left":
			bullet_create.velocity = Vector2( - 1, 0)
		else:
			bullet_create.velocity = Vector2(1, 0)
	if General.stand_index == "Soft&Wet" and attack_type == 2:
		var bullet_create = player.bullet_spawn.instance()
		var vfx_nail_create = player.vfx_nail_tusk_spawn.instance()
		bullet_create.is_dop_attack_second = false
		bullet_create.is_attack_strength = true
		bullet_create.is_dop_attack_three = false
		bullet_create.bubble = true
		bullet_create.bubble_id = 2
		if General.player_on_ysort_area == false:
			player.get_parent().get_parent().add_child(bullet_create)
			player.get_parent().get_parent().add_child(vfx_nail_create)
			vfx_nail_create.z_index = 0
			bullet_create.z_index = 0
		else:
			player.get_parent().add_child(bullet_create)
			player.get_parent().add_child(vfx_nail_create)
			vfx_nail_create.z_index = 0
			bullet_create.z_index = 0
		bullet_create.position = player.get_node("TuskBulletCreate").global_position
		vfx_nail_create.position = player.get_node("TuskBulletCreate").global_position
		vfx_nail_create.emitting = true
		vfx_nail_create.one_shot = true
		if General.player_direct == "left":
			bullet_create.velocity = Vector2( - 1, 0)
		else:
			bullet_create.velocity = Vector2(1, 0)
	if (General.stand_index == "TuskAct1" or General.stand_index == "TuskAct2") and attack_type == 3:
		if General.nail_count.find(1) != - 1:
			General.nail_timer_start()
			for i in range(General.nail_count.size()):
				if General.nail_count[i] == 1:
					General.nail_count[i] = 0
					break
			var bullet_create = player.bullet_spawn.instance()
			bullet_create.is_dop_attack_second = false
			bullet_create.is_dop_attack_three = true
			bullet_create.is_attack_strength = false
			bullet_create.bubble = false
			var vfx_nail_create = player.vfx_nail_tusk_spawn.instance()
			if General.player_on_ysort_area == false:
				player.get_parent().get_parent().add_child(bullet_create)
				player.get_parent().get_parent().add_child(vfx_nail_create)
				vfx_nail_create.z_index = 3
				bullet_create.z_index = 3
			else:
				player.get_parent().add_child(bullet_create)
				player.get_parent().add_child(vfx_nail_create)
				vfx_nail_create.z_index = 1
				bullet_create.z_index = 1
			bullet_create.position = player.get_node("TuskBulletCreate").global_position
			vfx_nail_create.position = player.get_node("TuskBulletCreate").global_position
			vfx_nail_create.emitting = true
			vfx_nail_create.one_shot = true
			if General.player_direct == "left":
				bullet_create.velocity = Vector2( - 1, 0)
				vfx_nail_create.scale.x = - 1
			else:
				bullet_create.velocity = Vector2(1, 0)
				vfx_nail_create.scale.x = 1
		else:
			General.message_spawn("Center", "У вас недостаточно ногтей")

	if (General.stand_index == "TuskAct3" or General.stand_index == "TuskAct4") and attack_type == 2:
		if General.nail_count.find(1) != - 1:
			General.nail_timer_start()
			for i in range(General.nail_count.size()):
				if General.nail_count[i] == 1:
					General.nail_count[i] = 0
					break
			var bullet_create = player.bullet_spawn.instance()
			bullet_create.is_dop_attack_second = false
			bullet_create.is_dop_attack_three = true
			bullet_create.bubble = false
			bullet_create.is_attack_strength = false
			var vfx_nail_create = player.vfx_nail_tusk_spawn.instance()
			if General.player_on_ysort_area == false:
				player.get_parent().get_parent().add_child(bullet_create)
				player.get_parent().get_parent().add_child(vfx_nail_create)
				vfx_nail_create.z_index = 3
				bullet_create.z_index = 3
			else:
				player.get_parent().add_child(bullet_create)
				player.get_parent().add_child(vfx_nail_create)
				vfx_nail_create.z_index = 1
				bullet_create.z_index = 1
			bullet_create.position = player.get_node("TuskBulletCreate").global_position
			vfx_nail_create.position = player.get_node("TuskBulletCreate").global_position
			vfx_nail_create.emitting = true
			vfx_nail_create.one_shot = true
			if General.player_direct == "left":
				bullet_create.velocity = Vector2( - 1, 0)
				vfx_nail_create.scale.x = - 1
			else:
				bullet_create.velocity = Vector2(1, 0)
				vfx_nail_create.scale.x = 1
		else:
			General.message_spawn("Center", "У вас недостаточно ногтей")


func bullet_attack(player, Bullet: int, DopData: Dictionary = {}):
	if Bullet == 1:
		if General.nail_count.find(1) != - 1:
			General.nail_timer_start()
			for i in range(General.nail_count.size()):
				if General.nail_count[i] == 1:
					General.nail_count[i] = 0
					break
			var bullet_create = player.bullet_spawn.instance()
			bullet_create.is_dop_attack_second = false
			bullet_create.is_dop_attack_three = false
			bullet_create.bubble = false
			bullet_create.is_attack_strength = false
			bullet_create.type = Bullet
			var vfx_nail_create = player.vfx_nail_tusk_spawn.instance()
			if General.player_on_ysort_area == false:
				player.get_parent().get_parent().add_child(bullet_create)
				player.get_parent().get_parent().add_child(vfx_nail_create)
				vfx_nail_create.z_index = 0
				bullet_create.z_index = 0
			else:
				player.get_parent().add_child(bullet_create)
				player.get_parent().add_child(vfx_nail_create)
				vfx_nail_create.z_index = 0
				bullet_create.z_index = 0
			bullet_create.position = player.get_node("TuskBulletCreate").global_position
			vfx_nail_create.position = player.get_node("TuskBulletCreate").global_position
			vfx_nail_create.emitting = true
			vfx_nail_create.one_shot = true
			if General.player_direct == "left":
				bullet_create.velocity = Vector2( - 1, 0)
				vfx_nail_create.scale.x = - 1
			else:
				bullet_create.velocity = Vector2(1, 0)
				vfx_nail_create.scale.x = 1
		else:
			General.message_spawn("Center", "У вас недостаточно ногтей")
	elif Bullet == 2:
		player.SoundPlay("res://Music/WeaponShotRevolver.mp3")
		var bullet_create = player.bullet_spawn.instance()
		bullet_create.is_dop_attack_second = false
		bullet_create.is_attack_strength = false
		bullet_create.is_dop_attack_three = false
		bullet_create.bubble = false
		bullet_create.type = Bullet
		if General.player_on_ysort_area == false:
			player.get_parent().get_parent().add_child(bullet_create)
			bullet_create.z_index = 0
		else:
			player.get_parent().add_child(bullet_create)
		bullet_create.z_index = 0
		bullet_create.position = player.get_node("TuskBulletCreate").global_position
		if General.player_direct == "left":
			bullet_create.velocity = Vector2( - 1, 0)
		else:
			bullet_create.velocity = Vector2(1, 0)


	elif Bullet == 3:
			player.SoundPlay("res://Music/GERshot.mp3")
			var bullet_create = player.bullet_spawn.instance()
			bullet_create.is_dop_attack_second = false
			bullet_create.is_dop_attack_three = false
			bullet_create.bubble = false
			bullet_create.is_attack_strength = false
			bullet_create.type = Bullet
			var vfx_nail_create = player.vfx_nail_tusk_spawn.instance()
			if General.player_on_ysort_area == false:
				player.get_parent().get_parent().add_child(bullet_create)
				player.get_parent().get_parent().add_child(vfx_nail_create)
				vfx_nail_create.z_index = 0
				bullet_create.z_index = 0
			else:
				player.get_parent().add_child(bullet_create)
				player.get_parent().add_child(vfx_nail_create)
				vfx_nail_create.z_index = 0
				bullet_create.z_index = 0
			bullet_create.position = player.get_node("YSort/Stand/Stand_Texture/PunchPos").global_position
			vfx_nail_create.position = player.get_node("YSort/Stand/Stand_Texture/PunchPos").global_position
			vfx_nail_create.emitting = true
			vfx_nail_create.one_shot = true
			if General.player_direct == "left":
				bullet_create.velocity = Vector2( - 1, 0)
				vfx_nail_create.scale.x = - 1
			else:
				bullet_create.velocity = Vector2(1, 0)
				vfx_nail_create.scale.x = 1
	elif Bullet == 4:

		var bullet_create = player.bullet_spawn.instance()
		bullet_create.DopData = DopData
		bullet_create.is_dop_attack_second = false
		bullet_create.is_attack_strength = false
		bullet_create.is_dop_attack_three = false
		bullet_create.bubble = false
		bullet_create.type = Bullet
		if General.player_on_ysort_area == false:
			player.get_parent().get_parent().add_child(bullet_create)
			bullet_create.z_index = 99
		else: player.get_parent().add_child(bullet_create)
		bullet_create.z_index = 99
		bullet_create.position = player.global_position + Vector2(0, - 45 + rand_range( - 3.1, 3.1))
		if General.player_direct == "left": bullet_create.velocity = Vector2( - 1, 0)
		else: bullet_create.velocity = Vector2(1, 0)
