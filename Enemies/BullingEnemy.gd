# BullingEnemy.gd — уникальные фазы и атаки Bulling.
#
# Наследует Enemy; общие навигация, урон и таймеры — в базовом классе.
# Здесь только атаки/анимации и регенерация этого врага.

extends "res://NewClasses/Enemy.gd"

var timer_regen = Timer.new()


var attack_array_chance = [1, 1, 1, 1, 1]
signal epitafia_damage


onready var bully = preload("res://Textures/BullingEnemySheet.png")

func _ready():
	._ready()
	
	enemy_block_timer.connect("timeout", self, "enemy_block_timer_end")
	enemy_block_timer.wait_time = 1
	enemy_block_timer.one_shot = true
	_ensure_child_timer(enemy_block_timer)
	
	regen_hp_timer()
	$Sprite.texture = bully
	health = 30
	max_hp = 30

	attack_id_start_for_small_dist = 0
	attack(0)
	kooldown_timer.connect("timeout", self, "lolololololol")
	kooldown_timer.wait_time = 1 / General.enemy_time_scale
	kooldown_timer.one_shot = true
	_ensure_child_timer(kooldown_timer)
	kooldown_timer.start()
	if General.enemy_list != null and id > 0 and id - 1 < General.enemy_list.size():
		health = General.enemy_list[id - 1]["HP"]
		max_hp = health

func regen_hp_timer():
	timer_regen.connect("timeout", self, "regen_hp")
	timer_regen.wait_time = 1
	timer_regen.one_shot = false
	_ensure_child_timer(timer_regen)
	timer_regen.start()
	
func regen_hp():
	var amount_health = 0.001
	if health + amount_health * max_hp <= max_hp:
		health += amount_health * max_hp
		
func _physics_process(delta):
	._physics_process(delta)
	if General.debuff_enemy == "HgZahvat":
		$Sprite / HierophantGreen.visible = true
	else:
		$Sprite / HierophantGreen.visible = false
	if General.stand_number == 7 and health < max_hp * 0.5 and not ("EA1" in General.Addition):
		General.Addition["EA1"] = true
		General.GGPlayer.Attack("EA1_bd")

	var random_crit_proc = random_crit.randf()
	if General.global_debuffs["hand_fear"] == true:
		if General.hands_opens["blood"] == false:
			if random_crit_proc <= 0.3 and General.add_hand_crit > 0:
				General.passive_damage(self, "lt", 1, 3, (3 + General.add_hand_damage * 2) + (3 + General.add_hand_damage * 2) / 100 * General.add_hand_crit, false)
			else:
				General.passive_damage(self, "lt", 1, 3, 3 + General.add_hand_damage * 2, false)
		elif General.hands_opens["blood"] == true:
			if random_crit_proc <= 0.3 and General.add_hand_crit > 0:
				General.passive_damage(self, "lt", 1, 4, (3 + General.add_hand_damage * 2) + (3 + General.add_hand_damage * 2) / 100 * General.add_hand_crit, false)
			else:
				General.passive_damage(self, "lt", 1, 4, 3 + General.add_hand_damage * 2, false)
		General.global_debuffs["hand_fear"] = false
	$Sprite / TextureProgress.value = health
	$Sprite / TextureProgress.max_value = max_hp
	
	if debuf_infinity > 0:
		$Debufs.play("InfinitySpin")
	
	
	if not enemy_block_timer.is_stopped():
		General.enemy_block_all = true
	else:
		General.enemy_block_all = false
	
	$EnemyStatus.rect_position.x = 0 - ((General.enemy_current_status.size() - 1) * 8)
	
	if global_position.distance_to(General.player_pos_start_erase) > 250 and General.time_erase == false:
		speed = (160 - debuf_infinity) * slow
	if global_position.distance_to(General.player_pos_start_erase) < 100:
		speed = (120 - debuf_infinity / 1.5) * slow
	
	$AnimationPlayer.playback_speed = General.enemy_time_scale
	animation_enemy.playback_speed = General.enemy_time_scale
	
	General.enemy_health = health
	General.enemy_direct = direct_text
	
	if General.combo_enemy_timer.is_stopped() == false:
		General.player_block_all = true
	
	if player_start_attack:
		yield(get_tree().create_timer(1 / General.enemy_time_scale), "timeout")
		player_start_attack = false
	
	General.enemy_position = global_position
	
	if General.enemy_block_all == false and General.time_erase == false:
		if global_position.distance_to(General.player_pos_start_erase) < 70 and attack_timer.is_stopped() and kooldown_timer.is_stopped() and global_position.y - General.player_pos_start_erase.y < 30 and global_position.y - General.player_pos_start_erase.y > - 30 and activate_angry and General.is_invent_show == false and not block_activate and not player_start_attack and not dashed and General.glush_enemy_timer.is_stopped() and General.combo_timer.is_stopped() and attacked == false:
			random.randomize()
			if combo_enabled == false and kooldown_timer.is_stopped() and not block_activate and not warning_activate and General.glush_enemy_timer.is_stopped() and General.combo_timer.is_stopped():
					var attack_count = random.randi_range(1, 3)
					
					for attack in range(attack_count):
						General.player_block_attack = true
						combo_enabled = true
						$AnimationPlayer.play("Idle")
	
						var attack_id = attack_array_chance[random.randi_range(0, attack_array_chance.size() - 1)]
						attack(attack_id)
						while animation_player.current_animation == "PlayerDamage":
							yield(get_tree().create_timer(0.1), "timeout")
						while animation_enemy.current_animation != "":
							yield(get_tree().create_timer(0.1), "timeout")
					
					var end_attack_chance = random.randf()
					
					if General.blocked:
						if end_attack_chance <= 0.7:
							General.player_block_attack = false
					if General.blocked == false:
						if end_attack_chance <= 0.4:
							General.player_block_attack = false
					
					yield(get_tree().create_timer(0.2), "timeout")
					
					if General.blocked:
						if end_attack_chance > 0.7:
							attack(5)
							end_attack_chance = 0
					if General.blocked == false:
						if end_attack_chance > 0.4:
							attack(5)
							end_attack_chance = 0
				
					kooldown_timer.connect("timeout", self, "lolololololol")
					kooldown_timer.wait_time = 2.0 / General.enemy_time_scale
					kooldown_timer.one_shot = true
					_ensure_child_timer(kooldown_timer)
					kooldown_timer.start()
					combo_enabled = false
	
	time_passed += delta
	if not activate_angry and timer.is_stopped():
		start_position = global_position
		$AnimationPlayer.play("Idle")
	
	if General.time_erase:
		$Ghost_Effect.wait_time = 1
		if $Ghost_Effect.is_stopped():
			$Ghost_Effect.start()
	$AnimationPlayer.playback_speed = 1.0 / General.mih_speed
	if General.enemy_block_all == false:
		direction = ((General.player_pos_start_erase) - global_position).normalized()
		distance = global_position.distance_to(General.player_pos)
		if distance > dist_end and not attacked and activate_angry and General.is_invent_show == false and not dashed and not block_activate and not attack_activate and not player_start_attack and not warning_activate and General.combo_timer.is_stopped() and General.glush_enemy_timer.is_stopped():
			move_and_slide((direction * (speed - debuf_infinity) * General.enemy_time_scale) * slow / General.mih_speed)
			state = "Moving"
			$AnimationPlayer.play("Walk")
		elif distance <= dist_end and not attacked and activate_angry and not dashed and not block_activate and General.time_stop == false:
			$AnimationPlayer.play("Idle")
	
			state = "Standing"
	else:
		if attacked == false:
			state = "Standing"
			$AnimationPlayer.play("Idle")
	
	if attacked:
		dashed = false
		state = "Attacked"
	elif dashed and not block_activate:
		state = "Dashed"
		if animation_enemy.current_animation == "DashEnemy":
			$AnimationPlayer.play("Attack")
		elif animation_enemy.current_animation == "BigDashEnemy":
			$AnimationPlayer.play("Idle")
		elif animation_enemy.current_animation == "BigDashEnemyBack":
			$AnimationPlayer.play("Idle")
		elif animation_enemy.current_animation == "AggresiveDashEnemy":
			$AnimationPlayer.play("AggresiveAttack")
	elif block_activate and attacked == false:
		$AnimationPlayer.play("Block")
	
	
	if position.x > General.player_pos_start_erase.x and direct_text != "Left" and activate_angry and not dashed and not attack_act and General.enemy_block_all == false and General.glush_enemy_timer.is_stopped():
		scale.x *= - 1
		direct_text = "Left"
	elif position.x < General.player_pos_start_erase.x and direct_text != "Right" and activate_angry and not dashed and not attack_act and General.enemy_block_all == false and General.glush_enemy_timer.is_stopped():
		scale.x *= - 1
		direct_text = "Right"
	
	dist_l = General.player_pos - General.left_block_position
	dist_r = General.right_block_position - General.player_pos
	dist_enemy_l = global_position - General.left_block_position
	dist_enemy_r = General.right_block_position - global_position
	dist_enemy_t = global_position - General.top_block_position
	dist_enemy_b = General.bottom_block_positon - global_position
	
	
	
	if health <= 0 and activate_angry and General.heart_points > 0:
		
		General.enemy_block_all = false
		enemy_block_timer.stop()
		activate_angry = false
		General.player_block_all = true
		General.money_change(50)
		General.exp_change(10)
		General.current_support["Fights"] -= 1
		General.kills += 1
		General.save_save()
		Transition.change_scene("res://GeneralGameScenes/WinScreen.tscn", "Black")
	if General.heart_points <= 0 and activate_angry and health > 0:
		
		General.enemy_block_all = false
		enemy_block_timer.stop()
		activate_angry = false
		General.player_block_all = true
		General.deaths += 1
		General.current_support["Fights"] -= 1
		General.save_save()
		Transition.change_scene("res://GeneralGameScenes/LoseScreen.tscn", "Black")
	if health <= 0 and activate_angry and General.heart_points <= 0:
		
		General.enemy_block_all = false
		enemy_block_timer.stop()
		activate_angry = false
		General.player_block_all = true
		General.money_change(50)
		General.exp_change(10)
		General.current_support["Fights"] -= 1
		General.kills += 1
		General.save_save()
		Transition.change_scene("res://GeneralGameScenes/WinScreen.tscn", "Black")
	position_first = global_position
	
func _on_Area2D_area_entered(area):
	if visible and area != null:
		General.HitBoxEnemy(self, area)
		
func _on_FightAnimations_animation_started(anim_name):
	if anim_name == "DamageDefault" or anim_name == "JumpEnemy":
		combo_enabled = false
		$Area2D / CollisionShape2D.set_deferred("disabled", true)
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
		
	if anim_name == "DashEnemy" or anim_name == "AggresiveDashEnemy":
		if $AnimationPlayer2.current_animation == "":
			$AnimationPlayer2.play("DefaultDamage")
		dashed = true
		attack_act = true
	
	if anim_name == "BigDashEnemy" or anim_name == "BigDashEnemyBack":
		dashed = true
		$AnimationPlayer.play("Idle")
		$Dash.play()
func _on_AttackBox_area_entered(area):
	if area.is_in_group("ItemBox") and General.time_erase == false and General.time_stop == false and attacked == false:
		if General.epitafia_enabled == false:
			if General.block_type == "None":
				if attack_id == 1:
					player_damage(3 - debuf_infinity / 5, 65, false)
				if attack_id == 2:
					player_damage(3 - debuf_infinity / 5, 65, false)
				if attack_id == 3:
					player_damage(3 - debuf_infinity / 5, 65, false)
				if attack_id == 5:
					player_damage(6 - debuf_infinity / 5, 200, true)
			elif General.block_type == "spin":
				if attack_id == 1:
					player_damage((3 - debuf_infinity / 5) * 0.2, 65, false)
					General.default_damage(self, "lt", (3 - debuf_infinity / 5) * 0.8, 65, true, false)
				if attack_id == 2:
					player_damage((3 - debuf_infinity / 5) * 0.2, 65, false)
					General.default_damage(self, "lt", (3 - debuf_infinity / 5) * 0.8, 65, true, false)
				if attack_id == 3:
					player_damage((3 - debuf_infinity / 5) * 0.2, 65, false)
					General.default_damage(self, "lt", (3 - debuf_infinity / 5) * 0.8, 65, true, false)
				if attack_id == 5:
					player_damage((6 - debuf_infinity / 5) * 0.2, 200, true)
					General.default_damage(self, "lt", (6 - debuf_infinity / 5) * 0.8, 200, true, false)
		else:
			epitafia_end()
func attack(id_attack):
	if General.glush_enemy_timer.is_stopped() and passive_damage_active == false and attacked == false:
		if id_attack == 1:
			random.randomize()
			player_position_first = General.player_pos
			attack_id = id_attack
			dash("AttackDash")
			attack_timer.connect("timeout", self, "do_this")
			if General.enemy_list[id - 1]["RAGE"] <= 1:
				attack_timer.wait_time = 3.0 / General.enemy_time_scale
			elif General.enemy_list[id - 1]["RAGE"] <= 2.5 and General.enemy_list[id - 1]["RAGE"] > 1:
				attack_timer.wait_time = 2.5 / General.enemy_time_scale
			elif General.enemy_list[id - 1]["RAGE"] > 2.5:
				attack_timer.wait_time = 1.5 / General.enemy_time_scale
			attack_timer.one_shot = true
			yield(attack_timer, "timeout")
		if id_attack == 2:
			attack_id = id_attack
			dash("AttackDash")
		if id_attack == 3:
			player_position_first = General.player_pos
			attack_id = id_attack
			dash("AttackDash")
			attack_timer.connect("timeout", self, "do_this")
			if General.enemy_list[id - 1]["RAGE"] <= 1:
				attack_timer.wait_time = 3.0 / General.enemy_time_scale
			elif General.enemy_list[id - 1]["RAGE"] <= 2.5 and General.enemy_list[id - 1]["RAGE"] > 1:
				attack_timer.wait_time = 2.5 / General.enemy_time_scale
			elif General.enemy_list[id - 1]["RAGE"] > 2.5:
				attack_timer.wait_time = 1.5 / General.enemy_time_scale
			attack_timer.one_shot = true
			yield(attack_timer, "timeout")
		if id_attack == 5:
			warning_activate = true
			var warning_inst = warning.instance()
			var player = get_node("/root/" + get_tree().current_scene.name + "/YSorting/GGPlayer")
			player.add_child(warning_inst)
			warning_inst.position = General.player_warning_position
			yield(get_tree().create_timer(0.25 / General.enemy_time_scale), "timeout")
			warning_activate = false
			player_position_first = General.player_pos
			attack_id = id_attack
			dash("AggresiveDash")
			attack_timer.connect("timeout", self, "ads")
			if General.enemy_list[id - 1]["RAGE"] <= 1:
				attack_timer.wait_time = 3.0 / General.enemy_time_scale
			elif General.enemy_list[id - 1]["RAGE"] <= 2.5 and General.enemy_list[id - 1]["RAGE"] > 1:
				attack_timer.wait_time = 2.5 / General.enemy_time_scale
			elif General.enemy_list[id - 1]["RAGE"] > 2.5:
				attack_timer.wait_time = 1.5 / General.enemy_time_scale
			attack_timer.one_shot = true
			General.player_block_attack = false
			yield(attack_timer, "timeout")
func _on_NizokHitBox_area_entered(area):
	if area.is_in_group("BlackHole"):
		General.enemy_current_status.append(2)
		General.default_damage(self, "lt", 0, 0, false, true)
		var black_hole = enemy_over_effect.instance()
		add_child(black_hole)
		black_hole.z_index = 2
		black_hole.global_position = $Center.global_position
		General.passive_damage(self, "lt", 1, 5, 1.5 * General.stand_power, false)
		yield(get_tree().create_timer(5), "timeout")
		General.remove_status(2)
func epitafia_end():
	
	General.enemy_block_all = true
	if not enemy_block_timer.is_stopped():
		enemy_block_timer.stop()
	enemy_block_timer.wait_time = 2
	enemy_block_timer.start()
	
	var time_erase_inst = time_erase.instance()
	get_parent().get_parent().add_child(time_erase_inst)
	General.combo_timer.connect("timeout", self, "do_this")
	General.combo_timer.wait_time = 3
	General.combo_timer.one_shot = true
	General.timer_service.ensure_autoload_timer(General, General.combo_timer)
	General.combo_timer.start()
	var player
	if get_tree().current_scene.name != "MorioMap":
		player = get_node("/root/" + get_tree().current_scene.name + "/YSorting/GGPlayer")
	elif get_tree().current_scene.name == "MorioMap":
		player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
	connect("epitafia_damage", player, "epitafia_damage")
	emit_signal("epitafia_damage")
	disconnect("epitafia_damage", player, "epitafia_damage")
	General.epitafia_enabled = false
	combo_enabled = false
	if attack_act:
		attack_act = false
	if dashed:
		dashed = false
	$AnimationPlayer.play("Idle")
