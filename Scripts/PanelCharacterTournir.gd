# PanelCharacterTournir.gd — панель персонажа перед турнирным боем.
#
# Показывает техники, лечение и награды; награды выдаёт
# TournamentRewardService. Не пересчитывайте турнирные формулы в UI.

extends Control

var tournament_reward_service = preload("res://Systems/TournamentRewardService.gd").new()

func _ready():
	$your_technic / TechnicSelectIconSheet.visible = false

func _process(delta):
	if General.heart_points <= 0:
		var Lvl: float = General.tournament_lvl
		General.LastToutnamentLvl = (int((Lvl - 1) * 0.1) * 10) + 1
		General.heart_points = General.hp_max
		_on_Collect_reward_pressed()
	$ALL_rewards.text = "Награда: " + str(General.tournir_money_reward) + "$"
	$your_hp.text = "Ваше здоровье: " + str(int(General.heart_points))
	$value_pizza.text = ":" + str(General.ItemCount(6))
	$your_technic.text = "Ваша техника: " + str(General.techic_index)
	$tournir_lvl.text = "Ваш уровень турнира: " + str(General.tournament_lvl)
	$tournir_record.text = "Ваш макс. уровень турнира: " + str(General.tournir_record)
	$ALL_rewards / Arrow / count.text = str(General.tournir_all_reward_items.get("arrow", 0)) + "x"
	$ALL_rewards / Disk / count.text = str(General.tournir_all_reward_items.get("disk", 0)) + "x"
	$ALL_rewards / Broken_disk / count.text = str(General.tournir_all_reward_items.get("broken_disk", 0)) + "x"
	$ALL_rewards / Roka / count.text = str(General.tournir_all_reward_items.get("roka", 0)) + "x"
	$ALL_rewards / Pizza / count.text = str(General.tournir_all_reward_items.get("pizzas", 0)) + "x"
	if General.techic_number == 0:
		pass
	elif General.techic_number == 1:
		$your_technic / TechnicSelectIconSheet.visible = true
		$your_technic / TechnicSelectIconSheet.frame = 0
	elif General.techic_number == 2:
		$your_technic / TechnicSelectIconSheet.visible = true
		$your_technic / TechnicSelectIconSheet.frame = 1
	elif General.techic_number == 6:
		$your_technic / TechnicSelectIconSheet.visible = true
		$your_technic / TechnicSelectIconSheet.frame = 2
	elif General.techic_number == 7:
		$your_technic / TechnicSelectIconSheet.visible = true
		$your_technic / TechnicSelectIconSheet.frame = 3
func _on_Heal_pressed():
	General.SoundPlay("res://Music/HitUI.mp3")
	if General.heart_points + 2 <= General.hp_max:
		General.check_array(General.items_shop[2]["ID"])
		if General.check_array_invnet != - 1:
			General.heart_points += 2
			General.remove_item(General.items_shop[2]["ID"], 1)
			General.save_save()

func _on_Stand_storage_pressed():
	General.SoundPlay("res://Music/HitUI.mp3")
	Transition.change_scene("res://Scenes/StandSlots.tscn", "Black")
	General.player_pos_save = General.player_pos



func _on_Collect_reward_pressed():
	General.SoundPlay("res://Music/HitUI.mp3")
	tournament_reward_service.collect(General)
	General.is_tournir = false
	General.save_save()
	Transition.change_scene("res://GeneralGameScenes/GeneralMenu.tscn", "Black")
