extends KinematicBody2D

var velocity: Vector2 = Vector2(0, 0)
export var speed: float = 1.0
onready var random: RandomNumberGenerator = RandomNumberGenerator.new()
var Type: int

func _ready():
	yield(get_tree().create_timer(5), "timeout")
	while General.time_stop:
		yield(get_tree().create_timer(0.1), "timeout")
	yield(get_tree().create_timer(5), "timeout")
	queue_free()

func BulletSet(TypeDa: int):
	Type = TypeDa
	for i in $Area2D.get_groups():
		if $Area2D.is_in_group(i):
			$Area2D.remove_from_group(i)
	if TypeDa == 1:
		$Area2D.add_to_group("BulletEnemy")
		$Sprite.frame = 1
		speed = 1.7
	elif TypeDa == 2:
		$Area2D.add_to_group("EnemyBall")
		$Sprite.frame = 2
		speed = 1.4
	elif TypeDa == 3:
		$Area2D.add_to_group("BulletEnemy")
		$Sprite.frame = 3
		speed = 0.8



				

func _physics_process(delta):
	if Type == 2: $Sprite.rotation_degrees += 270 * delta
	
	$Sprite.rotation_degrees = rad2deg(atan2(velocity.y, velocity.x))
	
	if General.time_stop == false:
		move_and_slide(velocity * speed * 50000 * delta * General.enemy_time_scale / General.mih_speed)

func _on_Area2D_area_entered(area):
	if area.is_in_group("ItemBox") and General.time_stop == false and General.time_erase == false:
		if Type == 2:
			if randf() > 0.5:
				General.SoundPlay("res://Music/GyroHeheheheVoice.mp3", {"Volume_db": 8})
			else:
				General.SoundPlay("res://Music/GyroNyoHo.mp3", {"Volume_db": 9})
			var Y_Save = global_position.y
			speed = 0
			get_parent().remove_child(self)
			area.get_parent().add_child(self)
			global_position.y = Y_Save
			position.x = 0
			z_index = 99
			
			
			for i in 20:
				wave()
				yield(get_tree().create_timer(0.1), "timeout")
			yield(get_tree().create_timer(0.9), "timeout")
		if Type == 3:
			General.SoundPlay("res://Music/Explosion0.mp3", {"Volume_db": 8})

			
			var da = preload("res://Scenes/Explosion.tscn")
			get_parent().add_child(da)
			da.global_position = global_position
			
			position.x = 0
			da.z_index = 99

		queue_free()

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
