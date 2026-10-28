extends Label

func _physics_process(delta):
	text = "Общий урон: " + str(General.all_damage_tren)
func _ready():
	General.all_damage_tren = 0
