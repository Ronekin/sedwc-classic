extends AnimationPlayer

onready var time_erase = preload("res://Scenes/KingCrimsonEffectTimeErase.tscn")

func _physics_process(delta):
	if General.time_erase and current_animation.find("TimeErase") == - 1:
		play("TimeEraseStart")
		yield(get_tree().create_timer(1.2), "timeout")
		var time_erase_inst = time_erase.instance()
		get_parent().get_parent().add_child(time_erase_inst)
	if General.time_erase == false and (current_animation == "TimeEraseMid" or current_animation == "TimeEraseStart"):
		var time_erase_inst = time_erase.instance()
		play("TimeEraseEnd")
		get_parent().get_parent().add_child(time_erase_inst)
	if General.time_stop and current_animation.find("TheWorld") == - 1:
		var animation = get_animation("TheWorldZoom")
		animation.track_set_key_value(0, 0, General.camera_scale)
		animation.track_set_key_value(0, 1, General.camera_scale + Vector2(0.5, 0.5))
		animation.track_set_key_value(0, 2, General.camera_scale + Vector2(0.5, 0.5))
		animation.track_set_key_value(0, 3, General.camera_scale)
		play("TheWorldZoom")
		General.player_block_all = true
	if General.time_stop == false and current_animation == "TheWorldTSIdle":
		var animation = get_animation("TheWorldZoomEnd")
		animation.track_set_key_value(0, 0, General.camera_scale)
		play("TheWorldZoomEnd")
		General.glush_enemy_timer.wait_time = 1.5
		General.glush_enemy_timer.one_shot = true
		General.timer_service.ensure_autoload_timer(General, General.glush_enemy_timer)
		General.glush_enemy_timer.start()

func _on_GeneralEffectAnimaion_animation_finished(anim_name):
	if anim_name == "TimeEraseStart":
		play("TimeEraseMid")
	if anim_name == "TheWorldZoom" and General.time_stop:
		var animation = get_animation("TheWorldTSIdle")
		General.player_block_all = false
		animation.track_set_key_value(0, 0, General.camera_scale)
		play("TheWorldTSIdle")
