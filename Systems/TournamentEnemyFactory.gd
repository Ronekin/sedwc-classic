# TournamentEnemyFactory.gd — генерация турнирных врагов.
#
# Контракт: generate(level) читает Data/Tournament*.gd и возвращает
# Dictionary с hp/damage/exp/money/items. Используется локальный RNG с
# seed=level: результат детерминирован и не влияет на остальную игру.
#
# Моддинг: пулы, формулы и дропы меняйте в Data/Tournament*.gd, а не здесь.

extends Reference

var encountered_enemies = {}
var rng = RandomNumberGenerator.new()

func _raw_name(level: int, keys: Array) -> String:
	rng.seed = int(level)
	return str(keys[rng.randi() % keys.size()])

func _previous_name(level: int, keys: Array, is_boss: bool) -> String:
	var prev_level = level - 5 if is_boss else level - 1
	if prev_level <= 0:
		return ""
	return _raw_name(prev_level, keys)

func _money_reward(level: int, rules: Dictionary) -> int:
	var key = str(level)
	var special = rules.get("money_reward_special", {})
	if key in special:
		return int(special[key])
	var table = rules.get("money_rewards", {})
	if key in table:
		return int(table[key])
	var start = int(rules.get("money_reward_level_start", 10))
	var base = int(rules.get("money_reward_base", 20000))
	var step = int(rules.get("money_reward_per_level", 1000))
	return base + (level - start + 1) * step

func generate(level: int) -> Dictionary:

	rng.seed = int(level)

	var is_boss = level % 5 == 0
	var is_strong = level % 10 == 0
	var rules = General.content_db().get_tournament_rules()

	var pool = General.content_db().get_tournament_pool(is_boss)
	var keys = General.content_db().get_tournament_keys(is_boss)

	var name = _raw_name(level, keys)
	if level > 1:
		var prev_name = _previous_name(level, keys, is_boss)
		rng.seed = int(level)
		if prev_name != "" and name == prev_name:
			name = str(keys[(keys.find(name) + 1) % keys.size()])

	var version = "Normal"
	var type = "Classic"

	if is_boss:
		var FirstMeet: int
		for i in level:
			if (i + 1) % 5 == 0:
				rng.seed = int(i + 1)
				var PreDa = keys[rng.randi() % keys.size()]
				rng.seed = int(i - 4)

				var PrePreDa = keys[rng.randi() % keys.size()] if i > 4 else ""

				if PrePreDa == PreDa:
					PreDa = keys[(keys.find(PreDa) + 1) % keys.size()]

				rng.seed = int(level)
				if name == PreDa:
					FirstMeet = i + 1
					break

		if not (name in encountered_enemies):
			encountered_enemies[name] = level

		if FirstMeet < level and FirstMeet != 0:

			version = "True" if is_strong else "Normal"
			if not is_strong or rng.randf() < float(rules.get("strong_type_chance", 0.2)):
				var type_pool = rules.get("type_pool", ["ярый", "танк", "шустрый"])
				type = type_pool[rng.randi() % type_pool.size()]

	var base = pool[name]
	var texture_file = str(base.get("texture", ""))

	var TexturePath = "res://Textures/Enemys/" + texture_file

	if not ResourceLoader.exists(TexturePath):
		TexturePath = "res://Textures/" + texture_file

	var hp_boss_base = float(rules.get("hp_boss_base", 250))
	var hp_boss_per_level = float(rules.get("hp_boss_per_level", 15))
	var hp_regular_base = float(rules.get("hp_regular_base", 60))
	var hp_regular_per_level = float(rules.get("hp_regular_per_level", 6))
	var damage_boss_base = float(rules.get("damage_boss_base", 20))
	var damage_boss_per_level = float(rules.get("damage_boss_per_level", 4))
	var damage_regular_base = float(rules.get("damage_regular_base", 8))
	var damage_regular_per_level = float(rules.get("damage_regular_per_level", 2))
	var exp_per_level = float(rules.get("exp_per_level", 5))
	var exp_boss_bonus = float(rules.get("exp_boss_bonus", 100))
	var exp_regular_bonus = float(rules.get("exp_regular_bonus", 10))
	var drop_strong_base = float(rules.get("drop_chance_strong_base", 0.5))
	var drop_boss_base = float(rules.get("drop_chance_boss_base", 0.2))

	var res = {
		"name": name,
		"hp": stepify(hp_boss_base + level * hp_boss_per_level, 10) if is_boss else (hp_regular_base + level * hp_regular_per_level),
		"damage": (damage_boss_base + level * damage_boss_per_level) if is_boss else (damage_regular_base + level * damage_regular_per_level),
		"exp": (level * exp_per_level) + (exp_boss_bonus if is_boss else exp_regular_bonus),
		"money": _money_reward(level, rules),
		"drop_chance": drop_strong_base + General.chance_calculate(drop_strong_base) if is_strong else (drop_boss_base + General.chance_calculate(drop_boss_base) if is_boss else 0.0),
		"texture": TexturePath,
		"hframes": int(base.get("hframes", 1)), "vframes": int(base.get("vframes", 1)),
		"addition": base.get("addition", []),
		"type": type, "version": version, "is_boss": is_boss,
		"items": [],
	}

	if type == "танк":
		res["hp"] *= float(rules.get("tank_hp_multiplier", 1.5))

	if version == "True":
		res["hp"] *= float(rules.get("true_hp_multiplier", 1.2))
		res["damage"] *= float(rules.get("true_damage_multiplier", 1.3))

	var drop_rule = {}
	for rule in rules.get("level_drops", []):
		if level >= int(rule.get("min_level", 0)):
			drop_rule = rule
			break
	if not drop_rule.empty():
		for roll in drop_rule.get("rolls", []):
			if rng.randf() > float(roll.get("threshold", 1.0)):
				res["items"].append([int(roll.get("item_id", 0)), int(roll.get("count", 1))])
				if bool(drop_rule.get("exclusive", false)):
					break
	var special = rules.get("special_drops", {}).get(res["name"], {})
	if not special.empty():
		var special_chance = float(special.get("chance", 0.0))
		res["items"] = [[int(special.get("item_id", 0)), special_chance + General.chance_calculate(special_chance)]]
		if bool(special.get("zero_drop_chance", false)):
			res["drop_chance"] = 0.0

	return res
