# GeneralSaveService.gd — сохранение и загрузка профиля.
#
# Контракт: формат и слот — в Persistence/SedwcSaveProfile.gd; сервис только
# вызывает save/load и чистит битые записи инвентаря. TrainingArena
# намеренно не сохраняется.

extends Reference


func saves_exist_check(general):
	var core = general.get_node_or_null("/root/Core")
	if core != null and core.save_exists(general.save_profile.SAVE_SLOT):
		return
	save_save(general)


func save_save_extended(general):
	if general.current_scene_name == "TrainingArena":
		return
	if not general.save_profile.save_to_core(general):
		push_warning("SEDWC: не удалось записать JSON-сейв")


func save_save(general):
	save_save_extended(general)


func load_save(general):
	general.save_profile.load_from_core(general)
	# Отмечаем попытку загрузки, чтобы GGPlayer не перечитывал сейв каждый раз.
	general.is_saves_load = true
	if typeof(general.items_inventory) != TYPE_ARRAY:
		general.items_inventory = []
	for i in range(general.items_inventory.size() - 1, - 1, - 1):
		if typeof(general.items_inventory[i]) != TYPE_VECTOR2 or general.items_inventory[i].x == 0:
			general.items_inventory.remove(i)
		else:
			break
