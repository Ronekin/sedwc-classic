extends KinematicBody2D

var black_hole = false
var velocity = Vector2(0, 1)
var direct = Vector2.ZERO
var speed = 10000
var vfx_spawn_hole = preload("res://Scenes/BlackHoleEffect.tscn")
var line = preload("res://Scenes/Line2D.tscn")

func _ready():
	$AUDIO.play("NailShoot")
	speed = 20000
	$Sprite.rotation_degrees = 270
	$CollisionArea / HitBox.set_deferred("disabled", true)
	black_hole = false
	$Sprite.frame = 0
	yield(get_tree().create_timer(0.2), "timeout")
	black_hole = true
	$AUDIO.play("BlackHole")
	speed = 0
	yield(get_tree().create_timer(0.1), "timeout")
	var inst_line = line.instance()
	inst_line.width = 5
	inst_line.leng = 25
	inst_line.default_color = Color(0, 0, 30 / 255)
	add_child(inst_line)
	var inst = vfx_spawn_hole.instance()
	inst.one_shot = true
	inst.global_position = $Sprite.global_position
	get_parent().add_child(inst)
	$Sprite.frame = 8
	$Sprite.rotation_degrees = 0
	$CollisionArea / HitBox.set_deferred("disabled", false)
	yield(get_tree().create_timer(0.5), "timeout")
	speed = 10000
	

func _physics_process(delta):
	direct = (General.enemy_position - global_position).normalized()
	if black_hole:
		move_and_slide(delta * speed * direct)
	else:
		move_and_slide(velocity * speed * delta)
		

func _on_CollisionArea_area_entered(area):
	if area.is_in_group("EnemyNiz"):
		queue_free()
