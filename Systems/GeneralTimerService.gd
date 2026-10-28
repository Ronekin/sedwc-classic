# GeneralTimerService.gd — таймеры General: бой, регенерация, play_time, ногти.
#
# Контракт: Timer-узлы и флаги принадлежат General; сервис настраивает их и
# снимает старые подключения, чтобы повторный запуск не дублировал сигналы.
# play_time идёт на General.play_timer, а не на General.timer.

extends Reference


# Все таймеры, которые принадлежат автолоаду General. Держите список в одном
# месте: если таймер создан через Timer.new(), он должен быть ребёнком General,
# иначе он переживёт смену сцены и превратится в утечку ObjectDB.
func all_timers(general) -> Array:
	return [
		general.timer,
		general.timer_spin,
		general.nail_timer,
		general.merchant_timer,
		general.timer_health_regen,
		general.block_glush,
		general.tea_timer,
		general.play_timer,
		general.parirovanie,
		general.grass_collect,
		general.combo_timer,
		general.combo_enemy_timer,
		general.glush_enemy_timer,
	]


# Добавляет таймер в дерево под General. Если таймер уже был ребёнком другого
# узла, сначала аккуратно отцепляет его, чтобы не было двух родителей.
func ensure_autoload_timer(general, timer: Timer) -> void :
	if timer == null:
		return
	if timer.get_parent() == general:
		return
	if timer.get_parent() != null:
		timer.get_parent().remove_child(timer)
	general.add_child(timer)


# Гарантирует, что все таймеры General находятся в дереве. Вызывайте один раз
# в General._ready(), а не при каждой смене сцены.
func ensure_all_timers(general) -> void :
	for timer in all_timers(general):
		ensure_autoload_timer(general, timer)


# Возвращает таймер под General, не создавая новый экземпляр. Нужен для
# временных таймеров игрока (например, timer_spin), которые нельзя оставлять
# без родителя после remove_child().
func park_timer(general, timer: Timer) -> void :
	if timer == null:
		return
	timer.stop()
	if timer.get_parent() == general:
		return
	if timer.get_parent() != null:
		timer.get_parent().remove_child(timer)
	general.add_child(timer)


# Смена сцены: останавливает боевые таймеры и отключает их от старых узлов.
# play_timer и grass_collect относятся ко всему прохождению, поэтому их не
# трогаем. Сами Timer-узлы не пересоздаются — они остаются детьми General.
func reset_for_scene_change(general) -> void :
	for timer in all_timers(general):
		if timer == null:
			continue
		if timer == general.play_timer or timer == general.grass_collect:
			continue
		timer.stop()
		for connection in timer.get_signal_connection_list("timeout"):
			var target = connection.get("target")
			var method = str(connection.get("method"))
			if target == null or target == general or not is_instance_valid(target):
				continue
			if timer.is_connected("timeout", target, method):
				timer.disconnect("timeout", target, method)
		park_timer(general, timer)


# Аварийная страховка на выходе: освобождает только осиротевшие таймеры.
# Таймеры-дети General или игрока освободятся вместе со своими владельцами.
func free_orphan_timers(general) -> void :
	for timer in all_timers(general):
		if timer != null and is_instance_valid(timer) and timer.get_parent() == null:
			timer.free()


func disconnect_timer_target(timer: Timer, target: Object, method: String) -> void :
	if timer == null or target == null:
		return
	if is_instance_valid(target) and timer.is_connected("timeout", target, method):
		timer.disconnect("timeout", target, method)


func start_combo_timer_for_enemy(general, enemy: Object, wait_time: float) -> void :
	if enemy == null:
		return
	ensure_autoload_timer(general, general.combo_timer)
	disconnect_timer_target(general.combo_timer, enemy, "do_this")
	general.combo_timer.connect("timeout", enemy, "do_this")
	general.combo_timer.wait_time = wait_time
	general.combo_timer.one_shot = true
	general.combo_timer.start()


func start_glush_enemy_timer(general, wait_time: float) -> void :
	ensure_autoload_timer(general, general.glush_enemy_timer)
	general.glush_enemy_timer.wait_time = wait_time
	general.glush_enemy_timer.one_shot = true
	general.glush_enemy_timer.start()


func start_combo_enemy_timer_for_enemy(general, enemy: Object, wait_time: float) -> void :
	if enemy == null:
		return
	ensure_autoload_timer(general, general.combo_enemy_timer)
	disconnect_timer_target(general.combo_enemy_timer, enemy, "combo_enemy_end")
	general.combo_enemy_timer.connect("timeout", enemy, "combo_enemy_end")
	general.combo_enemy_timer.wait_time = wait_time
	general.combo_enemy_timer.one_shot = true
	general.combo_enemy_timer.start()


func disconnect_fight_timers_from(general, enemy: Object) -> void :
	disconnect_timer_target(general.combo_timer, enemy, "do_this")
	disconnect_timer_target(general.combo_enemy_timer, enemy, "combo_enemy_end")


func release_player_refs(general, player: Object) -> void :
	if player == null:
		return
	if general.GGPlayer == player:
		general.GGPlayer = null
	disconnect_timer_target(general.nail_timer, player, "nail_plus")


func regen_hp_timer(general):
	if not general.timer_health_regen.is_connected("timeout", general, "regen_hp"):
		general.timer_health_regen.connect("timeout", general, "regen_hp")
	general.timer_health_regen.wait_time = 1
	general.timer_health_regen.one_shot = false
	if general.timer_health_regen.get_parent() == null:
		general.add_child(general.timer_health_regen)
	if general.timer_health_regen.is_stopped():
		general.timer_health_regen.start()


func regen_hp(general):
	var amount_health = 0
	var requim = 1
	if general.current_scene_name != "TournirSelect":
		if general.stand_number == 17:
			requim = 2
		if general.race_number == 0:
			amount_health = 0.001 * requim
		elif general.race_number == 1 and general.extra_heal > 0:
			amount_health = 0.0015 * requim + general.extra_heal
			general.extra_heal -= general.extra_heal / 10
		elif general.race_number == 1 and general.extra_heal == 0:
			amount_health = 0.002 * requim
		elif general.race_number == 2:
			amount_health = 0.00125 * requim
		elif general.race_number == 3:
			amount_health = 0.00225 * requim
		elif general.race_number == 4:
			amount_health = 0.0025 * requim

		if general.heart_points + amount_health * general.hp_max <= general.hp_max:
			general.heart_points += amount_health * general.hp_max * general.Stats["Regen"]
		elif general.heart_points + amount_health * general.hp_max >= general.hp_max:
			general.heart_points = general.hp_max


# play_time — накопительный счётчик; не сбрасывайте его при смене сцены.
func play_time_add(general):
	general.play_time += 1

	if general.play_time >= 60: general.AchievementGive(5)
	if general.play_time >= 600: general.AchievementGive(6)
	if general.play_time >= 3000: general.AchievementGive(7)
	if general.play_time >= 6000: general.AchievementGive(8)
	if general.play_time >= 15000: general.AchievementGive(9)
	if general.play_time >= 60000: general.AchievementGive(38)

	general.save_save()


func play_time_timer(general, sec):
	# play_time живёт на отдельном General.play_timer: Transition.change_scene
	# сбрасывает General.timer, и счётчик времени иначе терял бы соединение.
	if general.play_timer == null:
		general.play_timer = Timer.new()
	if not general.play_timer.is_connected("timeout", general, "play_time_add"):
		general.play_timer.connect("timeout", general, "play_time_add")
	general.play_timer.wait_time = sec
	general.play_timer.one_shot = false
	if not general.play_timer.is_inside_tree():
		general.add_child(general.play_timer)
	if general.play_timer.is_stopped():
		general.play_timer.start()


func grass_colectiong(general):
	general.timer_grass = 1


func timer_grass_collect(general, sec):
	if not general.grass_collect.is_connected("timeout", general, "grass_colectiong"):
		general.grass_collect.connect("timeout", general, "grass_colectiong")
	general.grass_collect.wait_time = sec
	general.grass_collect.one_shot = false
	if not general.grass_collect.is_inside_tree():
		general.add_child(general.grass_collect)
	if general.grass_collect.is_stopped():
		general.grass_collect.start()


func nail_timer_start(general):
	var player
	if general.get_tree().current_scene.name != "MorioMap":
		player = general.get_node("/root/" + general.get_tree().current_scene.name + "/YSorting/GGPlayer")
		if player == null:
			player = general.get_node("/root/" + general.get_tree().current_scene.name + "/SortingY/GGPlayer")
	elif general.get_tree().current_scene.name == "MorioMap":
		player = general.get_node("/root/" + general.get_tree().current_scene.name + "/SortingY/GGPlayer")
	disconnect_timer_target(general.nail_timer, general, "nail_plus")
	if player and is_instance_valid(player):
		disconnect_timer_target(general.nail_timer, player, "nail_plus")
	general.nail_timer.connect("timeout", general, "nail_plus")
	if player and is_instance_valid(player):
		general.nail_timer.connect("timeout", player, "nail_plus")
	if general.stand_index == "TuskAct1":
		general.nail_timer.wait_time = 3
	elif general.stand_index == "TuskAct2":
		general.nail_timer.wait_time = 5
	elif general.stand_index == "TuskAct3":
		general.nail_timer.wait_time = 7
	elif general.stand_index == "TuskAct4" and general.techic_number != 2:
		general.nail_timer.wait_time = 3
	elif general.stand_index == "TuskAct4" and general.techic_number == 2:
		general.nail_timer.wait_time = 1.5
	general.nail_timer.one_shot = true
	if not general.nail_timer.is_inside_tree():
		general.add_child(general.nail_timer)
	general.nail_timer.start()


func nail_plus(general):
	if general.nail_count.find(0) != - 1 and general.is_invent_show == false and general.dialog_activate == false:
		general.nail_count[general.nail_count.count(0) - 1] = 1
