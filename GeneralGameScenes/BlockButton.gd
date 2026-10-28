extends TouchScreenButton

signal block_activate
var button_pressed = false

func _physics_process(delta):
	if General.player_block_all:
		$Node2D / AnimationPlayer.playback_speed = 0
	else:
		$Node2D / AnimationPlayer.playback_speed = 1
	
	if General.block_glush.is_stopped() == false and $Node2D / AnimationPlayer.current_animation != "KD":
		$Node2D / AnimationPlayer.play("KD")
	if button_pressed and General.blocked == false:
		if $Node2D / AnimationPlayer.current_animation != "KD" and General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false:
			var player
			if get_tree().current_scene.name != "MorioMap":
				player = get_node("/root/" + get_tree().current_scene.name + "/YSorting/GGPlayer")
				if player == null:
					player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
			elif get_tree().current_scene.name == "MorioMap":
				player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
			connect("block_activate", player, "block")
			emit_signal("block_activate")
			disconnect("block_activate", player, "block")




	if button_pressed:
		$BlockButton.modulate = Color("828282")
	else:
		$BlockButton.modulate = Color("ffffff")
func _on_TouchScreenButton2_pressed():
	button_pressed = true

func _on_TouchScreenButton2_released():
	button_pressed = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "KD":
		$Node2D / AnimationPlayer.play("Idle")
