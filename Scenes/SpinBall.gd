extends KinematicBody2D

var velocity = Vector2(0, 1)
var direct = Vector2.ZERO
var back = false
var speed = 20000
var Popal = false
var Spin = 0.0
var Enemy
var punches = 15
var timer = 0.0
var type = 0
var skin_id = 0
var current_skin = General.choose_skins["spin"]
var ball_returned = false
var is_following_enemy = false
var follow_offset = Vector2.ZERO

func _ready():
	General.count = 5
	
	if not is_instance_valid(get_node("/root/" + get_tree().current_scene.name + "/YSorting/Enemy")):
		queue_free()
		return
	Enemy = get_node("/root/" + get_tree().current_scene.name + "/YSorting/Enemy")
	
	$Sprite.z_index = 15
	Spin = General.Addition["spin"]
	if current_skin == "default":
		skin_id = 0
	elif current_skin == "gold":
		skin_id = 2
	elif current_skin == "caramel":
		skin_id = 4
	if General.techic_number == 2:
		speed = 30000
		$Sprite.frame = skin_id + 1
		if type == 0:
			$Sprite.frame = skin_id
			if General.count > 0:
				$EnemyCheck.remove_from_group("SpinBall")
				$EnemyCheck.add_to_group("InfBalll")
			else:
				$EnemyCheck.add_to_group("SpinBall")
				$EnemyCheck.remove_from_group("InfBalll")
		$Line2D.default_color = Color("fff9c7")
		
		if randf() > 0.5:
			for i in 7:
				velocity.y = 0.6
				yield(get_tree().create_timer(0.03), "timeout")
		else:
			for i in 7:
				velocity.y = - 0.6
				yield(get_tree().create_timer(0.03), "timeout")
	else:
		speed = 20000
		$Sprite.frame = skin_id
		$EnemyCheck.add_to_group("SpinBall")
		$EnemyCheck.remove_from_group("InfBalll")
		$Sprite.frame = skin_id

	$PlayerCheclk / CollisionShape2D.set_deferred("disabled", true)
	$Line2D.leng /= General.enemy_time_scale
	while General.time_stop:
		yield(get_tree().create_timer(0.1), "timeout")
	
	back = false
	yield(get_tree().create_timer(2), "timeout")
	while General.time_erase:
		yield(get_tree().create_timer(0.1), "timeout")
	back = true
	$PlayerCheclk / CollisionShape2D.set_deferred("disabled", false)

func _return_ball():
	if ball_returned:
		return
	ball_returned = true
	
	for i in General.Addition["balls"].size():
		if General.Addition["balls"][i] == false:
			General.Addition["balls"][i] = true
			General.SoundPlay("res://Music/BallTake.mp3", {"Volume_db": 5})
			break

func _physics_process(delta):
	
	if is_following_enemy and is_instance_valid(Enemy):
		global_position = Enemy.global_position + follow_offset
		$AnimationPlayer.playback_speed = Spin / 70.0
		return
	
	if not is_instance_valid(Enemy):
		_return_ball()
		queue_free()
		return
	
	direct = ((General.player_pos - Vector2(0, 35)) - global_position).normalized()
	var ugol = rad2deg(velocity.angle())
	var direct_to_enemy = rad2deg(((Enemy.global_position - Vector2(0, 25)) - global_position).normalized().angle())
	
	timer += delta
	if General.techic_number == 2:
		var da = 1.0
		var dist = global_position.distance_to(Enemy.global_position)
		if dist < 300 and dist > 0:
			da += ((300 / dist) - 1) / 2
		
		timer = 0.0
		ugol = deg2rad(approach_angle(ugol, direct_to_enemy, delta * 300.0 * da))
		velocity = Vector2(cos(ugol), sin(ugol))
	
	if back == false:
		if General.time_stop == false:
			move_and_slide(velocity * speed * delta * General.enemy_time_scale)
			$AnimationPlayer.playback_speed = Spin / 70.0
		else:
			$AnimationPlayer.playback_speed = 0
	else:
		if General.time_stop == false:
			move_and_slide(speed * delta * direct * General.enemy_time_scale)
			$AnimationPlayer.playback_speed = Spin / 70.0
		else:
			$AnimationPlayer.playback_speed = 0

func _on_PlayerCheclk_area_entered(area):
	if area.is_in_group("ItemBox") and back:
		for i in General.Addition["balls"].size():
			if General.Addition["balls"][i] == false:
				General.Addition["balls"][i] = true
				General.SoundPlay("res://Music/BallTake.mp3", {"Volume_db": 5})
				break

		z_index = 4
		while General.time_stop:
			yield(get_tree().create_timer(0.1), "timeout")
		speed *= 0.2
		var da = global_position
		get_parent().remove_child(self)
		area.get_parent().add_child(self)
		global_position = da
		$AnimationPlayer2.play("Hide")
		if Spin > 0:
			for i in $Line2D.leng:
				if $Line2D.leng > 1:
					$Line2D.leng -= 1
				yield(get_tree().create_timer(0.03), "timeout")
		queue_free()

func _on_EnemyCheck_area_entered(area):
	if area.is_in_group("Enemy") and Popal == false:
		speed = 0
		Popal = true
		
		
		is_following_enemy = true
		follow_offset = global_position - Enemy.global_position
		
		var Player = get_node("/root/" + get_tree().current_scene.name + "/YSorting/GGPlayer")
		if is_instance_valid(Player):
			Player.CameraShake(0.07 * ((Spin) / 4.0), 10, 70)
		
		if Spin > 10:
			General.SoundPlay("res://Music/BigPunchEffect.mp3")
			General.SoundPlay("res://Music/SpinSoundDefense.mp3", {"Volume_db": 0})
		else:
			General.SoundPlay("res://Music/PunchPopadanie.mp3")
		
		z_index = 99
		
		$Line2D.leng = 60
		for i in int(max(1, Spin / 4.0)):
			wave()
			yield(get_tree().create_timer(0.1), "timeout")
			
		$Line2D.leng = 25
		
		
		is_following_enemy = false
		
		if Spin > 5:
			yield(get_tree().create_timer(0.5), "timeout")
			speed = 20000
			back = true
		else:
			back = true
			var x_m = 1
			if is_instance_valid(Player) and global_position.x > Player.global_position.x:
				x_m = - 1
			Spin = - 20
			for i in 10:
				global_position += Vector2(x_m * 2, 4)
				yield(get_tree().create_timer(0.02), "timeout")
			for i in 19:
				global_position += Vector2(x_m * 1, 0.5)
				yield(get_tree().create_timer(0.02), "timeout")
			$EnemyCheck.remove_from_group("InfBalll")
			Spin = 0

func wave():
	var da = Sprite.new()
	da.texture = load("res://Textures/Details/wave.png")
	da.scale *= 0
	add_child(da)
	da.rotation_degrees = rand_range(0, 360)
	for i in 10:
		da.scale += Vector2(0.01, 0.02) * 14
		da.modulate.a -= 0.1
		yield(get_tree().create_timer(0.04), "timeout")
	da.queue_free()

func approach_angle(current_angle: float, target_angle: float, step_degrees: float) -> float:
	current_angle = fmod(current_angle, 360)
	target_angle = fmod(target_angle, 360)

	var diff = fmod(target_angle - current_angle, 360)
	if diff > 180:
		diff -= 360
	elif diff < - 180:
		diff += 360

	if abs(diff) < step_degrees:
		return target_angle
	elif diff > 0:
		return fmod(current_angle + step_degrees, 360)
	else:
		return fmod(current_angle - step_degrees, 360)

func _exit_tree():
	if not ball_returned and not Popal:
		_return_ball()
