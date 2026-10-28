extends Control

var Stage: int







func _ready():
	$Text.text = ""
	$Sprite.visible = false
	if Stage == Stage:
		if Stage <= General.tournir_record:
			if Stage % 10 == 0:
				$NextFloorBranch.visible = true
			else:
				$ColorRect.visible = true
		elif Stage > General.tournir_record + 1: modulate = Color("818181")

		if Stage % 5 == 0:
			$Sprite.visible = true
			$Text.visible = false
		else: $Text.text = str(Stage)
	else: $Text.text = str(Stage)
		
	if Stage == General.tournir_record:
		$Text.text += "\nрекорд"
		$Text.visible = true
	elif Stage == General.LastToutnamentLvl:
		$Text.text += "\nlast"
		$Text.visible = true



func _process(delta):
	if General.tournament_lvl == Stage and $StandSlotPanelIcon.rotation_degrees == 0:
		$AnimationPlayer.play("Select")
	elif General.tournament_lvl != Stage and $StandSlotPanelIcon.rotation_degrees == 45:
		$AnimationPlayer.play("Unselect")



func Pressed():
	General.SoundPlay("res://Music/HitUI.mp3")
	
	
	$"../../../EnemyFastInfo".visible = true
	$"../../../EnemyFastInfo".rect_global_position = rect_global_position + Vector2(50, - 50)
	
	var DopData = General.GetTournamentEnemy(Stage)
	$"../../../EnemyFastInfo/Node2D/EnemyTexture".texture = load(DopData["texture"])
	$"../../../EnemyFastInfo/Node2D/EnemyTexture".hframes = DopData["hframes"]
	$"../../../EnemyFastInfo/Node2D/EnemyTexture".vframes = DopData["vframes"]
	
	$"../../../EnemyFastInfo/Node2D/Name".text = ""
	
	if DopData["type"] != "Classic": $"../../../EnemyFastInfo/Node2D/Name".text += DopData["type"] + " "
	if DopData["version"] != "Normal": $"../../../EnemyFastInfo/Node2D/Name".text += "ист."
	$"../../../EnemyFastInfo/Node2D/Name".text += DopData["name"] + "\n"
	$"../../../EnemyFastInfo/Node2D/Name".text += "HP: " + str(DopData["hp"])
	
	
	$"../../../EnemyFastInfo/AnimationPlayer".play("Show")
	$"../../../EnemyFastInfo/AnimationPlayer".seek(0)
	
	
	
	
	if ((int(float(Stage - 1) * 0.1) * 10) + 1) <= General.tournir_record + 1:
		if (Stage == General.LastToutnamentLvl + 1): General.tournament_lvl = Stage
		else:
			General.tournament_lvl = ((int(float(Stage - 1) * 0.1) * 10) + 1)
			if ((int(float(Stage - 1) * 0.1) * 10) + 1) != Stage and General.LastToutnamentLvl + 1 <= Stage and General.LastToutnamentLvl + 1 > General.tournament_lvl and ((int(float(General.LastToutnamentLvl) * 0.1) * 10) + 1) == ((int(float(Stage - 1) * 0.1) * 10) + 1):
				General.tournament_lvl = General.LastToutnamentLvl + 1
