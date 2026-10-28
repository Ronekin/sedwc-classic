extends Control


func _on_Texture_pressed():
	Transition.change_scene("res://GeneralGameScenes/TrainingArena.tscn", "Black")
	GeneralMusicPlayer.theme_resong("TrainingArena")
