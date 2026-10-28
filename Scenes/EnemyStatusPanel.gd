extends Panel

func _ready():
	name = "Sprite" + str(get_parent().get_child_count())
	if General.enemy_panel_status.size() >= int(name.substr(6)):
		$Sprite.frame = General.enemy_panel_status[int(name.substr(6)) - 1]
	else:
		queue_free()
	
func _physics_process(delta):
	if General.enemy_panel_status.size() >= int(name.substr(6)):
		$Sprite.frame = General.enemy_panel_status[int(name.substr(6)) - 1]
	else:
		queue_free()
