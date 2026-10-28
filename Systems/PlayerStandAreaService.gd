# PlayerStandAreaService.gd — попадания по Area2D стенда и игрока.
#
# Контракт: получает GGPlayer и area, не храня состояния; урон и эффекты
# делегируются в General/EnemyDamageService.

extends Reference


func on_stand_area_entered(player, area):
	if area.is_in_group("Enemy"):
		player.get_node("YSort/Stand/StandArea/AreaStandHitBox").set_deferred("disabled", true)
		if player.anim_stand.current_animation.find("StandThreeDopAttack") != - 1 and General.stand_number == 2:
			player.anim_stand.play("StarPlatinumStandThreeDopAttack_Back")
		if player.anim_stand.current_animation.find("StandSecondDopAttack") != - 1 and General.stand_number == 8:
			yield(player.get_tree().create_timer(0.25), "timeout")
			player.get_node("YSort/Stand/Stand_Texture").frame = 14
		if player.get_node("YSort/Stand/StandArea").is_in_group("overr"):
			var da = preload("res://Scenes/Effect.tscn").instance()
			player.get_parent().add_child(da)
			da.z_index = 99
			da.scale *= 1.6
			da.Play("OverWave")
			da.global_position = player.get_node("YSort/Stand/Stand_Texture/PunchPos").global_position
		if player.get_node("YSort/Stand/StandArea").is_in_group("zahvat_hg"):
			var animation_effect = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/GeneralEffectAnimaion")
			var da = preload("res://Scenes/Effect.tscn").instance()
			player.get_parent().add_child(da)
			da.z_index = 99
			da.scale *= 1.6
			da.Play("zahvat_hg")
			da.global_position = player.get_node("YSort/Stand/Stand_Texture/PunchPos").global_position
			General.debuff_enemy = "HgZahvat"
			General.stand_activated = false
			player.get_node("YSort/Texture/Node2D/StandAura").visible = false
			yield(player.get_tree().create_timer(5), "timeout")
			player.connect("stand_activate", player, "on_stand_activate")
			player.emit_signal("stand_activate")
			player.disconnect("stand_activate", player, "on_stand_activate")
			yield(player.get_tree().create_timer(0.3), "timeout")
			animation_effect.play("TheWorldDash")
			General.debuff_enemy = ""
		elif player.get_node("YSort/Stand/StandArea").is_in_group("StandAttackBig"):
			var da = preload("res://Scenes/Effect.tscn").instance()
			player.get_parent().add_child(da)
			da.z_index = 99
			da.scale *= 1.5
			da.Play("PunchWave")
			da.global_position = player.get_node("YSort/Stand/Stand_Texture/PunchPos").global_position


func on_attack_area_entered(player, area):
	if area.is_in_group("Enemy"):
		player.get_node("YSort/Texture/AttackArea/AttackBoxHit").set_deferred("disabled", true)
	elif area.is_in_group("GGclone"):
		player.health_less(General.hp_max * 0.1)
