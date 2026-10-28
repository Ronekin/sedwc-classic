# InventoryService.gd — инвентарь General.
#
# Контракт: состояние (items_inventory, item_in_arm, item_name) остаётся в
# General. Публичные методы принимают 0-based item_id; remove_item_slot()
# принимает 1-based slot_id (значение Vector2.x). Сервис не хранит данных.

extends Reference


func check_array_invent_zero(general):
	for i in range(0, 72):
		if general.items_inventory.size() >= i + 1:
			if general.items_inventory[i].x == 0 and general.items_inventory[i].y != 0:
				general.items_inventory[i].y = 0


# Все check_* и ItemCount принимают 0-based item_id.
func check_array(general, item_index_check):
	general.check_array_invnet = - 1
	for i in general.items_inventory.size():
		if general.items_inventory[i].x == item_index_check + 1:
			general.check_array_invnet = i
			return i
		else:
			general.check_array_invnet = - 1
	return - 1


func check_array_counts(general, item_index_check, item_count):
	for i in range(0, 72):
		if general.items_inventory.size() >= i + 1:
			if general.items_inventory[i].x == item_index_check + 1 and general.items_inventory[i].y >= item_count:
				return i
	return - 1


func ItemCount(general, ItemIndex: int) -> int:
	for i in general.items_inventory.size():
		if general.items_inventory[i].x == ItemIndex + 1:
			return general.items_inventory[i].y
	return 0


# item_index — 0-based ID; message_visible=0 подавляет всплывающее сообщение.
func add_item(general, item_index, item_count, message_visible = 1):
	item_index = int(item_index)
	general.item_name = ""
	if message_visible == 1:
		if general.get_tree().current_scene.name != "Shop" and general.get_tree().current_scene.name != "SpidwagonShop":
			var display_name = general.content_db().get_item_message_name(item_index)
			if display_name != "":
				general.item_name += "\n+ " + display_name + ": " + str(item_count) + general.content_db().get_item_message_suffix(item_index)
	check_array(general, item_index)
	if general.check_array_invnet != - 1:
		general.items_inventory[general.check_array_invnet].y += item_count
	else:
		var da = false
		for i in general.items_inventory.size():
			if general.items_inventory[i].x == 0:
				general.items_inventory[i].x = item_index + 1
				general.items_inventory[i].y = item_count
				da = true
				break
		if not da:
			general.items_inventory.append(Vector2(item_index + 1, item_count))
	if message_visible == 1:
		general.message_spawn("Item", general.item_name)
	general.save_save()


func remove_item(general, item_id, item_count, message_visible = 1):
	# Публичный API: item_id — индекс предмета из Data/Items.gd (0-based).
	remove_item_slot(general, int(item_id) + 1, item_count, message_visible)


func remove_item_slot(general, slot_id, item_count, message_visible = 1):
	# Внутренний/UI-API: slot_id — значение items_inventory[i].x (1-based).
	slot_id = int(slot_id)
	general.item_name = ""
	if message_visible == 1:
		if general.get_tree().current_scene.name != "Shop" and general.get_tree().current_scene.name != "SpidwagonShop":
			var item_id = slot_id - 1
			var display_name = general.content_db().get_item_message_name(item_id)
			if display_name != "":
				general.item_name += "\n- " + display_name + ": " + str(item_count) + general.content_db().get_item_message_suffix(item_id)
	for i in general.items_inventory.size():
		if general.items_inventory[i].x == slot_id and general.items_inventory[i].y > item_count:
			general.items_inventory[i].y -= item_count
			break
		elif general.items_inventory[i].x == slot_id and general.items_inventory[i].y == item_count:
			if int(general.item_in_arm) == general.items_inventory[i].x:
				general.item_in_arm = "0"
			general.items_inventory[i] = Vector2.ZERO
			break
	if message_visible == 1:
		general.message_spawn("Item", general.item_name)
	general.save_save()


func delete_item(general, item_id):
	# Публичный API: item_id — индекс предмета из Data/Items.gd (0-based).
	var slot_id = int(item_id) + 1
	for i in range(0, 72):
		if general.items_inventory.size() >= i + 1:
			if general.items_inventory[i].x == slot_id:
				if int(general.item_in_arm) == general.items_inventory[i].x:
					general.item_in_arm = "0"
				general.items_inventory[i] = Vector2.ZERO
				break
	general.save_save()


func item_spawn(general, array):
	var node = general.get_node("/root/" + general.get_tree().current_scene.name)
	# Сидируем general.random: именно он выбирает позицию. Глобальный
	# randomize() на этот выбор не влияет.
	general.random.randomize()
	var item_spawn = general.item_create.instance()
	node.add_child(item_spawn)
	var random_value = general.random.randi_range(0, array.size() - 1)
	var random_pos = array[random_value]
	item_spawn.position = random_pos
