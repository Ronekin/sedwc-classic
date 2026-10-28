extends TextureButton

var id: int = - 1

func _ready():
	while acs.achievements.size() == 0:
		yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	rect_scale = Vector2(0.94, 0.94)
	id = int(name.substr(11))
	
	
	acs.achievements[id]
	$Name.text = acs.achievements[id]["name"]
	$Descrip.text = acs.achievements[id]["description"]
	$AchieveIcon.frame = id


	if not acs.achievements[id]["completed"]:
		var Kills: int = 0
		if "kills" in General.player_statistic: Kills = General.player_statistic["kills"]

		var Deaths: int = 0
		if "deaths" in General.player_statistic: Deaths = General.player_statistic["deaths"]

		var Arrows: int = 0
		if "arrows_used" in General.player_statistic: Arrows = General.player_statistic["arrows_used"]
		
		var Condition: Array
		match id:
			1: Condition = [Kills, 5]
			2: Condition = [Kills, 50]
			3: Condition = [Kills, 100]
			4: Condition = [Kills, 1000]
			6: Condition = [General.play_time, 600]
			7: Condition = [General.play_time, 3000]
			8: Condition = [General.play_time, 6000]
			9: Condition = [General.play_time, 15000]
			38: Condition = [General.play_time, 60000]
			11: Condition = [Deaths, 10]
			12: Condition = [Deaths, 50]
			13: Condition = [Deaths, 100]
			14: Condition = [Deaths, 1000]
			15: Condition = [General.money, 10000]
			16: Condition = [General.money, 25000]
			17: Condition = [General.money, 100000]
			18: Condition = [General.money, 250000]
			19: Condition = [General.money, 1000000]
			31: Condition = [General.ItemCount(5), 50]
			35: Condition = [Arrows, 1000]
			37: Condition = [General.tournir_record, 100]
			_: Condition = [0, 1]
		$Claim2.text = str(Condition[0]) + "/" + str(Condition[1])

		$TextureProgress.value = Condition[0]
		$TextureProgress.max_value = Condition[1]



	else:
		$Claim2.text = "Выполнено"
