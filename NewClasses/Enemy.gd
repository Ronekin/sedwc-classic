# Enemy.gd — общая база врагов SEDWC.
#
# Наследование: Entity (ядро) -> Enemy -> Gyro / Dio / Kars / ...
# Здесь только общее: навигация, дистанции, таймеры, поворот, текст урона и
# каркас боя. Атаки, анимации, имена и числа остаются в конечных классах.
#
# Моддинг:
# - нового врага добавляйте в Data/Enemies.gd и отдельным классом-наследником;
# - общие проверки не дублируйте в наследниках;
# - сцены могут подключать старые no-op обработчики — не удаляйте их без
#   проверки .tscn.

extends "res://Core/CoreResources/Entity.gd"
class_name Enemy

signal attack_started(attack_id)
signal attack_finished(attack_id)
signal defeated(enemy)

export var speed = 120.0
export var id = 0
export var character_name = "Default"
export var enemy_type = "melee"
export var reward = {"money": 0, "exp": 0}

var current_scene_name = ""
var navigation = null
var navigation_node = null
var player_node = null

var direction = Vector2()
var distance = 0.0
var direct_text = "Right"
var attacked = false
var position_first = Vector2.ZERO
var activate_angry = true
var start_position = Vector2.ZERO
var time_passed = 0.0
var dashed = false

# Это мировые смещения до границ арены, поэтому храним их как Vector2:
# ниже код читает .x/.y, а не сами числа.
var dist_l = Vector2.ZERO
var dist_r = Vector2.ZERO
var dist_enemy_l = Vector2.ZERO
var dist_enemy_r = Vector2.ZERO
var dist_enemy_t = Vector2.ZERO
var dist_enemy_b = Vector2.ZERO

var attack_id = 0
var attack_start = false
var attack_timer = Timer.new()
var dash_timer = Timer.new()
# Дистанция, с которой враг подходит к игроку сбоку. Она должна быть
# меньше радиуса атаки (70), иначе враг бесконечно кружит вокруг игрока.
var player_offset = 60.0
var random = RandomNumberGenerator.new()
var random_crit = RandomNumberGenerator.new()
var block_activate = false
var animation_hit_played = false
var player_start_attack = false
var dist_end = 10.0
var player_position_first = Vector2.ZERO
var attack_activate = false
var timer_knifes = Timer.new()
var kooldown_timer = Timer.new()
var timer = Timer.new()
var passive_damage_active = false
var training_dummy = false
var attack_id_start = 0
var attack_id_start_for_small_dist = 0
var warning_activate = false
var attack_act = false
var path = []
var combo_enabled = false
var enemy_block_timer = Timer.new()

var slow = 1.0
var debuf_infinity = 0.0
var stand = "None"
var dialog_start = false
var death_processed = false
var current_yield = null
var _player_attack_reset_cd = 0.0
var last_hit_time = 0.0
var hit_cooldown = 0.1
var navigation_update_timer = 0.0
var navigation_update_interval = 0.3
var waiting_for_animation = false
var pending_attack_id = 0
var timers_to_remove = []
var timers_to_clear_list = []
var timers = {}
var dataDop = {}
var reward_get = false
var LastHp = 0.0
var SpeedBuff = 1.0
var AnimationTypeDa = 0

var time_erase = preload("res://Scenes/WhiteScreenVFX.tscn")
var barrage_arm = preload("res://Scenes/BarrageArm.tscn")
var block_brock_vfx = preload("res://Scenes/DiscActivateFullVFX.tscn")
var warning = preload("res://Scenes/WarningAggresiveAttack.tscn")
var damage_text = preload("res://Scenes/DamageTextForSpawn.tscn")
var ehos_effect = preload("res://Scenes/EhosEffect.tscn")
var ehos_effect_audio_second_attack = preload("res://Scenes/EchoesEffectSecondAttack.tscn")
var enemy_over_effect = preload("res://Scenes/EnemyOverEffect.tscn")
var time_erase_effect = preload("res://Scenes/KingCrimsonEffectTimeErase.tscn")
var tusk_3_hole_bd = preload("res://Scenes/Tusk3NailHoleBarrage.tscn")
var explosion = preload("res://Scenes/Explosion.tscn")
var knife = preload("res://Scenes/Knife.tscn")

onready var animation_enemy = _get_scene_node("YSorting/FightAnimations")
onready var animation_player = _get_scene_node("YSorting/PlayerFightAnimations")


func _ready():
	._ready()
	random.randomize()
	random_crit.randomize()
	current_scene_name = _current_scene_name()
	navigation = _get_scene_node("Navigation2D")
	navigation_node = navigation
	player_node = _find_player_node()
	start_position = global_position
	# Все таймеры врага должны быть детьми врага. Иначе Timer.new() без
	# add_child() переживёт смерть врага и останется в ObjectDB.
	for local_timer in [attack_timer, dash_timer, timer_knifes, kooldown_timer, timer, enemy_block_timer]:
		_ensure_child_timer(local_timer)


func Sound(_what):
	# Базовая заглушка для общих вызовов Enemy.Sound("damage").
	# Конкретный враг может переопределить метод своей озвучкой. Без неё
	# HitBoxEnemy падал с ошибкой на врагах, у которых нет Sound().
	pass


func _ensure_child_timer(local_timer: Timer) -> void :
	if local_timer == null:
		return
	var parent = local_timer.get_parent()
	# Некоторые сцены вызывают _ready базового класса повторно. Проверка
	# parent == self делает метод идемпотентным и не даёт add_child упасть
	# на уже добавленном таймере.
	if parent == self:
		return
	if parent != null:
		parent.remove_child(local_timer)
	if local_timer.get_parent() == null:
		add_child(local_timer)


func _exit_tree() -> void :
	if General != null:
		General.disconnect_fight_timers_from(self)
	for child in get_children():
		if not (child is Timer):
			continue
		child.stop()
		for connection in child.get_signal_connection_list("timeout"):
			var target = connection.get("target")
			var method = str(connection.get("method"))
			if target == self and child.is_connected("timeout", target, method):
				child.disconnect("timeout", target, method)


func _current_scene_name():
	var tree = get_tree()
	if tree == null or tree.current_scene == null:
		return ""
	return tree.current_scene.name


func _get_scene_node(path):
	var scene_name = _current_scene_name()
	if scene_name == "":
		return null
	return get_node_or_null("/root/" + scene_name + "/" + path)


func _find_player_node():
	var scene_name = _current_scene_name()
	if scene_name == "":
		return null
	var paths = [
		"/root/" + scene_name + "/YSorting/GGPlayer",
		"/root/" + scene_name + "/SortingY/GGPlayer"
	]
	for path in paths:
		if has_node(path):
			return get_node(path)
	return null


func get_player_node():
	if player_node == null or not is_instance_valid(player_node):
		player_node = _find_player_node()
	return player_node


func get_navigation_node():
	if navigation == null or not is_instance_valid(navigation):
		navigation = _get_scene_node("Navigation2D")
	if navigation == null:
		navigation = navigation_node
	return navigation


func refresh_navigation():
	navigation_node = get_navigation_node()
	player_node = get_player_node()
	return navigation_node


func generate_path():
	var nav = get_navigation_node()
	if nav != null:
		# Navigation2D в Godot 3.5 возвращает PoolVector2Array; коду нужны
		# Array-методы (pop_front), поэтому путь хранится как обычный Array.
		path = Array(nav.get_simple_path(global_position, General.player_pos, true))


func navigate():
	if path.size() > 1:
		velocity = global_position.direction_to(path[1]) * (speed - debuf_infinity) * slow
	if path.size() > 0 and global_position.distance_to(path[0]) < 5:
		path.pop_front()


func navigate_v2():
	if path.size() > 1:
		var target_dir = (path[1] - global_position).normalized()
		velocity = (target_dir * (speed - debuf_infinity)) * slow
	if path.size() > 0 and global_position.distance_to(path[0]) < 5:
		path.pop_front()


func generate_path_left():
	# Целимся в точку сбоку от игрока на той же высоте. Смещение по
	# перпендикуляру к направлению на игрока уводило врага на 60 px
	# выше/ниже игрока. Проверка атаки требует разницу по высоте меньше
	# 30 px, поэтому враг кружил вокруг игрока и не бил. Берём смещение
	# по X: враг подходит к игроку слева или справа, сохраняя его Y.
	var player_point = General.player_pos_start_erase
	var side = 1.0
	if global_position.x < player_point.x:
		side = -1.0
	var target_pos = Vector2(player_point.x + side * player_offset, player_point.y)
	var nav = get_navigation_node()
	if nav == null:
		# Арены без Navigation2D всё равно должны работать: ведём врага
		# напрямую к рассчитанной точке.
		path = [global_position, target_pos]
		return
	path = Array(nav.get_simple_path(global_position, target_pos, true))


func position_back():
	var sprite_node = get_node_or_null("Sprite")
	var reference = sprite_node if sprite_node != null else self
	var add_position = position_first - reference.global_position
	global_position -= add_position
	if sprite_node != null:
		sprite_node.global_position += add_position
	for node_name in ["Area2D", "AttackBox", "CollisionShape2D"]:
		var node = get_node_or_null(node_name)
		if node != null:
			node.global_position += add_position


func povorot_reset():
	if not General.glush_enemy_timer.is_stopped():
		return
	if position.x > General.player_pos.x and direct_text != "Left":
		scale.x *= - 1
		direct_text = "Left"
	elif position.x < General.player_pos.x and direct_text != "Right":
		scale.x *= - 1
		direct_text = "Right"


func face_target(target_position = null):
	var target = target_position
	if target == null:
		target = General.player_pos
	if global_position.x < target.x and direct_text != "Right":
		scale.x *= - 1
		direct_text = "Right"
	elif global_position.x > target.x and direct_text != "Left":
		scale.x *= - 1
		direct_text = "Left"


func move_towards(target_position, delta, stop_distance = 0.0):
	var to_target = target_position - global_position
	if to_target.length() <= stop_distance:
		velocity = Vector2.ZERO
		return
	velocity = to_target.normalized() * speed
	if use_base_movement:
		move(delta, velocity)
	else:
		move_and_slide(velocity)


func distance_to_player():
	var player = get_player_node()
	if player == null:
		return INF
	return global_position.distance_to(player.global_position)


func is_player_in_range(range_distance, vertical_tolerance = 30.0):
	var player = get_player_node()
	if player == null:
		return false
	var offset = player.global_position - global_position
	return offset.length() <= range_distance and abs(offset.y) <= vertical_tolerance


func play_animation(animation_name):
	if animation_player != null and animation_player.has_animation(animation_name):
		animation_player.play(animation_name)


func play_enemy_animation(animation_name):
	if animation_enemy != null and animation_enemy.has_animation(animation_name):
		animation_enemy.play(animation_name)


func spawn_vfx(vfx_scene, at_position = null, parent = null):
	if vfx_scene == null:
		return null
	var vfx = vfx_scene.instance()
	var target_parent = parent if parent != null else get_parent()
	if target_parent == null:
		return null
	target_parent.add_child(vfx)
	if at_position != null:
		vfx.global_position = at_position
	return vfx


func spawn_damage_text():
	var text_node = get_node_or_null("DamageText")
	if text_node == null:
		return
	random.randomize()
	yield(get_tree().create_timer(random.randf_range(0.0, 0.2)), "timeout")
	var damage_spawn = damage_text.instance()
	var target_parent = get_parent()
	if target_parent != null:
		target_parent.add_child(damage_spawn)
	damage_spawn.global_position = text_node.global_position
	damage_spawn.z_index = 1


func player_damage_push(amount_dist: float) -> Vector2:
	var dl_x = 0.0
	if typeof(dist_l) == TYPE_VECTOR2:
		dl_x = dist_l.x
	else:
		dl_x = float(dist_l)
	var dr_x = 0.0
	if typeof(dist_r) == TYPE_VECTOR2:
		dr_x = dist_r.x
	else:
		dr_x = float(dist_r)
	var push = 0.0
	if direct_text == "Left":
		if dl_x < amount_dist + 35:
			push = - dl_x + 35
		else:
			push = - amount_dist
	else:
		if dr_x < amount_dist + 35:
			push = dr_x - 35
		else:
			push = amount_dist
	return Vector2(push, 0)


func deal_damage_to_player(amount_hp, amount_dist, block_destroy, extra: Dictionary = {}):
	General.start_combo_enemy_timer_for_enemy(self, 0.65)
	var damage = amount_hp
	if block_destroy and General.blocked:
		damage = amount_hp / 2.0
	var dop = {
		"AntiBlock": block_destroy,
		"Push": player_damage_push(float(amount_dist)),
	}
	for key in extra:
		dop[key] = extra[key]
	General.PlayerDamage(damage, dop)
	if block_destroy and General.blocked:
		General.blocked = false
		if General.block_glush != null:
			if General.block_glush.is_connected("timeout", self, "aaaaaa"):
				General.block_glush.disconnect("timeout", self, "aaaaaa")
			General.block_glush.wait_time = 5.0 / max(0.01, General.enemy_time_scale)
			General.block_glush.one_shot = true
			# block_glush — общий таймер General. Не переносим его к врагу:
			# иначе при удалении врага таймер исчезал бы вместе с ним.
			General.block_glush.start()
		var gui = get_node_or_null("/root/" + get_tree().current_scene.name + "/GUI")
		if gui != null:
			var block_vfx_inst = block_brock_vfx.instance()
			gui.add_child(block_vfx_inst)


func damage_text_spawn():
	spawn_damage_text()


# Вампирское лечение: общий контракт для всех врагов.
# Лечит только расы 1/3/4 и не выше hp_max; для Jotaro 3/6 пополняет квест
# крови. Наследники не дублируют эту логику.
func vampiric_heal(amount):
	var amount_buff = 1.0
	if General.race_number == 3:
		amount_buff = 2.0
	elif General.race_number == 4:
		amount_buff = 2.5
	if General.race_number == 1 or General.race_number == 3 or General.race_number == 4:
		if General.hp_max >= General.heart_points + amount * amount_buff:
			General.heart_points += amount * amount_buff
		if (General.EnemyName == "jotaro6" or General.EnemyName == "jotaro3") and General.twoh_complete_quest.get("blood", 0) < 100:
			General.twoh_complete_quest["blood"] += amount / 2 * amount_buff


# Общие обработчики боевых анимаций. Наследники переопределяют только
# уникальные фазы, а не копируют базовый сброс флагов.


func _on_FightAnimations_animation_finished(anim_name):
	random.randomize()
	if anim_name == "DamageDefault" or anim_name == "JumpEnemy":
		$Area2D / CollisionShape2D.set_deferred("disabled", false)
		while General.barrage_activate or passive_damage_active:
			yield(get_tree().create_timer(0.1), "timeout")
		dashed = false
		attacked = false
		animation_hit_played = false
		if General.enemy_block_all == false and warning_activate == false and General.glush_enemy_timer.is_stopped() and General.combo_timer.is_stopped() and passive_damage_active == false:
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

	if anim_name == "BigDashEnemy" or anim_name == "BigDashEnemyBack" or anim_name == "BigDashEnemyVert":
		dashed = false

func _on_Ghost_Effect_timeout():
	if General.time_erase == false:
		if dashed and not attacked and animation_enemy.current_animation == "BigDashEnemyBack" or animation_enemy.current_animation == "BigDashEnemyVert":
			var effect = preload("res://Scenes/DashGhostEffectEnemy.tscn").instance()
			get_parent().add_child(effect)
			effect.position = global_position
			if direct_text == "left":
				effect.scale.x = - 1
			else:
				effect.scale.x = 1
	else:
		var effect = preload("res://Scenes/DashGhostEffectEnemy.tscn").instance()
		get_parent().add_child(effect)
		effect.position = global_position
		if direct_text == "left":
			effect.scale.x = - 1
		else:
			effect.scale.x = 1

func chop_end():
	$AnimationPlayer.play("ChopHitWithoutArm")

func damaged_default_eneemy(fin_pos):
	var time_stopped = false
	while General.time_stop:
		time_stopped = true
		yield(get_tree().create_timer(0.1), "timeout")
	var animation = animation_enemy.get_animation("DamageDefault")
	if time_stopped == false:
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

func dash(type):
	if General.enemy_block_all == false:
		if attacked == false and type == "AttackDash" and dashed == false and block_activate == false and General.time_erase == false and passive_damage_active == false and General.glush_enemy_timer.is_stopped():
			$Ghost_Effect.wait_time = 0.025 / General.enemy_time_scale
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
		elif attacked and type == "AttackDash" and dashed == false and block_activate == false and General.time_erase == false and passive_damage_active == false and General.glush_enemy_timer.is_stopped():
			$Ghost_Effect.wait_time = 0.025 / General.enemy_time_scale
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
		if attacked == false and type == "BigDash" and dashed == false and block_activate == false and General.time_erase == false and passive_damage_active == false and General.glush_enemy_timer.is_stopped():
			$Ghost_Effect.wait_time = 0.025 / General.enemy_time_scale
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
		elif attacked and type == "BigDash" and dashed == false and block_activate == false and General.time_erase == false and passive_damage_active == false and General.glush_enemy_timer.is_stopped():
			$Ghost_Effect.wait_time = 0.025 / General.enemy_time_scale
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
		if attacked == false and type == "BackDash" and dashed == false and block_activate == false and General.time_erase == false and passive_damage_active == false and General.glush_enemy_timer.is_stopped():
			$Ghost_Effect.wait_time = 0.025 / General.enemy_time_scale
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
		elif attacked and type == "BackDash" and dashed == false and block_activate == false and General.time_erase == false and passive_damage_active == false and General.glush_enemy_timer.is_stopped():
			$Ghost_Effect.wait_time = 0.025 / General.enemy_time_scale
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
		if attacked == false and type == "UpDash" and dashed == false and block_activate == false and General.time_erase == false and passive_damage_active == false and General.glush_enemy_timer.is_stopped():
			$Ghost_Effect.wait_time = 0.05 / General.enemy_time_scale
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
		elif attacked and type == "UpDash" and dashed == false and block_activate == false and General.time_erase == false and passive_damage_active == false and General.glush_enemy_timer.is_stopped():
			yield(animation_enemy, "animation_finished")
			$Ghost_Effect.wait_time = 0.05 / General.enemy_time_scale
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
		if attacked == false and type == "AggresiveDash" and dashed == false and block_activate == false and General.time_erase == false and passive_damage_active == false and General.glush_enemy_timer.is_stopped():
			$Ghost_Effect.wait_time = 0.025 / General.enemy_time_scale
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
		elif attacked and type == "AggresiveDash" and dashed == false and block_activate == false and General.time_erase == false and passive_damage_active == false and General.glush_enemy_timer.is_stopped():
			$Ghost_Effect.wait_time = 0.025 / General.enemy_time_scale
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
		if type == "JumpTreeDash" and dashed == false and block_activate == false and General.time_erase == false:
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
		if type == "Garpun" and dashed == false and block_activate == false and General.time_erase == false:
			var animation = animation_enemy.get_animation("DamageDefault")
			animation.track_set_key_value(0, 0, global_position)
			if General.player_pos > global_position:
				animation.track_set_key_value(0, 1, Vector2(General.player_pos.x - 65, General.player_pos.y))
			else:
				animation.track_set_key_value(0, 1, Vector2(General.player_pos.x + 65, General.player_pos.y))
			animation_enemy.play("DamageDefault")

func dash_big_random():
	if dash_timer.is_connected("timeout", self, "dash_big_random"):
		dash_timer.disconnect("timeout", self, "dash_big_random")
	dash("BigDash")
	_ensure_child_timer(dash_timer)
	dash_timer.connect("timeout", self, "dash_big_random")
	dash_timer.wait_time = 6.0 / General.enemy_time_scale
	dash_timer.one_shot = true
	dash_timer.start()

func player_damage(amount_hp, amount_dist: int, block_destroy: bool):
	deal_damage_to_player(amount_hp, amount_dist, block_destroy)

# Общие методы урона по игроку. Gyro и TrenirovkaEnemy переопределяют их
# из-за своих множителей stand_power и счётчиков тренировки.

func default_damage(amount_hp, amount_dist: int, direct_player_set: bool, block_destroy: bool) -> void:
	if block_destroy:
		if block_activate:
			block_activate = false
	if block_activate == false:
		$AnimationPlayer.play("Hit")
	else:
		$AnimationPlayer.play("HitBlock")
	attacked = true
	var time_stopped = false
	while General.time_stop:
		time_stopped = true
		yield(get_tree().create_timer(0.1), "timeout")
	random.randomize()
	var combo_wait = 1.0
	if General.enemy_list[id - 1]["RAGE"] <= 1:
		combo_wait = 1.0
	elif General.enemy_list[id - 1]["RAGE"] > 1 and General.enemy_list[id - 1]["RAGE"] <= 3:
		combo_wait = 0.8
	elif General.enemy_list[id - 1]["RAGE"] > 3:
		combo_wait = 0.5
	General.start_combo_timer_for_enemy(self, combo_wait)
	if time_stopped and direct_player_set:
		General.pre_bullet_direct = General.player_direct
	if time_stopped == false:
		damaged_default_eneemy(amount_dist / (int(block_activate) + 1))
	else:
		attacked = false
	if General.time_erase:
		General.time_erase = false
		General.enemy_time_scale = 1
	if block_activate == false:
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
	while General.time_stop:
		yield(get_tree().create_timer(0.1), "timeout")

func chop_damage(amount_hp: int):
	var time_stopped = false
	while General.time_stop:
		time_stopped = true
		yield(get_tree().create_timer(0.1), "timeout")
	General.start_combo_timer_for_enemy(self, 5)
	if General.time_erase:
		General.time_erase = false
		General.enemy_time_scale = 1
	if block_activate:
		block_activate = false
	passive_damage(1, 4, 4 / (int(time_stopped) + 1), true)
	attacked = true
	var animation = animation_enemy.get_animation("ChopDamage")
	if General.player_pos > global_position:
		animation.track_set_key_value(0, 0, General.player_pos - Vector2(55, 16))
	else:
		animation.track_set_key_value(0, 0, General.player_pos + Vector2(55, - 16))
	animation_enemy.play("ChopDamage")
	povorot_reset()
	_start_enemy_block_timer(5)

func passive_damage(wait_time: float, count_attacks: int, amount_hp, chop: bool):
	General.start_combo_timer_for_enemy(self, count_attacks * wait_time)
	if chop:
		$AnimationPlayer.play("ChopHit")
	else:
		$AnimationPlayer.play("Hit")
	var time_stopped = false
	while General.time_stop:
		time_stopped = true
		yield(get_tree().create_timer(0.1), "timeout")
	if block_activate:
		block_activate = false
	passive_damage_active = true
	if General.time_erase:
		General.time_erase = false
		General.enemy_time_scale = 1
	for attack in range(count_attacks):
		passive_damage_active = true
		$PunchEffect.play()
		if chop:
			$AnimationPlayer.play("ChopHit")
		else:
			$AnimationPlayer.play("Hit")
		attacked = true
		health -= amount_hp / (int(block_activate) + int(time_stopped) + 1)
		General.damage_text = "-" + str(amount_hp / (int(block_activate) + int(time_stopped) + 1))
		General.damage_for_enemy_counts += amount_hp / (int(time_stopped) + 1)
		damage_text_spawn()
		yield(get_tree().create_timer(wait_time), "timeout")
	attacked = false
	passive_damage_active = false

func jump_damage(amount_hp, amount_dist: int, direct_player_set: bool, block_destroy: bool) -> void:
	if block_destroy:
		if block_activate:
			block_activate = false
	if block_activate == false:
		$AnimationPlayer.play("Hit")
	else:
		$AnimationPlayer.play("HitBlock")
	var time_stopped = false
	while General.time_stop:
		time_stopped = true
		yield(get_tree().create_timer(0.1), "timeout")
	General.start_combo_timer_for_enemy(self, 1)
	attacked = true
	if time_stopped and direct_player_set:
		General.pre_bullet_direct = General.player_direct
	if time_stopped == false:
		dash("JumpTreeDash")
	else:
		attacked = false
	if General.time_erase:
		General.time_erase = false
		General.enemy_time_scale = 1
	if block_activate == false:
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

func epitafia_end():
	pass

func knife_player_attack():
	if General.time_erase == false and General.time_stop == false:
		if General.epitafia_enabled == false:
			player_damage(3, 65, false)
		else:
			epitafia_end()

func pre_attack():
	if General.enemy_block_all == false and General.time_erase == false and General.time_stop == false and General.glush_enemy_timer.is_stopped() and General.combo_timer.is_stopped() and passive_damage_active == false:
		random.randomize()
		var random_number = random.randf()
		if global_position.distance_to(General.player_pos) < 80 and General.player_pos.y - global_position.y > - 30 and General.player_pos.y - global_position.y < 30 and warning_activate == false:
			if General.enemy_list[id - 1]["RAGE"] <= 1:
				if random_number < 0.2 and block_activate == false and dashed == false and General.player_scale != scale and warning_activate == false:
					block_activate = true
					yield(get_tree().create_timer(random.randf_range(1, 3) / General.enemy_time_scale), "timeout")
					while attacked:
						yield(get_tree().create_timer(0.1), "timeout")
					block_activate = false
			elif General.enemy_list[id - 1]["RAGE"] < 3 and General.enemy_list[id - 1]["RAGE"] > 1:
				if random_number < 0.2 and block_activate == false and dashed == false and General.player_scale != scale:
					block_activate = true
					yield(get_tree().create_timer(random.randf_range(1, 3) / General.enemy_time_scale), "timeout")
					while attacked:
						yield(get_tree().create_timer(0.1), "timeout")
					block_activate = false
				elif random_number > 0.6 and random_number < 0.7 and block_activate == false and dashed == false and General.player_scale != scale and warning_activate == false:
					dash("BackDash")
				elif random_number > 0.2 and random_number < 0.3 and block_activate == false and dashed == false and General.player_scale != scale and warning_activate == false:
					dash("UpDash")
			else:
				if random_number < 0.3 and block_activate == false and dashed == false and General.player_scale != scale:
					block_activate = true
					yield(get_tree().create_timer(random.randf_range(1, 3) / General.enemy_time_scale), "timeout")
					while attacked:
						yield(get_tree().create_timer(0.1), "timeout")
					block_activate = false
				elif random_number > 0.8 and random_number < 1 and block_activate == false and dashed == false and General.player_scale != scale and warning_activate == false:
					dash("BackDash")
				elif random_number > 0.4 and random_number < 0.6 and block_activate == false and dashed == false and General.player_scale != scale and warning_activate == false:
					dash("UpDash")

func pre_bullet():
	if General.enemy_block_all == false and General.time_erase == false and General.time_stop == false and General.glush_enemy_timer.is_stopped() and General.combo_timer.is_stopped() and passive_damage_active == false:
		random.randomize()
		var random_number = random.randf()
		if General.player_pos.y - global_position.y > - 20 and General.player_pos.y - global_position.y < 20 and warning_activate == false:
			if General.enemy_list[id - 1]["RAGE"] <= 1:
				if random_number < 0.2 and block_activate == false and dashed == false and General.player_scale != scale:
					block_activate = true
					yield(get_tree().create_timer(random.randf_range(1, 3) / General.enemy_time_scale), "timeout")
					while attacked:
						yield(get_tree().create_timer(0.1), "timeout")
					block_activate = false
				elif random_number >= 0.2 and random_number < 0.3 and block_activate == false and dashed == false and General.player_scale != scale:
					dash("UpDash")
			elif General.enemy_list[id - 1]["RAGE"] < 3 and General.enemy_list[id - 1]["RAGE"] > 1:
				if random_number < 0.3 and block_activate == false and dashed == false and General.player_scale != scale:
					block_activate = true
					yield(get_tree().create_timer(random.randf_range(1, 3) / General.enemy_time_scale), "timeout")
					while attacked:
						yield(get_tree().create_timer(0.1), "timeout")
					block_activate = false
				elif random_number >= 0.3 and random_number < 0.6 and block_activate == false and dashed == false and General.player_scale != scale:
					dash("UpDash")
			else:
				if random_number < 0.4 and block_activate == false and dashed == false and General.player_scale != scale:
					block_activate = true
					yield(get_tree().create_timer(random.randf_range(1, 3) / General.enemy_time_scale), "timeout")
					while attacked:
						yield(get_tree().create_timer(0.1), "timeout")
					block_activate = false
				elif random_number >= 0.4 and random_number < 0.8 and block_activate == false and dashed == false and General.player_scale != scale:
					dash("UpDash")


func _attack_box_shape():
	return get_node_or_null("AttackBox/CollisionShape2D2")


func _on_PlayerFightAnimations_animation_started(anim_name):
	if anim_name == "PlayerDamage":
		var shape = _attack_box_shape()
		if shape != null:
			shape.set_deferred("disabled", true)


func _on_PlayerFightAnimations_animation_finished(anim_name):
	if anim_name == "PlayerDamage":
		var shape = _attack_box_shape()
		if shape != null:
			shape.set_deferred("disabled", false)


# Пустые обработчики для старых сигналов сцен: некоторые .tscn всё ещё
# подключают эти методы. Не удаляйте, пока сцены не обновлены.
func _on_AnimationPlayer_animation_started(_anim_name):
	pass


func _on_AnimationPlayer_animation_finished(_anim_name):
	pass


func _on_Area2D_area_exited(_area):
	pass


func _on_Area2D_body_entered(_body):
	pass


func _on_EmptyPunch_finished():
	pass


# Старые таймерные сигналы: враги подключают их к кулдаунам. Оставлены
# no-op для совместимости со сценами.
func lolololololol():
	pass


func do_this():
	pass


func combo_enemy_end():
	if General.heart_points > 0 or health > 0:
		General.player_block_all = false


func enemy_block_timer_end():
	enemy_block_timer.stop()
	if General.dialog_activate == false:
		General.enemy_block_all = false


func enemy_timer_start():
	_start_enemy_block_timer(1.0)


func _start_enemy_block_timer(wait_time):
	if not enemy_block_timer.is_stopped():
		enemy_block_timer_end()
	if not enemy_block_timer.is_connected("timeout", self, "enemy_block_timer_end"):
		enemy_block_timer.connect("timeout", self, "enemy_block_timer_end")
	enemy_block_timer.wait_time = wait_time
	enemy_block_timer.one_shot = true
	if enemy_block_timer.get_parent() == null:
		add_child(enemy_block_timer)
	enemy_block_timer.start()


func enemy_timer_timestop_sp():
	_start_enemy_block_timer(9.0)


func enemy_timer_timestop_shadowtw():
	_start_enemy_block_timer(10.0)


func enemy_timer_timestop_twoh():
	_start_enemy_block_timer(19.0)


func enemy_timer_timestop_tw():
	_start_enemy_block_timer(13.0)


func emit_attack_started(value):
	attack_id = value
	attack_start = true
	emit_signal("attack_started", value)


func emit_attack_finished(value = -1):
	attack_start = false
	emit_signal("attack_finished", attack_id if value < 0 else value)
