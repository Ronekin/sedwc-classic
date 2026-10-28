# PlayerProcessService.gd — покадровые визуальные состояния игрока.
#
# Контракт: process() получает GGPlayer; родительский _process(delta)
# остаётся в GGPlayer и вызывает сервис.

extends Reference


func process(player, delta):
	if player.Cast == 1:
		if General.choose_skins["spin"] == "default":
			player.get_node("YSort/Texture/SpinBall").frame = 0
		elif General.choose_skins["spin"] == "gold":
			player.get_node("YSort/Texture/SpinBall").frame = 2
		elif General.choose_skins["spin"] == "caramel":
			player.get_node("YSort/Texture/SpinBall").frame = 4
		player.get_node("YSort/Animations").play("SpinCast")
		General.player_block_attack = true
		player.get_node("YSort/Texture/SpinBall").visible = true
		player.get_node("YSort/Texture/Node2D/Musk").visible = true
	elif player.get_node("YSort/Animations").current_animation == "SpinCast":
		player.anim_player.play("Move" + player.is_item_in_arm)
		General.player_attack_activate = false
		player.get_node("YSort/Texture/SpinBall").visible = false
		player.get_node("YSort/Texture/Node2D/Musk").visible = false
		General.player_block_attack = false
		

	
	
	player.get_node("YSort/Texture/Node2D").visible = player.get_node("Sprite").visible == false and player.get_node("ImpactDa").visible == false
	
	General.update_stats()
	if player.get_tree().current_scene.name.find("Arena") != - 1:
		General.fight_timer += delta
		if General.heart_points < General.hp_max * 0.1 and not ("BERSERK" in General.Addition):
			if ("BERSERK" in General.Stats):
				General.Addition["BERSERK"] = 1
				General.enemy_block_all = true
				if true:
					General.SoundPlay("res://Music/GEReffect2.mp3")
					var da11 = ColorRect.new()
					da11.rect_size = Vector2(999, 999)
					da11.rect_position = Vector2( - 999, - 999)
					da11.rect_scale *= 999
					
					Transition.add_child(da11)
					for i in 20:
						da11.color.a -= 0.05
						yield(player.get_tree().create_timer(0.05), "timeout")
					da11.queue_free()
				
				GeneralMusicPlayer.theme_resong("StartOfPower")
				for i in 20:
					General.enemy_block_all = true
					player.restore_health((General.hp_max * 0.3) / 20.0)
					yield(player.get_tree().create_timer(0.2), "timeout")
				General.enemy_block_all = false

		if "Rage" in General.Addition and General.Addition["Rage"] >= 100:
			General.SoundPlay("res://Music/GEReffect2.mp3")
			General.Addition["Rage"] = 0
			General.Addition["RageMode"] = true
			player.get_node("YSort/Texture/Node2D/RageAura").visible = true
			player.get_node("YSort/Texture/Node2D/Rage").visible = true
			var Count = 60
			if General.Stats["Rage"] == 1:
				Count += 50
			
			
			for i in Count:
				General.Addition["Rage"] = 0
				if player.get_node("YSort/Texture/Node2D/RageAura").frame < 2:
					player.get_node("YSort/Texture/Node2D/RageAura").frame += 1
				else:
					player.get_node("YSort/Texture/Node2D/RageAura").frame = 0
				yield(player.get_tree().create_timer(0.1), "timeout")
			player.get_node("YSort/Texture/Node2D/RageAura").visible = false
			player.get_node("YSort/Texture/Node2D/Rage").visible = false
			General.Addition.erase("RageMode")
		
		
		
	else:
		General.fight_timer = 0
