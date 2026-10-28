extends Label

func _physics_process(delta):
	match General.techic_number:
		0: text = "Combat"
		1: text = "Spin"
		2: text = "Perfect Spin"
		3: text = "Combat Master"
		4: text = "Vampire(Dio)"
		5: text = "Pilarmen(Kars)"
		6: text = "SwordMaster"
		
