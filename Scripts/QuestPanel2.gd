# QuestPanel2.gd — список активных квестов.
#
# Панель перестраивает карточки, когда меняется набор квестов. Это проще и
# надёжнее старого «добавляем, пока детей меньше, чем квестов»: удалённые
# квесты тоже исчезают, а карточки не накапливаются.

extends Control

onready var quest_panel = preload("res://Scenes/PanelQuest.tscn")
onready var quest_complete = preload("res://Scenes/QuestComplete.tscn")

var last_signature = ""


func _ready():
	rebuild()


func _physics_process(_delta):
	var signature = make_signature()
	if signature != last_signature:
		rebuild()
	if General.signal_animation:
		General.signal_animation = false
		var animation = quest_complete.instance()
		get_parent().get_parent().add_child(animation)


func make_signature() -> String:
	var text = ""
	for quest in General.quests:
		text += str(quest.get("id", "")) + ":" + str(quest.get("index", 0)) + "|"
	return text


func rebuild():
	var grid = $TextureRect / GridContainer / GridContainer
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()

	if General.quests.empty():
		$TextureRect / Label.text = "У вас нет невыполненных квестов."
	else:
		$TextureRect / Label.text = ""

	for i in range(General.quests.size()):
		var panel = quest_panel.instance()
		panel.name = "QuestCard" + str(i)
		panel.quest_index = i
		panel.quest_id = General.quests[i].get("id", null)
		grid.add_child(panel)

	last_signature = make_signature()
	General.signal_deleted_for_rechek = false


func _on_TouchScreenButton_pressed():
	yield(get_tree().create_timer(0.1), "timeout")
	queue_free()
	General.quest_panel_activate = false
	General.quest_animation_play = false
