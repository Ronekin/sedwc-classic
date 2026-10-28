# GeneralProcessService.gd — покадровые проверки General.
#
# Контракт: process() получает General и обновляет таймер достижений,
# статистику и глобальные переключатели. Тяжёлую логику держите в профильных
# сервисах, а не в _process() автолоада.

extends Reference


func process(general, delta):
	general.TimerDa += delta
	if general.TimerDa >= 2:
		general.TimerDa = 0
		
		
		if "arrows_used" in general.player_statistic:
			if general.player_statistic["arrows_used"] >= 1000: general.AchievementGive(35)
		
		
		
		if general.money >= 10000: general.AchievementGive(15)
		if general.money >= 25000: general.AchievementGive(16)
		if general.money >= 100000: general.AchievementGive(17)
		if general.money >= 250000: general.AchievementGive(18)
		if general.money >= 1000000: general.AchievementGive(19)

		if general.ItemCount(5) >= 50:
			general.AchievementGive(31)
		if general.current_scene_name != "TrainingArena" and general.stand_number != 0: general.AchievementGive(32)
		
	
	
	
	

	
	
	
	if ("slow" in general.other_save) == false: general.other_save["slow"] = []

	if general.techic_number in [2, 1]:
		if not ("balls" in general.Addition):
			general.Addition["balls"] = [true, true]
	

	if Input.is_action_just_pressed("F11"):

		OS.window_fullscreen = not OS.window_fullscreen
