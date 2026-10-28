# TrenirovkaEnemy.gd — тренировочный враг.
#
# Наследует Enemy; используется на TrainingArena. Это полностью пассивный
# манекен:
# - не преследует игрока и не двигается;
# - не атакует вообще (ни ближними, ни ножами, ни рывками);
# - не телепортируется и не отлетает от ударов;
# - не может исчезнуть или выключить свой хитбокс;
# - не отнимает HP (см. player_damage ниже).

extends "res://NewClasses/Enemy.gd"

export var block_full = false

const TRAINING_HIT_REACTION_TIME = 0.1

# Точка, в которой манекен стоит. Каждый кадр возвращаем его сюда, чтобы
# никакая анимация, способность или мод не могли сдвинуть/увезти манекен.
var _stationary_position = Vector2.ZERO
var _stationary_scale = Vector2.ONE
var _stationary_sprite_position = Vector2.ZERO
var _stationary_sprite_scale = Vector2.ONE
var _stationary_sprite_rotation = 0.0
var _stationary_sprite_offset = Vector2.ZERO
var _stationary_sprite_centered = true


func _ready():
	._ready()
	# EnemyRoster[1] — манекен с бесконечным HP и RAGE 0. id — 1-based,
	# поэтому 2. Если сцену инстанцируют отдельно, не оставляем id = 0:
	# иначе General.enemy_list[id - 1] обратится к последнему элементу.
	if id <= 0:
		id = 2
	max_hp = 100.0
	health = - 1
	training_dummy = true
	# Манекен не должен ходить даже через общий Enemy.move()/navigate().
	speed = 0.0
	_stationary_position = global_position
	_stationary_scale = scale
	var sprite = get_node_or_null("Sprite")
	if sprite != null:
		# Запоминаем исходное положение спрайта. У Sprite уже есть offset
		# (2, -34); position должен оставаться нулевым, иначе текстура
		# уезжает вверх относительно манекена.
		_stationary_sprite_position = sprite.position
		_stationary_sprite_scale = sprite.scale
		_stationary_sprite_rotation = sprite.rotation
		_stationary_sprite_offset = sprite.offset
		_stationary_sprite_centered = sprite.centered
		sprite.z_index = max(sprite.z_index, 1)
	General.BeatDownCharge = 0
	attack_timer.stop()
	kooldown_timer.stop()
	_keep_still_and_visible()


func _physics_process(delta):
	._physics_process(delta)

	# Жёсткий якорь: даже если другая система попытается сдвинуть манекен,
	# на следующем физическом кадре он вернётся на своё место.
	_keep_still_and_visible()

	if not has_node("/root/General"):
		return
	if General.debuff_enemy == "HgZahvat":
		$Sprite / HierophantGreen.visible = true
	else:
		$Sprite / HierophantGreen.visible = false

	var player = get_player_node()
	if player == null or not is_instance_valid(player):
		return

	# Эти поля читают PlayerPhysicsService/UI. Без синхронизации у игрока
	# остаются нулевые dist_enemy_*, а HUD показывает чужое здоровье.
	var player_position = player.global_position
	General.enemy_health = health
	General.enemy_direct = direct_text
	General.enemy_position = global_position
	dist_l = player_position - General.left_block_position
	dist_r = General.right_block_position - player_position
	dist_enemy_l = global_position - General.left_block_position
	dist_enemy_r = General.right_block_position - global_position
	dist_enemy_t = global_position - General.top_block_position
	dist_enemy_b = General.bottom_block_positon - global_position
	distance = global_position.distance_to(player_position)

	# Манекен не атакует и не поворачивается к игроку. Он просто стоит.
	# Hit/ChopHit не перебиваем Idle, иначе реакция на удар исчезает.
	if not attacked and not passive_damage_active:
		_play_animation("Idle")


func _keep_still_and_visible() -> void:
	# Позиция, поворот и видимость восстанавливаются каждый физический кадр.
	# Это защищает от катсцен, старых модов и анимаций, которые двигают или
	# прячут врага: манекен не может «уехать» или исчезнуть.
	global_position = _stationary_position
	velocity = Vector2.ZERO
	rotation = 0
	scale = _stationary_scale
	visible = true
	modulate = Color(1, 1, 1, 1)

	var sprite = get_node_or_null("Sprite")
	if sprite != null:
		sprite.visible = true
		sprite.rotation = _stationary_sprite_rotation
		sprite.position = _stationary_sprite_position
		sprite.scale = _stationary_sprite_scale
		sprite.offset = _stationary_sprite_offset
		sprite.centered = _stationary_sprite_centered
		# Тело игрока рисуется на z_index = 2. Манекен всегда остаётся
		# поверх него, иначе при подходе вплотную игрок закрывает манекен.
		sprite.z_index = max(sprite.z_index, 6)

	# Манекен не атакует, поэтому его AttackBox всегда выключен. Даже если
	# анимация или мод включат его, на следующем кадре он снова выключится.
	var attack_box = get_node_or_null("AttackBox")
	if attack_box != null:
		attack_box.monitoring = false
		attack_box.monitorable = false
	var attack_shape = get_node_or_null("AttackBox/CollisionShape2D2")
	if attack_shape != null:
		attack_shape.set_deferred("disabled", true)

	_set_hurtbox_enabled(true)

	# В TrainingArena FightAnimations содержит дорожки Enemy:position. Манекен
	# не должен проигрывать эти боевые анимации вообще.
	if animation_enemy != null and animation_enemy.current_animation != "":
		animation_enemy.stop()


func _play_animation(animation_name: String) -> void:
	var animation_player = get_node_or_null("AnimationPlayer")
	if animation_player != null and animation_player.current_animation != animation_name:
		animation_player.play(animation_name)


func _set_hurtbox_enabled(enabled: bool) -> void:
	# Тренировочный манекен всегда остаётся уязвимым. Отдельный метод нужен,
	# чтобы старые сигналы FightAnimations не могли выключить хитбокс.
	var shape = get_node_or_null("Area2D/CollisionShape2D")
	if shape != null:
		shape.set_deferred("disabled", not enabled)


func _finish_hit_reaction() -> void:
	# У манекена нет FightAnimations, поэтому сбрасываем флаги вручную.
	# Задержка не даёт спамить атаки в одном кадре с получением урона.
	yield(get_tree().create_timer(TRAINING_HIT_REACTION_TIME), "timeout")
	if is_inside_tree():
		attacked = false
		animation_hit_played = false
		dashed = false
		attack_act = false


func player_damage(_amount_hp, _amount_dist: int, _block_destroy: bool):
	# Тренировка не должна убивать игрока: атаки врага остаются визуальными.
	pass


func _on_Area2D_area_entered(area):
	if visible and area != null:
		General.HitBoxEnemy(self, area)


func _on_FightAnimations_animation_started(_anim_name):
	# Манекен не использует боевые анимации перемещения. Если старый мод
	# всё-таки запустит такую анимацию, сразу останавливаем её и возвращаем
	# манекен в безопасное состояние.
	dashed = false
	attack_act = false
	_keep_still_and_visible()


func _on_FightAnimations_animation_finished(_anim_name):
	# Всегда возвращаем манекен в безопасное состояние: он не исчезает,
	# не остаётся в рывке и не теряет хитбокс.
	dashed = false
	attack_act = false
	attacked = false
	animation_hit_played = false
	_keep_still_and_visible()


func _on_AttackBox_area_entered(_area):
	# У тренировочного манекена нет атак. AttackBox всегда выключен, а этот
	# метод оставлен пустым для совместимости со старыми сценами/модами.
	pass


func dash(_type):
	# Полностью запрещаем рывки тренировочного манекена. Метод оставлен,
	# потому что его вызывают общие системы урона и старые моды.
	# Если это была реакция на удар — просто корректно завершаем её.
	_keep_still_and_visible()
	dashed = false
	attack_act = false
	if attacked:
		_finish_hit_reaction()


func attack(_id_attack):
	# Тренировочный манекен не атакует. Метод оставлен, потому что его могут
	# вызывать общие системы и старые моды; вызов ничего не делает.
	attack_id = 0
	attack_timer.stop()
	kooldown_timer.stop()
	_keep_still_and_visible()


func knife_end():
	# Заглушка для моддеров: старый колбэк атаки ножом.
	pass


func ads():
	# Заглушка для моддеров: старый колбэк предупреждающей атаки.
	pass


func Sound(what):
	match what:
		"damage":
			General.SoundPlay("res://Music/PunchPopadanie.mp3", {"Volume_db": - 7})


func damaged_default_eneemy(_fin_pos):
	# Никакого отбрасывания и никаких дорожек позиции: манекен остаётся
	# на месте. Общие системы урона ждут сброса attacked — делаем это сами.
	_finish_hit_reaction()


func default_damage(amount_hp, amount_dist: int, direct_player_set: bool, block_destroy: bool) -> void :
	if block_destroy:
		if block_activate:
			block_activate = false
	if block_activate == false:
		$AnimationPlayer.play("Hit")
	else:
		$AnimationPlayer.play("HitBlock")
	var time_stopped = false
	while General.time_stop and is_inside_tree():
		time_stopped = true
		yield(get_tree().create_timer(0.1), "timeout")
	General.start_combo_timer_for_enemy(self, 1.0)
	attacked = true
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
		General.all_damage_tren += amount_hp / (int(time_stopped) + 1)
		damage_text_spawn()
	else:
		health -= amount_hp / (int(time_stopped) + 2)
		General.damage_text = "-" + str(amount_hp / (int(time_stopped) + 2))
		General.all_damage_tren += amount_hp / (int(time_stopped) + 2)
		damage_text_spawn()


func passive_damage(wait_time: float, count_attacks: int, amount_hp, chop: bool):
	General.start_combo_timer_for_enemy(self, count_attacks * wait_time)
	if chop:
		$AnimationPlayer.play("ChopHit")
	else:
		$AnimationPlayer.play("Hit")
	attacked = true
	var time_stopped = false
	while General.time_stop and is_inside_tree():
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
		if chop:
			$AnimationPlayer.play("ChopHit")
		else:
			$AnimationPlayer.play("Hit")
		$PunchEffect.play()
		attacked = true
		health -= amount_hp / (int(block_activate) + int(time_stopped) + 1)
		General.damage_text = "-" + str(amount_hp / (int(block_activate) + int(time_stopped) + 1))
		General.all_damage_tren += amount_hp / (int(block_activate) + int(time_stopped) + 1)
		damage_text_spawn()
		yield(get_tree().create_timer(wait_time), "timeout")
	attacked = false
	passive_damage_active = false


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
