# PlayerStateService.gd — позиция игрока и кибернетическая батарея.
#
# Контракт: работает с полями General и переданным узлом игрока, не создавая
# собственного состояния. Позиция сохраняется в профиль.

extends Reference


func map_bounds_active(general) -> bool:
	return general.right_block_position.x > general.left_block_position.x and general.bottom_block_positon.y > general.top_block_position.y


func is_valid_map_position(general, pos: Vector2) -> bool:
	if is_nan(pos.x) or is_nan(pos.y) or is_inf(pos.x) or is_inf(pos.y):
		return false
	if map_bounds_active(general):
		var margin = 500.0
		if pos.x < general.left_block_position.x - margin or pos.x > general.right_block_position.x + margin:
			return false
		if pos.y < general.top_block_position.y - margin or pos.y > general.bottom_block_positon.y + margin:
			return false
	return true


func sync_player_pos_from_node(general, player: Node2D) -> void :
	if player == null or not is_instance_valid(player):
		return
	if not player.is_inside_tree() or general.fast_pos_change or general.loading:
		return
	var pos = player.global_position
	if is_valid_map_position(general, pos):
		general.player_pos = pos


func capture_player_pos_save(general, player: Node2D) -> void :
	if player == null or not is_instance_valid(player):
		return
	if not player.is_inside_tree() or general.fast_pos_change or general.loading:
		return
	var pos = player.global_position
	if is_valid_map_position(general, pos):
		general.player_pos_save = pos
	elif is_valid_map_position(general, general.player_pos):
		general.player_pos_save = general.player_pos


func apply_saved_player_position(general, player: Node2D) -> void :
	if player == null or not is_instance_valid(player):
		return
	if not player.is_inside_tree() or general.fast_pos_change or general.loading:
		return
	if general.player_pos_save == Vector2.ZERO:
		return
	if not is_valid_map_position(general, general.player_pos_save):
		return
	player.set_deferred("global_position", general.player_pos_save)


func persist_cyborg_battery_to_save(general) -> void :
	if general.race_number != 5 or not ("Cyborg" in general.other_save):
		return
	if general.other_save["Cyborg"][1][6] == "":
		return
	var parts = general.other_save["Cyborg"][1][6].split("/")
	if parts.size() < 2:
		return
	var remaining = float(parts[1])
	if "C_Battery" in general.Addition:
		remaining = max(0.0, float(general.Addition["C_Battery"]))
	if "C_Worched" in general.Addition and "C_ChargeStart" in general.Addition:
		if float(general.Addition["C_Worched"]) > float(general.Addition["C_ChargeStart"]):
			remaining = max(0.0, remaining - (float(general.Addition["C_Worched"]) - float(general.Addition["C_ChargeStart"])))
	if remaining <= 0.0:
		general.other_save["Cyborg"][1][6] = ""
		if "C_Battery" in general.Addition:
			general.Addition["C_Battery"] = 0.0
	else:
		general.other_save["Cyborg"][1][6] = parts[0] + "/" + str(stepify(remaining, 0.01))
		if "C_Battery" in general.Addition:
			general.Addition["C_Battery"] = remaining
	if "C_Worched" in general.Addition:
		general.Addition["C_Worched"] = 0.0
