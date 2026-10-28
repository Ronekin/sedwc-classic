# PlayerCutsceneService.gd — катсцена получения Requiem.
#
# Контракт: получает GGPlayer и использует его камеру, стенд, GUI и методы
# PlayerEntity. Новые катсцены добавляйте отдельными функциями.

extends Reference


func cutscene(player, cutscene_name: String):
	if cutscene_name == "Requim":
		General.remove_item(8, 1)
		player.get_node("../../GUI").visible = false
		BlackLinesVertical.start_lines()

		General.player_block_all = true
		General.enemy_block_all = true
		General.attacked = true
		var Enemy: Object
		for i in player.get_parent().get_children():
			if i.name.find("Enemy") == 0:
				Enemy = i
		player.CameraZoom(0.5, 0.5, 2)
		var StandPosSave = player.get_node("YSort/Stand").global_position
		if General.player_direct == "right":
			player.StandMove(player.global_position + Vector2(150, 0), 0.5, 1)
			player.CameraMove(player.get_node("YSort/Stand/Stand_Texture/PunchPos").global_position + Vector2(150, 0), 0.5, 1)
		else:
			player.StandMove(player.global_position + Vector2( - 150, 0), 0.5, 1)
			player.CameraMove(player.get_node("YSort/Stand/Stand_Texture/PunchPos").global_position + Vector2( - 150, 0), 0.5, 1)

		yield(player.get_tree().create_timer(3.3), "timeout")
		player.get_node("YSort/Stand/StandAnimation").play("Requim")
		player.CameraZoom(0.5, 0.5, 2)
		yield(player.get_tree().create_timer(1.3), "timeout")

		var da = preload("res://Scenes/Particles.tscn").instance()
		Enemy.get_parent().add_child(da)
		da.Play("MegaBlood")
		da.scale *= 0.9
		da.global_position = player.get_node("YSort/Stand/Stand_Texture").global_position

		da.z_index = 10

		player.SoundPlay("res://Music/GERarrow.mp3")
		player.CameraZoom(0.7, 0.5, 2)
		yield(player.get_tree().create_timer(1.9), "timeout")

		player.CameraMove(player.get_node("YSort/Stand/Stand_Texture").global_position + Vector2(0, - 83), 1.0, 0.001)

		player.SoundPlay("res://Music/GERsoundEffect.mp3")

		var da1 = ColorRect.new()
		player.get_node("../../GUI").add_child(da1)
		da1.rect_size = Vector2(100, 100)
		General.stand_number = 24
		General.AchievementGive(22)
		General.save_save()
		player.CameraMove(player.get_node("YSort/Stand/Stand_Texture").global_position + Vector2(0, 43), - 2.0, 2.0)
		da1.rect_scale *= 999
		for i in 20:
			da1.color.a -= 0.05
			yield(player.get_tree().create_timer(0.05), "timeout")
		da1.queue_free()
		yield(player.get_tree().create_timer(2.3), "timeout")
		player.StandMove(StandPosSave, 0.5, 1)
		player.CameraZoom(1.0, 0.5, 1)
		BlackLinesVertical.end_lines()
		General.attacked = false
		General.player_block_all = false

		player.get_node("../../GUI").visible = true

		yield(player.get_tree().create_timer(3.3), "timeout")
		General.enemy_block_all = false
