extends TouchScreenButton

signal attack_activate
var pressed_activate = false

func _physics_process(delta):
	if General.default_attack_count >= 5:
		if General.stand_number == 6:
			$Node2D / AnimationPlayer.play("KD_EhosAct1")
		else:
			$Node2D / AnimationPlayer.play("KD_3AttackCount")
		General.default_attack_count = 0
	if pressed_activate or ($Node2D / AnimationPlayer.current_animation in ["", "Idle"]) == false:
		$AttackButton.modulate = Color("828282")
	else:
		$AttackButton.modulate = Color("ffffff")





	if General.player_block_all:
		$Node2D / AnimationPlayer.playback_speed = 0
	else:
		$Node2D / AnimationPlayer.playback_speed = 1

func _on_TextureButton_pressed():
	if General.stable.find("hide") == - 1:
		pressed_activate = true
		if $Node2D / AnimationPlayer.current_animation.find("KD") == - 1 and General.attacked == false and General.dashed == false and General.player_block_all == false:
			var player
			if get_tree().current_scene.name != "MorioMap":
				player = get_node("/root/" + get_tree().current_scene.name + "/YSorting/GGPlayer")
			elif get_tree().current_scene.name == "MorioMap":
				player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
			connect("attack_activate", player, "on_attack_activate")
			emit_signal("attack_activate")
			disconnect("attack_activate", player, "on_attack_activate")
	else:
		General.message_spawn("Center", "Вы не можете атаковать!")
func _on_TextureButton_released():
	pressed_activate = false

func _on_AnimationPlayer_animation_finished(anim_name):
	
	
	
	
	
	if anim_name == "KD_EhosAct1" or anim_name == "KD_3AttackCount":
		$Node2D / AnimationPlayer.play("Idle")
	
	if anim_name.find("KD") != - 1:
		$AttackButton.scale = Vector2(0.75, 0.75)
		yield(get_tree().create_timer(0.05), "timeout")
		for i in 3:
			$AttackButton.scale += Vector2(0.09, 0.09)
			yield(get_tree().create_timer(0.05), "timeout")
		$AttackButton.scale = Vector2(0.95, 0.95)
	
	
