# QuestPanel.gd — карточка одного квеста в журнале.
#
# Карточка не ищет квест по имени узла: QuestPanel2 выставляет quest_id до
# add_child(), а здесь мы читаем квест через General.get_quest(quest_id).
# Это устойчивее старого разбора имени Panel<index>.

extends Panel

onready var complete_button = preload("res://Scenes/CompleteQuestButton.tscn")
onready var podrobnosti = preload("res://Scenes/PodrobnostiQuest.tscn")

var quest_id = null
var quest_index = - 1


func _ready():
	if quest_id == null:
		return
	refresh()


# Заполняет карточку данными квеста. Вызывается при создании и может быть
# вызвана повторно, если данные квеста изменились.
func refresh():
	var quest = General.get_quest(quest_id)
	if quest.empty():
		queue_free()
		return

	name = "QuestCard" + str(quest.get("index", 0))
	$AuthorName.text = str(quest.get("author", ""))
	$QuestName.text = str(quest.get("name", ""))
	var icon = $QuestIcon
	var frame = int(floor(float(quest.get("id", 1)) - 1))
	var frame_count = icon.hframes * icon.vframes
	if frame < 0 or frame >= frame_count:
		frame = 0
	icon.frame = frame

	var quest_number = float(quest.get("id", 0.0))
	if int(quest_number) == 11:
		$QuestIcon.frame = 4
		$AuthorName.text = "Пуччи"
		$QuestName.text = "Путь к раю"
	elif quest_number == 12.0:
		$QuestIcon.frame = 6
		$AuthorName.text = "узнать кто это"
		$QuestName.text = "лука"
	elif quest_number == 12.1:
		$QuestIcon.frame = 5
		$AuthorName.text = "надо к бучилати"
		$QuestName.text = "лука!"
	elif int(quest_number) == 12:
		$QuestIcon.frame = 5
		$AuthorName.text = "узнать кто это"
		$QuestName.text = "лука"

	if General.can_complete_quest(quest_id):
		show_complete_button()
	else:
		hide_complete_button()


func show_complete_button():
	if has_node("CompleteQuestButton"):
		return
	var button = complete_button.instance()
	button.name = "CompleteQuestButton"
	button.rect_position = Vector2(95, 11)
	add_child(button)


func hide_complete_button():
	if has_node("CompleteQuestButton"):
		get_node("CompleteQuestButton").queue_free()


func _on_TouchScreenButton_pressed():
	var index = General.quest_index(quest_id)
	if index == - 1:
		return
	General.id_for_check = index
	if General.podrobnosti_activate:
		return
	General.podrobnosti_activate = true
	var details = podrobnosti.instance()
	details.rect_global_position = Vector2.ZERO
	get_parent().get_parent().get_parent().add_child(details)
