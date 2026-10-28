extends Control
export var teleport_id: int = 0
var WorldPath: String = ""
var WorldName: String = ""
var WorldID: String = ""

func _ready():
	match teleport_id:
		0:
			WorldName = "Морио"
			WorldID = "morio"
			WorldPath = "res://GeneralGameScenes/MorioMap.tscn"
			$WorldsPanels.frame = 0
			if get_tree().current_scene.name == "MorioMap":
				WorldID = ""
				$WorldName.text = "не куда"
				$WorldsPanels.modulate = Color("8d8d8d")
			else: $WorldName.text = WorldName

		1:
			WorldName = "Пустыня"
			WorldID = "desert"
			WorldPath = "res://GeneralGameScenes/SandWorld.tscn"
			$WorldsPanels.frame = 1
			if get_tree().current_scene.name == "Desert":
				WorldID = ""
				$WorldName.text = "не куда"
				$WorldsPanels.modulate = Color("3c3c3c")
			else: $WorldName.text = WorldName

		2:
			WorldName = "Тюрьма"
			WorldID = "jail"
			WorldPath = "res://GeneralGameScenes/JailDa.tscn"
			$WorldsPanels.frame = 2
			if get_tree().current_scene.name == "Jail":
				WorldID = ""
				$WorldName.text = "не куда"
				$WorldsPanels.modulate = Color("3c3c3c")
			else:
				$WorldName.text = WorldName

		3:
			WorldName = "Италия"
			WorldID = "italy"
			WorldPath = "res://GeneralGameScenes/Italy.tscn"
			$WorldsPanels.frame = 3
			if get_tree().current_scene.name == "Italy":
				WorldID = ""
				$WorldName.text = "не куда"
				$WorldsPanels.modulate = Color("3c3c3c")
			else:
				$WorldName.text = WorldName
		4:
			WorldName = "Германия"
			WorldID = "germany"
			WorldPath = "res://GeneralGameScenes/Germany.tscn"
			$WorldsPanels.frame = 4
			if get_tree().current_scene.name == "Germany":
				WorldID = ""
				$WorldName.text = "не куда"
				$WorldsPanels.modulate = Color("3c3c3c")
			else:
				$WorldName.text = WorldName





func _on_Button_pressed():
	if $WorldName.text.find("не куда") == - 1 and WorldID != "":
		if General.infinity_teleports() == false:
			General.teleport_charges -= 1
		General.message_spawn("Center", "Вы успешно телепортировались в " + WorldName + "!")
		General.other_save["world"] = WorldID
		General.fast_pos_change = false
		General.teleport_pos = "None"
		General.save_save()
		General.toGameGeneral("D4C", true)
	$"../..".visible = false
	General.dialog_activate = false
	

