extends TouchScreenButton

signal dash_activate
var speed_boost = 1
var pressed_activate = false
var player

func _physics_process(delta):
		
	if get_tree().current_scene.name != "MorioMap":
				player = get_node("/root/" + get_tree().current_scene.name + "/YSorting/GGPlayer")
				if player == null:
					player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
	elif get_tree().current_scene.name == "MorioMap":
			player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
	if General.current_support["Name"] == "Pucci":
		speed_boost = 1.5




	
	if General.player_block_all:
		$Node2D / AnimationPlayer.playback_speed = 0 * speed_boost
	else:

		$Node2D / AnimationPlayer.playback_speed = 1 * speed_boost
		if General.stand_number == 23:
			$Node2D / AnimationPlayer.playback_speed *= 2.0

func _on_TouchScreenButton_pressed():
	pressed_activate = true
	if $Node2D / AnimationPlayer.current_animation != "KD" and General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.dialog_activate == false and General.is_invent_show == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false:

		connect("dash_activate", player, "on_dash_activate")
		emit_signal("dash_activate")
		disconnect("dash_activate", player, "on_dash_activate")
		

func _on_TouchScreenButton_released():
	pressed_activate = false

func kd_dash_start():
	$Node2D / AnimationPlayer.play("KD")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "KD":
		player.dash_kuldown.stop()
		$Node2D / AnimationPlayer.play("Idle")
