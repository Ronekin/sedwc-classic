extends Node2D
onready var NPCs = $Morio / NPCMap
onready var Items = $Morio / ItemMap
onready var Enemys = $Morio / EnemyMap
onready var Builds = $Morio / BuildsMap

func _physics_process(delta):
	NPCs = get_node(General.last_scene + "/NPCs")
	Items = get_node(General.last_scene + "/Items")
	Enemys = get_node(General.last_scene + "/Enemys")
	Builds = get_node(General.last_scene + "/Builds")
	
	if Builds == null: Builds = $Node2D
	if Items == null: Items = $Node2D
	if NPCs == null: NPCs = $Node2D
	if Enemys == null: Enemys = $Node2D
	
	for i in [$MorioMap, $Jail, $Italy]:
		if General.last_scene == i.name:
			i.visible = true
		else:
			i.visible = false
	
	match General.last_scene:
		"MorioMap": $EmptyMap.frame = 0
		"Jail": $EmptyMap.frame = 1
		"Italy": $EmptyMap.frame = 2
		"Germany": $EmptyMap.frame = 3
			
		
	
	
	if General.general_map_enabled.find(1) != - 1:
		NPCs.visible = true
	else:
		NPCs.visible = false
	
	if General.general_map_enabled.find(2) != - 1:
		Items.visible = true
	else:
		Items.visible = false
	
	if General.general_map_enabled.find(3) != - 1:
		Enemys.visible = true
	else:
		Enemys.visible = false
	
	if General.general_map_enabled.find(4) != - 1:
		Builds.visible = true
	else:
		Builds.visible = false
