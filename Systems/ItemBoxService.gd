# ItemBoxService.gd — вход/выход игрока в Area2D предметов и NPC.
#
# Контракт: handle_entered()/handle_exited() получают GGPlayer и меняют
# General.collision_npc или запускают эффекты от имени player.

extends Reference


func handle_entered(player, area):
	if area.is_in_group("Jotaro"): General.collision_npc = Vector2(true, 1)
	elif area.is_in_group("Johny"): General.collision_npc = Vector2(true, 2)
	elif area.is_in_group("Gyro"): General.collision_npc = Vector2(true, 3)
	elif area.is_in_group("Pucci"): General.collision_npc = Vector2(true, 4)
	elif area.is_in_group("Jesus"): General.collision_npc = Vector2(true, 5)
	elif area.is_in_group("Spidwagon"): General.collision_npc = Vector2(true, 6)
	elif area.is_in_group("Valentine"): General.collision_npc = Vector2(true, 7)
	elif area.is_in_group("Shtroiham"): General.collision_npc = Vector2(true, 8)
	elif area.is_in_group("Polnaref"): General.collision_npc = Vector2(true, 9)
	elif area.is_in_group("spidwagoon"): General.collision_npc = Vector2(true, 10)
	elif area.is_in_group("DefaultEnemy"): General.collision_npc = Vector2(true, - 1)
	elif area.is_in_group("BullingEnemy"): General.collision_npc = Vector2(true, - 1.01)
	elif area.is_in_group("KarsEnemy"): General.collision_npc = Vector2(true, - 1.02)
	elif area.is_in_group("NPC"): General.collision_npc = Vector2(true, area.get_parent().NPC_Index)

	elif area.is_in_group("Cafe"): General.collision_npc = Vector2(true, - 2)
	elif area.is_in_group("Rest"): General.collision_npc = Vector2(true, - 4.44)
	elif area.is_in_group("DoorExit"): General.collision_npc = Vector2(true, - 4.4)
	elif area.is_in_group("House100k"): General.collision_npc = Vector2(true, - 3)
	elif area.is_in_group("PODVAL"):
		General.collision_npc = Vector2(true, - 3.1)
		area.get_node("../Text").visible = true
	elif area.is_in_group("Centrifuges"):
		if General.ItemCount(40) >= 3 and General.item_in_arm == "41":
			General.collision_npc = Vector2(true, - 3.11)
			area.get_node("../Text").visible = true
			area.get_node("../Text").text = "начать процесс обогащения?\n\\/"
	elif area.is_in_group("Craft_0"):
		if General.ItemCount(43) >= 5 and General.item_in_arm == "44":
			General.collision_npc = Vector2(true, - 3.12)
			area.get_node("../Text").visible = true
	elif area.is_in_group("Craft_1"):
		if General.ItemCount(42) >= 1 and General.ItemCount(44) >= 2 and General.item_in_arm == "45":
			General.collision_npc = Vector2(true, - 3.13)
			area.get_node("../Text").visible = true
	elif area.is_in_group("TreeMiniGame"): General.tree_mini_game_collision = true
	elif area.is_in_group("collect_grass"): General.grass_around = true
	elif area.is_in_group("TrashLoot"): General.Trash_obtained = true
	elif area.is_in_group("buy"): General.buy_garden = true

	elif area.is_in_group("Knife"):
		var enemy = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/Enemy")
		if General.time_stop == false and General.time_erase == false:
			if General.epitafia_enabled == false: enemy.player_damage(3, 65, false)
			else: enemy.epitafia_end()
			var da = preload("res://Scenes/Particles.tscn").instance()
			player.add_child(da)
			da.Play("Blood")
			da.global_position = Vector2(player.global_position.x, area.global_position.y)
			da.z_index = 10
			
	elif area.is_in_group("BulletEnemy"):
		var enemy = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/Enemy")
		if General.time_stop == false and General.time_erase == false:
			if General.epitafia_enabled == false: enemy.player_damage(9, 65, false, {"Sound": "res://Music/PunchStand.mp3"})
			else: enemy.epitafia_end()
			var da = preload("res://Scenes/Particles.tscn").instance()
			player.add_child(da)
			da.Play("Blood")
			da.global_position = Vector2(player.global_position.x, area.global_position.y)
			da.z_index = 10
	elif area.is_in_group("EnemyBall"):
		var enemy = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/Enemy")
		if General.time_stop == false and General.time_erase == false:
			player.CameraShake(0.07 * ((50) / 4.0), 10, 70)
			if General.epitafia_enabled == false: enemy.player_damage(2, 65, false, {"Sound": "res://Music/PunchStand.mp3"})
			else: enemy.epitafia_end()
			var da = preload("res://Scenes/Particles.tscn").instance()
			player.add_child(da)
			da.Play("Blood")
			da.global_position = Vector2(player.global_position.x, area.global_position.y)
			da.z_index = 10
			

			
	elif area.is_in_group("Attack_0"):
		General.PlayerDamage(20)
	elif area.is_in_group("Attack_1"):
		General.PlayerDamage(20)

	elif area.is_in_group("CarsWave"):
		var enemy = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/Enemy")
		if General.time_stop == false and General.time_erase == false:
			player.CameraShake(0.07 * ((50) / 4.0), 10, 70)
			if General.epitafia_enabled == false: enemy.player_damage(2, 65, false, {"Sound": "res://Music/PunchStand.mp3"})
			else: enemy.epitafia_end()
			var da = preload("res://Scenes/Particles.tscn").instance()
			player.add_child(da)
			da.Play("Blood")
			da.global_position = Vector2(player.global_position.x, area.global_position.y)
			da.z_index = 10


func handle_exited(player, area):
	if area.is_in_group("Jotaro"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("Johny"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("Gyro"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("Pucci"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("Jesus"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("Spidwagon"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("Valentine"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("Shtroiham"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("Polnaref"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("spidwagoon"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("DefaultEnemy"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("BullingEnemy"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("KarsEnemy"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("Cafe") or area.is_in_group("Rest") or area.is_in_group("Door"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("House100k"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("DoorExit"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("NPC"):
		General.collision_npc = Vector2(false, 0)
	elif area.is_in_group("TreeMiniGame"):
		General.tree_mini_game_collision = false
	elif area.is_in_group("collect_grass"):
		General.grass_around = false
	elif area.is_in_group("TrashLoot"):
		General.Trash_obtained = false
	elif area.is_in_group("buy"):
		General.buy_garden = false
	elif area.is_in_group("PODVAL"):
		General.collision_npc = Vector2(false, 0)
		area.get_node("../Text").visible = false

	elif area.is_in_group("Centrifuges"):
		General.collision_npc = Vector2(false, 0)
		area.get_node("../Text").visible = false

	elif area.is_in_group("Craft_0"):
		General.collision_npc = Vector2(false, 0)
		area.get_node("../Text").visible = false
	elif area.is_in_group("Craft_1"):
		General.collision_npc = Vector2(false, 0)
		area.get_node("../Text").visible = false
