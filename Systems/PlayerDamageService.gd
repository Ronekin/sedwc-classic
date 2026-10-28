# PlayerDamageService.gd — входящий урон игроку и его VFX.
#
# Контракт: apply() получает General и параметры урона; при наличии
# PlayerEntity вызывает take_damage(), иначе использует fallback с защитой и
# clamp HP. Новые модификаторы урона добавляйте здесь.

extends Reference


func apply(general, Damage: float, Dop: Dictionary = {}):
	if not ("Sound" in Dop): Dop["Sound"] = "res://Music/PunchPopadanie.mp3"

	
	if general.blocked and (( not ("AntiBlock" in Dop)) or (Dop["AntiBlock"] == false)): Damage *= 0.5
	
	if general.blocked and ((("AntiBlock" in Dop)) and (Dop["AntiBlock"])):
		general.damage_effect("Blocked")
	else:
		general.damage_effect("Default")
		
	
	if "C_Chance" in general.Stats:
		if randf() < general.Stats["C_Chance"]:
			Damage *= 0.7
			Dop["Sound"] = "res://Music/MetalHitPunch.mp3"
	
	
	if general.GGPlayer != null and is_instance_valid(general.GGPlayer) and general.GGPlayer.has_method("take_damage"):
		general.GGPlayer.take_damage(Damage, general, {"blocked": general.blocked})
	else:
		var defense = float(general.Stats.get("D", 0.0))
		var applied = max(0.0, Damage * (1.0 - defense))
		general.damage_for_player_counts += applied
		general.heart_points = clamp(float(general.heart_points) - applied, 0.0, float(general.hp_max))
		if "Rage" in general.Addition: general.Addition["Rage"] += Damage
	
	
	general.SoundPlay(Dop["Sound"])
	
	var animation_player = general.get_node_or_null("/root/" + general.get_tree().current_scene.name + "/YSorting/PlayerFightAnimations")
	if animation_player == null:
		return
	var animation = animation_player.get_animation("PlayerDamage")
	if animation == null:
		return
	if "Push" in Dop:
	
		animation.track_set_key_value(0, 0, general.player_pos)

		
		var Pos_ = Vector2(general.player_pos.x, general.player_pos.y) + Dop["Push"]
		
		animation.track_set_key_value(0, 1, Vector2(clamp(Pos_.x, general.left_block_position.x, general.right_block_position.x), Pos_.y))






	
	
	
		animation_player.play("PlayerDamage")
