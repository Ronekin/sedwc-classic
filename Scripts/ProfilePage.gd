extends Control





onready var name_s = $TouchScreenButton / PersonagePanel / NamePanel / NameStand
onready var name_t = $TouchScreenButton / PersonagePanel / NamePanel / NameTechnic
onready var name_r = $TouchScreenButton / PersonagePanel / NamePanel / NameRace
onready var name_ = $PersonagePanel / Name
onready var name_n = $TouchScreenButton / PersonagePanel / NamePanel / NameNick
var current_page = 0
var panel_visible = {
	"name_s_": false, 
	"name_t_": false, 
	"name_r_": false, 
	"name_n": false
}
const page_limit = 3






func _process(delta):
	if General.play_time <= 60:
		$OtherStats.text = "в игре: " + str(General.play_time) + " мин"
	else:
		$OtherStats.text = "в игре: " + str(General.play_time / 60) + "." + str((General.play_time - General.play_time / 60 * 60) / 6) + " ч"





func update_panels(c_p):
	$StandSlots.visible = false
	
	match c_p:
		0:
			name_.text = "стенд"
			$StandSlots.visible = true
			$StandSlots / Name.text = "хранилище стендов"
		1:
			name_.text = "техника"
			$StandSlots.visible = true
			$StandSlots / Name.text = "мои техники"
			
		2:
			name_.text = "раса"
			$StandSlots.visible = true
			if General.race_number == 5:
				$StandSlots / Name.text = "тюнинг"
			else:
				$StandSlots / Name.text = "древо умений"
		3: name_.text = "прочее"
	match c_p:
		0: panel_visible = {"name_s_": true, "name_t_": false, "name_r_": false, "name_n": false}
		1: panel_visible = {"name_s_": false, "name_t_": true, "name_r_": false, "name_n": false}
		2: panel_visible = {"name_s_": false, "name_t_": false, "name_r_": true, "name_n": false}
		3: panel_visible = {"name_s_": false, "name_t_": false, "name_r_": false, "name_n": true}
	name_s.visible = panel_visible["name_s_"]
	name_r.visible = panel_visible["name_r_"]
	name_t.visible = panel_visible["name_t_"]
	name_n.visible = panel_visible["name_n"]
	if panel_visible == {"name_s_": false, "name_t_": false, "name_r_": false, "name_n": false}:
		$TouchScreenButton / PersonagePanel / NamePanel.visible = false
		$TextureProgress.visible = true
		$TextureProgress2.visible = true
	else:
		$TouchScreenButton / PersonagePanel / NamePanel.visible = true
		$TextureProgress.visible = true
		$TextureProgress2.visible = true

func _on_RaceTree_pressed():
	General.player_pos = General.player_pos_save
	# Отдельных деревьев для стендов и техник нет: кнопка всегда открывает
	# расовое дерево. У киборга вместо дерева — экран тюнинга.
	if General.race_number == 5:
		Transition.change_scene("res://Scenes/CyborgEditing.tscn", "Black")
	else:
		General.steam_tree = "race"
		Transition.change_scene("res://Scenes/RaceSkillTree.tscn", "Black")
	General.save_save()

func _on_Map_pressed():
	General.player_pos = General.player_pos_save
	General.tutorial_id = 5
	
	match get_tree().current_scene.name:
		"MorioMap":
				General.last_scene = "MorioMap"
		"Jail":
				General.last_scene = "Jail"
		"Italy":
				General.last_scene = "Italy"
		"Germany":
				General.last_scene = "Germany"
		_:
				General.last_scene = "MorioMap"
	
	
	
	
	Transition.change_scene("res://GeneralGameScenes/TutorialTema.tscn", "Black")
	
func _on_StandSlots_pressed():
	if current_page == 0:
		General.player_pos = General.player_pos_save
		Transition.change_scene("res://Scenes/StandSlots.tscn", "Black")
	elif current_page == 1:
		General.player_pos = General.player_pos_save
		Transition.change_scene("res://Scenes/TechicSelect.tscn", "Black")
	elif current_page == 2:
		if General.race_number == 5:
			General.player_pos = General.player_pos_save
			Transition.change_scene("res://Scenes/CyborgEditing.tscn", "Black")
			General.save_save()
		else:
			General.player_pos = General.player_pos_save
			General.steam_tree = "race"
			Transition.change_scene("res://Scenes/RaceSkillTree.tscn", "Black")
			General.save_save()

func _on_Next_pressed():
	if current_page < page_limit:
		current_page += 1
		update_panels(current_page)
func _on_Pre_pressed():
	if current_page > 0:
		current_page -= 1
		update_panels(current_page)


func AchievButton_Pressed():
	Transition.change_scene("res://GeneralGameScenes/Achievements.tscn", "Black")
