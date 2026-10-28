extends KinematicBody2D

var random = RandomNumberGenerator.new()
var velocity = Vector2( - 1, 0)
var speed = 10000
var start_position = Vector2.ZERO
var is_up = false
var VelocityDa = Vector2( - 1, 0)
var life_timer = Timer.new()

func _ready():
	
	life_timer.connect("timeout", self, "_on_life_timeout")
	life_timer.wait_time = 5.0
	life_timer.one_shot = true
	add_child(life_timer)
	life_timer.start()
	
	if "CutScene" in General.Addition:
		$Area2D / CollisionShape2D.scale.x *= 3
	General.arm_barrage_count += 1
	random.randomize()
	is_up = bool(random.randi_range(0, 1))
	
	if "CutScene" in General.Addition:
		is_up = true
	
	if is_up:
		z_index = 5
	else:
		z_index = 1

	if General.stand_number == 3 and General.stand_activated == true:
		if is_up:
			$Sprite.frame = 0
		else:
			$Sprite.frame = 1
	if General.stand_number == 1 and General.stand_activated == true:
		if is_up:
			$Sprite.frame = 2
		else:
			$Sprite.frame = 3
	if General.stand_number == 10 and General.stand_activated == true:
		if is_up:
			$Sprite.frame = 4
		else:
			$Sprite.frame = 5
	if General.stand_number == 2 and General.stand_activated == true:
		if is_up:
			$Sprite.frame = 6
		else:
			$Sprite.frame = 7
	if General.stand_number == 16 and General.stand_activated == true:
		if is_up:
			$Sprite.frame = 8
		else:
			$Sprite.frame = 9
	if General.stand_number == 18 and General.stand_activated == true:
		if is_up:
			$Sprite.frame = 10
		else:
			$Sprite.frame = 11
	if General.stand_number == 11 and General.stand_activated == true:
		if is_up:
			$Sprite.frame = 12
		else:
			$Sprite.frame = 13
	if General.stand_number == 22 and General.stand_activated == true:
		if is_up:
			$Sprite.frame = 14
		else:
			$Sprite.frame = 15
	if General.stand_number == 20 and General.stand_activated == true:
		if is_up:
			$Sprite.frame = 24
		else:
			$Sprite.frame = 25
	if General.stand_number == 26 and General.stand_activated == true:
		if is_up:
			$Sprite.frame = 22
		else:
			$Sprite.frame = 23
	if General.stand_number == 23 and General.stand_activated == true:
		if is_up:
			$Sprite.frame = 16
		else:
			$Sprite.frame = 17
	if General.stand_number == 24 and General.stand_activated == true:
		if is_up:
			$Sprite.frame = 18
		else:
			$Sprite.frame = 19
	if General.stand_number == 25 and General.stand_activated == true:
		if is_up:
			$Sprite.frame = 20
		else:
			$Sprite.frame = 21
	if General.stand_number == 27 and General.stand_activated == true:
		if is_up:
			$Sprite.frame = 27
		else:
			$Sprite.frame = 26
		
	yield(get_tree().create_timer(0.01), "timeout")
	
	var angle_radians: float = deg2rad(rotation_degrees)
	var vel = Vector2(cos(angle_radians), sin(angle_radians))
	
	if General.player_direct == "left":
		velocity = vel
		scale.x = - 1
		while global_position.x >= start_position.x:
			yield(get_tree().create_timer(0.1), "timeout")
		speed = 0
	else:
		velocity = vel
		scale.x = - 1
		while global_position.x <= start_position.x:
			yield(get_tree().create_timer(0.1), "timeout")
		speed = 0

func _physics_process(delta):
	move_and_slide(speed * velocity * delta * 2)

func _on_Area2D_area_entered(area):
	if area.is_in_group("Enemy"):
		General.SoundPlay("res://Music/PunchPopadanie.mp3")
		$ENEMY_PUNCH.play("DefaultPunch")
		$Area2D / CollisionShape2D.set_deferred("disabled", true)
		$Area2D / CollisionShape2D.disabled = true
		
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		
		var da = preload("res://Scenes/Effect.tscn").instance()
		get_parent().add_child(da)
		da.z_index = 99
		da.scale *= 1.5
		da.Play("HitWave")
		da.global_position = $Position2D.global_position
		
		
		queue_free()

func _on_life_timeout():
	
	if is_instance_valid(self):
		
		if General.arm_barrage_count > 0:
			General.arm_barrage_count -= 1
		queue_free()
