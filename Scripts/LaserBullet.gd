extends KinematicBody2D

var velocity = Vector2(0, 1)
var direct = Vector2.ZERO
var back = false
var speed = 20000

func _ready():
	if $EnemyCheck.is_in_group("SpinBall"):
		$EnemyCheck.remove_from_group("SpinBall")
	$EnemyCheck.add_to_group("LaserBullet")
	$PlayerCheclk / CollisionShape2D.set_deferred("disabled", true)
	while General.time_stop:
		yield(get_tree().create_timer(0.1), "timeout")
	speed = 20000
	back = false
	yield(get_tree().create_timer(2), "timeout")
	while General.time_erase:
		yield(get_tree().create_timer(0.1), "timeout")
	back = false
	$PlayerCheclk / CollisionShape2D.set_deferred("disabled", false)
	
func _physics_process(delta):
	direct = ((General.player_pos - Vector2(0, 25)) - global_position).normalized()
	if back == false:
		if General.time_stop == false:
			move_and_slide(velocity * speed * delta * General.enemy_time_scale)
			$AnimationPlayer.playback_speed = 1
		else:
			$AnimationPlayer.playback_speed = 0
	else:
		if General.time_stop == false:
			move_and_slide(speed * delta * direct * General.enemy_time_scale)
			$AnimationPlayer.playback_speed = 1
		else:
			$AnimationPlayer.playback_speed = 0

func _on_PlayerCheclk_area_entered(area):
	if area.is_in_group("ItemBox") and back:
		while General.time_stop:
			yield(get_tree().create_timer(0.1), "timeout")
		yield(get_tree().create_timer(0.05), "timeout")
		queue_free()

func _on_EnemyCheck_area_entered(area):
	if area.is_in_group("Enemy"):
		queue_free()
		
