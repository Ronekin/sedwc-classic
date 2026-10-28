# PanelEnemyTournir.gd — панель турнирного врага.
#
# Вся информация берётся из General.GetTournamentEnemy(); панель не
# перегенерирует врага каждый кадр. Данные врага — в Data/Tournament*.gd.

extends Control

# Панель турнирного врага. Вся информация берётся из
# General.GetTournamentEnemy(); панель не перегенерирует врага каждый кадр.

var enemy_data: Dictionary = {}
var enemy_level: int = -1

func _ready():
	$custom_reward.text = ""
	General.last_scene = "Tournir"
	General.is_tournir = true
	_refresh_enemy()

func _process(delta):
	General.is_tournir = true
	if enemy_level != General.tournament_lvl:
		_refresh_enemy()

func _item_line(drop) -> String:
	var item_id = int(drop[0])
	var value = float(drop[1])
	var item_name = str(General.content_db().get_item_name(item_id))
	if item_name == "":
		item_name = "?"
	if value >= 1.0:
		return "  " + str(int(value)) + " " + item_name
	return "  " + str(int(round(value * 100.0))) + "% " + item_name

func _refresh_enemy():
	enemy_level = General.tournament_lvl
	enemy_data = General.GetTournamentEnemy(enemy_level)
	General.tournir_character = str(enemy_data.get("name", ""))

	$Name.text = General.tournir_character
	$lvl.text = "этап " + str(General.tournament_lvl)

	$items.text = "предметы: \n"
	for drop in enemy_data.get("items", []):
		$items.text += _item_line(drop) + "\n"
	if enemy_data.get("items", []).size() == 0:
		$items.text = "предметов нет"

	$hp.text = "хп: " + str(enemy_data.get("hp", 0))
	$damage.text = "Урон: " + str(enemy_data.get("damage", 0))

	$NpcSheet.texture = load(str(enemy_data.get("texture", "")))
	$NpcSheet.hframes = int(enemy_data.get("hframes", 1))
	$NpcSheet.vframes = int(enemy_data.get("vframes", 1))
	$NpcSheet.frame = 0

	var drop_chance = float(enemy_data.get("drop_chance", 0.0))
	$custom_reward.visible = drop_chance > 0.0
	$custom_reward.text = ""
	if drop_chance > 0.0:
		$custom_reward.text = str(drop_chance * 100.0) + "% шанс на выпадение части святого трупа"

func _on_Fight_pressed():
	General.LastToutnamentLvl = General.tournament_lvl
	General.EnemyName = General.tournir_character
	General.save_save()
	Transition.change_scene("res://GeneralGameScenes/TournirEnemyArena.tscn", "White")
