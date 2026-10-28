extends TouchScreenButton

var is_learn = false
var Available = true
export var id = 0
export var last_talent_in_branch = false


func _ready():
	$Node2D / Icon.frame = General.GetTalentInfo(General.steam_tree, id)[0]
	if id == - 1:
		scale = Vector2(1.2, 1.2)
	else:
		scale = Vector2(0.8, 0.8)






func _process(_delta):
	# Родитель узла — контейнер Skills, а его родитель — RaceSkillTree.
	var tree = get_parent().get_parent()
	if tree != null and tree.selected_talent_id == id:
		$AnimationPlayer.play("Selected")
	else:
		$AnimationPlayer.play("Static")
	
	if not Available:
		modulate = Color("242424")
	else:
		if id == - 1 or General.find_talent(id, General.steam_tree):
			modulate = "82f800"
	
		else:
			modulate = "ffffff"



func _on_RaceTalent_pressed():
	General.SoundPlay("res://Music/HitUI.mp3")
	get_parent().get_parent().TalentSelect(General.steam_tree, id, Available)

