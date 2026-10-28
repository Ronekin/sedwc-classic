# TournamentRewardService.gd — выдача и учёт турнирных наград.
#
# Контракт: award() начисляет деньги/предметы из enemy_data и категории
# наград; collect() переносит деньги в General и обновляет рекорд.
# Данные наград — в Data/TournamentRules.gd.

extends Reference

var rng = RandomNumberGenerator.new()

func _init():
	rng.randomize()

func _category_for_item(item_id: int, rules: Dictionary) -> String:
	var categories = rules.get("reward_categories", {})
	var key = str(int(item_id))
	if key in categories:
		return str(categories[key])
	return ""

func _record_item(general, item_id: int, count: int, rules: Dictionary) -> void:
	var category = _category_for_item(item_id, rules)
	if category == "":
		return
	if not (category in general.tournir_all_reward_items):
		general.tournir_all_reward_items[category] = 0
	general.tournir_all_reward_items[category] += int(count)

# Начисляет деньги/предметы в турнирные счётчики; в General.money они попадут
# только после collect().
func award(general, enemy_data: Dictionary) -> Dictionary:
	var rules = general.content_db().get_tournament_rules()
	var money_bonus = float(general.global_bonus.get("money", 1.0))
	var awarded_money = int(round(float(enemy_data.get("money", 0)) * money_bonus))
	general.tournir_money_reward += awarded_money

	var awarded_items = []
	for drop in enemy_data.get("items", []):
		var item_id = int(drop[0])
		var value = float(drop[1])
		if general.content_db().get_item(item_id).empty():
			continue
		var count = 0
		if value >= 1.0:
			count = int(value)
		elif rng.randf() < value:
			count = 1
		if count <= 0:
			continue
		general.add_item(item_id, count)
		_record_item(general, item_id, count, rules)
		awarded_items.append([item_id, count])

	return {"money": awarded_money, "items": awarded_items}

# Переносит накопленные деньги в General, обновляет рекорд и очищает счётчики.
func collect(general) -> int:
	var money = int(general.tournir_money_reward)
	if money > 0:
		general.money_change(money)
	var completed_level = int(general.tournament_lvl) - 1
	if completed_level > int(general.tournir_record):
		general.tournir_record = completed_level
	general.tournir_money_reward = 0
	general.tournir_all_reward_items = general.content_db().get_default("tournir_all_reward_items", {})
	return money
