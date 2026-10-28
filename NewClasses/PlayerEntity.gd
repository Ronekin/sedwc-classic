# PlayerEntity.gd — базовый игрок SEDWC Classic.
#
# Наследует Entity ядра. Содержит общее для игрока: движение, синхронизацию
# здоровья с General и явный API урона/лечения. Стенды, техники и расовые
# специализации подключаются как AbilityMassive-узлы.
#
# Моддинг: новое общее поведение игрока добавляйте сюда, сценовые детали —
# в GGPlayer.gd или Systems/Player*Service.gd.

extends "res://Core/CoreResources/Entity.gd"
class_name PlayerEntity

export var speed = 100.0
var is_item_in_arm = "BEZ"
onready var anim_player = $YSort / Animations

const VFX_HEALTH_UP = preload("res://Scenes/HealthUpParticles.tscn")
const VFX_LEVEL_UP = preload("res://Scenes/LvlUpParticles.tscn")


func _ready():
	initialize()
	sync_player_health()


func _process(_delta):
	sync_player_health()



func SoundPlay(link_to_sound: String, Dop: Dictionary = {}):
	var sound = load(link_to_sound)
	if sound:
		if sound.has_method("get_loop") or ("loop" in sound):
			if sound.loop != null:
				sound.loop = false
		var da: AudioStreamPlayer = AudioStreamPlayer.new()
		da.stream = sound
		var final_volume = General.db_sfx
		if "Volume_db" in Dop:
			final_volume += Dop["Volume_db"]
		da.volume_db = final_volume
		add_child(da)
		da.play()
		yield(da, "finished")
		da.queue_free()


func CameraShake(time_Sec: float, power_Pixel: float, frequency_Hz: float = 5):
	var camera = get_node("YSort/Camera2D")
	var offsetDa = 0
	for i in frequency_Hz * time_Sec:
		if i % 2 == 0:
			camera.position.x -= power_Pixel
			offsetDa -= power_Pixel
		else:
			camera.position.x += power_Pixel
			offsetDa += power_Pixel
		yield(get_tree().create_timer(1.0 / frequency_Hz), "timeout")
	camera.position.x -= offsetDa


func CameraZoom(zoom: float, type: float, time: float):
	var animation_da: Animation = get_node("YSort/Animations/CameraZoomAnimation").get_animation("Move" + str(0))
	animation_da.track_remove_key(0, 1)
	animation_da.length = time
	animation_da.track_set_key_value(0, 0, General.camera_scale)
	animation_da.track_set_key_transition(0, 0, type)
	animation_da.track_insert_key(0, time, Vector2(zoom, zoom))
	get_node("YSort/Animations/CameraZoomAnimation").stop()
	get_node("YSort/Animations/CameraZoomAnimation").play("Move" + str(0))


func CameraMove(move_pos: Vector2, type: float, time: float):
	var ysort = get_node("YSort")
	var camera = get_node("YSort/Camera2D")
	var local_move_pos = move_pos - ysort.global_position
	if General.player_direct != "right":
		local_move_pos.x = - local_move_pos.x
	var animation_da: Animation = get_node("YSort/Animations/CameraMoveAnimation").get_animation("Move" + str(0))
	animation_da.length = time
	animation_da.track_remove_key(0, 1)
	animation_da.track_set_key_value(0, 0, camera.position)
	animation_da.track_set_key_transition(0, 0, type)
	animation_da.track_insert_key(0, time, local_move_pos)
	get_node("YSort/Animations/CameraMoveAnimation").stop()
	get_node("YSort/Animations/CameraMoveAnimation").play("Move" + str(0))


func StandMove(move_pos: Vector2, type: float, time: float):
	var ysort = get_node("YSort")
	var stand = get_node("YSort/Stand")
	var local_move_pos = move_pos - ysort.global_position
	if General.player_direct != "right":
		local_move_pos.x = - local_move_pos.x
	var animation_da: Animation = get_node("YSort/Stand/StandMoveAnim").get_animation("Custom")
	animation_da.length = time
	animation_da.track_remove_key(0, 1)
	animation_da.track_set_key_value(0, 0, stand.position)
	animation_da.track_set_key_transition(0, 0, type)
	animation_da.track_insert_key(0, time, local_move_pos)
	get_node("YSort/Stand/StandMoveAnim").stop()
	get_node("YSort/Stand/StandMoveAnim").play("Custom")


func sync_player_health():
	max_hp = max(1.0, float(General.hp_max))
	health = clamp(float(General.heart_points), 0.0, max_hp)
	alive = health > 0.0


func movement(delta):
	if General.barrage_activate or (General.dialog_activate == false and General.is_invent_show == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false and General.player_attack_activate == false and General.blocked == false and General.attacked == false):
		var speedDa = 1.0
		var AnimMove = true
		if General.barrage_activate:
			speedDa = 0.2
		elif anim_player.current_animation == "SpinCast":
			speedDa = 0.2
			AnimMove = false
		speedDa *= General.Stats["MoveSpeed"]
		if General.velocity_player != Vector2.ZERO:
			if General.velocity_player.x < 0 and General.player_direct != "left":
				General.player_direct = "left"
				scale.x *= - 1
			elif General.velocity_player.x > 0 and General.player_direct != "right":
				General.player_direct = "right"
				scale.x *= - 1
			if AnimMove: anim_player.play("Move" + is_item_in_arm)
			if get_tree().current_scene.name.find("Arena") == - 1:
				move_and_slide(General.velocity_player.normalized() * speedDa * speed * delta * General.run_scale)
			else:
				move_and_slide(General.velocity_player.normalized() * speedDa * speed * delta)
		else:
			if General.bubble_go_beyound_start_activate == false:
				if AnimMove: anim_player.play("Idle" + is_item_in_arm)
			General.velocity_player = Vector2(0, 0)
			if General.player_direct == "left":
				General.direct = "Left"
			else:
				General.direct = "Right"


func health_up(amount):
	restore_health(amount)
	var particles = VFX_HEALTH_UP.instance()
	if General.player_on_ysort_area == false:
		get_parent().get_parent().add_child(particles)
	else:
		get_parent().add_child(particles)
	particles.emitting = true
	particles.one_shot = true
	particles.position = Vector2(global_position.x, global_position.y - 30)
	particles.z_index = 1
	particles.amount = amount * 4


func health_less(amount):
	var defense = float(General.Stats.get("D", 0.0))
	var applied = float(amount) * (1.0 - defense)
	if "Rage" in General.Addition:
		General.Addition["Rage"] += amount
	General.damage_for_player_counts += applied
	General.heart_points = clamp(float(General.heart_points) - applied, 0.0, float(General.hp_max))
	health = General.heart_points
	alive = health > 0.0


# Явный API здоровья. Нужен для затрат и восстановления, которые не являются
# боевым уроном: стоимость снятия брони, регенерация, сброс HP на арене.
func spend_health(amount):
	var before = float(General.heart_points)
	var applied = max(0.0, float(amount))
	max_hp = max(1.0, float(General.hp_max))
	General.heart_points = clamp(before - applied, 0.0, max_hp)
	health = General.heart_points
	alive = health > 0.0
	emit_signal("health_changed", health, max_hp)
	return before - health


func restore_health(amount, cap = null):
	var before = float(General.heart_points)
	var applied = max(0.0, float(amount))
	max_hp = max(1.0, float(General.hp_max))
	var limit = max_hp
	if cap != null:
		limit = min(limit, float(cap))
	General.heart_points = clamp(before + applied, 0.0, limit)
	health = General.heart_points
	alive = health > 0.0
	emit_signal("health_changed", health, max_hp)
	return health - before


func reset_health():
	max_hp = max(1.0, float(General.hp_max))
	General.heart_points = max_hp
	health = max_hp
	alive = true
	emit_signal("health_changed", health, max_hp)
	return health


func level_up():
	General.level_points += 1
	General.expirience_points = 0
	var particles = VFX_LEVEL_UP.instance()
	get_parent().add_child(particles)
	particles.emitting = true
	particles.one_shot = true
	particles.position = Vector2(global_position.x, global_position.y - 30)
	particles.z_index = 1


func heal(amount, source = null):
	if amount <= 0.0 or not alive:
		return 0.0
	var before = General.heart_points
	health_up(amount)
	return float(General.heart_points) - float(before)


func take_damage(amount_or_info, source = null, options = null):
	var info = _make_damage_info(amount_or_info, source, options)
	info.target = self
	if not alive or info.amount <= 0.0:
		return info
	if invulnerable and not info.ignore_invuln:
		info.blocked = true
		info.absorbed = info.amount
		emit_signal("damaged", info)
		return info
	if damage_cooldown > 0.0 and not info.ignore_cooldown:
		info.blocked = true
		info.absorbed = info.amount
		emit_signal("damaged", info)
		return info
	info = _before_damage(info)
	if info.blocked or info.amount <= 0.0:
		emit_signal("damaged", info)
		return info
	health_less(info.amount)
	info.applied = info.amount
	health = clamp(float(General.heart_points), 0.0, max_hp)
	alive = health > 0.0
	emit_signal("health_changed", health, max_hp)
	emit_signal("damaged", info)
	if not alive:
		info.killed = true
		emit_signal("died", info)
	return info
