extends Control

onready var qa = preload("res://Scenes/Q_A.tscn")
onready var gui = get_node("/root/" + get_tree().current_scene.name + "/GUI")

func _ready():
	$TouchScreenButton / Label.text = "сохраниться"
	$AnimationPlayer.play("Idle")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Back":
		queue_free()
		General.settings_activate = false
		General.player_block_all = false

func _on_TouchScreenButton2_released():
	if General.qa_activate == false:
		$AnimationPlayer.play("Back")

func _on_TouchScreenButton4_released():
	if General.qa_activate == false:
		General.player_pos_save = General.player_pos
		General.qa_activate = true
		General.last_scene = "MorioMap"
		Transition.change_scene("res://Scenes/Q_A.tscn", "Black")

func _on_TouchScreenButton5_pressed():
	General.player_pos_save = General.player_pos
	General.last_scene = "MorioMap"
	Transition.change_scene("res://Scenes/GameSettings.tscn", "Black")

func _on_TouchScreenButton_pressed():
	if $TouchScreenButton / Label.text == "сохраниться":
		General.save_save()
		$TouchScreenButton / Label.text = "сохранено!"

func _on_MenuButton_pressed():
	if get_tree().current_scene.name == "MorioMap":
		General.save_save()
	Transition.change_scene("res://GeneralGameScenes/GeneralMenu.tscn", "Black")

func _on_AudioButton_pressed():
	General.player_pos_save = General.player_pos
	General.last_scene = "MorioMap"
	Transition.change_scene("res://Scenes/AudioSettings.tscn", "Black")
