extends Control

var RewardsOpen: bool

func _ready():
	var EnemyInfo: Dictionary = General.GetEnemyInfo(General.enemy_collision_name)
	General.player_block_all = true
	$TextureRect / LVLprogress.value = General.enemy_collision_stats["RAGE"]
	$AnimationPlayer.play("First")
	$TextureRect / Name.text = General.enemy_collision_stats["NAMERUS"]
	match General.enemy_collision_stats["NAMERUS"]:
		"враг": $TextureRect / Icon.frame = 0
		"хулиган": $TextureRect / Icon.frame = 1
		"Карс": $TextureRect / Icon.frame = 2
		"дио брандо(вампир)": $TextureRect / Icon.frame = 3
		"пеши": $TextureRect / Icon.frame = 0
	match General.enemy_collision_name:
		"IronMan":
			$TextureRect / Icon.frame = 4

	
	
	




	var has_info = not EnemyInfo.empty()
	if has_info and "Items" in EnemyInfo:
		for i in EnemyInfo["Items"]:
			var jujutsu = $Rewards / GridContainer / ItemShop.duplicate()
			jujutsu.visible = true
			jujutsu.get_node("Item").frame = i[0]
			jujutsu.get_node("Text").text = " " + i[2] + " " + str(i[1] * 100.0) + "%"
			$Rewards / GridContainer.add_child(jujutsu)
	
	$TextureRect / RewardButton.visible = has_info and EnemyInfo.get("Items", []).size() > 0

	var hp_text = str(EnemyInfo.get("HP", "?")) if has_info else "?"
	$TextureRect / Stats.text = "\nDAMAGE: " + str(General.enemy_collision_stats["DMG"]) + "\nHP: " + hp_text
	if General.enemy_collision_stats["OSOBENNOSTI"] != "":
		$TextureRect / Stats.text += "\nСлабости: " + General.enemy_collision_stats["OSOBENNOSTIRUS"]
	else:
		$TextureRect / Stats.text += "\n"

func _on_FightButton_pressed():
	if RewardsOpen: return
	GeneralMusicPlayer.stream_paused = true
	var name_scene = "res://GeneralGameScenes/" + General.enemy_collision_name + "Arena.tscn"
	if General.enemy_collision_name == "dio":
		name_scene = "res://GeneralGameScenes/DIOEnemyArena.tscn"
		General.EnemyName = "dio"
	elif General.enemy_collision_name == "jotaro6":
		name_scene = "res://GeneralGameScenes/JotaroEnemyArena.tscn"
		General.EnemyName = "jotaro6"
	elif General.enemy_collision_name == "zeck":
		General.EnemyName = "zeck"
		name_scene = "res://GeneralGameScenes/ZecksEnemyArena.tscn"
		if General.item_in_arm == "20":
			General.fight_with = 1
	elif General.enemy_collision_name == "peshi":
		name_scene = "res://GeneralGameScenes/LukaEnemyArena.tscn"
		General.EnemyName = "peshi"
	elif General.enemy_collision_name == "Diabolo":
		name_scene = "res://GeneralGameScenes/LukaEnemyArena.tscn"
		General.EnemyName = "diablo"
		if General.item_in_arm == "9":
			General.fight_with = 2
	elif General.enemy_collision_name == "Cars":
		name_scene = "res://GeneralGameScenes/LukaEnemyArena.tscn"
		General.EnemyName = "Cars"
	elif General.enemy_collision_name == "cyborg":
		name_scene = "res://GeneralGameScenes/LukaEnemyArena.tscn"
		General.EnemyName = "cyborg"
	elif General.enemy_collision_name == "IronMan":
		name_scene = "res://GeneralGameScenes/DIOEnemyArena.tscn"
		General.EnemyName = "IronMan"

	General.LastGameSceneLink = General.PathCurrentScene
	Transition.change_scene(name_scene, "Black")
	General.seconds_get_start = false

func _on_BackButton_pressed():
	if not RewardsOpen:
		$AnimationPlayer.play("Back")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Back":
		queue_free()
		General.player_block_all = false


func LeaveReward_Pressed():
	$AnimationPlayer.play("Rewards_hide")
	RewardsOpen = false


func RewardButton_Pressed():
	$AnimationPlayer.play("Rewards_up")
	RewardsOpen = true
