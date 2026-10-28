# Gyro.gd — базовый сценарий гуманоидного врага SEDWC.
#
# Конкретный персонаж выбирается по General.EnemyName и Data/Enemies.gd;
# общие атаки и анимации остаются здесь. Наследники переопределяют только
# уникальные фазы.

extends "res://NewClasses/Enemy.gd"
class_name Gyro


onready var sprite = $Sprite
onready var sprite2 = $Sprite2 if has_node("Sprite2") else null
onready var label = $Label if has_node("Label") else null
onready var debufs = $debufs if has_node("debufs") else null
onready var texture_progress = $Sprite.get_node_or_null("TextureProgress")
onready var collision_shape = $CollisionShape2D if has_node("CollisionShape2D") else null
onready var area_collision = $Area2D / CollisionShape2D if has_node("Area2D/CollisionShape2D") else null
onready var attack_box_collision = $AttackBox / CollisionShape2D2 if has_node("AttackBox/CollisionShape2D2") else null
onready var ghost_effect = $Ghost_Effect if has_node("Ghost_Effect") else null
onready var animation_player_node = $AnimationPlayer if has_node("AnimationPlayer") else null
onready var enemy_status = $EnemyStatus if has_node("EnemyStatus") else null
onready var dash_effect = $Dash if has_node("Dash") else null
onready var punch_effect = $PunchEffect if has_node("PunchEffect") else null
onready var shadow_npc = $ShadowNpc if has_node("ShadowNpc") else null






var attack_array_chance = [1, 1, 1]
signal epitafia_damage
var count_win_zecks = 0
var tournament_reward_service = preload("res://Systems/TournamentRewardService.gd").new()










func _connect_local_timer(t: Timer, method: String, wait_time: float, one_shot: bool = true) -> void :
	_ensure_child_timer(t)
	if t.is_connected("timeout", self, method):
		t.disconnect("timeout", self, method)
	t.connect("timeout", self, method)
	t.wait_time = wait_time
	t.one_shot = one_shot
	t.start()

func _exit_tree() -> void :
	._exit_tree()
	_disconnect_epitafia_player_signal()
	path.clear()
	timers.clear()
	dataDop.clear()

func _disconnect_epitafia_player_signal() -> void :
	var player_path = "/root/" + current_scene_name + "/YSorting/GGPlayer"
	if current_scene_name == "MorioMap":
		player_path = "/root/" + current_scene_name + "/SortingY/GGPlayer"
	if has_node(player_path):
		var player = get_node(player_path)
		if is_connected("epitafia_damage", player, "epitafia_damage"):
			disconnect("epitafia_damage", player, "epitafia_damage")

func create_enemy():
	if character_name == "Dio":
		stand = "TheWorld"
	elif character_name == "Diavolo":
		stand = "KingCrimson"
	else:
		stand = "None"


func _ready():
	._ready()
	max_hp = 75.0
	
	current_scene_name = get_tree().current_scene.name
	navigation_node = get_node_or_null("/root/" + current_scene_name + "/Navigation2D")
	
	
	var player_path = "/root/" + current_scene_name + "/YSorting/GGPlayer"
	if current_scene_name == "MorioMap":
		player_path = "/root/" + current_scene_name + "/SortingY/GGPlayer"
	if has_node(player_path):
		player_node = get_node(player_path)
	
	
	if enemy_block_timer.get_parent() == null:
		if not enemy_block_timer.is_connected("timeout", self, "enemy_block_timer_end"):
			enemy_block_timer.connect("timeout", self, "enemy_block_timer_end")
		enemy_block_timer.wait_time = 1
		enemy_block_timer.one_shot = true
		_ensure_child_timer(enemy_block_timer)
	
	
	if not has_node("/root/General"):
		printerr("Ошибка: General не найден!")
		return
	
	if General.EnemyName == "":
		General.EnemyName = General.enemy_collision_name
	
	
	var texture_path = "res://Textures/EnemySheet.png"
	if ResourceLoader.exists(texture_path):
		sprite.texture = load(texture_path)
	sprite.hframes = 8
	sprite.vframes = 1
	
	create_enemy()
	attack_id_start_for_small_dist = 0
	attack(0)
	
	
	_connect_local_timer(kooldown_timer, "lolololololol", 1 / max(General.enemy_time_scale, 0.1))
	
	
	if animation_player:
		if not animation_player.is_connected("animation_finished", self, "_on_player_animation_finished"):
			animation_player.connect("animation_finished", self, "_on_player_animation_finished")
	
	if animation_enemy:
		if not animation_enemy.is_connected("animation_finished", self, "_on_enemy_animation_finished"):
			animation_enemy.connect("animation_finished", self, "_on_enemy_animation_finished")
	
	
	if General.enemy_list != null and id - 1 < General.enemy_list.size() and id - 1 >= 0:
		health = General.enemy_list[id - 1]["HP"]
	else:
		health = 75
		printerr("Ошибка: enemy_list индекс вне диапазона")
	
	var TournamentDataDa: Dictionary = {}
	if General.is_tournir and General.tournament_lvl != null:
		TournamentDataDa = General.GetTournamentEnemy(General.tournament_lvl)
	
	
	match General.EnemyName:
		"dio":
			AnimationTypeDa = 1
			health = 500
			max_hp = health
			var dio_texture = "res://Textures/Enemys/Dio.png"
			if ResourceLoader.exists(dio_texture):
				sprite.texture = load(dio_texture)
			sprite.hframes = 3
			sprite.vframes = 3
			if sprite2:
				sprite2.visible = true
			yield(get_tree().create_timer(1), "timeout")
			General.SoundPlay("res://Music/TheWorldSummon.mp3")
		"jotaro6":
			var jotaro6_texture = "res://Textures/Enemys/JotaroPart6.png"
			if ResourceLoader.exists(jotaro6_texture):
				sprite.texture = load(jotaro6_texture)
			if sprite2:
				sprite2.visible = true
				sprite2.texture = load("res://Textures/Stands/StarPlatinum.png")
			yield(get_tree().create_timer(1), "timeout")
			General.SoundPlay("res://Music/StarPlatinumSummon.mp3")
		"jotaro3":
			var jotaro3_texture = "res://Textures/jotaroEnemy.png"
			if ResourceLoader.exists(jotaro3_texture):
				sprite.texture = load(jotaro3_texture)
			if sprite2:
				sprite2.visible = true
				sprite2.texture = load("res://Textures/Stands/StarPlatinum.png")
			yield(get_tree().create_timer(1), "timeout")
			General.SoundPlay("res://Music/StarPlatinumSummon.mp3")
		"zeck":
			health = 40
			max_hp = health
			var zeck_texture = "res://Textures/Enemys/Zeck.png"
			if ResourceLoader.exists(zeck_texture):
				sprite.texture = load(zeck_texture)
			yield(get_tree().create_timer(1), "timeout")
		"luka":
			health = 300
			max_hp = health
			var luka_texture = "res://Textures/Enemys/Luka.png"
			if ResourceLoader.exists(luka_texture):
				sprite.texture = load(luka_texture)
			yield(get_tree().create_timer(2), "timeout")
			if General.money > 1000:
				General.message_spawn("Center", "на кону 500$")
			else:
				General.message_spawn("Center", "на кону " + str(General.money / 2.0) + " $")
		"bucciarati":
			var bucciarati_texture = "res://Textures/Enemys/Bucciarati.png"
			if ResourceLoader.exists(bucciarati_texture):
				sprite.texture = load(bucciarati_texture)
			if sprite2:
				sprite2.visible = true
				sprite2.texture = load("res://Textures/Stands/StickyFingers.png")
				sprite2.hframes = 4
				sprite2.vframes = 1
		"peshi":
			AnimationTypeDa = 1
			health = 500
			max_hp = health
			var peshi_texture = "res://Textures/Enemys/Peshi.png"
			if ResourceLoader.exists(peshi_texture):
				sprite.texture = load(peshi_texture)
			sprite.hframes = 4
			sprite.vframes = 4
			yield(get_tree().create_timer(1), "timeout")
		"diablo":
			AnimationTypeDa = 1
			if shadow_npc:
				shadow_npc.visible = true
			health = 700
			max_hp = health
			var diablo_texture = "res://Textures/Enemys/Diablo.png"
			if ResourceLoader.exists(diablo_texture):
				sprite.texture = load(diablo_texture)
			if sprite2:
				sprite2.visible = true
				sprite2.texture = load("res://Textures/Stands/KingCrimson.png")
				sprite2.hframes = 4
				sprite2.vframes = 4
			yield(get_tree().create_timer(1), "timeout")
			General.SoundPlay("res://Music/KingCrimsonSummon.mp3")
		"Valentine":
			AnimationTypeDa = 1
			var valentine_texture = "res://Textures/Enemys/FunnyValentain.png"
			if ResourceLoader.exists(valentine_texture):
				sprite.texture = load(valentine_texture)
			sprite.vframes = 2
			if sprite2:
				sprite2.visible = true
				sprite2.texture = load("res://Textures/Stands/D4C.png")
				sprite2.hframes = 4
				sprite2.vframes = 3
			if TournamentDataDa.get("version", "") == "True":
				dataDop["Stop"] = true
				General.enemy_block_all = true
				General.player_block_all = true
				yield(get_tree().create_timer(0.1), "timeout")
				if has_node("../../GUI"):
					$"../../GUI".visible = false
				General.enemy_block_all = true
				General.player_block_all = true
				
				var camera_pos_save: Vector2 = Vector2.ZERO
				if General.GGPlayer and General.GGPlayer.has_node("YSort/Camera2D"):
					camera_pos_save = General.GGPlayer.get_node("YSort/Camera2D").global_position
				
				BlackLinesVertical.start_lines()
				yield(get_tree().create_timer(1), "timeout")
				if General.GGPlayer:
					General.GGPlayer.CameraMove(global_position + Vector2(0, - 50), 0.5, 2)
				General.SoundPlay("res://Music/D4C_LoveTrainVoice.mp3")
				yield(get_tree().create_timer(1.5), "timeout")
				if General.GGPlayer:
					General.GGPlayer.CameraMove(global_position + Vector2(0, - 110), 0.5, 0.2)
				yield(get_tree().create_timer(0.2), "timeout")
				
				if General.GGPlayer:
					General.GGPlayer.CameraMove(global_position + Vector2(0, - 50), 2, 0.1)
				
				var loveTrain = preload("res://Scenes/LoveTrain.tscn").instance()
				add_child(loveTrain)
				yield(get_tree().create_timer(1.9), "timeout")
				BlackLinesVertical.end_lines()
				if has_node("../../GUI"):
					$"../../GUI".visible = true
				if General.GGPlayer:
					General.GGPlayer.CameraMove(camera_pos_save, 0.5, 2)
				yield(get_tree().create_timer(0.5), "timeout")
				General.enemy_block_all = false
				General.player_block_all = false
				dataDop.erase("Stop")
		"Diego":
			AnimationTypeDa = 1
			var diego_texture = "res://Textures/Enemys/Diego.png"
			if ResourceLoader.exists(diego_texture):
				sprite.texture = load(diego_texture)
			sprite.vframes = 3
			sprite.hframes = 3
			if sprite2:
				sprite2.visible = true
				sprite2.texture = load("res://Textures/twautw.png")
				sprite2.hframes = 2
				sprite2.vframes = 2
		"Gyro":
			AnimationTypeDa = 1
			var gyro_texture = "res://Textures/Enemys/Gyro.png"
			if ResourceLoader.exists(gyro_texture):
				sprite.texture = load(gyro_texture)
			sprite.vframes = 3
			sprite.hframes = 4
		"Cars":
			AnimationTypeDa = 1
			if shadow_npc:
				shadow_npc.visible = true
			health = 1000
			max_hp = health
			var cars_texture = "res://Textures/Enemys/Cars.png"
			if ResourceLoader.exists(cars_texture):
				sprite.texture = load(cars_texture)
			sprite.vframes = 2
		"cyborg":
			AnimationTypeDa = 1
			if shadow_npc:
				shadow_npc.visible = true
			health = 400
			max_hp = health
			sprite.vframes = 2
			var cyborg_texture = "res://Textures/Enemys/Somebody0.png"
			if ResourceLoader.exists(cyborg_texture):
				sprite.texture = load(cyborg_texture)
		"IronMan":
			AnimationTypeDa = 1
			if shadow_npc:
				shadow_npc.visible = true
			health = 800
			max_hp = health
			sprite.vframes = 2
			var ironman_texture = "res://Textures/Enemys/Somebody1.png"
			if ResourceLoader.exists(ironman_texture):
				sprite.texture = load(ironman_texture)
	
	if General.is_tournir and TournamentDataDa:
		health = TournamentDataDa.get("hp", health)
		var texture_path_tour = TournamentDataDa.get("texture", "")
		if texture_path_tour != "" and ResourceLoader.exists(texture_path_tour):
			sprite.texture = load(texture_path_tour)
		sprite.hframes = TournamentDataDa.get("hframes", 8)
		sprite.vframes = TournamentDataDa.get("vframes", 1)
		if "new_anim_type" in TournamentDataDa.get("addition", {}):
			AnimationTypeDa = 1
		max_hp = health
		if TournamentDataDa.get("type", "") == "шустрый":
			SpeedBuff = 1.6
		elif TournamentDataDa.get("type", "") == "ярый":
			var da = AnimatedSprite.new()
			var dada = SpriteFrames.new()
			dada.add_animation("Fire")
			var TextureDa = load("res://Textures/Others/RageAura.png")
			if TextureDa:
				for i in 3:
					var Adada = AtlasTexture.new()
					Adada.atlas = TextureDa
					Adada.region = Rect2(i * 150, 0, 150, 150)
					dada.add_frame("Fire", Adada)
				da.frames = dada
				da.play("Fire")
				da.speed_scale = 1.5
				da.position = Vector2(3, - 30)
				da.scale = Vector2(0.7, 0.9)
				da.z_index = - 1
				add_child(da)
				var Zoro = da.duplicate()
				Zoro.scale = Vector2(0.8, 1.1)
				Zoro.modulate.a = 165.0 / 255
				Zoro.z_index = 2
				Zoro.play("Fire")
				add_child(Zoro)
				var F = Light2D.new()
				var light_texture = load("res://Textures/Light.png")
				if light_texture:
					F.texture = light_texture
				F.color = Color("ff598c")
				F.energy = 1.2
				F.scale *= 2
				F.position = Vector2(7.4, - 43)
				add_child(F)
	else:
		var enemy_info = General.GetEnemyInfo(General.EnemyName)
		if enemy_info and "HP" in enemy_info:
			health = enemy_info["HP"]
		max_hp = health
	
	
	random.randomize()
	random_crit.randomize()


func _on_player_animation_finished(anim_name: String) -> void :
	if waiting_for_animation and anim_name == "PlayerDamage":
		waiting_for_animation = false
		if pending_attack_id != 0:
			var attack_id_local = pending_attack_id
			pending_attack_id = 0
			attack(attack_id_local)

func _on_enemy_animation_finished(anim_name: String) -> void :
	if waiting_for_animation and anim_name == "DashEnemy":
		waiting_for_animation = false


func _physics_process(delta):
	._physics_process(delta)
	if death_processed:
		return
	
	
	if not has_node("/root/General"):
		return
	
	
	if General.debuff_enemy == "HgZahvat":
		if sprite.has_node("HierophantGreen"):
			sprite.get_node("HierophantGreen").visible = true
	else:
		if sprite.has_node("HierophantGreen"):
			sprite.get_node("HierophantGreen").visible = false
	
	if General.stand_number == 7 and health < max_hp * 0.5 and not ("EA1" in General.Addition):
		General.Addition["EA1"] = true
		if General.GGPlayer:
			General.GGPlayer.Attack("EA1_bd")
	
	if General.is_tournir and General.EnemyName == "Valentine" and General.GetTournamentEnemy(General.tournament_lvl).get("version", "") == "True":
		if General.stand_number == 9 and not dialog_start:
			if General.heart_points > 0 and health <= max_hp * 0.25:
				dialog_start = true
				arigato_gyro_valentine()
	
	if reward_get:
		return
	
	
	if texture_progress:
		texture_progress.visible = not ("CutScene" in General.Addition)
	
	if health < LastHp:
		General.BeatDownCharge += LastHp - health
		if General.BeatDownCharge > 300:
			General.BeatDownCharge = 300
		LastHp = health
	elif LastHp < health:
		LastHp = health
	
	if health <= 0 and activate_angry and not death_processed:
		process_death()
		return
	
	if General.EnemyName == "diablo":
		if General.fight_with == 2 and health < 230 and General.stand_number == 3:
			General.fight_with = 0
			if has_node("../GGPlayer"):
				$"../GGPlayer".CutScene("Requim")
		
		if "eph" in timers:
			if timers["eph"] > 10:
				if attacked:
					attacked = false
					timers.erase("eph")
					General.SoundPlay("res://Music/EpitaphEnd.mp3")
					var da = ColorRect.new()
					da.rect_size = Vector2(1233, 616)
					if has_node("../../GUI"):
						$"../../GUI".add_child(da)
					da.color = Color("ff0000")
					General.player_block_all = true
					if global_position.x > General.player_pos.x:
						global_position = General.player_pos + Vector2( - 100, 0)
					else:
						global_position = General.player_pos + Vector2(100, 0)
					for i in 10:
						yield(get_tree().create_timer(0.05), "timeout")
						da.modulate.a -= 0.1
					da.queue_free()
					yield(get_tree().create_timer(0.5), "timeout")
					General.player_block_all = false
		else:
			timers["eph"] = 0.0
		
		if "erase" in timers:
			if timers["erase"] > 15 and timers["erase"] < 20:
				timers["erase"] = 20.0
				dataDop["time_save"] = {
					"player_pos": General.player_pos, 
					"enemy_pos": global_position, 
					"hp": health, 
				}
			if timers["erase"] > 30:
				global_position = dataDop["time_save"]["enemy_pos"]
				if has_node("../GGPlayer"):
					$"../GGPlayer".global_position = dataDop["time_save"]["player_pos"]
				health = dataDop["time_save"]["hp"]
				General.SoundPlay("res://Music/TimeEraseEnd.mp3")
				timers.erase("erase")
				var da = time_erase_effect.instance()
				add_child(da)
		else:
			timers["erase"] = - 10.0
	
	
	timers_to_clear()
	
	
	if label:
		if attacked:
			label.text = "attacked"
		else:
			label.text = "not attacked"
	
	var random_crit_proc = random_crit.randf()
	if General.global_debuffs.get("hand_fear", false):
		if not General.hands_opens.get("blood", false):
			if random_crit_proc <= 0.3 and General.add_hand_crit > 0:
				passive_damage(1, 3, (3 + General.add_hand_damage * 2) + (3 + General.add_hand_damage * 2) / 100 * General.add_hand_crit, false)
			else:
				passive_damage(1, 3, 3 + General.add_hand_damage * 2, false)
		else:
			if random_crit_proc <= 0.3 and General.add_hand_crit > 0:
				passive_damage(1, 4, (3 + General.add_hand_damage * 2) + (3 + General.add_hand_damage * 2) / 100 * General.add_hand_crit, false)
			else:
				passive_damage(1, 4, 3 + General.add_hand_damage * 2, false)
		General.global_debuffs["hand_fear"] = false
	
	if debuf_infinity > 0:
		if debufs:
			debufs.play("infinityspin")
	
	
	if not enemy_block_timer.is_stopped():
		General.enemy_block_all = true
	else:
		General.enemy_block_all = false
	
	if enemy_status:
		enemy_status.rect_position.x = 0 - ((General.enemy_current_status.size() - 1) * 8)
	
	if General.EnemyName != "IronMan":
		if global_position.distance_to(General.player_pos_start_erase) > 250 and not General.time_erase:
			speed = (250 - debuf_infinity) * slow
		if global_position.distance_to(General.player_pos_start_erase) < 100:
			speed = (120 - debuf_infinity / 2) * slow
	
	if animation_player_node:
		animation_player_node.playback_speed = General.enemy_time_scale
	if animation_enemy:
		animation_enemy.playback_speed = General.enemy_time_scale
	
	General.enemy_health = health
	General.enemy_direct = direct_text
	
	if player_start_attack:
		_player_attack_reset_cd += delta
		if _player_attack_reset_cd >= 1.0 / max(General.enemy_time_scale, 0.1):
			player_start_attack = false
			_player_attack_reset_cd = 0.0
	else:
		_player_attack_reset_cd = 0.0
	
	General.enemy_position = global_position
	
	
	if not General.enemy_block_all and not General.time_erase and not attacked and not ("Stop" in dataDop):
		
		if global_position.distance_to(General.player_pos_start_erase) < 70 and attack_timer.is_stopped() and kooldown_timer.is_stopped() and abs(global_position.y - General.player_pos_start_erase.y) < 30 and activate_angry and not General.is_invent_show and not block_activate and not player_start_attack and not dashed and General.glush_enemy_timer.is_stopped() and General.combo_timer.is_stopped() and not attacked:
			if not combo_enabled and kooldown_timer.is_stopped() and not block_activate and not warning_activate and General.glush_enemy_timer.is_stopped() and General.combo_timer.is_stopped() and not General.enemy_block_all:
				var attack_count = random.randi_range(2, 5)
				for attack_idx in range(attack_count):
					General.player_block_attack = true
					combo_enabled = true
					if animation_player_node:
						animation_player_node.play("Idle")
					var attack_id_local = attack_array_chance[random.randi_range(0, attack_array_chance.size() - 1)]
					attack(attack_id_local)
					
					
					if animation_player and animation_player.current_animation == "PlayerDamage":
						waiting_for_animation = true
						yield(animation_player, "animation_finished")
						waiting_for_animation = false
					
					if animation_enemy:
						waiting_for_animation = true
						yield(animation_enemy, "animation_finished")
						waiting_for_animation = false
				
				var end_attack_chance = random.randf()
				if not General.blocked:
					if end_attack_chance <= 0.7:
						General.player_block_attack = false
				else:
					if end_attack_chance <= 0.5:
						General.player_block_attack = false
				yield(get_tree().create_timer(0.2), "timeout")
				if not General.blocked:
					if end_attack_chance > 0.7:
						attack(5)
				else:
					if end_attack_chance > 0.5:
						attack(5)
				_connect_local_timer(kooldown_timer, "lolololololol", 2.0 / max(General.enemy_time_scale, 0.1))
				combo_enabled = false
		
		elif global_position.distance_to(General.player_pos_start_erase) > 150 and attack_timer.is_stopped() and timer_knifes.is_stopped() and abs(global_position.y - General.player_pos_start_erase.y) < 30 and activate_angry and not General.is_invent_show and not block_activate and not player_start_attack and not dashed and General.glush_enemy_timer.is_stopped() and General.combo_timer.is_stopped():
			if attack_id_start == 0 and timer_knifes.is_stopped() and not block_activate and not warning_activate and General.glush_enemy_timer.is_stopped() and General.combo_timer.is_stopped():
				attack_id_start = random.randf()
				if attack_id_start > 0 and attack_id_start < 0.3:
					if get_tree().current_scene.name in ["DioDefaultEnemyArena", "JotaroDefaultEnemyArena"]:
						General.SoundPlay("res://Music/TheWorldStrengthAttack.mp3")
					if animation_player_node:
						animation_player_node.play("Idle")
					attack(4)
					_connect_local_timer(timer_knifes, "lolololololol", 3.0 / max(General.enemy_time_scale, 0.1))
					attack_id_start = 0
				else:
					_connect_local_timer(timer_knifes, "lolololololol", 3.0 / max(General.enemy_time_scale, 0.1))
					attack_id_start = 0
	
	time_passed += delta
	if texture_progress:
		texture_progress.value = health
		texture_progress.max_value = max_hp
	
	if not activate_angry and timer.is_stopped() and not ("Stop" in dataDop):
		start_position = global_position
		if animation_player_node:
			animation_player_node.play("Idle")
	
	if General.time_erase:
		if ghost_effect:
			ghost_effect.wait_time = 1
			if ghost_effect.is_stopped():
				ghost_effect.start()
	
	if animation_player_node:
		animation_player_node.playback_speed = 1.0 / max(General.mih_speed, 0.1)
	
	if not General.enemy_block_all and not ("Stop" in dataDop) and activate_angry:
		distance = global_position.distance_to(General.player_pos)
		
		
		if distance > dist_end and not attacked and activate_angry and not General.is_invent_show and not dashed and not block_activate and not attack_activate and not player_start_attack and not warning_activate and General.combo_timer.is_stopped() and General.glush_enemy_timer.is_stopped():
			if navigation_update_timer <= 0:
				navigation_update_timer = navigation_update_interval
				generate_path_left()
				navigate_v2()
			else:
				navigation_update_timer -= delta
				if path.size() > 0:
					navigate_v2()
			
			# direction считаем после navigate_v2(): иначе враг двигался
			# по направлению прошлого кадра и заметно запаздывал.
			direction = velocity.normalized()
			move_and_slide((direction * SpeedBuff * (speed + debuf_infinity) * General.enemy_time_scale) * slow / max(General.mih_speed, 0.1))
			state = "Moving"
			if AnimationTypeDa == 1:
				if animation_player_node:
					animation_player_node.play("WalkNew")
			else:
				if animation_player_node:
					animation_player_node.play("Walk")
		elif distance <= dist_end and not attacked and activate_angry and not dashed and not block_activate and not General.time_stop:
			if animation_player_node:
				animation_player_node.play("Idle")
			state = "Standing"
	else:
		if not attacked:
			if not ("Stop" in dataDop) and activate_angry:
				state = "Standing"
				if animation_player_node:
					animation_player_node.play("Idle")
	
	if attacked:
		dashed = false
		state = "Attacked"
	elif dashed and not block_activate and activate_angry:
		state = "Dashed"
		if animation_enemy and animation_enemy.current_animation == "DashEnemy":
			if sprite2 and sprite2.visible:
				if animation_player_node:
					animation_player_node.play("StandAttack")
			else:
				if General.EnemyName == "peshi":
					if animation_player_node and animation_player_node.current_animation != "AttackJust":
						if animation_player_node:
							animation_player_node.play("AttackJust")
						for i in [12, 13, 10, 11, 9, 8]:
							yield(get_tree().create_timer(0.035), "timeout")
							sprite.frame = i
							if animation_player_node and animation_player_node.current_animation != "AttackJust":
								return
					if animation_player_node:
						animation_player_node.play("AttackJust")
				elif AnimationTypeDa == 1:
					if animation_player_node:
						animation_player_node.play("AttackNew")
				else:
					if animation_player_node:
						animation_player_node.play("Attack")
		elif animation_enemy and animation_enemy.current_animation == "BigDashEnemy":
			if animation_player_node:
				animation_player_node.play("Idle")
		elif animation_enemy and animation_enemy.current_animation == "BigDashEnemyBack":
			if animation_player_node:
				animation_player_node.play("Idle")
		elif animation_enemy and animation_enemy.current_animation == "AggresiveDashEnemy":
			if AnimationTypeDa == 1:
				if animation_player_node:
					animation_player_node.play("AggresiveAttackNew")
			else:
				if animation_player_node:
					animation_player_node.play("AggresiveAttack")
	elif block_activate and not attacked and activate_angry:
		if animation_player_node:
			animation_player_node.play("Block")
	
	if position.x > General.player_pos_start_erase.x and direct_text != "Left" and activate_angry and not dashed and not General.enemy_block_all and General.glush_enemy_timer.is_stopped():
		scale.x *= - 1
		direct_text = "Left"
	elif position.x < General.player_pos_start_erase.x and direct_text != "Right" and activate_angry and not dashed and not General.enemy_block_all and General.glush_enemy_timer.is_stopped():
		scale.x *= - 1
		direct_text = "Right"
	
	dist_l = General.player_pos - General.left_block_position
	dist_r = General.right_block_position - General.player_pos
	dist_enemy_l = global_position - General.left_block_position
	dist_enemy_r = General.right_block_position - global_position
	dist_enemy_t = global_position - General.top_block_position
	dist_enemy_b = General.bottom_block_positon - global_position
	
	if Input.is_action_just_pressed("kill"):
		health -= 100
	
	if General.heart_points <= 0 and activate_angry and health > 0 and not death_processed:
		General.enemy_block_all = false
		enemy_block_timer.stop()
		
		death_processed = true
		activate_angry = false
		General.player_block_all = true
		if General.is_tournir:
			var completed_level = int(General.tournament_lvl) - 1
			if completed_level > int(General.tournir_record):
				General.tournir_record = completed_level
			General.is_tournir = false
		Transition.change_scene("res://GeneralGameScenes/LoseScreen.tscn", "Black")
		General.current_support["Fights"] -= 1
		General.save_save()
		return
	
	position_first = global_position


func timers_to_clear():
	timers_to_clear_list.clear()
	for key in timers:
		var before = timers[key]
		timers[key] += get_process_delta_time()
		if before < 0 and timers[key] >= 0:
			timers_to_clear_list.append(key)
	for key in timers_to_clear_list:
		timers.erase(key)



func process_death():
	General.disconnect_fight_timers_from(self)
	General.enemy_block_all = false
	enemy_block_timer.stop()
	
	General.SoundPlay("res://Music/Enemy.mp3")
	
	var da = preload("res://Scenes/Particles.tscn").instance()
	if get_parent():
		get_parent().add_child(da)
	da.Play("MegaBlood")
	da.scale *= 0.75
	da.global_position = global_position + Vector2(0, - 40)
	da.global_position.x = global_position.x
	da.z_index = 10
	
	death_processed = true
	reward_get = true
	activate_angry = false
	
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
	if area_collision:
		area_collision.set_deferred("disabled", true)
	if attack_box_collision:
		attack_box_collision.set_deferred("disabled", true)
	
	if General.is_tournir:
		reward_get = true
		General.player_statistic["kills"] = General.player_statistic.get("kills", 0) + 1
		General.AchievementGive(0)
		
		if General.tournament_lvl >= 100:
			General.AchievementGive(37)
		var randomix = RandomNumberGenerator.new()
		randomix.randomize()
		
		var tour_enemy = General.GetTournamentEnemy(General.tournament_lvl)
		if randomix.randf() < float(tour_enemy.get("drop_chance", 0.0)):
			randomix.randomize()
			var random_chnce = randomix.randf()
			if random_chnce <= 0.25:
				General.add_item(7, 1)
			elif random_chnce <= 0.5:
				General.add_item(9, 1)
			elif random_chnce <= 0.75:
				General.add_item(14, 1)
			elif random_chnce <= 1:
				General.add_item(16, 1)
			if str(tour_enemy.get("name", "")) == "Gyro" and General.stand_number == 0 and General.techic_number == 1:
				General.quest_delete(3.8, false)
				General.techic_number = 2
		tournament_reward_service.award(General, tour_enemy)

		General.tournament_lvl += 1
		General.save_save()
		General.player_block_all = true
		if has_node("/root/" + current_scene_name + "/YSorting/GGPlayer/YSort/Camera2D"):
			var camera = get_node("/root/" + current_scene_name + "/YSorting/GGPlayer/YSort/Camera2D")
			camera.global_position = global_position + Vector2(30, 21)
			camera.smoothing_speed = 2
		if texture_progress:
			texture_progress.value = health
		
		yield(get_tree().create_timer(1.0), "timeout")
		if has_node("../../GUI"):
			$"../../GUI".AfterTournament()
	else:
		if General.EnemyName == "zeck":
			death_processed = false
			reward_get = false
			activate_angry = true
			if collision_shape:
				collision_shape.set_deferred("disabled", false)
			if area_collision:
				area_collision.set_deferred("disabled", false)
			if attack_box_collision:
				attack_box_collision.set_deferred("disabled", false)

			count_win_zecks += 1
			health = 40
			if has_node("../../StaticBody2D/Light2D"):
				$"../../StaticBody2D/Light2D".energy += 2.5 / 6
			
			if has_node("../../Zecks/Sprite"):
				var dada = $"../../Zecks/Sprite".duplicate()
				$"../../Zecks".add_child(da)
				dada.visible = true
				dada.global_position = global_position
			
			var dada = global_position + Vector2(700, 0)
			if randf() > 0.5:
				dada = global_position + Vector2( - 700, 0)
			attacked = true
			
			if count_win_zecks < 30:
				General.player_statistic["kills"] = General.player_statistic.get("kills", 0) + 1
				General.AchievementGive(0)
				attacked = false
				global_position = dada
				for i in 120:
					General.enemy_block_all = false
					yield(get_tree(), "idle_frame")
					attacked = false
				yield(get_tree().create_timer(2), "timeout")
				General.enemy_block_all = false
			else:
				visible = false
				General.player_block_all = true
				General.enemy_block_all = true
				attacked = true
				activate_angry = false
				if has_node("../GGPlayer"):
					$"../GGPlayer".CameraZoom(2, 1.0, 1)
				
				if has_node("../../StaticBody2D") and $"../../StaticBody2D".visible:
					GeneralMusicPlayer.theme_resong("L_Theme")
					if has_node("../../GUI") and not $"../../GUI".visible:
						while has_node("../../GUI") and not $"../../GUI".visible and is_inside_tree():
							yield(get_tree(), "idle_frame")
					if has_node("../../GUI"):
						$"../../GUI".visible = false
					
					if has_node("../../Zecks"):
						for child in $"../../Zecks".get_children():
							if has_node("../.."):
								get_node("../..").ZeckPlant(child)
							yield(get_tree().create_timer(0.1), "timeout")
					
					yield(get_tree().create_timer(2), "timeout")
					BlackLinesVertical.start_lines()
					if has_node("../GGPlayer") and has_node("../../StaticBody2D"):
						if $"../GGPlayer".global_position.distance_to($"../../StaticBody2D".global_position) < 300:
							var directionDa = $"../../StaticBody2D".global_position.direction_to($"../GGPlayer".global_position)
							if directionDa.x < 0:
								directionDa.x = - 1
							else:
								directionDa.x = 1
							while $"../GGPlayer".global_position.distance_to($"../../StaticBody2D".global_position) < 300 and is_inside_tree():
								$"../GGPlayer".global_position += directionDa * 7
								yield(get_tree().create_timer(0.02), "timeout")
					if has_node("../GGPlayer") and has_node("../../StaticBody2D"):
						if $"../GGPlayer".global_position.distance_to($"../../StaticBody2D".global_position) > 300:
							var directionDa = $"../../StaticBody2D".global_position.direction_to($"../GGPlayer".global_position)
							while $"../GGPlayer".global_position.distance_to($"../../StaticBody2D".global_position) > 300 and is_inside_tree():
								$"../GGPlayer".global_position -= directionDa * 7
								yield(get_tree().create_timer(0.02), "timeout")
					
					yield(get_tree().create_timer(1), "timeout")
					if has_node("../GGPlayer/YSort/Camera2D"):
						var camera = $"../GGPlayer".get_node("YSort/Camera2D")
						var CameraPosSave = camera.position
						if has_node("../../StaticBody2D/GreenBabySpawn"):
							$"../GGPlayer".CameraMove($"../../StaticBody2D/GreenBabySpawn".global_position, 1.0, 2)
						
						yield(get_tree().create_timer(2), "timeout")
						$"../GGPlayer".CameraZoom(0.5, 1.0, 1)
						yield(get_tree().create_timer(2), "timeout")
						if has_node("../../StaticBody2D/AnimationPlayer"):
							$"../../StaticBody2D/AnimationPlayer".play("lightEnd")
						
						for i in 6:
							if has_node("../../StaticBody2D/Sprite2"):
								$"../../StaticBody2D/Sprite2".frame += 1
							yield(get_tree().create_timer(0.5), "timeout")
						yield(get_tree().create_timer(1), "timeout")
						if has_node("../../StaticBody2D/Sprite2"):
							$"../../StaticBody2D/Sprite2".frame += 1
						yield(get_tree().create_timer(1), "timeout")
						
						camera.current = false
						var NewCamera = Camera2D.new()
						NewCamera.current = true
						NewCamera.zoom *= 0.5
						if has_node("../../StaticBody2D/Sprite2"):
							$"../../StaticBody2D/Sprite2".add_child(NewCamera)
							if $"../../StaticBody2D/Sprite2".global_position.x > $"../GGPlayer".global_position.x:
								$"../../StaticBody2D/Sprite2".scale.x *= - 1
							
						var InitiallyDist: float = $"../../StaticBody2D/Sprite2".global_position.distance_to($"../GGPlayer".global_position)
						while $"../../StaticBody2D/Sprite2".global_position.distance_to($"../GGPlayer".global_position) > 50 and is_inside_tree():
							$"../../StaticBody2D/Sprite2".frame += 1
							for i in 5:
								$"../../StaticBody2D/Sprite2".global_position += $"../../StaticBody2D/Sprite2".global_position.direction_to($"../GGPlayer".global_position) * 3
								yield(get_tree().create_timer(0.02), "timeout")
							$"../../StaticBody2D/Sprite2".frame -= 1
							for i in 5:
								$"../../StaticBody2D/Sprite2".global_position += $"../../StaticBody2D/Sprite2".global_position.direction_to($"../GGPlayer".global_position) * 3
								yield(get_tree().create_timer(0.02), "timeout")
							
							if $"../../StaticBody2D/Sprite2".global_position.distance_to($"../GGPlayer".global_position) < 0.5 * InitiallyDist:
								NewCamera.current = false
								camera.position = CameraPosSave
								camera.current = true
					General.add_item(20, 1)
					yield(get_tree().create_timer(0.5), "timeout")
					$"../GGPlayer".CameraZoom(1, 1.0, 0.5)
					yield(get_tree().create_timer(1), "timeout")
					Transition.change_scene("res://GeneralGameScenes/WinScreen.tscn", "Black")
					General.current_support["Fights"] -= 1
					General.save_save()
				else:
					Transition.change_scene("res://GeneralGameScenes/WinScreen.tscn", "Black")
					General.current_support["Fights"] -= 1
					General.save_save()
		else:
			if General.heart_points > 0:
				General.player_block_all = true
				General.money_change(10)
				General.exp_change(25)
				General.current_support["Fights"] -= 1
				General.kills += 1
				General.AchievementGive(0)
				General.save_save()
				Transition.change_scene("res://GeneralGameScenes/WinScreen.tscn", "Black")
			else:
				General.player_block_all = true
				General.money_change(10)
				General.exp_change(25)
				if (General.techic_number == 1 and General.stand_number == 0) or (General.stand_number == 7 and General.techic_number == 1):
					General.add_item(15, 1)
				General.current_support["Fights"] -= 1
				General.kills += 1
				General.AchievementGive(0)
				General.save_save()
				Transition.change_scene("res://GeneralGameScenes/WinScreen.tscn", "Black")

func arigato_gyro_valentine():
	dialog_create("...", 0, 0, 0, 0, General.dialogue_text("gyro_thanks"), "Главный Герой", "GeneralCharacter")
	if General.stand_number == 11:
		General.enemy_block_all = true
		General.player_block_all = true
	GeneralMusicPlayer.theme_resong("TuskAct4Bd")
	General.passive_damage(self, "None", 1000000, 1000000, 0, false)

func dialog_create(ans1, ans2, ans3, ans4, ans5, text, name, eng_name):
	General.dialog_create_signal = true
	General.answer_1 = ans1
	General.answer_2 = ans2
	General.answer_3 = ans3
	General.answer_4 = ans4
	General.answer_5 = ans5
	General.text_dialog = text
	General.npc_name = name
	General.npc_eng_name = eng_name
func Sound(what):
	match what:
		"damage":
			match General.EnemyName:
				"cyborg", "IronMan":
					General.SoundPlay("res://Music/MetalHitPunch.mp3")
				_:
					General.SoundPlay("res://Music/PunchPopadanie.mp3", {"Volume_db": - 7})


func _on_Area2D_area_entered(area):
	if not visible or not area:
		return
	
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_hit_time < hit_cooldown:
		return
	last_hit_time = current_time
	
	if ("eph" in timers) and timers["eph"] > 10:
		attacked = true
		General.HitBoxEnemy(self, area)
	else:
		General.HitBoxEnemy(self, area)

func _on_FightAnimations_animation_started(anim_name):
	if anim_name in ["DamageDefault", "JumpEnemy"]:
		combo_enabled = false
		if area_collision:
			area_collision.set_deferred("disabled", true)
		if attack_act:
			attack_act = false
		if dashed:
			dashed = false
		
	if anim_name == "ChopDamage":
		combo_enabled = false
		if attack_act:
			attack_act = false
		if dashed:
			dashed = false
	
	if anim_name in ["DashEnemy", "AggresiveDashEnemy"]:
		if has_node("AnimationPlayer2"):
			$AnimationPlayer2.play("DefaultDamage")
		dashed = true
		attack_act = true
	
	if anim_name in ["BigDashEnemy", "BigDashEnemyBack"]:
		dashed = true
		if animation_player_node:
			animation_player_node.play("Idle")
		if dash_effect:
			dash_effect.play()

func _on_FightAnimations_animation_finished(anim_name):
	random.randomize()
	if anim_name in ["DamageDefault", "JumpEnemy"]:
		if area_collision:
			area_collision.set_deferred("disabled", false)
		while (General.barrage_activate or passive_damage_active) and is_inside_tree():
			yield(get_tree().create_timer(0.1), "timeout")
		dashed = false
		attacked = false
		animation_hit_played = false
		if not General.enemy_block_all and not warning_activate and General.glush_enemy_timer.is_stopped() and General.combo_timer.is_stopped() and not passive_damage_active:
			var number = random.randf()
			if number >= 0.6 and number < 1:
				dash("UpDash")
	
	if anim_name == "ChopDamage":
		dashed = false
		attacked = false
		animation_hit_played = false
		
	if anim_name == "DashEnemy":
		dashed = false
		attack_act = false
	
	if anim_name == "AggresiveDashEnemy":
		dashed = false
		attack_act = false
		
	if anim_name in ["BigDashEnemy", "BigDashEnemyBack", "BigDashEnemyVert"]:
		dashed = false

func dash(type):
	if General.enemy_block_all:
		return
		
	if attacked == false and type == "AttackDash" and dashed == false and block_activate == false and not General.time_erase and not passive_damage_active and General.glush_enemy_timer.is_stopped():
		if ghost_effect:
			ghost_effect.wait_time = 0.025 / max(General.enemy_time_scale, 0.1)
		if animation_enemy:
			var animation = animation_enemy.get_animation("DashEnemy")
			if global_position.x < General.player_pos.x:
				if dist_enemy_r.x < 100:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x + dist_enemy_r.x) - 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x + 65, global_position.y))
			else:
				if dist_enemy_l.x < 100:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x - dist_enemy_l.x) + 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x - 65, global_position.y))
			animation_enemy.play("DashEnemy")
	elif attacked and type == "AttackDash" and dashed == false and block_activate == false and not General.time_erase and not passive_damage_active and General.glush_enemy_timer.is_stopped():
		if ghost_effect:
			ghost_effect.wait_time = 0.025 / max(General.enemy_time_scale, 0.1)
		if animation_enemy:
			yield(animation_enemy, "animation_finished")
			var animation = animation_enemy.get_animation("DashEnemy")
			if global_position.x < General.player_pos.x:
				if dist_enemy_r.x < 100:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x + dist_enemy_r.x) - 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x + 65, global_position.y))
			else:
				if dist_enemy_l.x < 100:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x - dist_enemy_l.x) + 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x - 65, global_position.y))
			animation_enemy.play("DashEnemy")
			
	if attacked == false and type == "BigDash" and dashed == false and block_activate == false and not General.time_erase and not passive_damage_active and General.glush_enemy_timer.is_stopped():
		if ghost_effect:
			ghost_effect.wait_time = 0.025 / max(General.enemy_time_scale, 0.1)
		if animation_enemy:
			var animation = animation_enemy.get_animation("BigDashEnemy")
			if global_position.x < General.player_pos.x:
				if dist_enemy_r.x < 135:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x + dist_enemy_r.x) - 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x + 100, global_position.y))
			else:
				if dist_enemy_l.x < 135:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x - dist_enemy_l.x) + 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x - 100, global_position.y))
			animation_enemy.play("BigDashEnemy")
	elif attacked and type == "BigDash" and dashed == false and block_activate == false and not General.time_erase and not passive_damage_active and General.glush_enemy_timer.is_stopped():
		if ghost_effect:
			ghost_effect.wait_time = 0.025 / max(General.enemy_time_scale, 0.1)
		if animation_enemy:
			yield(animation_enemy, "animation_finished")
			var animation = animation_enemy.get_animation("BigDashEnemy")
			if global_position.x < General.player_pos.x:
				if dist_enemy_r.x < 135:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x + dist_enemy_r.x) - 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x + 65, global_position.y))
			else:
				if dist_enemy_l.x < 135:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x - dist_enemy_l.x) + 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x - 65, global_position.y))
			animation_enemy.play("BigDashEnemy")
			
	if attacked == false and type == "BackDash" and dashed == false and block_activate == false and not General.time_erase and not passive_damage_active and General.glush_enemy_timer.is_stopped():
		if ghost_effect:
			ghost_effect.wait_time = 0.025 / max(General.enemy_time_scale, 0.1)
		if animation_enemy:
			var animation = animation_enemy.get_animation("BigDashEnemyBack")
			if global_position.x < General.player_pos.x:
				if dist_enemy_l.x < 135:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x - dist_enemy_l.x) + 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x - 100, global_position.y))
			else:
				if dist_enemy_r.x < 135:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x + dist_enemy_r.x) - 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x + 100, global_position.y))
			animation_enemy.play("BigDashEnemyBack")
	elif attacked and type == "BackDash" and dashed == false and block_activate == false and not General.time_erase and not passive_damage_active and General.glush_enemy_timer.is_stopped():
		if ghost_effect:
			ghost_effect.wait_time = 0.025 / max(General.enemy_time_scale, 0.1)
		if animation_enemy:
			yield(animation_enemy, "animation_finished")
			var animation = animation_enemy.get_animation("BigDashEnemyBack")
			if global_position.x < General.player_pos.x:
				if dist_enemy_l.x < 135:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x - dist_enemy_l.x) + 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x - 100, global_position.y))
			else:
				if dist_enemy_r.x < 135:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x + dist_enemy_r.x) - 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x + 100, global_position.y))
			animation_enemy.play("BigDashEnemyBack")
			
	if attacked == false and type == "UpDash" and dashed == false and block_activate == false and not General.time_erase and not passive_damage_active and General.glush_enemy_timer.is_stopped():
		if ghost_effect:
			ghost_effect.wait_time = 0.05 / max(General.enemy_time_scale, 0.1)
		if animation_enemy:
			var animation = animation_enemy.get_animation("BigDashEnemyVert")
			if global_position.y < General.player_pos.y:
				if dist_enemy_t.y < 115:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x, (global_position.y - dist_enemy_t.y) + 35))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x, global_position.y - 80))
			else:
				if dist_enemy_b.y < 115:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x, (global_position.y + dist_enemy_b.y) - 35))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x, global_position.y + 80))
			animation_enemy.play("BigDashEnemyVert")
	elif attacked and type == "UpDash" and dashed == false and block_activate == false and not General.time_erase and not passive_damage_active and General.glush_enemy_timer.is_stopped():
		if animation_enemy:
			yield(animation_enemy, "animation_finished")
			if ghost_effect:
				ghost_effect.wait_time = 0.05 / max(General.enemy_time_scale, 0.1)
			var animation = animation_enemy.get_animation("BigDashEnemyVert")
			if global_position.y < General.player_pos.y:
				if dist_enemy_t.y < 115:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x, (global_position.y - dist_enemy_t.y) + 35))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x, global_position.y - 80))
			else:
				if dist_enemy_b.y < 115:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x, (global_position.y + dist_enemy_b.y) - 35))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x, global_position.y + 80))
			animation_enemy.play("BigDashEnemyVert")
			
	if attacked == false and type == "AggresiveDash" and dashed == false and block_activate == false and not General.time_erase and not passive_damage_active and General.glush_enemy_timer.is_stopped():
		if ghost_effect:
			ghost_effect.wait_time = 0.025 / max(General.enemy_time_scale, 0.1)
		if animation_enemy:
			var animation = animation_enemy.get_animation("AggresiveDashEnemy")
			if global_position.x < General.player_pos.x:
				if dist_enemy_r.x < 135:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x + dist_enemy_r.x) - 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x + 100, global_position.y))
			else:
				if dist_enemy_l.x < 135:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x - dist_enemy_l.x) + 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x - 100, global_position.y))
			animation_enemy.play("AggresiveDashEnemy")
	elif attacked and type == "AggresiveDash" and dashed == false and block_activate == false and not General.time_erase and not passive_damage_active and General.glush_enemy_timer.is_stopped():
		if ghost_effect:
			ghost_effect.wait_time = 0.025 / max(General.enemy_time_scale, 0.1)
		if animation_enemy:
			yield(animation_enemy, "animation_finished")
			var animation = animation_enemy.get_animation("AggresiveDashEnemy")
			if global_position.x < General.player_pos.x:
				if dist_enemy_r.x < 135:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x + dist_enemy_r.x) - 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x + 100, global_position.y))
			else:
				if dist_enemy_l.x < 135:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x - dist_enemy_l.x) + 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x - 100, global_position.y))
			animation_enemy.play("AggresiveDashEnemy")
			
	if type == "JumpTreeDash" and dashed == false and block_activate == false and not General.time_erase:
		if animation_enemy:
			var animation = animation_enemy.get_animation("JumpEnemy")
			if dist_enemy_t.y < 70:
				animation.track_set_key_value(0, 0, global_position)
				animation.track_set_key_value(0, 1, Vector2(global_position.x, (global_position.y - dist_enemy_t.y) + 35))
				animation.track_set_key_value(0, 2, Vector2(global_position.x, (global_position.y - dist_enemy_t.y) + 35))
				animation.track_set_key_value(0, 3, global_position)
			else:
				animation.track_set_key_value(0, 0, global_position)
				animation.track_set_key_value(0, 1, Vector2(global_position.x, global_position.y - 35))
				animation.track_set_key_value(0, 2, Vector2(global_position.x, global_position.y - 35))
				animation.track_set_key_value(0, 3, global_position)
			animation_enemy.play("JumpEnemy")
			
	if type == "Garpun" and dashed == false and block_activate == false and not General.time_erase:
		if animation_enemy:
			var animation = animation_enemy.get_animation("DamageDefault")
			animation.track_set_key_value(0, 0, global_position)
			if General.player_pos > global_position:
				animation.track_set_key_value(0, 1, Vector2(General.player_pos.x - 65, General.player_pos.y))
			else:
				animation.track_set_key_value(0, 1, Vector2(General.player_pos.x + 65, General.player_pos.y))
			animation_enemy.play("DamageDefault")

func _on_AttackBox_area_entered(area):
	if not area.is_in_group("ItemBox") or General.time_erase or General.time_stop or attacked:
		return
		
	if "WoU" in General.Addition:
		General.passive_damage(self, "None", 5, 6, 1, false)
		General.SoundPlay("res://Music/HitEffectNumber1.mp3")
		return
	if General.epitafia_enabled:
		epitafia_end()
		return
		
	if "MegaAttack" in dataDop:
		dataDop["MegaAttackReal"] = true
		General.start_combo_enemy_timer_for_enemy(self, 6.0)
		return
	
	if attack_id == 5:
		if General.EnemyName == "luka":
			General.SoundPlay("res://Music/MetalHit.mp3")
		else:
			General.SoundPlay("res://Music/BigPunchEffect.mp3")
	
		var da = preload("res://Scenes/Effect.tscn").instance()
		if get_parent():
			get_parent().add_child(da)
		da.z_index = 99
		da.scale *= 1.5
		da.Play("PunchWave")
		da.global_position = global_position + Vector2((int(direct_text != "Left") - int(direct_text == "Left")) * 105, - 50)
	
	if General.block_type == "None":
		var ratio = 1.0
		if General.EnemyName == "Cars":
			ratio = 6.0
		elif General.EnemyName == "dio":
			ratio = 4.0
		if attack_id in [1, 2, 3]:
			player_damage((1.5 - debuf_infinity / 10) * ratio, 65, false)
		if attack_id == 5:
			player_damage((3 - debuf_infinity / 10) * ratio, 200, true)
	elif General.block_type == "spin":
		if attack_id == 1:
			player_damage((1.5 - debuf_infinity / 10) * 0.2, 65, false)
			default_damage((1.5 - debuf_infinity / 10) * 0.8, 65, true, false)
		if attack_id == 2:
			player_damage((1.5 - debuf_infinity / 10) * 0.2, 65, false)
			default_damage((1.5 - debuf_infinity / 10) * 0.8, 65, true, false)
		if attack_id == 3:
			player_damage((1.5 - debuf_infinity / 10) * 0.2, 65, false)
			default_damage((1.5 - debuf_infinity / 10) * 0.8, 65, true, false)
		if attack_id == 5:
			player_damage((3 - debuf_infinity / 10) * 0.2, 200, true)
			default_damage((3 - debuf_infinity / 10) * 0.8, 200, true, false)

func damaged_default_eneemy(fin_pos):
	var time_stopped = false
	while General.time_stop and is_inside_tree():
		time_stopped = true
		yield(get_tree().create_timer(0.1), "timeout")
	if animation_enemy:
		var animation = animation_enemy.get_animation("DamageDefault")
		if not time_stopped:
			if General.player_direct == "right":
				if dist_enemy_r.x < fin_pos + 35:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x + dist_enemy_r.x) - 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x + fin_pos, global_position.y))
			else:
				if dist_enemy_l.x < fin_pos + 35:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x - dist_enemy_l.x) + 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x - fin_pos, global_position.y))
		else:
			if General.pre_bullet_direct == "right":
				if dist_enemy_r.x < fin_pos + 35:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x + dist_enemy_r.x) - 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x + fin_pos, global_position.y))
			else:
				if dist_enemy_l.x < fin_pos + 35:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2((global_position.x - dist_enemy_l.x) + 35, global_position.y))
				else:
					animation.track_set_key_value(0, 0, global_position)
					animation.track_set_key_value(0, 1, Vector2(global_position.x - fin_pos, global_position.y))
		animation_enemy.play("DamageDefault")

func attack(id_attack):
	if General.enemy_block_all or not General.glush_enemy_timer.is_stopped() or passive_damage_active or attacked:
		return
		
	if id_attack == 1:
		random.randomize()
		player_position_first = General.player_pos
		attack_id = id_attack
		dash("AttackDash")
		if attack_timer.is_connected("timeout", self, "do_this"):
			attack_timer.disconnect("timeout", self, "do_this")
		attack_timer.connect("timeout", self, "do_this")
		if General.enemy_list and id - 1 < General.enemy_list.size():
			if General.enemy_list[id - 1]["RAGE"] <= 1:
				attack_timer.wait_time = 3.0 / max(General.enemy_time_scale, 0.1)
			elif General.enemy_list[id - 1]["RAGE"] <= 2.5 and General.enemy_list[id - 1]["RAGE"] > 1:
				attack_timer.wait_time = 2.5 / max(General.enemy_time_scale, 0.1)
			elif General.enemy_list[id - 1]["RAGE"] > 2.5:
				attack_timer.wait_time = 1.5 / max(General.enemy_time_scale, 0.1)
		else:
			attack_timer.wait_time = 2.0 / max(General.enemy_time_scale, 0.1)
		attack_timer.start()
		yield(attack_timer, "timeout")
	if id_attack == 2:
		attack_id = id_attack
		dash("AttackDash")
	if id_attack == 3:
		player_position_first = General.player_pos
		attack_id = id_attack
		dash("AttackDash")
		if attack_timer.is_connected("timeout", self, "do_this"):
			attack_timer.disconnect("timeout", self, "do_this")
		attack_timer.connect("timeout", self, "do_this")
		if General.enemy_list and id - 1 < General.enemy_list.size():
			if General.enemy_list[id - 1]["RAGE"] <= 1:
				attack_timer.wait_time = 3.0 / max(General.enemy_time_scale, 0.1)
			elif General.enemy_list[id - 1]["RAGE"] <= 2.5 and General.enemy_list[id - 1]["RAGE"] > 1:
				attack_timer.wait_time = 2.5 / max(General.enemy_time_scale, 0.1)
			elif General.enemy_list[id - 1]["RAGE"] > 2.5:
				attack_timer.wait_time = 1.5 / max(General.enemy_time_scale, 0.1)
		else:
			attack_timer.wait_time = 2.0 / max(General.enemy_time_scale, 0.1)
		attack_timer.start()
		yield(attack_timer, "timeout")
	if id_attack == 4:
		attack_activate = true
		player_position_first = General.player_pos
		attack_id = id_attack
		var knife_create = knife.instance()
		if get_parent():
			get_parent().add_child(knife_create)
		knife_create.z_index = 1
		if direct_text == "Left":
			knife_create.velocity = Vector2( - 1, 0)
		else:
			knife_create.velocity = Vector2(1, 0)
		knife_create.global_position = $Position2D.global_position
		if attack_timer.is_connected("timeout", self, "knife_end"):
			attack_timer.disconnect("timeout", self, "knife_end")
		attack_timer.connect("timeout", self, "knife_end")
		if General.enemy_list and id - 1 < General.enemy_list.size():
			if General.enemy_list[id - 1]["RAGE"] <= 1:
				attack_timer.wait_time = 4.0 / max(General.enemy_time_scale, 0.1)
			elif General.enemy_list[id - 1]["RAGE"] <= 2.5 and General.enemy_list[id - 1]["RAGE"] > 1:
				attack_timer.wait_time = 3.0 / max(General.enemy_time_scale, 0.1)
			elif General.enemy_list[id - 1]["RAGE"] > 2.5:
				attack_timer.wait_time = 2.5 / max(General.enemy_time_scale, 0.1)
		else:
			attack_timer.wait_time = 3.0 / max(General.enemy_time_scale, 0.1)
		attack_timer.start()
		yield(get_tree().create_timer(1 / max(General.enemy_time_scale, 0.1)), "timeout")
		attack_activate = false
	if id_attack == 5:
		warning_activate = true
		var warning_inst = warning.instance()
		var player_path = "/root/" + current_scene_name + "/YSorting/GGPlayer"
		if has_node(player_path):
			var player = get_node(player_path)
			player.add_child(warning_inst)
			warning_inst.position = General.player_warning_position
		yield(get_tree().create_timer(0.25 / max(General.enemy_time_scale, 0.1)), "timeout")
		warning_activate = false
		player_position_first = General.player_pos
		attack_id = id_attack
		dash("AggresiveDash")
		if attack_timer.is_connected("timeout", self, "ads"):
			attack_timer.disconnect("timeout", self, "ads")
		attack_timer.connect("timeout", self, "ads")
		if General.enemy_list and id - 1 < General.enemy_list.size():
			if General.enemy_list[id - 1]["RAGE"] <= 1:
				attack_timer.wait_time = 3.0 / max(General.enemy_time_scale, 0.1)
			elif General.enemy_list[id - 1]["RAGE"] <= 2.5 and General.enemy_list[id - 1]["RAGE"] > 1:
				attack_timer.wait_time = 2.5 / max(General.enemy_time_scale, 0.1)
			elif General.enemy_list[id - 1]["RAGE"] > 2.5:
				attack_timer.wait_time = 1.5 / max(General.enemy_time_scale, 0.1)
		else:
			attack_timer.wait_time = 2.0 / max(General.enemy_time_scale, 0.1)
		attack_timer.one_shot = true
		General.player_block_attack = false
		yield(attack_timer, "timeout")
func dash_big_random():
	dash("BigDash")
	_connect_local_timer(dash_timer, "dash_big_random", 6.0 / max(General.enemy_time_scale, 0.1))

func pre_attack():
	if General.enemy_block_all or General.time_erase or General.time_stop or not General.glush_enemy_timer.is_stopped() or not General.combo_timer.is_stopped() or passive_damage_active:
		return
		
	random.randomize()
	var random_number = random.randf()
	if global_position.distance_to(General.player_pos) < 80 and General.player_pos.y - global_position.y > - 30 and General.player_pos.y - global_position.y < 30 and not warning_activate:
		if General.enemy_list and id - 1 < General.enemy_list.size():
			if General.enemy_list[id - 1]["RAGE"] <= 1:
				if random_number < 0.2 and not block_activate and not dashed and General.player_scale != scale and not warning_activate:
					block_activate = true
					yield(get_tree().create_timer(random.randf_range(1, 3) / max(General.enemy_time_scale, 0.1)), "timeout")
					while attacked and is_inside_tree():
						yield(get_tree().create_timer(0.1), "timeout")
					block_activate = false
			elif General.enemy_list[id - 1]["RAGE"] < 3 and General.enemy_list[id - 1]["RAGE"] > 1:
				if random_number < 0.2 and not block_activate and not dashed and General.player_scale != scale:
					block_activate = true
					yield(get_tree().create_timer(random.randf_range(1, 3) / max(General.enemy_time_scale, 0.1)), "timeout")
					while attacked and is_inside_tree():
						yield(get_tree().create_timer(0.1), "timeout")
					block_activate = false
				elif random_number > 0.6 and random_number < 0.7 and not block_activate and not dashed and General.player_scale != scale and not warning_activate:
					dash("BackDash")
					whawha("dash")
				elif random_number > 0.2 and random_number < 0.3 and not block_activate and not dashed and General.player_scale != scale and not warning_activate:
					dash("UpDash")
					whawha("dash")
			else:
				if random_number < 0.3 and not block_activate and not dashed and General.player_scale != scale:
					block_activate = true
					yield(get_tree().create_timer(random.randf_range(1, 3) / max(General.enemy_time_scale, 0.1)), "timeout")
					while attacked and is_inside_tree():
						yield(get_tree().create_timer(0.1), "timeout")
					block_activate = false
				elif random_number > 0.8 and random_number < 1 and not block_activate and not dashed and General.player_scale != scale and not warning_activate:
					dash("BackDash")
					whawha("dash")
				elif random_number > 0.4 and random_number < 0.6 and not block_activate and not dashed and General.player_scale != scale and not warning_activate:
					dash("UpDash")
					whawha("dash")

func pre_bullet():
	if General.enemy_block_all or General.time_erase or General.time_stop or not General.glush_enemy_timer.is_stopped() or not General.combo_timer.is_stopped() or passive_damage_active:
		return
		
	random.randomize()
	var random_number = random.randf()
	if General.player_pos.y - global_position.y > - 20 and General.player_pos.y - global_position.y < 20 and not warning_activate:
		if General.enemy_list and id - 1 < General.enemy_list.size():
			if General.enemy_list[id - 1]["RAGE"] <= 1:
				if random_number < 0.2 and not block_activate and not dashed and General.player_scale != scale:
					block_activate = true
					yield(get_tree().create_timer(random.randf_range(1, 3) / max(General.enemy_time_scale, 0.1)), "timeout")
					while attacked and is_inside_tree():
						yield(get_tree().create_timer(0.1), "timeout")
					block_activate = false
				elif random_number >= 0.2 and random_number < 0.3 and not block_activate and not dashed and General.player_scale != scale:
					dash("UpDash")
					whawha("dash")
			elif General.enemy_list[id - 1]["RAGE"] < 3 and General.enemy_list[id - 1]["RAGE"] > 1:
				if random_number < 0.3 and not block_activate and not dashed and General.player_scale != scale:
					block_activate = true
					yield(get_tree().create_timer(random.randf_range(1, 3) / max(General.enemy_time_scale, 0.1)), "timeout")
					while attacked and is_inside_tree():
						yield(get_tree().create_timer(0.1), "timeout")
					block_activate = false
				elif random_number >= 0.3 and random_number < 0.6 and not block_activate and not dashed and General.player_scale != scale:
					dash("UpDash")
					whawha("dash")
			else:
				if random_number < 0.4 and not block_activate and not dashed and General.player_scale != scale:
					block_activate = true
					yield(get_tree().create_timer(random.randf_range(1, 3) / max(General.enemy_time_scale, 0.1)), "timeout")
					while attacked and is_inside_tree():
						yield(get_tree().create_timer(0.1), "timeout")
					block_activate = false
				elif random_number >= 0.4 and random_number < 0.8 and not block_activate and not dashed and General.player_scale != scale:
					dash("UpDash")
					whawha("dash")


func _on_Ghost_Effect_timeout():
	if not General.time_erase:
		if dashed and not attacked and animation_enemy and animation_enemy.current_animation in ["BigDashEnemyBack", "BigDashEnemyVert"]:
			var effect = preload("res://Scenes/DashGhostEffectEnemy.tscn").instance()
			if get_parent():
				get_parent().add_child(effect)
			effect.position = global_position
			if direct_text == "left":
				effect.scale.x = - 1
			else:
				effect.scale.x = 1
	else:
		var effect = preload("res://Scenes/DashGhostEffectEnemy.tscn").instance()
		if get_parent():
			get_parent().add_child(effect)
		effect.position = global_position
		if direct_text == "left":
			effect.scale.x = - 1
		else:
			effect.scale.x = 1

func default_damage(amount_hp, amount_dist: int, direct_player_set: bool, block_destroy: bool) -> void :
	if block_destroy and block_activate:
		block_activate = false
		
	if block_activate:
		if animation_player_node:
			animation_player_node.play("HitBlock")
	else:
		if animation_player_node:
			animation_player_node.play("Hit")
			
	attacked = true
	var time_stopped = false
	while General.time_stop and is_inside_tree():
		time_stopped = true
		yield(get_tree().create_timer(0.1), "timeout")
		
	random.randomize()
	var combo_wait = 1.0
	if General.enemy_list and id - 1 < General.enemy_list.size():
		if General.enemy_list[id - 1]["RAGE"] <= 1:
			combo_wait = 1.0
		elif General.enemy_list[id - 1]["RAGE"] > 1 and General.enemy_list[id - 1]["RAGE"] <= 3:
			combo_wait = 0.8
		elif General.enemy_list[id - 1]["RAGE"] > 3:
			combo_wait = 0.5
	General.start_combo_timer_for_enemy(self, combo_wait)
	
	if time_stopped and direct_player_set:
		General.pre_bullet_direct = General.player_direct
		
	if not time_stopped:
		damaged_default_eneemy(amount_dist / (int(block_activate) + 1))
	else:
		attacked = false
		
	if General.time_erase:
		General.time_erase = false
		General.enemy_time_scale = 1
		
	if not block_activate:
		health -= amount_hp / (int(time_stopped) + 1)
		General.damage_text = "-" + str(amount_hp / (int(time_stopped) + 1))
		General.damage_for_enemy_counts += amount_hp / (int(time_stopped) + 1)
		General.popadania += 1
		damage_text_spawn()
	else:
		health -= amount_hp / (int(time_stopped) + 2)
		General.damage_text = "-" + str(amount_hp / (int(time_stopped) + 2))
		General.damage_for_enemy_counts += amount_hp / (int(time_stopped) + 2)
		General.popadania += 1
		damage_text_spawn()
		
	while General.time_stop and is_inside_tree():
		yield(get_tree().create_timer(0.1), "timeout")

func chop_damage(amount_hp: int):
	var time_stopped = false
	while General.time_stop and is_inside_tree():
		time_stopped = true
		yield(get_tree().create_timer(0.1), "timeout")
		
	General.start_combo_timer_for_enemy(self, 5)
	
	if General.time_erase:
		General.time_erase = false
		General.enemy_time_scale = 1
		
	if block_activate:
		block_activate = false
		
	passive_damage(1, 4, (4 / (int(time_stopped) + 1)) * General.stand_power, true)
	
	attacked = true
	if animation_enemy:
		var animation = animation_enemy.get_animation("ChopDamage")
		if General.player_pos > global_position:
			animation.track_set_key_value(0, 0, General.player_pos - Vector2(55, 16))
		else:
			animation.track_set_key_value(0, 0, General.player_pos + Vector2(55, - 16))
		animation_enemy.play("ChopDamage")
	povorot_reset()
	
	if not enemy_block_timer.is_stopped():
		enemy_block_timer_end()
	_connect_local_timer(enemy_block_timer, "enemy_block_timer_end", 5)
	
func passive_damage(wait_time: float, count_attacks: int, amount_hp, chop: bool):
	General.start_combo_timer_for_enemy(self, count_attacks * wait_time)
	
	if chop:
		if animation_player_node:
			animation_player_node.play("ChopHit")
	else:
		if animation_player_node:
			animation_player_node.play("Hit")
			
	var time_stopped = false
	while General.time_stop and is_inside_tree():
		time_stopped = true
		yield(get_tree().create_timer(0.1), "timeout")
		
	if block_activate:
		block_activate = false
		
	if General.time_erase:
		General.time_erase = false
		General.enemy_time_scale = 1
		
	passive_damage_active = true
	for attack in range(count_attacks):
		passive_damage_active = true
		if punch_effect:
			punch_effect.play()
		if chop:
			if animation_player_node:
				animation_player_node.play("ChopHit")
		else:
			if animation_player_node:
				animation_player_node.play("Hit")
		attacked = true
		health -= amount_hp / (int(block_activate) + int(time_stopped) + 1)
		General.damage_text = "-" + str(amount_hp / (int(block_activate) + int(time_stopped) + 1))
		General.damage_for_enemy_counts += amount_hp / (int(time_stopped) + 1)
		damage_text_spawn()
		yield(get_tree().create_timer(wait_time), "timeout")
	attacked = false
	passive_damage_active = false

func chop_end():
	if animation_player_node:
		animation_player_node.play("ChopHitWithoutArm")

func _on_NizokHitBox_area_entered(area):
	if area.is_in_group("BlackHole"):
		General.enemy_current_status.append(2)
		default_damage(0, 0, false, true)
		var black_hole = enemy_over_effect.instance()
		add_child(black_hole)
		black_hole.z_index = 2
		black_hole.global_position = $Center.global_position
		passive_damage(1, 5, 1.5 * General.stand_power, false)
		yield(get_tree().create_timer(5), "timeout")
		General.remove_status(2)

func player_damage(amount_hp, amount_dist: int, block_destroy: bool, Dop: Dictionary = {}):
	deal_damage_to_player(amount_hp, amount_dist, block_destroy, Dop)
func epitafia_end():
	General.enemy_block_all = true
	if not enemy_block_timer.is_stopped():
		enemy_block_timer.stop()
	enemy_block_timer.wait_time = 2
	enemy_block_timer.start()
	
	var time_erase_inst = time_erase.instance()
	if get_parent() and get_parent().get_parent():
		get_parent().get_parent().add_child(time_erase_inst)
		
	General.start_combo_timer_for_enemy(self, 3)
	
	var player_path = "/root/" + current_scene_name + "/YSorting/GGPlayer"
	if current_scene_name == "MorioMap":
		player_path = "/root/" + current_scene_name + "/SortingY/GGPlayer"
		
	if has_node(player_path):
		var player = get_node(player_path)
		if is_connected("epitafia_damage", player, "epitafia_damage"):
			disconnect("epitafia_damage", player, "epitafia_damage")
		connect("epitafia_damage", player, "epitafia_damage")
		emit_signal("epitafia_damage")
		if is_connected("epitafia_damage", player, "epitafia_damage"):
			disconnect("epitafia_damage", player, "epitafia_damage")
			
	General.epitafia_enabled = false
	combo_enabled = false
	if attack_act:
		attack_act = false
	if dashed:
		dashed = false
	if animation_player_node:
		animation_player_node.play("Idle")

func jump_damage(amount_hp, amount_dist: int, direct_player_set: bool, block_destroy: bool) -> void :
	if block_destroy and block_activate:
		block_activate = false
		
	if block_activate:
		if animation_player_node:
			animation_player_node.play("HitBlock")
	else:
		if animation_player_node:
			animation_player_node.play("Hit")
			
	var time_stopped = false
	while General.time_stop and is_inside_tree():
		time_stopped = true
		yield(get_tree().create_timer(0.1), "timeout")
		
	General.start_combo_timer_for_enemy(self, 1)
	
	attacked = true
	if time_stopped and direct_player_set:
		General.pre_bullet_direct = General.player_direct
		
	if not time_stopped:
		dash("JumpTreeDash")
	else:
		attacked = false
		
	if General.time_erase:
		General.time_erase = false
		General.enemy_time_scale = 1
		
	if not block_activate:
		health -= amount_hp / (int(time_stopped) + 1)
		General.damage_text = "-" + str(amount_hp / (int(time_stopped) + 1))
		General.damage_for_enemy_counts += amount_hp / (int(time_stopped) + 1)
		General.popadania += 1
		damage_text_spawn()
	else:
		health -= amount_hp / (int(time_stopped) + 2)
		General.damage_text = "-" + str(amount_hp / (int(time_stopped) + 2))
		General.damage_for_enemy_counts += amount_hp / (int(time_stopped) + 2)
		General.popadania += 1
		damage_text_spawn()

func whawha(wha):
	if wha == "dash":
		if get_tree().current_scene.name in ["DioDefaultEnemyArena", "JotaroDefaultEnemyArena"]:
			General.SoundPlay("res://Music/TimeSkipEffect.mp3")
			if has_node("../GeneralEffectAnimaion"):
				$"../GeneralEffectAnimaion".play("TheWorldDash")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "StandAttack":
		if animation_enemy and animation_enemy.current_animation == "DashEnemy":
			if animation_player_node:
				animation_player_node.play("StandAttackNext")


func lolololololol():
	pass

func do_this():
	pass

func knife_end():
	pass

func ads():
	pass
