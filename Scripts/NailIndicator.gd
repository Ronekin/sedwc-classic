extends GridContainer

func _physics_process(delta):
	if General.stand_index == "TuskAct1" or General.stand_index == "TuskAct2" or General.stand_index == "TuskAct3" or General.stand_index == "TuskAct4":
		visible = true
	else:
		visible = false
	
	if General.tea_timer.is_stopped():
		$Particles2D.visible = false
	else:
		$Particles2D.visible = true
