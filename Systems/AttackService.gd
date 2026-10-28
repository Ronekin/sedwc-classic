# AttackService.gd — именованные атаки и катсцены игрока.
#
# Контракт: execute()/barrage() получают GGPlayer и используют его сцены,
# узлы, камеру и методы PlayerEntity. Сервис не хранит состояния.
#
# Моддинг: новая атака — ветка в execute() и, при необходимости, сцена или
# анимация в GGPlayer.tscn.

extends Reference


func barrage(player):
	if player.anim_stand.current_animation.find("Idle") == - 1 and player.anim_stand.current_animation.find("Move") == - 1:
		yield(player.anim_stand, "animation_finished")
	player.stand_attack_anim("Barrage")
	match General.stand_number:
		1, 16:
			player.get_node("BARRAGE_STANDS").play("BarrageTheWorld")
		2:
			player.get_node("BARRAGE_STANDS").play("BarrageStarPlatinum")
		10:
			player.get_node("BARRAGE_STANDS").play("BarrageSoft")
		3, 24:
			player.get_node("BARRAGE_STANDS").play("BarrageGoldExp")
		11:
			player.get_node("BARRAGE_STANDS").play("BarrageTuskAct4")
		18:
			player.get_node("BARRAGE_STANDS").play("BarrageSCRetro")

func execute(player, Attack):
	if General.dostup_combo:
		if Attack == "TuskAct3bd":
			player.stand_attack_anim("NailTuskMega")
			player.anim_player.play("TuskAct1Nail")
			General.count_attacks += 1
		elif Attack == "EA1_bd":
			General.enemy_block_all = true
			General.player_block_all = true
	
			player.get_node("../../GUI").visible = false
			BlackLinesVertical.start_lines()
			
			yield(player.get_tree().create_timer(2.5), "timeout")
			General.SoundPlay("res://Music/EggDestroyEffect.mp3", {"Volume_db": 5})
			
			var da = Sprite.new()
			da.texture = load("res://Textures/Details/EchoesEggCracks.png")
			da.hframes = 2
			player.get_node("YSort/Stand/Stand_Texture").add_child(da)
			yield(player.get_tree().create_timer(1.0), "timeout")
			General.SoundPlay("res://Music/EggDestroyEffect.mp3", {"Volume_db": 5})
			da.frame = 1
			yield(player.get_tree().create_timer(1.0), "timeout")
			General.SoundPlay("res://Music/EggDestroyEffect.mp3", {"Volume_db": 5})
			da.queue_free()
			General.stand_number = 6
			if true:
				var da1 = preload("res://Scenes/Particles.tscn").instance()
				player.get_parent().add_child(da1)
				da1.Play("Egg")
				da1.scale *= 0.75
				da1.global_position = player.get_node("YSort/Stand/Stand_Texture").global_position

				da1.z_index = 10
			
			yield(player.get_tree().create_timer(1.5), "timeout")
			player.get_node("../../GUI").visible = true
			BlackLinesVertical.end_lines()
			
			General.player_block_all = false
			yield(player.get_tree().create_timer(1.5), "timeout")
			General.enemy_block_all = false
			
		elif Attack == "LV":
			var da = Sprite.new()
			da.offset = Vector2( - 110, 18)
			da.texture = load("res://Textures/Others/LasersVampire.png")
			player.get_node("YSort/Texture").add_child(da)
			da.position = Vector2(1, - 42)
			da.scale.x = 0
			
			
			
			var AveMariaaa = Area2D.new()
			var NuclearBomb_hvasan_31 = CollisionShape2D.new()
			var Ovogadro = RectangleShape2D.new()
			Ovogadro.extents = Vector2(200, 10)
			NuclearBomb_hvasan_31.shape = Ovogadro
			NuclearBomb_hvasan_31.disabled = true
			AveMariaaa.add_child(NuclearBomb_hvasan_31)
			NuclearBomb_hvasan_31.position = Vector2( - 193, - 40)
			player.get_node("YSort/Texture").add_child(AveMariaaa)
			AveMariaaa.add_to_group("LV")
			NuclearBomb_hvasan_31.disabled = false

			
			
			
			
			
			
			for i in 10:
				da.scale.x += 0.2
				yield(player.get_tree().create_timer(0.05), "timeout")
			for i in 5:
				da.scale.y -= 0.2
				yield(player.get_tree().create_timer(0.05), "timeout")
			NuclearBomb_hvasan_31.queue_free()
			da.queue_free()
			
			
			
		elif Attack == "R_L":
				General.player_block_all = true
				General.SoundPlay("res://Music/RechargeWeaponRevolver.mp3")
				yield(player.get_tree().create_timer(0.8), "timeout")
				
				var AveMariaaa = Area2D.new()
				var NuclearBomb_hvasan_31 = CollisionShape2D.new()
				var Ovogadro = RectangleShape2D.new()
				Ovogadro.extents = Vector2(0, 10)
				NuclearBomb_hvasan_31.shape = Ovogadro
				NuclearBomb_hvasan_31.disabled = true
				AveMariaaa.add_child(NuclearBomb_hvasan_31)
				NuclearBomb_hvasan_31.position = Vector2( - 400, - 40)
				
				player.add_child(AveMariaaa)
				AveMariaaa.add_to_group("R_L")
				NuclearBomb_hvasan_31.disabled = false
				
				
				
				
				
				
				
				
				
				
				
				General.SoundPlay("res://Music/ImpactHitShot.wav")
				var Snikers = Node2D.new()
				var da = ColorRect.new()
				Snikers.add_child(da)
				player.add_child(Snikers)
				Snikers.position = Vector2( - 1, - 51)
				da.rect_size = Vector2(0, 9)
				da.rect_rotation = 180

				
				Snikers.z_index = 99
				General.GGPlayer.CameraShake(0.3, 25, 25)
				
				for i in 5:
					yield(player.get_tree().create_timer(0.02), "timeout")
					da.rect_size.x += 190
					Ovogadro.extents.x += 80
















				AveMariaaa.queue_free()
				for i in 10:
					yield(player.get_tree().create_timer(0.02), "timeout")
					da.rect_size.y -= 9.0 / 10
					da.rect_position.y -= 9.0 / 20
				General.player_block_all = false
					
				

				Snikers.queue_free()
		elif Attack == "C_Laser":
			var da = Sprite.new()
			da.offset = Vector2( - 110, 18)
			da.texture = load("res://Textures/Others/LasersVampire.png")
			player.get_node("YSort/Texture").add_child(da)
			da.position = Vector2(1, - 42)
			da.scale.x = 0
			var AveMariaaa = Area2D.new()
			var NuclearBomb_hvasan_31 = CollisionShape2D.new()
			var Ovogadro = RectangleShape2D.new()
			Ovogadro.extents = Vector2(200, 10)
			NuclearBomb_hvasan_31.shape = Ovogadro
			NuclearBomb_hvasan_31.disabled = true
			AveMariaaa.add_child(NuclearBomb_hvasan_31)
			NuclearBomb_hvasan_31.position = Vector2( - 193, - 40)
			player.get_node("YSort/Texture").add_child(AveMariaaa)
			AveMariaaa.add_to_group("C_L")
			NuclearBomb_hvasan_31.disabled = false
			
			for i in 5:
				da.scale.x += 0.4
				yield(player.get_tree().create_timer(0.05), "timeout")
			da.scale.y = 0
			while ("C_Laser" in General.Addition) and General.Addition["C_Charge"] > 0:
				General.Addition["C_Charge"] -= 20.0 * 0.2
				General.Addition["C_Worched"] += 20.0 * 0.2
				for i in 2:
					da.scale.y -= 0.3
					yield(player.get_tree().create_timer(0.02), "timeout")
				NuclearBomb_hvasan_31.disabled = false
				
				for i in 2:
					da.scale.y += 0.3
					yield(player.get_tree().create_timer(0.02), "timeout")
				NuclearBomb_hvasan_31.disabled = true
			NuclearBomb_hvasan_31.queue_free()
			da.queue_free()
		elif Attack == "C_Gatling":
			var raycast = player.get_node("YSort/Texture/RayCast2D")
			raycast.enabled = true


			var AveMariaaa = Area2D.new()
			var NuclearBomb_hvasan_31 = CollisionShape2D.new()
			var Ovogadro = RectangleShape2D.new()
			
			Ovogadro.extents = Vector2(200, 1)
			NuclearBomb_hvasan_31.shape = Ovogadro
			NuclearBomb_hvasan_31.disabled = true
			AveMariaaa.add_child(NuclearBomb_hvasan_31)
			NuclearBomb_hvasan_31.position = Vector2( - 193, - 9)
			player.get_node("YSort/Texture").add_child(AveMariaaa)
			AveMariaaa.add_to_group("C_Gatling")

			
			
			
			
			
			
			var JojoPose = Sprite.new()
			JojoPose.texture = load("res://Textures/Others/CyborgGatling.png")
			JojoPose.offset.x = 14
			JojoPose.scale = Vector2(0, 1.4)
			player.get_node("YSort/Texture/Equips").add_child(JojoPose)
			JojoPose.position = Vector2( - 3, - 8)


			var KonoDioDa = Sprite.new()
			KonoDioDa.texture = load("res://Textures/Others/ShotGunEffectFire.png")
			KonoDioDa.position.x = 14

			JojoPose.add_child(KonoDioDa)

			KonoDioDa.visible = false
			
			
			for i in 10:
				JojoPose.scale.x -= 0.14

				yield(player.get_tree().create_timer(0.05), "timeout")
			
			while ("C_Gatling" in General.Addition) and General.Addition["C_bullets"] > 0:
				yield(player.get_tree().create_timer(0.05), "timeout")
				General.Addition["C_bullets"] -= 1
				KonoDioDa.visible = true
				player.Attack("BulletEff")

				raycast.force_raycast_update()
				General.SoundPlay("res://Music/WeaponShotRevolver.mp3")
				NuclearBomb_hvasan_31.disabled = false
				yield(player.get_tree().create_timer(0.03), "timeout")
				KonoDioDa.visible = false
				yield(player.get_tree().create_timer(0.02), "timeout")
				
				NuclearBomb_hvasan_31.disabled = true
			NuclearBomb_hvasan_31.queue_free()
			JojoPose.queue_free()
		elif Attack == "BulletEff":
				var da = player.get_node("TextureRect").duplicate()
				var Povar = Node2D.new()
				var Paravozik: TextureRect = da.duplicate()
				Povar.z_index = 99
				Povar.add_child(Paravozik)
				Paravozik.visible = true
				Paravozik.rect_position.y = - 44 + rand_range( - 4, 4)




				Paravozik.rect_position.x = - 35

				
				Paravozik.rect_scale.x = 0
				Paravozik.rect_scale.y = 0.02
				player.add_child(Povar)
				
				

				
				
				
				
				
				
				
				

				for i in 3:
					Paravozik.rect_scale.x += (1.0 / 3.0)
					yield(player.get_tree().create_timer(0.02), "timeout")
				var Rad = deg2rad(Paravozik.rect_rotation)
				var Degrees = Vector2(cos(Rad), sin(Rad))
				for i in 8:
					Paravozik.rect_position += Degrees * 40
					yield(player.get_tree().create_timer(0.02), "timeout")
				for i in 5:
					Paravozik.rect_scale.y -= 0.01 / 5.0
					yield(player.get_tree().create_timer(0.02), "timeout")
				Povar.queue_free()
		elif Attack == "TripleNails":
			player.stand_attack_anim("TuskNailTriple")
			player.anim_player.play("TuskAct1Nail")
			General.count_attacks += 3
		elif Attack == "Scorpio":
			player.SoundPlay("res://Music/GoldExpEffect.mp3")
			var da = preload("res://Scenes/AutoMoveAttack.tscn").instance()
			player.get_parent().add_child(da)
			da.global_position = player.global_position + Vector2(50, 0)
		elif Attack == "GERstone":
			player.stand_attack_anim("GERstone")
		elif Attack == "GravityRight":
			player.SoundPlay("res://Music/PucciCMoonVoice.mp3", {"Volume_db": 12})
			var enemy = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/Enemy")
			for i in [Vector2(150, 0), Vector2( - 150, 0), Vector2(0, - 150)]:
				var h = preload("res://Scenes/Hieroglyph.tscn").instance()
				player.get_parent().add_child(h)
				h.scale *= 1.5
				h.global_position = General.player_pos + i
				h.get_node("AnimationPlayer").play("!")
				yield(player.get_tree().create_timer(0.3), "timeout")
			for i in 20:
				for g in 4:
					
					enemy.global_position.x += 3
					yield(player.get_tree().create_timer(0.05), "timeout")
				var da = preload("res://Scenes/Metior.tscn").instance()
				player.get_parent().add_child(da)
				da.global_position = player.global_position + Vector2( - 600, rand_range( - 200, 200))
		elif Attack == "StarFinger":
			player.stand_attack_anim("StarFinger")
			player.get_node("AUDIO_EFFECT_STANDS").play("StarPlatinumStarFinger")
			General.count_attacks += 1
		elif Attack == "CMoonEver":
			player.stand_attack_anim("ChopCMoon")
			player.SoundPlay("res://Music/UshaVoice.mp3")
			player.SoundPlay("res://Music/HitStartEpic.mp3")
			General.count_attacks += 1
		elif Attack == "MIHchop":
			player.stand_attack_anim("ChopCMoon")

			player.SoundPlay("res://Music/HitStartEpic.mp3")
			General.count_attacks += 1
		elif Attack == "ChopKC":
			player.start_dop_kooldown(2)
			player.stand_attack_anim("KC_Chop")
			var enemy = player.get_node("/root/" + player.get_tree().current_scene.name + "/YSorting/Enemy")
			player.connect("enemy_timer_start", enemy, "enemy_timer_start")
			player.emit_signal("enemy_timer_start")
			player.disconnect("enemy_timer_start", enemy, "enemy_timer_start")
			player.get_node("ATTACK_SOUND").play("EPMTYPUNCH")
			General.count_attacks += 1
		elif Attack == "EchoesGlush":
			player.start_dop_kooldown(1)
			player.stand_attack_anim("NailTuskMega")
			player.get_node("ATTACK_SOUND").play("EPMTYPUNCH")
			General.count_attacks += 1
		elif Attack == "WoU_defence":
			
			player.SoundPlay("res://Music/GERsoundEffect.mp3")
			General.Addition["WoU"] = true
			yield(player.get_tree().create_timer(10.0), "timeout")
			General.Addition.erase("WoU")
		elif Attack == "WoU_NoLucky":
			
			
					
			var Enemy: Object
			for i in player.get_parent().get_children():
				if i.name.find("Enemy") == 0:
					Enemy = i
			
			
			
			
			player.SoundPlay("res://Music/WoU_Voice1.mp3")
			yield(player.get_tree().create_timer(1.0), "timeout")
			
			var da = Sprite.new()
			da.texture = load("res://Textures/RoundEchoesEffect.png")
			
			
			
			

			player.CameraShake(0.4, 30, 50)
			
			Enemy.health -= 20
			
			
			
			General.enemy_block_all = true
			for i in 5:
				Enemy.get_node("Sprite").rotation_degrees += 18

				
				yield(player.get_tree().create_timer(0.03), "timeout")

			Enemy.add_child(da)
			player.SoundPlay("res://Music/HitEpicPau.mp3")
			da.scale *= 0.4

			for i in 20:
				da.scale *= 1.1
				da.modulate.a -= 0.05
				
				yield(player.get_tree().create_timer(0.05), "timeout")
			da.queue_free()
			yield(player.get_tree().create_timer(3.0), "timeout")
			General.enemy_block_all = false
			Enemy.get_node("Sprite").rotation_degrees = 0
		elif Attack == "GERzero":
			player.SoundPlay("res://Music/GERsoundEffect.mp3")
			
			
			player.get_node("../../GUI").visible = false
			BlackLinesVertical.start_lines()
			
			General.player_block_all = true
			General.enemy_block_all = true
			
			var Enemy: Object
			for i in player.get_parent().get_children():
				if i.name.find("Enemy") == 0:
					Enemy = i
			
			var da: Sprite = Enemy.get_node("Sprite").duplicate()
			for g in da.get_children():
				g.queue_free()
			var Clones: Array = []
			for i in 6:
				yield(player.get_tree().create_timer(0.9), "timeout")
				var clone: Sprite = da.duplicate()
				Enemy.add_child(clone)
				clone.position.x += (i * 35) + 35
				Clones.append(clone)
			yield(player.get_tree().create_timer(1.9), "timeout")
			for i in Clones:
				i.queue_free()
			
			player.get_node("../../GUI").visible = true
			BlackLinesVertical.end_lines()
			
			General.player_block_all = false
			yield(player.get_tree().create_timer(3.9), "timeout")
			General.enemy_block_all = false
		elif Attack == "TuskHoleSave":
			
			
			
			
			
			if General.nail_count.find(1) != - 1:
				General.nail_timer_start()
				for i in range(General.nail_count.size()):
					if General.nail_count[i] == 1:
						General.nail_count[i] = 0
						break
			else:
				General.message_spawn("Center", "У вас недостаточно ногтей")
				return
			player.get_node("ItemBox/CollisionShape2D").disabled = true
			

			player.SoundPlay("res://Music/BlackHoleTuskAct2.mp3")
			player.SoundPlay("res://Music/NailDamage.mp3")
			
			var effect = player.tusk_4_hole.instance()
			player.tusk_4_hole_position = General.player_pos
			effect.global_position = player.tusk_4_hole_position
			player.get_parent().add_child(effect)
			player.get_node("YSort/Animations/DopAnimations").play("InHoleTusk")
			General.stable.append("hide")
			yield(player.get_tree().create_timer(0.3), "timeout")
			player.SoundPlay("res://Music/EmptyPunch.mp3")
			yield(player.get_node("YSort/Animations/DopAnimations"), "animation_finished")
			player.get_node(".").visible = false
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
			General.stable.erase("hide")
			player.get_node("YSort/Animations/DopAnimations").play("ExitHoleTusk")
			yield(player.get_tree(), "idle_frame")
			player.get_node(".").visible = true
			player.get_node("ItemBox/CollisionShape2D").disabled = false
			yield(player.get_node("YSort/Animations/DopAnimations"), "animation_finished")
		elif Attack == "d4cHIDE":
			
			player.get_node("ItemBox/CollisionShape2D").disabled = true
			
			
			

			player.SoundPlay("res://Music/EmptyPunch.mp3")
			



			player.get_node("Light2D").visible = false
			player.SoundPlay("res://Music/FlagWindD4C.mp3")

			player.get_node("YSort/Animations/DopAnimations").play("InFlag")
			yield(player.get_tree().create_timer(0.1), "timeout")
			
			yield(player.get_node("YSort/Animations/DopAnimations"), "animation_finished")
			player.visible = false
			General.stable.append("hide")
			yield(player.get_tree().create_timer(5), "timeout")
			player.SoundPlay("res://Music/FlagWindD4C.mp3")
			General.stable.erase("hide")
			yield(player.get_tree().create_timer(0.1), "timeout")


			
			player.get_node("YSort/Animations/DopAnimations").play("ExitFlag")
			yield(player.get_tree(), "idle_frame")
			
			player.get_node(".").visible = true
			player.get_node("ItemBox/CollisionShape2D").disabled = false
			yield(player.get_node("YSort/Animations/DopAnimations"), "animation_finished")
			player.get_node("Light2D").visible = true
		elif Attack == "GERstart":
			player.stand_attack_anim("GERstart")
			yield(player.get_tree().create_timer(1), "timeout")
			if not ("CutScene" in General.Addition):
				General.BeatDownCharge = 300
		elif Attack == "WoU_bd":
			player.SoundPlay("res://Music/WoU_Voice2.mp3")
			var zoom_save = General.camera_scale.x
			var camera_pos_save = player.get_node("YSort/Camera2D").global_position

			BlackLinesVertical.start_lines()
			General.Addition["CutScene"] = true
			General.attacked = true
			General.enemy_block_all = true
			player.get_node("../../GUI").visible = false
			var Enemy
			for i in player.get_parent().get_children():
				if i.name.find("Enemy") == 0:
					Enemy = i




			
			
			yield(player.get_tree().create_timer(0.4), "timeout")
			player.CameraMove(Enemy.global_position + Vector2(0, - 50), 0.1, 7)
			player.CameraZoom(0.7, 1, 0.5)


			
			
			yield(player.get_tree().create_timer(2.6), "timeout")
			
			Enemy.get_node("Sprite").rotation_degrees = 0
			

			

			
			if true:
				var da11 = ColorRect.new()
				da11.rect_size = Vector2(999, 999)
				da11.rect_position = Vector2( - 999, - 999)
				da11.rect_scale *= 999
				da11.color = Color(1, 0, 0)
				
				Transition.add_child(da11)
				for i in 20:
					da11.color.a -= 0.05
					yield(player.get_tree().create_timer(0.05), "timeout")
				da11.queue_free()
			
			
			
			var da = Sprite.new()
			da.texture = load("res://Textures/Details/Car.png")
			da.scale *= 1.5
			player.get_parent().add_child(da)
			da.global_position = Enemy.global_position + Vector2( - 500, - 45)
			player.CameraZoom(0.7, 0.5, 0.5)
			for i in 50:
				yield(player.get_tree().create_timer(0.02), "timeout")
				da.global_position.x += 20
				if i == 18:
					player.SoundPlay("res://Music/ImpactHitShot.wav")
					General.default_damage(Enemy, "lt", 30, 6, true, false)
					var da1 = preload("res://Scenes/Particles.tscn").instance()
					Enemy.add_child(da1)
					da1.Play("Blood")
					da1.position.y -= 50
					da1.z_index = 10
					player.CameraZoom(1.0, 0.5, 0.5)
			
			da.queue_free()
			yield(player.get_tree().create_timer(1.3), "timeout")
			

			
			
			BlackLinesVertical.end_lines()
			General.Addition.erase("CutScene")
			General.attacked = false

			player.get_node("../../GUI").visible = true
			General.arm_barrage_count = 0
			player.visible = true
			
			player.CameraMove(camera_pos_save, 0.5, 1)
			












			
			
			
			
			yield(player.get_tree().create_timer(4.3), "timeout")
			General.enemy_block_all = false
		elif Attack == "GER_bd":
			player.SoundPlay("res://Music/GER_BeatDown.mp3", {"Volume_db": 10})
			var zoom_save = General.camera_scale.x
			var camera_pos_save = player.get_node("YSort/Camera2D").global_position

			BlackLinesVertical.start_lines()
			General.Addition["CutScene"] = true
			General.attacked = true
			General.enemy_block_all = true
			player.get_node("../../GUI").visible = false
			var Enemy
			for i in player.get_parent().get_children():
				if i.name.find("Enemy") == 0:
					Enemy = i
			# Тренировочный манекен нельзя переставлять катсценой:
			# он должен оставаться на своём месте и не «исчезать».
			if Enemy.training_dummy == false:
				if General.player_direct == "right":
					Enemy.global_position = player.global_position + Vector2(100, 0)
				else:
					Enemy.global_position = player.global_position + Vector2( - 100, 0)
			
			
			yield(player.get_tree().create_timer(0.4), "timeout")
			player.CameraMove(Enemy.global_position + Vector2(0, - 50), 0.1, 7)
			player.CameraZoom(0.7, 1, 0.5)

			yield(player.get_tree().create_timer(1.4), "timeout")
			player.StandMove(Enemy.global_position, 0.5, 1.2)
			yield(player.get_tree().create_timer(0.2), "timeout")
			player.anim_stand.play("Hit")
			player.anim_stand.playback_speed = 2
			yield(player.get_tree().create_timer(0.7), "timeout")
			player.anim_stand.stop()

			Enemy.povorot_reset()
			
			
			General.arm_barrage_count = - 200
			General.barrage_activate = true
			
			player.anim_stand.playback_speed = 1
			player.anim_stand.play("Barrage")
			yield(player.get_tree().create_timer(8.7), "timeout")

			
			
			
			General.barrage_activate = false
			player.anim_stand.play("Hit")
			General.default_damage(Enemy, "lt", 10, 6, true, false, true, 150)
			
			for i in 10:
				Enemy.get_node("Sprite").rotation_degrees += 9
				
				yield(player.get_tree().create_timer(0.05), "timeout")
				player.CameraMove(Enemy.global_position + Vector2(0, - 50), 1, 0.05)
			
			
			if true:
				var h = preload("res://Scenes/Hieroglyph.tscn").instance()
				Enemy.get_parent().add_child(h)
				if Enemy.global_position.x > General.player_pos.x:
					h.global_position = Enemy.global_position + Vector2(50, - 60)
				else:
					h.global_position = Enemy.global_position + Vector2( - 50, - 60)
				h.get_node("AnimationPlayer").play("Mega")
			
			
			yield(player.get_tree().create_timer(0.9), "timeout")
			
			if General.player_direct == "right":
				player.StandMove(player.get_node("YSort").global_position + Vector2(39, 37), 2.5, 1)
			else:
				player.StandMove(player.get_node("YSort").global_position + Vector2( - 39, 37), 2.5, 1)
			
			
			
			
			
			yield(player.get_tree().create_timer(1.0), "timeout")
			
			Enemy.get_node("Sprite").rotation_degrees = 0
			
			player.SoundPlay("res://Music/GEReffect2.mp3")
			
			player.visible = false
			
			if true:
				var da11 = ColorRect.new()
				da11.rect_size = Vector2(999, 999)
				da11.rect_position = Vector2( - 999, - 999)
				da11.rect_scale *= 999
				
				Transition.add_child(da11)
				for i in 20:
					da11.color.a -= 0.05
					yield(player.get_tree().create_timer(0.05), "timeout")
				da11.queue_free()
			
			
			
			var da = Sprite.new()
			da.texture = load("res://Textures/Details/Car.png")
			da.scale *= 1.5
			player.get_parent().add_child(da)
			da.global_position = Enemy.global_position + Vector2( - 500, - 45)
			player.CameraZoom(0.7, 0.5, 0.5)
			for i in 50:
				yield(player.get_tree().create_timer(0.02), "timeout")
				da.global_position.x += 20
				if i == 18:
					var da1 = preload("res://Scenes/Particles.tscn").instance()
					Enemy.add_child(da1)
					da1.Play("Blood")
					da1.position.y -= 50
					da1.z_index = 10
					player.CameraZoom(1.0, 0.5, 0.5)
			
			da.queue_free()
			yield(player.get_tree().create_timer(1.3), "timeout")
			

			
			
			BlackLinesVertical.end_lines()
			General.Addition.erase("CutScene")
			General.attacked = false

			player.get_node("../../GUI").visible = true
			General.arm_barrage_count = 0
			player.visible = true
			
			player.CameraMove(camera_pos_save, 0.5, 1)
			
			if true:
				player.SoundPlay("res://Music/GEReffect2.mp3")
				var da11 = ColorRect.new()
				da11.rect_size = Vector2(999, 999)
				da11.rect_position = Vector2( - 999, - 999)
				da11.rect_scale *= 999
				
				Transition.add_child(da11)
				for i in 20:
					da11.color.a -= 0.05
					yield(player.get_tree().create_timer(0.05), "timeout")
				da11.queue_free()
			
			
			
			
			yield(player.get_tree().create_timer(4.3), "timeout")
			General.enemy_block_all = false
		elif Attack == "GoldNailDa":
			




			
			
			
			var Enemy
			for i in player.get_parent().get_children():
				if i.name.find("Enemy") == 0:
					Enemy = i
			player.get_node("../../GUI").visible = false
			BlackLinesVertical.start_lines()
			Enemy.attacked = true
			

			player.SoundPlay("res://Music/PerfectGoldSpinEnergyVoice.mp3")
			var allEffs = []
			var dada = Node2D.new()
			player.get_node("YSort/Texture").add_child(dada)
			for i in 4:
				var da = Sprite.new()
				da.texture = load("res://Textures/Details/SpinPlayerEff.png")
				da.hframes = 2
				da.vframes = 2
				da.frame = i
				da.modulate.a = 0
				da.set_light_mask(32)
				allEffs.append(da)
				dada.add_child(da)
			var l: Light2D = Light2D.new()
			l.texture = load("res://Textures/MaskDaTusk.png")
			l.energy = 0.5


			l.set_item_cull_mask(32)
			l.scale = Vector2(3, 10)
			dada.add_child(l)
			l.position = Vector2(42, - 8)
			var dafa = range( - 20, 20)
			dafa.append_array(range( - 20, 0))
			var zoom_save = General.camera_scale
			player.CameraZoom(0.5, 0.3, 2)
			
			for i in (dafa):
				
				l.position.x += 16 / (i + 0.8)
				for k in allEffs.size():
					var das = float(int(i >= 0) - int(i < 0))
					allEffs[k].modulate.a += 0.1
				
					allEffs[k].position.y += float(int(k % 2 == 0) - int(k % 2 != 0)) * das * 0.2
				yield(player.get_tree().create_timer(0.03), "timeout")

			

			yield(player.get_tree().create_timer(0.3), "timeout")
			player.CameraZoom(zoom_save.x, 0.5, 0.3)
			yield(player.get_tree().create_timer(0.1), "timeout")
			player.anim_player.play("TuskAct1Nail")
			General.attacked = true
			player.BulletAttack(1)
			var t = Sprite.new()
			t.texture = load("res://Textures/Details/NailShotEff.png")
			player.add_child(t)
			t.global_position = player.get_node("TuskBulletCreate").global_position
			t.scale *= 0
			
			
			for i in 5:
				t.scale += Vector2(0.2, 0.2)
				yield(player.get_tree().create_timer(0.02), "timeout")
			player.SoundPlay("res://Music/ImpactHitShot.wav")
			
			var h = preload("res://Scenes/Hieroglyph.tscn").instance()
			h.scale *= 2
			player.get_parent().add_child(h)
			if General.direct == "Right":
				h.global_position = player.get_node("TuskBulletCreate").global_position + Vector2(50, - 35)
			else:
				h.global_position = player.get_node("TuskBulletCreate").global_position + Vector2( - 50, - 35)
			h.get_node("AnimationPlayer").play("Mega")
			
			yield(player.get_tree().create_timer(0.05), "timeout")
			Enemy.attacked = false
			player.get_node("ImpactDa").modulate.a = 1
			player.get_node("ImpactDa").visible = true
			
			dada.queue_free()
			
			player.CameraShake(0.4, 10, 60)
			player.CameraShake(0.2, 50, 20)
			yield(player.get_tree().create_timer(0.1), "timeout")
			for i in 5:
				player.get_node("ImpactDa").modulate.a -= 0.2
				yield(player.get_tree().create_timer(0.02), "timeout")
			player.get_node("ImpactDa").visible = false
			yield(player.anim_player, "animation_finished")
			General.attacked = false
			yield(player.get_tree().create_timer(0.1), "timeout")
			BlackLinesVertical.end_lines()
			player.get_node("../../GUI").visible = true
			for i in 5:
				t.scale -= Vector2(0.2, 0.2)
				yield(player.get_tree().create_timer(0.02), "timeout")
			t.queue_free()
		elif Attack == "C-Moon_Jump":
			var zoom_save = General.camera_scale.x
			var camera_pos_save = player.get_node("YSort/Camera2D").global_position

			player.CameraZoom(1.5, 1.0, 0.2)
			player.SoundPlay("res://Music/HitStartEpic.mp3")
			var Enemy
			for i in player.get_parent().get_children():
				if i.name.find("Enemy") == 0:
					Enemy = i
			# Тренировочный манекен не подбрасываем: иначе он уезжает
			# вверх/вниз и выглядит исчезнувшим.
			if Enemy.training_dummy == false:
				for i in 15:
					Enemy.global_position.y -= 12 / (1.0 + (i * 0.3))
					yield(player.get_tree().create_timer(0.02), "timeout")
			player.CameraZoom(zoom_save, 1.0, 0.2)
			if Enemy.training_dummy == false:
				for i in 7:
					Enemy.global_position.y += 24 / (1.0 + (i * 0.3))
					yield(player.get_tree().create_timer(0.02), "timeout")
			player.SoundPlay("res://Music/HitEpicPau.mp3")
			player.CameraShake(0.2, 10, 60)
			var da = preload("res://Scenes/Effect.tscn").instance()
			player.get_parent().add_child(da)
			da.z_index = 99
			da.scale *= 1.9
			da.rotation_degrees = 90
			da.Play("PunchWave")
			da.global_position = Enemy.global_position
			var h = preload("res://Scenes/Hieroglyph.tscn").instance()
			Enemy.get_parent().add_child(h)
			if Enemy.global_position.x > General.player_pos.x:
					h.global_position = Enemy.global_position + Vector2(50, - 60)
			else:
					h.global_position = Enemy.global_position + Vector2( - 50, - 60)
			h.get_node("AnimationPlayer").play("Pau")
		elif Attack == "revolver":
			General.player_attack_activate = true
			player.stand_attack_anim("revolver")
		elif Attack == "emerald_splash":
			General.player_attack_activate = true
			player.stand_attack_anim("emerald_splash")
			
		elif Attack == "InfinitySpinEnemy":
			player.anim_player.play("IdleBEZ")

			General.attacked = true
			
			General.Addition["CutScene"] = true
			
			
			
			var Enemy
			for i in player.get_parent().get_children():
				if i.name.find("Enemy") == 0:
					Enemy = i
			
			if (player.global_position.x < Enemy.global_position.x) and General.player_direct == "left":
				player.scale.x *= - 1
				General.player_direct = "right"
			elif (player.global_position.x > Enemy.global_position.x) and General.player_direct == "right":
				player.scale.x *= - 1
				General.player_direct = "left"
			
			
			
			var zoom_save = General.camera_scale.x
			var camera_pos_save = player.get_node("YSort/Camera2D").global_position

			player.CameraZoom(0.4, 0.5, 1)
			player.CameraMove(player.global_position + Vector2(0, - 20), 0.5, 2)
			

			
			
			player.get_node("../../GUI").visible = false
			BlackLinesVertical.start_lines()

			GeneralMusicPlayer.theme_resong("JonnyTheme")
			player.SoundPlay("res://Music/HontonyJonnyVoice.mp3")
			yield(player.get_tree().create_timer(1.0), "timeout")

			
			player.CameraMove(player.global_position + Vector2(0, - 80), 0.5, 4)
			
			yield(player.get_tree().create_timer(3.0), "timeout")

			
			var h1 = preload("res://Scenes/Hieroglyph.tscn").instance()
			Enemy.get_parent().add_child(h1)
			if Enemy.global_position.x > General.player_pos.x:
					h1.global_position = player.global_position + Vector2(50, - 60)
			else:
					h1.global_position = player.global_position + Vector2( - 50, - 60)
			h1.get_node("AnimationPlayer").play("do")
			
			
			
			yield(player.get_tree().create_timer(3.0), "timeout")
			player.anim_player.play("Tudooo")


			yield(player.get_tree().create_timer(0.8), "timeout")

			
			
			
			player.CameraMove(Enemy.global_position + Vector2(0, - 30), 0.5, 0.5)
			
			
			player.CameraZoom(0.7, 0.5, 0.5)


			GeneralMusicPlayer.volume_db = 10
			
			
			General.arm_barrage_count = - 200
			General.barrage_activate = true
			
			yield(player.get_tree().create_timer(0.4), "timeout")
			player.StandMove(Enemy.global_position, 0.5, 1.2)
			yield(player.get_tree().create_timer(0.8), "timeout")

			Enemy.povorot_reset()

			player.anim_stand.play("Barrage")
			

			player.SoundPlay("res://Music/Tusk4Barrage.mp3")
			var h = preload("res://Scenes/Hieroglyph.tscn").instance()
			player.get_parent().add_child(h)
			h.global_position = Enemy.global_position
			h.get_node("AnimationPlayer").play("Go")
			yield(player.get_tree().create_timer(0.5), "timeout")
			Enemy.attacked = true
			General.arm_barrage_count = - 200
			BlackLinesVertical.get_node("Control/Eff").visible = true
			for i in 13:
				Enemy.attacked = true
				player.anim_stand.play("Barrage")
				yield(player.get_tree().create_timer(0.5), "timeout")
				
			Enemy.attacked = true
			player.get_node("YSort/Stand/Stand_Texture").rotation_degrees = - 80
			player.anim_stand.play("BigHit")
			
			
			
			var da = preload("res://Scenes/Effect.tscn").instance()
			player.get_parent().add_child(da)
			da.z_index = 99
			da.scale *= 2.9
			da.rotation_degrees = 90
			da.Play("PunchWave")
			da.global_position = Enemy.global_position
			
			
			player.CameraShake(0.6, 10, 60)
			player.SoundPlay("res://Music/HitEpicPau.mp3")
			player.CameraZoom(1.1, 0.3, 1)
			General.barrage_activate = false
			
			Enemy.get_node("ShadowNpc").position = Vector2(3, - 32)
			Enemy.get_node("ShadowNpc").scale = Vector2(2, 3)
			Enemy.get_node("ShadowNpc").rotation_degrees = 90
			
			var EnemyCenterPos: Vector2 = Vector2()
			if Enemy.direct_text == "Right":
				Enemy.rotation_degrees = - 90
				EnemyCenterPos = Enemy.global_position + Vector2( - 30, 0)
			else:
				Enemy.rotation_degrees = 90
				EnemyCenterPos = Enemy.global_position + Vector2(30, 0)
			player.get_node("YSort/Stand/Stand_Texture").global_position = EnemyCenterPos + Vector2(0, - 60)
			
			var CrackEffect = Sprite.new()
			CrackEffect.texture = load("res://Textures/Details/Cracks.png")
			CrackEffect.scale *= 3
			player.get_parent().add_child(CrackEffect)
			CrackEffect.global_position = EnemyCenterPos
			
			yield(player.get_tree().create_timer(0.1), "timeout")
			
			player.anim_stand.playback_speed = 0.3

			yield(player.get_tree().create_timer(0.5), "timeout")
			yield(player.get_tree().create_timer(0.5), "timeout")
			player.CameraZoom(0.6, 2.0, 0.5)
			player.CameraMove(EnemyCenterPos, 2.0, 0.5)
			General.barrage_activate = true
			player.anim_stand.play("Barrage")
			player.anim_stand.playback_speed = 1.0
			player.SoundPlay("res://Music/Tusk4Barrage.mp3")
			if Enemy.direct_text == "Right":

				player.get_node("YSort/Stand/Stand_Texture").global_position = Enemy.global_position + Vector2( - 30, - 60)
			else:

				player.get_node("YSort/Stand/Stand_Texture").global_position = Enemy.global_position + Vector2(30, - 60)

			General.arm_barrage_count = - 200
			for i in 14:
				Enemy.attacked = true
				player.anim_stand.play("Barrage")
				yield(player.get_tree().create_timer(0.5), "timeout")
			player.CameraMove(camera_pos_save, 1.0, 0.5)
			General.barrage_activate = false
			player.anim_player.playback_speed = 1
			player.anim_player.play("IdleBEZ")
			player.SoundPlay("res://Music/ArigatoGyroVoice.mp3")
			player.get_node("YSort/Stand/Stand_Texture").rotation_degrees = 0
			
			BlackLinesVertical.get_node("Control/Eff").visible = false
			General.arm_barrage_count = 0
			player.anim_stand.play("LeftIdle")
			player.get_node("YSort/Stand/StandMoveAnim").play("ToBack")
			GeneralMusicPlayer.volume_db = 0
			

			h.queue_free()
			yield(player.get_tree().create_timer(1), "timeout")
			player.get_node("YSort/Stand/Stand_Texture").flip_h = true
			if General.player_direct == "right":
				player.StandMove(player.get_node("YSort").global_position + Vector2(39, 37), 2.5, 2)
			else:
				player.StandMove(player.get_node("YSort").global_position + Vector2( - 39, 37), 2.5, 2)
			yield(player.get_tree().create_timer(2), "timeout")
			player.get_node("YSort/Camera2D").global_position = camera_pos_save
			player.get_node("YSort/Stand/Stand_Texture").flip_h = false
			Enemy.rotation_degrees = 0
			Enemy.get_node("ShadowNpc").position = Vector2(1, 4)
			Enemy.get_node("ShadowNpc").scale = Vector2(1, 1)
			Enemy.get_node("ShadowNpc").rotation_degrees = 0
			player.CameraZoom(zoom_save, 1.0, 0.5)
			General.attacked = false
			Enemy.attacked = false
			GeneralMusicPlayer.theme_resong()

			player.get_node("../../GUI").visible = true
			General.passive_damage(Enemy, "lt", 0.5, 12, 5, false)
			BlackLinesVertical.end_lines()
			Enemy.rotation_degrees = 0
			General.Addition.erase("CutScene")
			
			General.BeatDownCharge = 0
			
			for i in 20:
				CrackEffect.modulate.a -= 0.05
				yield(player.get_tree().create_timer(0.05), "timeout")
				
			CrackEffect.queue_free()
		elif Attack == "ws_disc":
			player.stand_attack_anim("Hit")
			player.StandHitBoxGroup("ws_disc")
			yield(player.get_tree().create_timer(1), "timeout")
			player.StandHitBoxGroup("ws_disc", true)

			General.count_attacks += 1

		elif Attack == "BallShot":
			if not General.player_attack_activate:
				General.player_attack_activate = true
				player.anim_player.play("Knife")
				
				player.SoundPlay("res://Music/EmptyPunch.mp3")
				yield(player.get_tree().create_timer(0.2), "timeout")
			
				player.attack_bullet( - 1)
				
					



				General.count_attacks += 1
		elif Attack == "BallShotInfinity":
			if not General.player_attack_activate:
				General.player_attack_activate = true
				player.anim_player.play("Knife")
				
				player.SoundPlay("res://Music/EmptyPunch.mp3")
				yield(player.get_tree().create_timer(0.1), "timeout")
			
				player.attack_bullet( - 2)
				
					



				General.count_attacks += 1
