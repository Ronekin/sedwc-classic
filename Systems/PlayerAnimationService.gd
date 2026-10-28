# PlayerAnimationService.gd — реакция игрока на боевые анимации и поворот.
#
# Контракт: получает GGPlayer и меняет его узлы/флаги, не храня состояния.
# Новые анимационные переходы добавляйте сюда, а не в _process() игрока.

extends Reference


func povorot_check(player, check_on_direct: bool):
	if check_on_direct == false:
		if General.enemy_position.x < General.player_pos.x and General.player_direct == "right":
			player.scale.x *= - 1
			General.player_direct = "left"
		elif General.enemy_position.x > General.player_pos.x and General.player_direct == "left":
			player.scale.x *= - 1
			General.player_direct = "right"
	else:
		if General.enemy_direct == "Left" and General.player_direct == "right":
			player.scale.x *= - 1
			General.player_direct = "left"
		elif General.enemy_direct == "Right" and General.player_direct == "left":
			player.scale.x *= - 1
			General.player_direct = "right"


func position_back(player):
	var add_position = player.position_first - player.get_node("YSort/Texture").global_position
	player.global_position -= add_position
	player.get_node("YSort/Texture").global_position += add_position
	player.get_node("Area2D").global_position += add_position
	player.get_node("ItemBox").global_position += add_position
	player.get_node("YSort/Stand").global_position += add_position
	player.get_node("YSort/Node2D").global_position += add_position
	player.get_node("CollisionCheck").global_position += add_position
	player.get_node("HitBox").global_position += add_position
	player.get_node("TuskBulletCreate").global_position += add_position


func on_fight_animation_finished(player, anim_name):
	if anim_name == "PlayerDamage":
		General.attacked = false
		player.get_node("ItemBox/CollisionShape2D").set_deferred("disabled", false)


func on_fight_animation_started(player, anim_name):
	if anim_name == "PlayerDamage":
		player.get_node("ItemBox/CollisionShape2D").set_deferred("disabled", true)
		General.dostup_combo = true
		if General.blocked == false:
			player.anim_player.play("Hit")
			player.povorot_check(false)
			General.attacked = true
			if General.player_attack_activate:
				player.anim_stand.play(General.stand_index + "StandDefaultAttack_Back")
		else:
			player.anim_player.play("BlockHit")
			player.povorot_check(false)
			if General.player_attack_activate:
				player.anim_stand.play(General.stand_index + "StandDefaultAttack_Back")
		General.player_attack_activate = false
		General.dashed = false


func ghost_dash_timeout(player):
	var animation_player
	if player.get_tree().current_scene.name != "MorioMap":
		animation_player = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/PlayerFightAnimations")
	else:
		animation_player = player.get_node("/root/" + player.get_tree().current_scene.name + "/SortingY/PlayerFightAnimations")
	if General.dashed and not General.attacked and not General.player_attack_activate and (animation_player.current_animation != "PlayerDashAttack"):
		var effect = preload("res://Scenes/DashGhostEffect.tscn").instance()
		player.get_parent().add_child(effect)
		effect.position = player.global_position
		if General.player_direct == "left":
			effect.scale.x = 1
		else:
			effect.scale.x = - 1


func time_health_up(player):
	if General.heart_points < 100:
		player.restore_health(1, 100)


func fear_animation(player):
	player.fear_count += 0.8
	player.get_node("YSort/Texture/Global_buffs_anim").play("Fear")


func end_anim_check(player):
	var animation_enemy = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/FightAnimations")
	if animation_enemy.current_animation != "ChopDamage":
		player.anim_stand.play("KingCrimsonStandSecondDopAttack_Back")
