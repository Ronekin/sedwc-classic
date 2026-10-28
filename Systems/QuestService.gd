# QuestService.gd — журнал квестов General.
#
# Контракт:
# - General.quests — массив словарей; порядок в массиве не важен, потому что
#   у каждого квеста есть стабильный id;
# - requirements: Array<Vector2(1-based item_id, count)>;
# - rewards: Array<Vector2(0-based item_id, count)>;
# - index — позиция квеста в General.quests, её обновляет refresh_quest_indices();
# - complete_quests хранит id завершённых этапов (кроме последнего).
#
# Сервис не хранит собственного состояния: все данные лежат в General, чтобы
# они попадали в сейв и были доступны модам.

extends Reference


# Добавляет квест. Параметры совпадают с полями словаря; is_last означает
# последний этап цепочки (после него промежуточные этапы удаляются).
func add_quest(general, author, id, name, requirements, rewards, stand, title, author_title, stand_title, is_last, technic, technic_title, custom_requirement, custom_reward):
	var quest = _make_quest(author, id, name, requirements, rewards, stand, title, author_title, stand_title, is_last, technic, technic_title, custom_requirement, custom_reward)
	# Повторно выданный квест заменяет старую копию, а не дублирует её.
	var old_index = quest_index(general, id)
	if old_index != - 1:
		general.quests.remove(old_index)
	general.quests.append(quest)
	refresh_quest_indices(general)
	general.save_save()
	general.message_spawn("Quest", "+ новый квест")


# Заменяет пустой сюжетный этап следующим (например, 12.2 -> 12.3).
# Полные данные для таких этапов не нужны: они продвигаются диалогом.
func replace_quest(general, old_id, new_id):
	var index = quest_index(general, old_id)
	if index == - 1:
		return false
	general.quests.remove(index)
	general.quests.append(_make_quest("", new_id, "", [], [], "", "", "", "", false, "", "", "", ""))
	general.signal_deleted_for_rechek = true
	refresh_quest_indices(general)
	general.save_save()
	general.message_spawn("Quest", "+ новый квест")
	return true


# Удаляет квест, не записывая его в complete_quests. Нужен, когда этап
# заканчивается без награды и без следующего этапа.
func remove_quest(general, id):
	var index = quest_index(general, id)
	if index == - 1:
		return false
	general.quests.remove(index)
	general.signal_deleted_for_rechek = true
	refresh_quest_indices(general)
	general.save_save()
	return true


func _make_quest(author, id, name, requirements, rewards, stand, title, author_title, stand_title, is_last, technic, technic_title, custom_requirement, custom_reward):
	return {
		"id": id,
		"author": author,
		"name": name,
		"title": title,
		"author_title": author_title,
		"requirements": requirements,
		"rewards": rewards,
		"stand_requirement": stand,
		"stand_requirement_title": stand_title,
		"technic_requirement": technic,
		"technic_requirement_title": technic_title,
		"custom_requirement": custom_requirement,
		"custom_reward": custom_reward,
		"is_last": is_last,
		"index": 0,
	}


# Завершает квест по id. Все требования, награды и флаги берутся из
# сохранённого квеста, поэтому вызывающему не нужно передавать их повторно.
func quest_complete(general, id):
	var index = quest_index(general, id)
	if index == - 1:
		return false
	var quest = general.quests[index]
	general.AchievementGive(28)
	_mark_completed(general, id, bool(quest.get("is_last", false)))
	general.signal_deleted_for_rechek = true
	general.signal_animation = true

	for requirement in quest.get("requirements", []):
		general.remove_item(int(requirement.x) - 1, int(requirement.y), 1)
	for reward in quest.get("rewards", []):
		general.add_item(int(reward.x), int(reward.y), 1)

	general.quests.remove(index)
	_apply_side_effects(general, id)
	refresh_quest_indices(general)
	general.save_save()
	return true


# Удаляет квест без выдачи наград. Нужен сюжетным скриптам, когда этап
# заменяется следующим.
func quest_delete(general, id, is_last):
	var index = quest_index(general, id)
	if index == - 1:
		return false
	_mark_completed(general, id, is_last)
	general.signal_deleted_for_rechek = true
	general.quests.remove(index)
	refresh_quest_indices(general)
	general.save_save()
	return true


# Удаляет все квесты одной сюжетной ветки (например, 2, 2.1, 2.2, 2.6).
# Ветка определяется целой частью id.
func full_quest_delete(general, id):
	var chain = floor(float(id))
	general.signal_deleted_for_rechek = true
	for i in range(general.quests.size() - 1, - 1, - 1):
		if floor(float(general.quests[i].get("id", 0.0))) == chain:
			general.quests.remove(i)
	var kept = []
	for completed_id in general.complete_quests:
		if floor(float(completed_id)) != chain:
			kept.append(completed_id)
	general.complete_quests = kept
	refresh_quest_indices(general)
	general.save_save()
	general.message_spawn("Quest", "некоторые квесты были удалены")


# Проверяет, можно ли завершить квест: предметы, стенд, техника и особые
# условия сюжетных квестов. Кнопка завершения показывается только при true.
func can_complete(general, id):
	var index = quest_index(general, id)
	if index == - 1:
		return false
	var quest = general.quests[index]

	for requirement in quest.get("requirements", []):
		if general.check_array_counts(int(requirement.x) - 1, int(requirement.y)) == - 1:
			return false

	var stand = str(quest.get("stand_requirement", ""))
	if stand != "" and general.stand_index != stand:
		return false
	var technic = str(quest.get("technic_requirement", ""))
	if technic != "" and general.techic_index != technic:
		return false

	var quest_id = float(quest.get("id", 0.0))
	# 11.x и 12.x двигаются сюжетными скриптами, а не кнопкой.
	if floor(quest_id) in [11.0, 12.0]:
		return false
	if quest_id == 1.0:
		return general.houses.find("100khouse") != - 1
	if quest_id == 2.0:
		return general.money >= 3000
	if quest_id == 2.1:
		return general.tree_gold_mini_game_completed >= 5
	if quest_id == 2.2:
		return general.jesus_dialog_complete
	if quest_id == 3.0:
		return general.pizza_8_yes
	if quest_id == 3.3:
		return general.mini_true_game_complete
	if quest_id == 3.8:
		return general.event_coins >= 1000000000000
	return true


# Старое имя оставлено для совместимости с UI/модами.
func check_selected_quests(general, id):
	return can_complete(general, id)


# Возвращает копию квеста по id или пустой словарь.
func get_quest(general, id):
	var index = quest_index(general, id)
	if index == - 1:
		return {}
	return general.quests[index].duplicate(true)


# Позиция квеста в General.quests или -1.
func quest_index(general, id):
	for i in range(general.quests.size()):
		if float(general.quests[i].get("id", 0.0)) == float(id):
			return i
	return - 1


# Обновляет служебный index у каждого квеста. Сейв не трогает: вызывающий
# код сам решает, когда сохранять.
func refresh_quest_indices(general):
	for i in range(general.quests.size()):
		general.quests[i]["index"] = i


# Совместимость со старым именем.
func id_set(general):
	refresh_quest_indices(general)


func search_id(general, id):
	return quest_index(general, id)


func _mark_completed(general, id, is_last):
	if not is_last:
		general.complete_quests.append(id)
		return
	var chain = floor(float(id))
	var kept = []
	for completed_id in general.complete_quests:
		if floor(float(completed_id)) != chain:
			kept.append(completed_id)
	general.complete_quests = kept


func _apply_side_effects(general, id):
	var quest_id = float(id)
	if quest_id == 3.3:
		if general.techic_index == "None" and general.techic_all.find(1) == - 1:
			general.techic_number = 1
			general.mini_true_game_complete = false
			general.techic_all.append(1)
		elif general.techic_index != "None" and general.techic_all.find(1) == - 1:
			general.techic_all.append(1)
	elif quest_id == 2.0:
		general.money -= 10000
	elif quest_id == 4.0:
		general.pucci_money_quest -= 2000
		general.money_change(2000)
	elif quest_id == 2.1:
		general.tree_gold_mini_game_completed = 0
