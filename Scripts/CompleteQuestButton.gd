# CompleteQuestButton.gd — кнопка «завершить квест» на карточке квеста.
#
# Кнопка создаётся только когда General.can_complete_quest() вернул true.
# Данные квеста (награды, требования) QuestService берёт по id из General.quests,
# поэтому кнопке не нужно копировать их в свои поля.

extends TextureButton

var quest_id = null


func _ready():
	# Родитель — карточка QuestPanel; она выставляет quest_id до add_child().
	quest_id = get_parent().quest_id


func _on_TouchScreenButton_pressed():
	if General.quest_animation_play:
		return
	General.quest_complete(quest_id)
