extends Node2D

var second_ts = 8

func restart():
	$AnimationPlayer.play("Start")
	visible = true
	if General.stand_number == 1:
		second_ts = 9
		yield(get_tree().create_timer(4), "timeout")
	if General.stand_number == 14:
		second_ts = 5
		yield(get_tree().create_timer(4), "timeout")
	if General.stand_number == 16:
		second_ts = 15
		yield(get_tree().create_timer(4), "timeout")
	elif General.stand_number == 2:
		second_ts = 5
		yield(get_tree().create_timer(4), "timeout")
	for sec in range(second_ts):
		yield(get_tree().create_timer(1), "timeout")
		second_ts -= 1
	$AnimationPlayer.play("End")
	
	
func _physics_process(delta):
	$Label.text = str(second_ts)
	
	if General.time_stop and $AnimationPlayer.current_animation == "":
		restart()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Start":
		$AnimationPlayer.play("Idle")
	if anim_name == "End":
		visible = false
