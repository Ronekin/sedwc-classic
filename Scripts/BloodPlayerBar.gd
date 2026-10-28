extends TextureProgress

func _physics_process(delta):
	visible = false
	value = General.blood
	max_value = 100
	$value.text = "кровь:" + str(General.blood) + "л"
	if General.race_number == 1:
		if General.stand_number == 1 and General.twoh_complete_quest["jesus"] == false:
			$value.text = "кровь: " + str(General.twoh_complete_quest["blood"]) + " л"
			value = General.twoh_complete_quest["blood"]
			max_value = 100
			visible = true
		else:
			visible = false
