# PodrobnostiQuest.gd — окно подробностей выбранного квеста.
#
# Требования и награды строятся из данных квеста:
# - requirements: Vector2(1-based item_id, count);
# - rewards: Vector2(0-based item_id, count).
# Названия предметов берутся из Data/Items.gd, поэтому новый предмет не нужно
# вручную добавлять в этот файл. Сюжетные подсказки для 11.x/12.x остаются
# отдельными текстами: это не требования, а авторский текст.

extends Control


func _ready():
	if General.id_for_check < 0 or General.id_for_check >= General.quests.size():
		close()
		return
	var quest = General.quests[General.id_for_check]
	$TextureRect / Label2.text = build_text(quest)


func build_text(quest) -> String:
	var quest_id = float(quest.get("id", 0.0))
	var special = special_text(quest_id)
	if special != "":
		return special

	var text = "квест:\n - " + str(quest.get("title", ""))
	text += "\n\nот:\n - " + str(quest.get("author_title", ""))
	text += "\n\nтребования:"
	var has_requirement = false

	for requirement in quest.get("requirements", []):
		var item_id = int(requirement.x) - 1
		text += "\n - " + item_name(item_id) + ": " + str(int(requirement.y))
		has_requirement = true

	var stand = str(quest.get("stand_requirement", ""))
	if stand != "":
		var stand_title = str(quest.get("stand_requirement_title", stand))
		text += "\n - стенд: " + stand_title
		has_requirement = true

	var technic = str(quest.get("technic_requirement", ""))
	if technic != "":
		var technic_title = str(quest.get("technic_requirement_title", technic))
		text += "\n - техника боя: " + technic_title
		has_requirement = true

	var custom_requirement = str(quest.get("custom_requirement", ""))
	if custom_requirement != "":
		text += "\n - " + custom_requirement
		has_requirement = true
	if not has_requirement:
		text += "\n - нет"

	text += "\n\nнаграда:"
	var has_reward = false
	for reward in quest.get("rewards", []):
		var item_id = int(reward.x)
		text += "\n - " + item_name(item_id) + ": " + str(int(reward.y))
		has_reward = true
	var custom_reward = str(quest.get("custom_reward", ""))
	if custom_reward != "":
		text += "\n - " + custom_reward
		has_reward = true
	if not has_reward:
		text += "\n - нет"
	return text


func item_name(item_id: int) -> String:
	var name = General.content_db().get_item_name(item_id)
	if name == "":
		return "предмет #" + str(item_id)
	return name


func special_text(quest_id: float) -> String:
	if quest_id == 11.0:
		return "квест: добыча кости дио\nот: Энрико Пуччи\n\nтребования: получить кость дио\nнаграда: продолжение пути к раю\n\nподсказка:\n- кость дио можно получить, убив Дио (шанс выпадения — 10%).\n\nПосле выполнения идите к Пуччи!"
	if quest_id == 11.1:
		return """квест: добыча диска памяти Джотаро
от: Энрико Пуччи

требования: получить диск Джотаро
награда: продолжение пути к раю

подсказка:
- чтобы из Джотаро выпал диск, убейте его второй атакой White Snake (диском).
  Джотаро находится в тюрьме, куда можно попасть через Валентайна."""
	if quest_id == 11.2:
		return """квест: получить зелёного ребёнка
от: Энрико Пуччи

требования: убить 36 преступников, взяв с собой кость Дио
награда: продолжение пути к раю

подсказка:
- отправьтесь в тюрьму, возьмите кость Дио в руку и зайдите в бой против преступников."""
	if quest_id == 11.3:
		return """квест: Made in Heaven
от: Энрико Пуччи

требования: найти в пустыне гору и достигнуть рая
награда: получить Made in Heaven

подсказка:
- идите вверх от точки появления в пустыне: там появится рай."""
	if quest_id == 12.0:
		return "Хм... Буччелати сказал про какого-то Луку. Интересно, кто это? Дружелюбный ли он? А если..."
	if quest_id == 12.1:
		return "Я встретил этого Луку, но он оказался не очень добрым. Что скажет Буччелати? Может, лучше не говорить, что это был я..."
	if quest_id == 12.2:
		return "Я победил Буччелати. Что он скажет?"
	if quest_id == 12.3:
		return "Вы вступили в мафию Passione, в подразделение Буччелати. Познакомьтесь с остальными участниками банды — идите вправо от места встречи."
	if quest_id == 12.31:
		return "Ждём поручения от Буччелати."
	if quest_id == 12.32:
		return "Задание от Буччелати\n\nНадо убить Пеши, который похож на ананас. По словам Буччелати, он угрожает дочери босса."
	if quest_id == 12.33:
		return "Задание от Буччелати (выполнено)\n\nПеши, который похож на ананас, побеждён."
	if quest_id == 12.34:
		return "Задание от Буччелати\n\nНадо отправиться к римскому Колизею, где босс ждёт дочь.\n\nЖ/д для отправки находится на севере Неаполя; на карте он обозначен значком $."
	if quest_id == 12.35:
		return "Задание от Буччелати\n\nНадо убить босса. Его называют Дьяволо."
	return ""


func _on_TouchScreenButton_pressed():
	close()


func close():
	General.podrobnosti_activate = false
	queue_free()
