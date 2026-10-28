extends Node2D

onready var part = preload("res://Scenes/WinParticlesFull.tscn")
var animation_end = false
var money_add = 0
var _rewards_applied: = false

func _ready():
	if _rewards_applied:
		return
	_rewards_applied = true
	if not ("kills" in General.player_statistic): General.player_statistic["kills"] = 0
	General.player_statistic["kills"] += 1
	General.AchievementGive(0)
	if General.player_statistic["kills"] >= 5: General.AchievementGive(1)
	if General.player_statistic["kills"] >= 50: General.AchievementGive(2)
	if General.player_statistic["kills"] >= 100: General.AchievementGive(3)
	if General.player_statistic["kills"] >= 1000: General.AchievementGive(4)
	General.save_save()
	$CanvasLayer / Control / WinPanel / Label.visible = false
	$CanvasLayer / Control / WinPanel / Label2.visible = false
	$CanvasLayer / Control / WinPanel / Label3.visible = false
	$CanvasLayer / Control / WinPanel / Label4.visible = false
	$CanvasLayer / Control / WinPanel / Label5.visible = false
	money_add = 0
	animation_end = false
	yield(get_tree().create_timer(0.5), "timeout")
	var particles = part.instance()
	add_child(particles)
	$CanvasLayer / Control / WinPanel / Label.visible = false
	$CanvasLayer / Control / WinPanel / Label.text = "- кол-во пропущенного урона врага: " + str(General.damage_for_player_counts)
	
	if General.hp_max != 0: money_add += (1.0 - (float(General.damage_for_player_counts) / float(General.hp_max))) * 100
	else: money_add += 0
	$CanvasLayer / Control / WinPanel / Label2.visible = false
	$CanvasLayer / Control / WinPanel / Label2.text = "- оставшееся здоровье: " + str(General.heart_points)
	money_add += (General.heart_points * 5)
	$CanvasLayer / Control / WinPanel / Label3.visible = false
	$CanvasLayer / Control / WinPanel / Label3.text = "- время боя: " + str(int(General.fight_timer)) + " c."

	money_add += (100 * (1 - (int(General.fight_timer) / 100)))

	if General.count_attacks != 0:
		$CanvasLayer / Control / WinPanel / Label4.visible = false
		$CanvasLayer / Control / WinPanel / Label4.text = "- процент попадания: " + str(int((float(General.popadania) / float(General.count_attacks)) * 100.0)) + "%"
	else:
		$CanvasLayer / Control / WinPanel / Label4.visible = false
		$CanvasLayer / Control / WinPanel / Label4.text = "- процент попадания: 0%"
	
	if General.count_attacks != 0: money_add += (int((float(General.popadania) / float(General.count_attacks)) * 100.0) * 5)
	else: money_add += 0

	$CanvasLayer / Control / WinPanel / Label5.visible = false
	$CanvasLayer / Control / WinPanel / Label5.text = "- общий урон: " + str(General.damage_for_enemy_counts)

	money_add += (General.damage_for_enemy_counts * 2)

	randomize()

	var Rewards: Dictionary = General.GetEnemyInfo(General.EnemyName)
	if Rewards.size() == 0: Rewards = General.GetEnemyInfo(General.enemy_collision_name)
	if not Rewards.empty():
		if "Money" in Rewards:
			$CanvasLayer / Control / RewardPanel / Reward.text = "награда: +" + str(Rewards["Money"]) + " $, + " + str(Rewards["Exp"]) + " exp"

		for i in Rewards["Items"].size():
			randomize()
			if Rewards["Items"][i][1] >= 1:
				General.add_item(Rewards["Items"][i][0], Rewards["Items"][i][1])
				$CanvasLayer / Control / RewardPanel / Reward.text += ", + " + str(Rewards["Items"][i][1]) + " " + Rewards["Items"][i][2]
			elif randf() < Rewards["Items"][i][1]:
				General.add_item(Rewards["Items"][i][0], 1)
				$CanvasLayer / Control / RewardPanel / Reward.text += ", + " + Rewards["Items"][i][2]

		General.money_change(Rewards["Money"])
		General.exp_change(Rewards["Exp"])
	
	
	match General.EnemyName:
		"zeck":
			if General.fight_with == 1:
				General.add_item(20, 1)
				$CanvasLayer / Control / RewardPanel / Reward.text += ", + зелёный ребёнок"
		"luka":
			General.replace_quest(12.0, 12.1)
		"bucciarati":
			General.replace_quest(12.1, 12.2)
		"jotaro6":
			if "jotaro_disc" in General.loot_info:
				General.add_item(22, 1)
				$CanvasLayer / Control / RewardPanel / Reward.text += ", + диск памяти"
		"peshi":
			General.replace_quest(12.32, 12.33)

	General.save_save()
	
	if General.enemy_collision_stats["REWARD_TEXT"] != "":
		$CanvasLayer / Control / RewardPanel / Reward.visible = false
		$CanvasLayer / Control / RewardPanel / Reward.text = "награда: " + General.enemy_collision_stats["REWARD_TEXT"]

	General.loot_info.clear()
	
	$CanvasLayer / Control / AnimationPlayer2.play("Idle")
	$CanvasLayer / Control / WinPanel / Label.visible = true
	$CanvasLayer / Control / RewardPanel / Reward.visible = true
	$CanvasLayer / Control / WinPanel / Label5.visible = true
	$CanvasLayer / Control / WinPanel / Label4.visible = true
	$CanvasLayer / Control / WinPanel / Label3.visible = true
	$CanvasLayer / Control / WinPanel / Label2.visible = true
	
	
	
	

	
	
	
func _input(event):
	if event is InputEventScreenTouch and animation_end:
		General.fast_pos_change = false
		General.persist_cyborg_battery_to_save()
		General.toGameGeneral("Black", true)
		GeneralMusicPlayer.theme_resong("MorioMap")
		GeneralMusicPlayer.stream_paused = true
		
func _on_AnimationPlayer2_animation_finished(anim_name):
	animation_end = true
	var particles = part.instance()
	add_child(particles)
	
	money_add = 0

