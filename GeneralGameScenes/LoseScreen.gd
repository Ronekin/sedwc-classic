extends Node2D

func _ready():
	if not ("deaths" in General.player_statistic): General.player_statistic["deaths"] = 0
	General.player_statistic["deaths"] += 1
	General.AchievementGive(10)
	
	if General.player_statistic["deaths"] >= 10: General.AchievementGive(11)
	if General.player_statistic["deaths"] >= 50: General.AchievementGive(12)
	if General.player_statistic["deaths"] >= 100: General.AchievementGive(13)
	if General.player_statistic["deaths"] >= 1000: General.AchievementGive(14)
	
	General.save_save()

func _input(event):
	
	if (event is InputEventScreenTouch):

		General.toGameGeneral()
		GeneralMusicPlayer.theme_resong("MorioMap")
		GeneralMusicPlayer.stream_paused = true
		if General.EnemyName == "luka":
			if General.money > 1000:
				General.money -= 500
			else:
				General.money -= General.money / 2.0

