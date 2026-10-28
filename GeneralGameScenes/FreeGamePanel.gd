extends Control

export var type = 0

func _ready():
	match type:
		0:
			$SelectGame.frame = 0
			$Texture / Label.text = "свободная"
			$Texture / Label2.text = "игра"
		1:
			$SelectGame.frame = 1
			$Texture / Label.text = "тренирочный"
			$Texture / Label2.text = "режим"
		2:
			$SelectGame.frame = 3
			$Texture / Label.text = "гладиаторский"
			$Texture / Label2.text = "турнир"
		3:
			$SelectGame.frame = 2
			$Texture / Label.text = "редактор"
			$Texture / Label2.text = "режимов"
func _on_Texture_pressed():
	General.SoundPlay("res://Music/HitUI.mp3")
	match type:
		0:
			General.toGameGeneral("Black", true)


			GeneralMusicPlayer.theme_resong("MorioMap")
		1:
			Transition.change_scene("res://GeneralGameScenes/TrainingArena.tscn", "Black")
			GeneralMusicPlayer.theme_resong("TrainingArena")
		2:
			Transition.change_scene("res://GeneralGameScenes/TournirSelected.tscn", "Black")

		3:
			General.toGameGeneral("Black", true)
			Transition.change_scene("res://GeneralGameScenes/CustomGameMenu.tscn", "Black")
			GeneralMusicPlayer.theme_resong("MorioMap")
