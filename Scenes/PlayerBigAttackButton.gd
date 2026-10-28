extends TouchScreenButton

signal big_attack_activate
var pressed_activate = false

func _physics_process(delta):





	if pressed_activate or ($Node2D / AnimationPlayer.current_animation in ["", "Idle"]) == false:
		$Icon.modulate = Color("828282")
	else:
		$Icon.modulate = Color("ffffff")
	if General.player_block_all:
		$Node2D / AnimationPlayer.playback_speed = 0
	else:
		$Node2D / AnimationPlayer.playback_speed = 1

func _on_TextureButton_pressed():
	if General.stable.find("hide") == - 1:
		pressed_activate = true
		if $Node2D / AnimationPlayer.current_animation != "KD" and General.attacked == false and General.dashed == false and General.player_block_all == false and General.dostup_combo:
			var player
			if get_tree().current_scene.name != "MorioMap":
				player = get_node("/root/" + get_tree().current_scene.name + "/YSorting/GGPlayer")
			elif get_tree().current_scene.name == "MorioMap":
				player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
			connect("big_attack_activate", player, "on_attack_activate_big")
			emit_signal("big_attack_activate")
			disconnect("big_attack_activate", player, "on_attack_activate_big")
	else:
		General.message_spawn("Center", "Вы не можете атаковать!")

func _on_TextureButton_released():
	pressed_activate = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "KD":
		$Node2D / AnimationPlayer.play("Idle")
	
	
	
	$Icon.scale = Vector2(0.75, 0.75)
	yield(get_tree().create_timer(0.05), "timeout")
	for i in 3:
		$Icon.scale += Vector2(0.09, 0.09)
		yield(get_tree().create_timer(0.05), "timeout")
	$Icon.scale = Vector2(0.95, 0.95)
	

func attack_kd_start():
	$Node2D / AnimationPlayer.play("KD")
