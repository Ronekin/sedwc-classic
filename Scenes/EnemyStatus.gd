extends GridContainer

var panel_preload = preload("res://Scenes/EnemyStatusPanel.tscn")

func _physics_process(delta):
	if General.enemy_current_status != General.enemy_panel_status:
		columns = General.enemy_current_status.size()
		General.enemy_panel_status = General.enemy_current_status.duplicate()
		for i in range(General.enemy_current_status.size()):
			var inst = panel_preload.instance()
			add_child(inst)
		
