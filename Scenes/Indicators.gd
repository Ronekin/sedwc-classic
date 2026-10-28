extends Control







func _ready():
	pass



func _process(delta):
	if $Right / Nails.visible: $Right / Balls.rect_position = Vector2(197, 6)
	else: $Right / Balls.rect_position = Vector2(197, - 28)
	
	$Left / VBoxContainer / TrainingDamage.visible = get_tree().current_scene.name == "TrainingArena"
	
	if "Rage" in General.Stats:
		$Left / VBoxContainer / TextureProgress.visible = true
		$Left / VBoxContainer / TextureProgress.value = General.Addition["Rage"]
		$Left / VBoxContainer / TextureProgress / value.text = "ярость: " + str(stepify(General.Addition["Rage"], 1)) + "%"
		$Left / VBoxContainer / TextureProgress.max_value = 100
		$Left / VBoxContainer / TextureProgress.self_modulate = Color("ff4900")
	elif "VB" in General.Stats:
		$Left / VBoxContainer / TextureProgress.self_modulate = Color("ff4900")
		$Left / VBoxContainer / TextureProgress.visible = true
		$Left / VBoxContainer / TextureProgress.value = General.Addition["Blood"] * 5.0
		$Left / VBoxContainer / TextureProgress / value.text = "кровь: " + str(stepify(General.Addition["Blood"], 0.1)) + " л"
		$Left / VBoxContainer / TextureProgress.max_value = 100
		if General.Addition["Blood"] > 0:
			if General.Addition["Blood"] > 20.0: General.Addition["Blood"] = 20.0
			if (General.Stats["VB"] < 2 or ("RegenVamp" in General.Addition)) and General.heart_points < General.hp_max:
				if General.Stats["VB"] == 2:
					General.heart_points += delta * 5.0 * 1.5
					General.Addition["Blood"] -= delta * 5.0
				elif General.Stats["VB"] == 1:
					General.heart_points += delta * 0.6 * 1.5
					General.Addition["Blood"] -= delta * 0.6
				else:
					General.heart_points += delta * 0.4
					General.Addition["Blood"] -= delta * 0.4
		else: General.Addition["Blood"] = 0.0
		
	elif ("C_Volume" in General.Stats) and General.Stats["C_Volume"] != 0:
		$Left / VBoxContainer / TextureProgress.self_modulate = Color("18ff00")
		$Left / VBoxContainer / TextureProgress.visible = true
		$Left / VBoxContainer / TextureProgress.value = General.Addition["C_Charge"]
		$Left / VBoxContainer / TextureProgress.max_value = General.Stats["C_Volume"]
		$Left / VBoxContainer / TextureProgress / value.text = "энергия: " + str(stepify(General.Addition["C_Charge"], 0.1)) + " гдж"
		if (General.Addition["C_Charge"] < General.Stats["C_Volume"]) and (General.Addition["C_Battery"] > 0.0):
			var drain = delta * General.Stats["C_ChargeSpeed"]
			General.Addition["C_Charge"] = min(General.Stats["C_Volume"], General.Addition["C_Charge"] + drain)
			General.Addition["C_Battery"] = max(0.0, General.Addition["C_Battery"] - drain)
		
		if General.Addition["C_Charge"] > 0:
			if General.Addition["C_Charge"] > General.Stats["C_Volume"]: General.Addition["C_Charge"] = General.Stats["C_Volume"]
			
		else: General.Addition["C_Charge"] = 0.0
		





	else: $Left / VBoxContainer / TextureProgress.visible = false


	if "C_max_bullets" in General.Stats and General.Stats["C_max_bullets"] != 0:
		$Left / VBoxContainer / TextureProgress3.visible = true
		$Left / VBoxContainer / TextureProgress3.value = General.Addition["C_bullets"]
		$Left / VBoxContainer / TextureProgress3.max_value = General.Stats["C_max_bullets"]
		$Left / VBoxContainer / TextureProgress3 / value.text = "патроны: " + str(stepify(General.Addition["C_bullets"], 0.1)) + ""
		
		

