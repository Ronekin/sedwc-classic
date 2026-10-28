# PlayerAbilityActionService.gd — действия способностей игрока.
#
# Контракт: лечение стендов, пробуждение Джонни, чай и броня. Функции
# получают GGPlayer и меняют General/player; UI вызывает их через GGPlayer.

extends Reference


func health_up_ge_activate(player):
	player.get_node("AUDIO_EFFECT_STANDS").play("GoldExpHeal")
	player.health_up(0.25 * General.hp_max)
	player.start_dop_kooldown(1)


func health_up_ger_activate(player):
	player.get_node("AUDIO_EFFECT_STANDS").play("GoldExpHeal")
	player.health_up(0.5 * General.hp_max)
	player.start_dop_kooldown(1)


func overwrite_twoh_self_activ(player):
	player.get_node("AUDIO_EFFECT_STANDS").play("TwohSelfOverWrite")
	player.health_up(General.hp_max * 0.5)
	player.start_dop_kooldown(1)


func johny_awakening_go(player):
	General.global_buffs["johny_awakeng"] = true
	if General.global_buffs["johny_awakeng"] == true:
		var effect = player.vfx_johny_awaken.instance()
		player.get_node("YSort/Stand/Stand_Texture/JohnyEffectPos").add_child(effect)
		effect.z_index = 3
		yield(player.get_tree().create_timer(10), "timeout")
		General.global_buffs["johny_awakeng"] = false


func tea_go(player):
	var tusk = 1
	player.get_node("AUDIO_EFFECT_STANDS").play("TuskTea")

	var count_nail_add
	if General.stand_number == 4:
		count_nail_add = 4
		tusk = 1
	elif General.stand_number == 5:
		count_nail_add = 3
		tusk = 2
	elif General.stand_number == 9:
		count_nail_add = 3
		tusk = 3
	elif General.stand_number == 11:
		count_nail_add = 5
		tusk = 4
	player.health_up(5 * tusk)
	var count_zero = General.nail_count.count(0)
	if count_zero >= count_nail_add:
		for i in range(1, count_nail_add + 1):
			General.nail_count[count_zero - i] = 1
	else:
		for i in range(1, count_nail_add - count_zero):
			General.nail_count[count_zero - i] = 1


func armor_scr_func(player):
	if ("NoArmor" in player.addition) == false:
		player.addition.append("NoArmor")
		player.spend_health(50)
		player.get_node("YSort/Animations/DopAnimations").play("UnArmor")
		player.get_node("AUDIO_EFFECT_STANDS").play("SCRetroDisArmor")
		yield(player.get_tree().create_timer(0.5), "timeout")
	else:
		player.addition.erase("NoArmor")
		player.anim_player.play()
		player.restore_health(50)
		player.get_node("YSort/Animations/DopAnimations").play("Armor")
		yield(player.get_tree().create_timer(0.5), "timeout")
