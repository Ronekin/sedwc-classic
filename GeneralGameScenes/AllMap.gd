extends Control

func delete_array_id(id):
	for i in range(General.general_map_enabled.size()):
		if General.general_map_enabled[i] == id:
			General.general_map_enabled.remove(i)
			break

func _physics_process(delta):
	if $NPC.pressed == false and General.general_map_enabled.find(1) != - 1:
		delete_array_id(1)
	if $NPC.pressed and General.general_map_enabled.find(1) == - 1:
		General.general_map_enabled.append(1)
	
	if $Items.pressed == false and General.general_map_enabled.find(2) != - 1:
		delete_array_id(2)
	if $Items.pressed and General.general_map_enabled.find(2) == - 1:
		General.general_map_enabled.append(2)
	
	if $Enemies.pressed == false and General.general_map_enabled.find(3) != - 1:
		delete_array_id(3)
	if $Enemies.pressed and General.general_map_enabled.find(3) == - 1:
		General.general_map_enabled.append(3)
	
	if $Builds.pressed == false and General.general_map_enabled.find(4) != - 1:
		delete_array_id(4)
	if $Builds.pressed and General.general_map_enabled.find(4) == - 1:
		General.general_map_enabled.append(4)
