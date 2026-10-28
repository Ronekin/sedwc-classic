extends KinematicBody2D
var scale_x = true
var speed = 1.0






func _ready():
	pass



func _process(delta):

	var direction = (General.enemy_position - global_position).normalized()
	if $AnimationPlayer.current_animation != "ScorpioSpawn":
		move_and_slide(direction * 100 * speed)
	var right = direction.x >= 0
	if not right and scale_x:
		scale_x = false
		scale.x *= - 1
	elif right and not scale_x:
		scale_x = true
		scale.x *= - 1

func _on_Area2D_area_entered(area):
	if area.is_in_group("Enemy"):
		
		speed = 0.5
		$Area2D.queue_free()
		$AnimationPlayer.play("ScorpioAttack")
		yield(get_tree().create_timer(0.3), "timeout")
		queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "ScorpioSpawn":
		$AnimationPlayer.play("ScorpioWalk")
