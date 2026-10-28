# RaceSkillTree.gd — дерево расовых талантов.
#
# Данные узлов лежат в Data/Talents.gd. Здесь только раскладка дерева:
# позиция узла в сетке и список родителей. Расы 3 и 4 используют дерево
# базовых пилламенов (это задаёт SedwcContent.get_talent_race_number()).
#
# Контракт:
# - ID узла — 0-based ключ из Data/Talents.gd;
# - узел можно изучить, если изучен хотя бы один его родитель;
# - ID -1 — корень дерева, он всегда доступен и показывает суммарные бонусы.
#
# ИСПРАВЛЕНО: добавлена адаптация под разрешение экрана.
# Все позиции теперь учитывают текущий размер окна для корректного отображения.
extends Control

const TALENT_SCENE = preload("res://Scenes/RaceTalent.tscn")
const BRANCH_TEXTURE = preload("res://Textures/RaceTalentBranch.png")
const NODE_SPACING = 70.0

var selected_talent_id: int = - 1
var selected_talent_available := false
var tree_scale := 1.0

# [позиция в сетке, родительские ID]. Фактическая позиция = grid_position * NODE_SPACING * scale_factor
var tree_layouts = {
	0: {
		0: [Vector2(1, 0), []],
		1: [Vector2(2, 0), [0]],
		2: [Vector2(2, 1), [1]],
		3: [Vector2( - 1, 1), []],
		4: [Vector2( - 1, 2), [3]],
		5: [Vector2(0, 1), []],
		6: [Vector2(1, 1), [5]],
		7: [Vector2(1, 2), [6]],
		8: [Vector2(3, 0), [1]],
		9: [Vector2(4, 0), [8]],
		10: [Vector2(3, 3), [2, 12, 7, 9]],
		11: [Vector2( - 1, 3), [4]],
		12: [Vector2(0, 3), [11]],
	},
	1: {
		0: [Vector2(1, 0), []],
		1: [Vector2(2, 0), [0]],
		2: [Vector2(2, 1), [1]],
		3: [Vector2(3, 1), [2]],
		4: [Vector2(3, 2), [3]],
		5: [Vector2(0, 1), []],
		6: [Vector2(1, 1), [5]],
		7: [Vector2(1, 2), [6]],
		8: [Vector2(2, 3), [2]],
		9: [Vector2(1, 3), [8]],
		10: [Vector2(0, 3), [9]],
		12: [Vector2(0, 2), [9]],
	},
	2: {
		0: [Vector2(1, 0), []],
		1: [Vector2(2, 0), [0]],
		2: [Vector2(2, 1), [1]],
		3: [Vector2( - 1, 1), []],
		4: [Vector2( - 1, 2), [3]],
		5: [Vector2(0, 1), []],
		6: [Vector2(1, 1), [5]],
		7: [Vector2(1, 2), [6]],
		8: [Vector2(3, 0), [1]],
		9: [Vector2(4, 0), [8]],
		10: [Vector2(3, 3), [2, 12, 7, 9]],
		11: [Vector2( - 1, 3), [4]],
		12: [Vector2(0, 3), [11]],
	},
}

func _ready():
	$CanvasLayer / RightDown / SkillInfo.visible = false
	# Этот экран всегда показывает расовое дерево. Stand/technic-деревья
	# сюда не попадают, поэтому не оставляем steam_tree от другой страницы.
	General.steam_tree = "race"
	var race = General.content_db().get_race(General.race_number)
	var race_name = str(race.get("index", "human"))
	$CanvasLayer / SkillTreeRace.text = "раса: " + race_name
	build_tree()


func _process(_delta):
	$CanvasLayer / SkillTreePoint.text = "skill points: " + str(General.points)


func _on_TouchScreenButton_pressed():
	if General.is_tournir == false:
		General.toGameGeneral()
	else:
		Transition.change_scene("res://GeneralGameScenes/TournirSelect.tscn", "Black")


# Перестраивает все узлы и линии. Вызывается при открытии и после изучения
# таланта, потому что доступность соседних узлов меняется.
func build_tree():
	for child in $Skills.get_children():
		$Skills.remove_child(child)
		child.queue_free()

	var talent_race = General.talent_race_number()
	var layout = tree_layouts.get(talent_race, {})
	if layout.empty():
		$CanvasLayer / SkillTreeRace.text += " (нет древа талантов)"
		return

	var root = TALENT_SCENE.instance()
	root.id = - 1
	$Skills.add_child(root)
	root.position = Vector2.ZERO

	# Вычисляем коэффициент масштаба для адаптации под разрешение
	var view_width = $CanvasLayer.get_viewport().get_visible_rect().size.x
	var view_height = $CanvasLayer.get_viewport().get_visible_rect().size.y
	tree_scale = min(view_width / 800.0, view_height / 600.0)

	for talent_id in layout:
		var talent_node = TALENT_SCENE.instance()
		talent_node.id = talent_id
		$Skills.add_child(talent_node)

		# Применяем масштаб к позиции
		var grid_pos = layout[talent_id][0]
		talent_node.position = grid_pos * NODE_SPACING * Vector2(tree_scale, tree_scale)

		var parents = layout[talent_id][1]
		if parents.empty():
			_add_branch(talent_node, Vector2.ZERO, talent_id)
		for parent_id in parents:
			_add_branch(talent_node, layout[parent_id][0] * NODE_SPACING * Vector2(tree_scale, tree_scale), parent_id)
			if not _is_learned(parent_id):
				talent_node.Available = false


# Рисует линию от узла к родителю. Цвет линии показывает, изучен ли родитель.
func _add_branch(talent_node, parent_position: Vector2, parent_id: int):
	var branch = Sprite.new()
	branch.texture = BRANCH_TEXTURE
	branch.offset.y = 4
	branch.hframes = 2
	branch.scale.x = 2.5
	# Вычисляем расстояние с учетом масштаба
	var distance = parent_position.distance_to(talent_node.position)
	branch.scale.y = distance * 10 * tree_scale
	branch.rotation_degrees = rad2deg(talent_node.position.direction_to(parent_position).angle()) - 90
	branch.global_position = talent_node.global_position
	branch.z_index = - 1
	if _is_learned(parent_id):
		branch.modulate = Color("26ff00")
	elif parent_id != - 1:
		branch.modulate = Color("4d4d4d")
	$Skills.add_child(branch)


func _is_learned(talent_id: int) -> bool:
	if not ("race" in General.talents):
		return false
	return General.find_talent(talent_id, "race")


func _on_talent_selected(talent_id: int, available: bool):
	show_talent_info(talent_id, available)


# Показывает описание узла и кнопку изучения. Для корня (ID -1) вместо
# изучения выводится сводка уже полученных бонусов.
func show_talent_info(talent_id: int, available: bool):
	selected_talent_id = talent_id
	selected_talent_available = available
	var talent_info = General.GetTalentInfo("race", talent_id)
	var description = ""
	var cost = 0
	if talent_info.size() > 2:
		description = str(talent_info[2])
	if talent_info.size() > 1:
		cost = int(talent_info[1])

	$CanvasLayer / RightDown / SkillInfo.visible = true
	$CanvasLayer / RightDown / SkillInfo / Descript.text = description
	$CanvasLayer / RightDown / SkillInfo / Learn / Cost.text = "-" + str(cost) + " Skill points"

	if talent_id == - 1:
		$CanvasLayer / RightDown / SkillInfo / Text1.text = "расовые таланты"
		$CanvasLayer / RightDown / SkillInfo / Learn.visible = false
		$CanvasLayer / RightDown / SkillInfo / Descript.text = _learned_bonus_text()
	elif not selected_talent_available:
		$CanvasLayer / RightDown / SkillInfo / Text1.text = "недоступный навык"
		$CanvasLayer / RightDown / SkillInfo / Learn.visible = false
	elif _is_learned(talent_id):
		$CanvasLayer / RightDown / SkillInfo / Text1.text = "изученный навык"
		$CanvasLayer / RightDown / SkillInfo / Learn.visible = false
	else:
		$CanvasLayer / RightDown / SkillInfo / Text1.text = "навык"
		$CanvasLayer / RightDown / SkillInfo / Learn.visible = true
	build_tree()


func _learned_bonus_text() -> String:
	var all_buffs = {}
	var learned = []
	if "race" in General.talents:
		learned = General.talents["race"]
	for talent_id in learned:
		var talent_info = General.GetTalentInfo("race", talent_id)
		if talent_info.size() < 4:
			continue
		var buffs = talent_info[3]
		for key in buffs:
			var value = buffs[key]
			if typeof(value) == TYPE_BOOL:
				all_buffs[key] = value
			elif key in all_buffs and typeof(all_buffs[key]) in [TYPE_INT, TYPE_REAL]:
				all_buffs[key] += value
			else:
				all_buffs[key] = value

	var text = ""
	if General.race_number == 1:
		text = "старт баффы:\n  +25 HP\n"
	if all_buffs.empty():
		return text + "прокаченных баффов нет"

	var labels = {
		"DamageProcent": "% All damage",
		"DamageHands": " Damage hands",
		"MoveSpeed": "% move speed",
		"Regen": "% Regen HP",
	}
	text += "прокаченные баффы:"
	for key in all_buffs:
		var value = all_buffs[key]
		if typeof(value) == TYPE_BOOL:
			if value:
				text += "\n  +" + str(key)
		else:
			text += "\n  +" + str(value) + str(labels.get(key, " " + str(key)))
	return text


func close_talent_info():
	$CanvasLayer / RightDown / SkillInfo.visible = false


func learn_selected_talent():
	if selected_talent_id < 0 or not selected_talent_available:
		return
	var talent_info = General.GetTalentInfo("race", selected_talent_id)
	var cost = 0
	if talent_info.size() > 1:
		cost = int(talent_info[1])
	if General.points < cost:
		return
	General.SoundPlay("res://Music/UIdada.mp3")
	General.points -= cost
	General.learn_talent(selected_talent_id, "race")
	show_talent_info(selected_talent_id, true)
	build_tree()
	General.save_save()


# Старые имена оставлены для сигналов в Scenes/RaceSkillTree.tscn.
func TalentSelect(type: String, talent_id: int, available: bool):
	show_talent_info(talent_id, available)


func InfoClose():
	close_talent_info()


func LearnTalent():
	learn_selected_talent()


func BuildTree():
	build_tree()
