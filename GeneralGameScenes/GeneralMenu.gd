extends Node2D

func _ready():
	General.heart_points = General.hp_max
	General.all_damage_tren = 0
	General.is_saves_load = false
	$AudioStreamPlayer.play()
	$Book / GgSheet / hello.text = str(General.player_name)

func _on_GameButton_pressed():
	General.SoundPlay("res://Music/HitUI.mp3")
	$CameraAnimation.play("GameActivate")

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_CameraAnimation_animation_finished(anim_name):
	if anim_name == "Back":
		$CameraAnimation.play("Idle")

func _on_BackButton_pressed():
	General.SoundPlay("res://Music/HitUI.mp3")
	$CameraAnimation.play("Back")

func _on_ToturoalButton_pressed():
	Transition.change_scene("res://GeneralGameScenes/TutorialGeneral.tscn", "Black")


func _on_SettingsButton_pressed():
	Transition.change_scene("res://GeneralGameScenes/SettingsMenu.tscn", "Black")


func _on_DonatePage_pressed():
	General.SoundPlay("res://Music/HitUI.mp3")
	Transition.change_scene("res://Scenes/DonateShop.tscn", "Black")
func _on_Clicker_pressed():
	Transition.change_scene("res://GeneralGameScenes/ClickerPage.tscn", "Black")
	
func _on_Achievement_pressed():
	Transition.change_scene("res://GeneralGameScenes/Achievements.tscn", "Black")

