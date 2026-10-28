extends Node2D

var random_spin_timer = [0.25, 0.35, 0.45, 0.55, 0.65, 0.75]
var number = General.mini_game_second_number - General.mini_game_first_number

func _physics_process(delta):
	number = General.mini_game_second_number - General.mini_game_first_number
	if General.search_id(3.2) != - 1:
		$BG.frame = 1
		$Center.frame = 1
	if General.search_id(3.3) != - 1:
		$BG.frame = 0
		$Center.frame = 0
	$BG.rotation_degrees = (General.mini_game_second_number - (General.mini_game_second_number - General.mini_game_first_number - 0.1)) * 360
	if General.signal_reset_spin_bar_lesson:
		visible = true
		$AnimationPlayer.stop()
		$AnimationPlayer.play_backwards("Start")
		$AnimationPlayer.play("Start")
		General.signal_reset_spin_bar_lesson = false
	if $AnimationPlayer.is_playing() == false or General.timer_spin.is_stopped():
		visible = false
		General.mini_game_activate = false
		General.mini_game_first_number = 0
		General.mini_game_second_number = 0
		
