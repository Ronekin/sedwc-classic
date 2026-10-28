# EnemyDamageService.gd — исходящий урон по врагам.
#
# Контракт: default/jump/chop/passive_damage получают General и Enemy,
# учитывают stand_power, Stats["DP"], блок, time_stop и тренировочный урон.
# Новые типы урона добавляйте сюда, чтобы не дублировать формулы в сценах.

extends Reference


func jump_damage(general, Enemy, damage_yes, amount_hp, amount_dist: int, direct_player_set: bool, block_destroy: bool)-> void :
	amount_hp = amount_hp * general.stand_power
	amount_hp *= general.Stats["DP"]
	
	var EnemyLoveTrain: bool
	var TournamentDataDa: Dictionary
	if general.is_tournir:
		TournamentDataDa = general.GetTournamentEnemy(general.tournament_lvl)
		if general.EnemyName == "Valentine" and TournamentDataDa["version"] == "True":
			EnemyLoveTrain = true
	
	if damage_yes == "lt" and EnemyLoveTrain:
		pass
	else:
		if block_destroy:
			if Enemy.block_activate:
				Enemy.block_activate = false
		if Enemy.block_activate == false:
			Enemy.get_node("AnimationPlayer").play("Hit")
		else:
			Enemy.get_node("AnimationPlayer").play("HitBlock")
		var time_stopped = false
		while general.time_stop:
			time_stopped = true
			yield(general.get_tree().create_timer(0.1), "timeout")
		general.start_combo_timer_for_enemy(Enemy, 1)
		Enemy.attacked = true
		if time_stopped and direct_player_set:
			general.pre_bullet_direct = general.player_direct
		if time_stopped == false:
			# Тренировочный манекен не прыгает: у JumpEnemy в TrainingArena
			# есть дорожка позиции, которая уводит его от игрока.
			if Enemy.training_dummy == false:
				Enemy.dash("JumpTreeDash")
			else:
				Enemy.attacked = false
		else:
			Enemy.attacked = false
		if general.time_erase:
			general.time_erase = false
			general.enemy_time_scale = 1
		if Enemy.block_activate == false:
			Enemy.health -= amount_hp / (int(time_stopped) + 1)
			general.damage_text = "-" + str(amount_hp / (int(time_stopped) + 1))
			general.damage_for_enemy_counts += amount_hp / (int(time_stopped) + 1)
			general._track_training_damage(Enemy, amount_hp / (int(time_stopped) + 1))
			general.popadania += 1
			Enemy.damage_text_spawn()
		else:
			Enemy.health -= amount_hp / (int(time_stopped) + 2)
			general.damage_text = "-" + str(amount_hp / (int(time_stopped) + 2))
			general.damage_for_enemy_counts += amount_hp / (int(time_stopped) + 2)
			general._track_training_damage(Enemy, amount_hp / (int(time_stopped) + 2))
			general.popadania += 1
			Enemy.damage_text_spawn()

func StunEnemy(general, Enemy, StunTime: float):


		
		if general.combo_timer.is_stopped() or general.combo_timer.time_left < StunTime:
			general.start_combo_timer_for_enemy(Enemy, StunTime)

func _track_training_damage(general, Enemy, amount):
	if Enemy != null and is_instance_valid(Enemy) and Enemy.training_dummy:
		general.all_damage_tren += amount

func default_damage(general, Enemy, damage_yes, amount_hp, amount_dist: int, direct_player_set: bool, block_destroy: bool, popadanie_check: bool = true, push: float = 0.0)-> void :
	
	var EnemyLoveTrain: bool
	var TournamentDataDa: Dictionary
	if general.is_tournir:
		TournamentDataDa = general.GetTournamentEnemy(general.tournament_lvl)
		if general.EnemyName == "Valentine" and TournamentDataDa["version"] == "True":
			EnemyLoveTrain = true
	
	
	if "Rage" in general.Addition: general.Addition["Rage"] += amount_hp / 1.0
	if "Blood" in general.Addition:
		if general.Stats["VB"] == 0:
			general.Addition["Blood"] += amount_hp / 4.0
	
			
		else:
			general.Addition["Blood"] += (amount_hp / 4.0) * 2.0
	amount_hp = amount_hp * general.stand_power
	
	if general.twoh_complete_quest["blood"] < 100 and general.stand_number == 1:
		general.twoh_complete_quest["blood"] += amount_hp / 4.0
	if damage_yes.find("_Hand_") != - 1: amount_hp = amount_hp + general.Stats["DH"]
	amount_hp *= general.Stats["DP"]
	
	if damage_yes.find("lt") != - 1 and EnemyLoveTrain:
		pass
	else:
		if block_destroy:
			if Enemy.block_activate:
				Enemy.block_activate = false
		if Enemy.block_activate == false:
			Enemy.get_node("AnimationPlayer").play("Hit")
		else:
			Enemy.get_node("AnimationPlayer").play("HitBlock")
		Enemy.attacked = true
		var time_stopped = false
		while general.time_stop:
			time_stopped = true
			yield(general.get_tree().create_timer(0.1), "timeout")
		general.random.randomize()
		var StunTime: float
		
		if general.enemy_list[Enemy.id - 1]["RAGE"] <= 1:
			StunTime = 1
		elif general.enemy_list[Enemy.id - 1]["RAGE"] > 1 and general.enemy_list[Enemy.id - 1]["RAGE"] <= 3:
			StunTime = 0.8
		elif general.enemy_list[Enemy.id - 1]["RAGE"] > 3:
			StunTime = 0.5

		if general.combo_timer.is_stopped() or general.combo_timer.time_left < StunTime:
			general.start_combo_timer_for_enemy(Enemy, StunTime)
		
		if time_stopped and direct_player_set:
			general.pre_bullet_direct = general.player_direct
		if time_stopped == false:
			Enemy.damaged_default_eneemy(amount_dist / (int(Enemy.block_activate) + 1))
		else:
			Enemy.attacked = false
		if general.time_erase:
			general.time_erase = false
			general.enemy_time_scale = 1
		if Enemy.block_activate == false:
			Enemy.health -= amount_hp / (int(time_stopped) + 1)
			general.damage_text = "-" + str(amount_hp / (int(time_stopped) + 1))
			general.damage_for_enemy_counts += amount_hp / (int(time_stopped) + 1)
			general._track_training_damage(Enemy, amount_hp / (int(time_stopped) + 1))
			
			if popadanie_check:
				general.popadania += 1
			Enemy.damage_text_spawn()
			
			# Тренировочный манекен нельзя оттолкнуть: иначе он уезжает
			# из зоны видимости и выглядит так, будто исчез.
			if Enemy.training_dummy == false:
				var direction = int(Enemy.position.x > general.GGPlayer.position.x) - int(Enemy.position.x < general.GGPlayer.position.x)
				for i in 3:
					Enemy.position.x += float(direction * push) / 3.0
					yield(general.get_tree().create_timer(0.02), "timeout")
		else:
			Enemy.health -= amount_hp / (int(time_stopped) + 2)
			general.damage_text = "-" + str(amount_hp / (int(time_stopped) + 2))
			general.damage_for_enemy_counts += amount_hp / (int(time_stopped) + 2)
			general._track_training_damage(Enemy, amount_hp / (int(time_stopped) + 2))
			if popadanie_check:
				general.popadania += 1
			Enemy.damage_text_spawn()

		while general.time_stop:
			yield(general.get_tree().create_timer(0.1), "timeout")
func chop_damage(general, Enemy, amount_hp: int):
	amount_hp *= general.Stats["DP"]
	var time_stopped = false
	while general.time_stop:
		time_stopped = true
		yield(general.get_tree().create_timer(0.1), "timeout")
	general.start_combo_timer_for_enemy(Enemy, 5)
	if general.time_erase:
		general.time_erase = false
		general.enemy_time_scale = 1
	if Enemy.block_activate:
		Enemy.block_activate = false
	general.passive_damage(Enemy, "lt", 1, 4, (4 / (int(time_stopped) + 1)) * general.stand_power, true)
	Enemy.attacked = true
	# У ChopDamage в TrainingArena есть дорожка позиции: она телепортирует
	# манекен в фиксированную точку. Для тренировочного врага её не играем.
	if Enemy.training_dummy == false:
		var animation = Enemy.animation_enemy.get_animation("ChopDamage")
		if general.player_pos > Enemy.global_position:
			animation.track_set_key_value(0, 0, general.player_pos - Vector2(55, 16))
		else:
			animation.track_set_key_value(0, 0, general.player_pos + Vector2(55, - 16))
		Enemy.animation_enemy.play("ChopDamage")
	Enemy.povorot_reset()
	if Enemy.enemy_block_timer.is_stopped() == false:
		Enemy.enemy_block_timer_end()
	if not Enemy.enemy_block_timer.is_connected("timeout", Enemy, "enemy_block_timer_end"):
		Enemy.enemy_block_timer.connect("timeout", Enemy, "enemy_block_timer_end")
	Enemy.enemy_block_timer.wait_time = 5
	Enemy.enemy_block_timer.one_shot = true
	if Enemy.enemy_block_timer.get_parent() == null:
		Enemy.add_child(Enemy.enemy_block_timer)
	Enemy.enemy_block_timer.start()
func passive_damage(general, Enemy, damage_yes, wait_time: float, count_attacks: int, amount_hp, chop: bool):
	amount_hp = amount_hp * general.stand_power
	amount_hp *= general.Stats["DP"]
	
	
	var EnemyLoveTrain: bool
	var TournamentDataDa: Dictionary
	if general.is_tournir:
		TournamentDataDa = general.GetTournamentEnemy(general.tournament_lvl)
		if general.EnemyName == "Valentine" and TournamentDataDa["version"] == "True":
			EnemyLoveTrain = true
	
	
	
	
	if damage_yes == "lt" and EnemyLoveTrain:
		pass
	else:
		general.start_combo_timer_for_enemy(Enemy, count_attacks * wait_time)
		if chop:
			Enemy.get_node("AnimationPlayer").play("ChopHit")
		else:
			Enemy.get_node("AnimationPlayer").play("Hit")
		var time_stopped = false
		while general.time_stop:
			time_stopped = true
			yield(general.get_tree().create_timer(0.1), "timeout")
		if Enemy == null or is_instance_valid(Enemy) == false:
			return
		if Enemy.block_activate:
			Enemy.block_activate = false
		if general.time_erase:
			general.time_erase = false
			general.enemy_time_scale = 1
		if Enemy == null or is_instance_valid(Enemy) == false:
			return
		for attack in range(count_attacks):
			Enemy.get_node("PunchEffect").play()
			if chop:
				Enemy.get_node("AnimationPlayer").play("ChopHit")
			else:
				Enemy.get_node("AnimationPlayer").play("Hit")
			Enemy.attacked = true
			Enemy.health -= amount_hp / (int(Enemy.block_activate) + int(time_stopped) + 1)
			general.damage_text = "-" + str(amount_hp / (int(Enemy.block_activate) + int(time_stopped) + 1))
			general.damage_for_enemy_counts += amount_hp / (int(time_stopped) + 1)
			general._track_training_damage(Enemy, amount_hp / (int(Enemy.block_activate) + int(time_stopped) + 1))
			Enemy.damage_text_spawn()
			yield(general.get_tree().create_timer(wait_time), "timeout")
		Enemy.attacked = false
