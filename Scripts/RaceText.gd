extends Label

func _physics_process(delta):
	match General.race_number:
		0: text = "human"
		1: text = "vampire"
		2: text = "pilarmen"
		3: text = "evo pilarmen"
		4: text = "perfect creature"
		5: text = "cyborg"
